package com.docconnect.payment.service;

import com.docconnect.payment.model.dao.PaymentDAO;
import com.docconnect.payment.model.Payment;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.*;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service layer for Payment-related business logic.
 * Integrates Khalti ePay v2 — server-side redirect flow.
 *
 * Flow:
 *   1. initiateKhaltiPayment() → calls Khalti initiation API, stores pidx, returns payment_url
 *   2. User is redirected to payment_url on Khalti's hosted page
 *   3. Khalti redirects back to return_url with ?pidx=...&status=...
 *   4. lookupAndVerify() → calls Khalti lookup API, confirms status, updates DB
 */
public class PaymentService {

    private static final Logger LOGGER = Logger.getLogger(PaymentService.class.getName());
    private final PaymentDAO paymentDAO = new PaymentDAO();

    // Khalti ePay v2 Sandbox credentials
    public static final String KHALTI_PUBLIC_KEY = "1b2a0016106c41619ef3df109b964f08";  // for reference only
    private static final String DEFAULT_KHALTI_SECRET_KEY = "729e6a0f1de44ac3a139e73eaacc4a32";
    private static final String KHALTI_INITIATE_URL = "https://dev.khalti.com/api/v2/epayment/initiate/";
    private static final String KHALTI_LOOKUP_URL   = "https://dev.khalti.com/api/v2/epayment/lookup/";
    private static final String DEFAULT_KHALTI_CHECKOUT_URL = "https://test-pay.khalti.com/?pidx=";

    public enum VerificationStatus {
        COMPLETED,
        PENDING,
        FAILED
    }

    /**
     * Step 1: Initiates a Khalti ePay v2 payment.
     *
     * Creates (or reuses) a pending payment record, calls Khalti's initiation
     * endpoint, stores the returned pidx in transaction_id, and returns the
     * payment_url to redirect the user to.
     *
     * @return Khalti payment_url on success, null on failure
     */
    public String initiateKhaltiPayment(int appointmentId, BigDecimal amount,
                                        String returnUrl, String websiteUrl,
                                        String customerName, String customerEmail,
                                        String customerPhone) {

        // Guard: don't re-initiate an already completed payment
        Payment existing = paymentDAO.findByAppointmentId(appointmentId);
        if (existing != null && existing.isCompleted()) {
            return null;
        }

        // Khalti requires amount in paisa (1 Rs = 100 paisa)
        long amountInPaisa = amount.multiply(new BigDecimal("100")).longValue();

        String requestBody = buildInitiateJson(
                returnUrl, websiteUrl, amountInPaisa,
                appointmentId, customerName, customerEmail, customerPhone);

        try {
            String responseBody = postJson(KHALTI_INITIATE_URL, requestBody);
            LOGGER.info("Khalti initiate response: " + responseBody);

            JsonObject resp = JsonParser.parseString(responseBody).getAsJsonObject();

            if (!resp.has("pidx")) {
                LOGGER.severe("Khalti initiation failed — no pidx in response: " + responseBody);
                return null;
            }

            String pidx = resp.get("pidx").getAsString();
            String paymentUrl = extractPaymentUrl(resp, pidx);
            if (!hasText(paymentUrl)) {
                LOGGER.severe("Khalti initiation failed — no valid payment_url for pidx: " + pidx);
                return null;
            }

            // Persist the payment record with pidx stored in transaction_id
            if (existing != null) {
                // Reuse existing pending record, refresh pidx
                paymentDAO.updateStatus(existing.getId(), "pending", pidx);
            } else {
                Payment payment = new Payment();
                payment.setAppointmentId(appointmentId);
                payment.setAmount(amount);
                payment.setPaymentMethod("khalti");
                payment.setTransactionId(pidx);   // pidx stored here until verified
                payment.setStatus("pending");
                paymentDAO.create(payment);
            }

            return paymentUrl;

        } catch (Exception e) {
            LOGGER.severe("Error initiating Khalti payment: " + e.getMessage());
            return null;
        }
    }

