package com.docconnect.payment.controller;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.appointment.service.AppointmentService;
import com.docconnect.doctor.model.Doctor;
import com.docconnect.doctor.service.DoctorService;
import com.docconnect.payment.model.Payment;
import com.docconnect.payment.service.PaymentService;
import com.docconnect.slot.model.Slot;
import com.docconnect.slot.service.SlotService;
import com.docconnect.user.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

/**
 * Handles Khalti ePay v2 payment flow.
 */
public class PaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentServlet.class.getName());

    private final PaymentService paymentService = new PaymentService();
    private final AppointmentService appointmentService = new AppointmentService();
    private final DoctorService doctorService = new DoctorService();
    private final SlotService slotService = new SlotService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();
        if (uri.endsWith("/payments")) {
            showPaymentHistory(request, response);
        } else if (uri.endsWith("/verify")) {
            handleKhaltiCallback(request, response);
        } else {
            showPaymentPage(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            int appointmentId = resolveAppointmentForPayment(request, session, user);
            if (appointmentId <= 0) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }

            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null || appointment.getPatientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }

            Payment existingPayment = paymentService.getPaymentByAppointmentId(appointmentId);
            if (existingPayment != null && existingPayment.isCompleted()) {
                response.sendRedirect(request.getContextPath()
                        + "/patient/appointments?success=Payment+already+completed.");
                return;
            }

            String baseUrl = buildPublicBaseUrl(request);
            String returnUrl = baseUrl + "/payment/verify";
            String websiteUrl = baseUrl + "/home";
            BigDecimal fee = appointment.getConsultationFee() != null
                    ? appointment.getConsultationFee()
                    : new BigDecimal("1000");

            String paymentUrl = paymentService.initiateKhaltiPayment(
                    appointmentId,
                    fee,
                    returnUrl,
                    websiteUrl,
                    user.getFullName(),
                    user.getEmail(),
                    user.getPhone() != null ? user.getPhone() : "");

            if (paymentUrl == null) {
                paymentService.deletePaymentByAppointmentId(appointmentId);
                appointmentService.deleteAppointment(appointmentId);
                response.sendRedirect(request.getContextPath()
                        + "/doctors?error=Could+not+start+payment.+Please+try+booking+again.");
                return;
            }

            response.sendRedirect(paymentUrl);
        } catch (Exception e) {
            LOGGER.severe("Payment initiation error: " + e.getMessage());
            response.sendRedirect(request.getContextPath()
                    + "/doctors?error=Payment+could+not+be+started.+Please+try+again.");
        }
    }

    private int resolveAppointmentForPayment(HttpServletRequest request, HttpSession session, User user)
            throws IOException {

        if (!"true".equals(request.getParameter("pending"))) {
            String appointmentIdStr = request.getParameter("appointmentId");
            return appointmentIdStr != null ? Integer.parseInt(appointmentIdStr) : -1;
        }

        Integer bookingDoctorId = (Integer) session.getAttribute("bookingDoctorId");
        Integer bookingSlotId = (Integer) session.getAttribute("bookingSlotId");
        String bookingDate = (String) session.getAttribute("bookingDate");
        String bookingNotes = (String) session.getAttribute("bookingNotes");

        if (bookingDoctorId == null || bookingSlotId == null || bookingDate == null) {
            return -1;
        }

        LocalDate date = LocalDate.parse(bookingDate);
        String validError = appointmentService.validateBooking(user.getId(), bookingDoctorId, bookingSlotId, date);
        if (validError != null) {
            throw new IllegalStateException(validError);
        }

        String bookError = appointmentService.bookAppointment(
                user.getId(), bookingDoctorId, bookingSlotId, date, bookingNotes);
        if (bookError != null) {
            throw new IllegalStateException(bookError);
        }

        session.removeAttribute("bookingDoctorId");
        session.removeAttribute("bookingSlotId");
        session.removeAttribute("bookingDate");
        session.removeAttribute("bookingNotes");

        return appointmentService.getLastCreatedAppointmentId(user.getId());
    }

    private void showPaymentPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if ("true".equals(request.getParameter("pending"))) {
            Integer bookingDoctorId = (Integer) session.getAttribute("bookingDoctorId");
            Integer bookingSlotId = (Integer) session.getAttribute("bookingSlotId");
            String bookingDate = (String) session.getAttribute("bookingDate");

            if (bookingDoctorId == null || bookingSlotId == null || bookingDate == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            Doctor doctor = doctorService.getDoctorById(bookingDoctorId);
            Slot slot = slotService.getSlotById(bookingSlotId);
            if (doctor == null || slot == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            Appointment display = new Appointment();
            display.setId(0);
            display.setDoctorName(doctor.getFullName());
            display.setSpecializationName(doctor.getSpecializationName());
            display.setAppointmentDate(LocalDate.parse(bookingDate));
            display.setSlotTime(slot.getFormattedTimeRange());
            display.setConsultationFee(doctor.getConsultationFee());

            request.setAttribute("appointment", display);
            request.setAttribute("existingPayment", null);
            request.setAttribute("pending", true);
        } else {
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null || appointment.getPatientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }

            request.setAttribute("appointment", appointment);
            request.setAttribute("existingPayment", paymentService.getPaymentByAppointmentId(appointmentId));
            request.setAttribute("pending", false);
        }

        request.setAttribute("pageTitle", "Payment - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/patient/payment.jsp").forward(request, response);
    }

    private void handleKhaltiCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String pidx = request.getParameter("pidx");
        String status = request.getParameter("status");
        String callbackTransactionId = request.getParameter("transaction_id");

        if (pidx == null || pidx.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/patient/appointments?error=Payment+was+not+verified.+Please+try+again.");
            return;
        }

        int appointmentId = paymentService.getAppointmentIdByPidx(pidx);
        PaymentService.VerificationStatus verificationStatus = paymentService.lookupAndVerify(pidx);

        if (verificationStatus == PaymentService.VerificationStatus.COMPLETED && appointmentId > 0) {
            appointmentService.updateStatus(appointmentId, "confirmed");
            response.sendRedirect(request.getContextPath()
                    + "/patient/appointments?success=Payment+successful.+Your+appointment+is+confirmed.");
            return;
        }

        if (verificationStatus == PaymentService.VerificationStatus.PENDING && appointmentId > 0) {
            response.sendRedirect(request.getContextPath()
                    + "/patient/appointments?success=Payment+is+pending+confirmation.+Please+refresh+in+a+moment.");
            return;
        }

        boolean userCancelled = "User canceled".equalsIgnoreCase(status)
                || callbackTransactionId == null
                || callbackTransactionId.trim().isEmpty();
        if (appointmentId > 0) {
            paymentService.deletePaymentByAppointmentId(appointmentId);
            appointmentService.deleteAppointment(appointmentId);
        }

        String message = userCancelled
                ? "Payment was cancelled. Your appointment was not confirmed."
                : "Payment could not be confirmed. Your appointment was not confirmed.";
        message = URLEncoder.encode(message, "UTF-8");
        response.sendRedirect(request.getContextPath() + "/doctors?error=" + message);
    }

    private void showPaymentHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<Payment> payments = paymentService.getPatientPayments(user.getId());
        request.setAttribute("payments", payments);
        request.setAttribute("pageTitle", "Payment History - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/patient/payments.jsp").forward(request, response);
    }

    private String buildPublicBaseUrl(HttpServletRequest request) {
        String forwardedProto = request.getHeader("X-Forwarded-Proto");
        String forwardedHost = request.getHeader("X-Forwarded-Host");
        String forwardedPort = request.getHeader("X-Forwarded-Port");

        String scheme = hasText(forwardedProto) ? forwardedProto : request.getScheme();
        String host = hasText(forwardedHost) ? forwardedHost : request.getServerName();
        int port = request.getServerPort();
        if (hasText(forwardedPort)) {
            try {
                port = Integer.parseInt(forwardedPort.trim());
            } catch (NumberFormatException ignored) {
                // Fall back to servlet request port when proxy port header is malformed.
            }
        }

        if (host.contains(",")) {
            host = host.split(",")[0].trim();
        }
        if (host.contains(":")) {
            host = host.substring(0, host.indexOf(':'));
        }

        boolean defaultPort = ("http".equalsIgnoreCase(scheme) && port == 80)
                || ("https".equalsIgnoreCase(scheme) && port == 443);
        String portPart = defaultPort ? "" : ":" + port;
        return scheme + "://" + host + portPart + request.getContextPath();
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
