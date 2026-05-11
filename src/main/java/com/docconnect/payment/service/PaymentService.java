package com.docconnect.payment.service;

import com.docconnect.payment.model.dao.PaymentDAO;
import com.docconnect.payment.model.Payment;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.*;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URI;
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
    public static final String KHALTI_PUBLIC_KEY  = "1b2a0016106c41619ef3df109b964f08";  // for reference only
    public static final String KHALTI_SECRET_KEY  = "729e6a0f1de44ac3a139e73eaacc4a32"; // used in Authorization header
    private static final String KHALTI_INITIATE_URL = "https://dev.khalti.com/api/v2/epayment/initiate/";
    private static final String KHALTI_LOOKUP_URL   = "https://dev.khalti.com/api/v2/epayment/lookup/";

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

            String pidx       = resp.get("pidx").getAsString();
            String paymentUrl = resp.get("payment_url").getAsString();

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
     * @return true if payment is confirmed as Completed
     */
    public boolean lookupAndVerify(String pidx) {
        try {
            String requestBody  = "{\"pidx\":\"" + pidx + "\"}";
            String responseBody = postJson(KHALTI_LOOKUP_URL, requestBody);
            LOGGER.info("Khalti lookup response: " + responseBody);

            JsonObject resp = JsonParser.parseString(responseBody).getAsJsonObject();

            if (!resp.has("status")) {
                LOGGER.severe("Khalti lookup failed — no status in response: " + responseBody);
                return false;
            }

            String status = resp.get("status").getAsString();

            if (!"Completed".equalsIgnoreCase(status)) {
                LOGGER.warning("Khalti payment not completed. Status: " + status);
                return false;
            }

            // Use real transaction_id if available, fall back to pidx
            String transactionId = (resp.has("transaction_id") && !resp.get("transaction_id").isJsonNull())
                    ? resp.get("transaction_id").getAsString()
                    : pidx;

            Payment payment = paymentDAO.findByPidx(pidx);
            if (payment == null) {
                LOGGER.severe("No payment record found for pidx: " + pidx);
                return false;
            }

            paymentDAO.updateStatus(payment.getId(), "completed", transactionId);
            LOGGER.info("Payment confirmed. AppointmentId=" + payment.getAppointmentId()
                    + " TransactionId=" + transactionId);
            return true;

        } catch (Exception e) {
            LOGGER.severe("Error verifying Khalti payment: " + e.getMessage());
            return false;
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

    private String buildInitiateJson(String returnUrl, String websiteUrl,
                                     long amountPaisa, int appointmentId,
                                     String name, String email, String phone) {
        return "{"
                + "\"return_url\":\"" + returnUrl + "\","
                + "\"website_url\":\"" + websiteUrl + "\","
                + "\"amount\":" + amountPaisa + ","
                + "\"purchase_order_id\":\"APT-" + appointmentId + "\","
                + "\"purchase_order_name\":\"DocConnect Appointment #" + appointmentId + "\","
                + "\"customer_info\":{"
                +   "\"name\":\"" + escape(name) + "\","
                +   "\"email\":\"" + escape(email) + "\","
                +   "\"phone\":\"" + escape(phone) + "\""
                + "}"
                + "}";
    }

    /**
     * Sends a POST request with JSON body to the given URL using the Khalti secret key.
     * Reads and returns the response body (both success and error streams).
     */
    private String postJson(String targetUrl, String jsonBody) throws IOException {
        URL url = URI.create(targetUrl).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Key " + KHALTI_SECRET_KEY);
        conn.setRequestProperty("Content-Type", "application/json");
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
}