    /**
     * Step 2: Verifies a completed Khalti payment via the lookup endpoint.
     *
     * Called from the return_url callback. Looks up the pidx, confirms
     * status == "Completed", then updates the payment record with the real
     * Khalti transaction_id and marks it completed.
     *
     * @return normalized verification result from lookup response
     */
    public VerificationStatus lookupAndVerify(String pidx) {
        try {
            String requestBody = "{\"pidx\":\"" + escape(pidx) + "\"}";
            String responseBody = postJson(KHALTI_LOOKUP_URL, requestBody);
            LOGGER.info("Khalti lookup response: " + responseBody);

            JsonObject resp = JsonParser.parseString(responseBody).getAsJsonObject();

            if (!resp.has("status")) {
                LOGGER.severe("Khalti lookup failed — no status in response: " + responseBody);
                return VerificationStatus.FAILED;
            }

            String status = resp.get("status").getAsString().trim();

            // Use callback pidx unless a transaction_id is available.
            String transactionId = extractTransactionId(resp, pidx);

            Payment payment = paymentDAO.findByPidx(pidx);
            if (payment == null) {
                LOGGER.severe("No payment record found for pidx: " + pidx);
                return VerificationStatus.FAILED;
            }

            if ("Completed".equalsIgnoreCase(status)) {
                paymentDAO.updateStatus(payment.getId(), "completed", transactionId);
                LOGGER.info("Payment confirmed. AppointmentId=" + payment.getAppointmentId()
                        + " TransactionId=" + transactionId);
                return VerificationStatus.COMPLETED;
            }

            if ("Pending".equalsIgnoreCase(status) || "Initiated".equalsIgnoreCase(status)) {
                paymentDAO.updateStatus(payment.getId(), "pending", pidx);
                LOGGER.info("Payment is still pending. AppointmentId=" + payment.getAppointmentId()
                        + " Status=" + status);
                return VerificationStatus.PENDING;
            }

            String normalized = status.toLowerCase();
            if ("refunded".equals(normalized) || "expired".equals(normalized)) {
                paymentDAO.updateStatus(payment.getId(), normalized, transactionId);
            } else {
                paymentDAO.updateStatus(payment.getId(), "failed", transactionId);
            }
            LOGGER.warning("Payment could not be completed. AppointmentId=" + payment.getAppointmentId()
                    + " Status=" + status);
            return VerificationStatus.FAILED;

        } catch (Exception e) {
            LOGGER.severe("Error verifying Khalti payment: " + e.getMessage());
            return VerificationStatus.FAILED;
        }
    }

    /**
     * Returns the appointment ID linked to a pidx (for updating appointment status
     * after payment confirmation).
     */
    public int getAppointmentIdByPidx(String pidx) {
        Payment payment = paymentDAO.findByPidx(pidx);
        return payment != null ? payment.getAppointmentId() : -1;
    }

    // -------------------------------------------------------------------------
    // Remaining service methods (unchanged)
    // -------------------------------------------------------------------------

    public Payment getPaymentByAppointmentId(int appointmentId) {
        return paymentDAO.findByAppointmentId(appointmentId);
    }

    public Payment getPaymentById(int id) {
        return paymentDAO.findById(id);
    }

    public List<Payment> getPatientPayments(int patientId) {
        return paymentDAO.findByPatientId(patientId);
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.findAll();
    }

    public double getTotalRevenue() {
        return paymentDAO.getTotalRevenue();
    }

    public void deletePaymentByAppointmentId(int appointmentId) {
        paymentDAO.deleteByAppointmentId(appointmentId);
    }

    // -------------------------------------------------------------------------
    // Private helpers
    // -------------------------------------------------------------------------

    private String extractPaymentUrl(JsonObject response, String pidx) {
        String rawPaymentUrl = null;
        if (response.has("payment_url")) {
            JsonElement paymentUrlElement = response.get("payment_url");
            if (paymentUrlElement != null && !paymentUrlElement.isJsonNull()) {
                rawPaymentUrl = paymentUrlElement.getAsString();
            }
        }

        if (!hasText(rawPaymentUrl)) {
            return resolveCheckoutBaseUrl() + URLEncoder.encode(pidx, StandardCharsets.UTF_8);
        }

        String normalized = rawPaymentUrl.trim()
                .replace("?pid=", "?pidx=")
                .replace("&pid=", "&pidx=");

        if (!normalized.matches(".*[?&]pidx=.*")) {
            String delimiter = normalized.contains("?") ? "&" : "?";
            normalized += delimiter + "pidx=" + URLEncoder.encode(pidx, StandardCharsets.UTF_8);
        }
        return normalized;
    }

    private String resolveCheckoutBaseUrl() {
        String configured = System.getenv("KHALTI_CHECKOUT_URL");
        if (!hasText(configured)) {
            configured = System.getProperty("khalti.checkoutUrl");
        }
        if (!hasText(configured)) {
            configured = DEFAULT_KHALTI_CHECKOUT_URL;
        }
        configured = configured.trim();
        return configured.endsWith("=") ? configured : (configured + (configured.contains("?") ? "&pidx=" : "?pidx="));
    }

    private String buildInitiateJson(String returnUrl, String websiteUrl,
                                     long amountPaisa, int appointmentId,
                                     String name, String email, String phone) {
        JsonObject body = new JsonObject();
        body.addProperty("return_url", returnUrl);
        body.addProperty("website_url", websiteUrl);
        body.addProperty("amount", amountPaisa);
        body.addProperty("purchase_order_id", "APT-" + appointmentId);
        body.addProperty("purchase_order_name", "DocConnect Appointment #" + appointmentId);

        JsonObject customerInfo = new JsonObject();
        if (hasText(name)) {
            customerInfo.addProperty("name", name.trim());
        }
        if (hasText(email) && isLikelyEmail(email.trim())) {
            customerInfo.addProperty("email", email.trim());
        }
        if (hasText(phone) && isLikelyPhone(phone.trim())) {
            customerInfo.addProperty("phone", phone.trim());
        }
        if (customerInfo.size() > 0) {
            body.add("customer_info", customerInfo);
        }

        return body.toString();
    }

    /**
     * Sends a POST request with JSON body to the given URL using the Khalti secret key.
     * Reads and returns the response body (both success and error streams).
     */
    private String postJson(String targetUrl, String jsonBody) throws IOException {
        URL url = URI.create(targetUrl).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", resolveAuthorizationHeader());
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(15_000);
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
        }

        int code = conn.getResponseCode();
        InputStream stream = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
        return readFully(stream);
    }

    private String readFully(InputStream is) throws IOException {
        if (is == null) return "{}";
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return sb.toString();
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private String extractTransactionId(JsonObject response, String fallbackPidx) {
        JsonElement transactionIdElement = response.has("transaction_id")
                ? response.get("transaction_id")
                : JsonNull.INSTANCE;
        if (transactionIdElement != null && !transactionIdElement.isJsonNull()) {
            String value = transactionIdElement.getAsString();
            if (hasText(value)) {
                return value.trim();
            }
        }
        return fallbackPidx;
    }

    private String resolveAuthorizationHeader() {
        String configured = System.getenv("KHALTI_SECRET_KEY");
        if (!hasText(configured)) {
            configured = System.getProperty("khalti.secretKey");
        }
        if (!hasText(configured)) {
            configured = DEFAULT_KHALTI_SECRET_KEY;
        }
        configured = configured.trim();
        return configured.regionMatches(true, 0, "Key ", 0, 4) ? configured : "Key " + configured;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private boolean isLikelyEmail(String email) {
        return email.contains("@") && email.indexOf('@') > 0 && email.indexOf('@') < email.length() - 1;
    }

    private boolean isLikelyPhone(String phone) {
        return phone.matches("^\\d{10}$");
    }
}
