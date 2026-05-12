package com.docconnect.payment.controller;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.doctor.model.Doctor;
import com.docconnect.doctor.service.DoctorService;
import com.docconnect.payment.model.Payment;
import com.docconnect.slot.model.Slot;
import com.docconnect.slot.service.SlotService;
import com.docconnect.user.model.User;
import com.docconnect.appointment.service.AppointmentService;
import com.docconnect.payment.service.PaymentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

/**
 * Handles Khalti ePay v2 payment flow.
 *
 * GET  /patient/payment          — show payment summary page
 * POST /patient/payment          — create appointment + initiate Khalti payment
 * GET  /patient/payment/verify   — Khalti callback: verify, update DB
 * GET  /patient/payments         — payment history
 *
 * Appointment is created only when the patient clicks "Pay with Khalti",
 * not when the booking form is submitted. This ensures no "Awaiting Payment"
 * appointments appear — every appointment in the DB has a completed payment.
 */
@WebServlet(name = "PaymentServlet",
        urlPatterns = {"/patient/payment", "/patient/payments", "/patient/payment/verify"})
public class PaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentServlet.class.getName());
    private final PaymentService paymentService = new PaymentService();
    private final AppointmentService appointmentService = new AppointmentService();
    private final DoctorService doctorService = new DoctorService();
    private final SlotService slotService = new SlotService();

    // -------------------------------------------------------------------------
    // GET
    // -------------------------------------------------------------------------
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

    // -------------------------------------------------------------------------
    // POST — create appointment then initiate Khalti ePay v2
    // -------------------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String pendingParam = request.getParameter("pending");

        try {
            int appointmentId;

            if ("true".equals(pendingParam)) {
                // ── Pending booking flow ──────────────────────────────────────
                // Appointment has NOT been saved yet; create it now.
                Integer bookingDoctorId = (Integer) session.getAttribute("bookingDoctorId");
                Integer bookingSlotId   = (Integer) session.getAttribute("bookingSlotId");
                String  bookingDate     = (String)  session.getAttribute("bookingDate");
                String  bookingNotes    = (String)  session.getAttribute("bookingNotes");

                if (bookingDoctorId == null || bookingSlotId == null || bookingDate == null) {
                    response.sendRedirect(request.getContextPath() + "/doctors");
                    return;
                }

                LocalDate date = LocalDate.parse(bookingDate);

                // Re-validate (slot might have been taken since user saw the form)
                String validError = appointmentService.validateBooking(
                        user.getId(), bookingDoctorId, bookingSlotId, date);
                if (validError != null) {
                    response.sendRedirect(request.getContextPath()
                            + "/patient/payment?pending=true&error="
                            + java.net.URLEncoder.encode(validError, "UTF-8"));
                    return;
                }

                // Create appointment now
                String bookError = appointmentService.bookAppointment(
                        user.getId(), bookingDoctorId, bookingSlotId, date, bookingNotes);
                if (bookError != null) {
                    response.sendRedirect(request.getContextPath()
                            + "/patient/payment?pending=true&error="
                            + java.net.URLEncoder.encode(bookError, "UTF-8"));
                    return;
                }

                appointmentId = appointmentService.getLastCreatedAppointmentId(user.getId());

                // Clear session booking data
                session.removeAttribute("bookingDoctorId");
                session.removeAttribute("bookingSlotId");
                session.removeAttribute("bookingDate");
                session.removeAttribute("bookingNotes");

            } else {
                // ── Normal flow (already-created appointment) ─────────────────
                String appointmentIdStr = request.getParameter("appointmentId");
                if (appointmentIdStr == null) {
                    response.sendRedirect(request.getContextPath() + "/patient/appointments");
                    return;
                }
                appointmentId = Integer.parseInt(appointmentIdStr);
            }

            Appointment appointment = appointmentService.getAppointmentById(appointmentId);

            if (appointment == null || appointment.getPatientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }

            // Build URLs dynamically so localhost works
            String baseUrl = request.getScheme() + "://"
                    + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath();
            String returnUrl  = baseUrl + "/patient/payment/verify";
            String websiteUrl = baseUrl + "/home";

            BigDecimal fee = appointment.getConsultationFee() != null
                    ? appointment.getConsultationFee()
                    : new BigDecimal("1000");

            String paymentUrl = paymentService.initiateKhaltiPayment(
                    appointmentId, fee,
                    returnUrl, websiteUrl,
                    user.getFullName(),
                    user.getEmail(),
                    user.getPhone() != null ? user.getPhone() : "");

            if (paymentUrl != null) {
                response.sendRedirect(paymentUrl);
            } else {
                // Khalti initiation failed — delete the appointment we just created
                paymentService.deletePaymentByAppointmentId(appointmentId);
                appointmentService.deleteAppointment(appointmentId);
                response.sendRedirect(request.getContextPath()
                        + "/doctors?error=Could+not+initiate+payment.+Please+try+again.");
            }

        } catch (Exception e) {
            LOGGER.severe("Payment initiation error: " + e.getMessage());
            response.sendRedirect(request.getContextPath()
                    + "/doctors?error=Payment+initiation+failed.+Please+try+again.");
        }
    }

    // -------------------------------------------------------------------------
    // Private handlers
    // -------------------------------------------------------------------------

    /**
     * Shows the payment summary page.
     * If pending=true, reads booking details from session and builds a display
     * Appointment without saving to DB. Otherwise loads from DB by appointmentId.
     */
    private void showPaymentPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if ("true".equals(request.getParameter("pending"))) {
            // ── Pending booking — show summary from session ───────────────────
            Integer bookingDoctorId = (Integer) session.getAttribute("bookingDoctorId");
            Integer bookingSlotId   = (Integer) session.getAttribute("bookingSlotId");
            String  bookingDate     = (String)  session.getAttribute("bookingDate");

            if (bookingDoctorId == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            Doctor doctor = doctorService.getDoctorById(bookingDoctorId);
            Slot   slot   = slotService.getSlotById(bookingSlotId);

            if (doctor == null || slot == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            // Build a display-only Appointment (id=0, not in DB)
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
            // ── Existing appointment ──────────────────────────────────────────
            String appointmentIdStr = request.getParameter("appointmentId");
            if (appointmentIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentService.getAppointmentById(appointmentId);

                if (appointment == null || appointment.getPatientId() != user.getId()) {
                    response.sendRedirect(request.getContextPath() + "/patient/appointments");
                    return;
                }

                Payment existingPayment = paymentService.getPaymentByAppointmentId(appointmentId);
                request.setAttribute("appointment", appointment);
                request.setAttribute("existingPayment", existingPayment);
                request.setAttribute("pending", false);

            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
        }

        request.setAttribute("pageTitle", "Payment - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/patient/payment.jsp").forward(request, response);
    }

    /**
     * Khalti ePay v2 callback handler.
     * On success: update payment status.
     * On failure: delete appointment + payment (clean up).
     */
    private void handleKhaltiCallback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String pidx   = request.getParameter("pidx");
        String status = request.getParameter("status");

        if (pidx == null || pidx.isEmpty()) {
            LOGGER.warning("Khalti callback missing pidx");
            response.sendRedirect(request.getContextPath()
                    + "/patient/appointments?error=Invalid+payment+callback.");
            return;
        }

        LOGGER.info("Khalti callback received. pidx=" + pidx + " status=" + status);

        // Resolve appointment ID BEFORE lookupAndVerify() — that method overwrites
        // transaction_id with the real Khalti transaction ID, making findByPidx() fail afterward.
        int appointmentId = paymentService.getAppointmentIdByPidx(pidx);

        boolean verified = paymentService.lookupAndVerify(pidx);

        if (verified) {
            if (appointmentId > 0) {
                appointmentService.updateStatus(appointmentId, "confirmed");
            }
            response.sendRedirect(request.getContextPath()
                    + "/patient/appointments?success=Payment+successful!+Your+appointment+is+confirmed.");
        } else {
            // Payment failed or was cancelled — clean up the appointment and payment
            if (appointmentId > 0) {
                paymentService.deletePaymentByAppointmentId(appointmentId);
                appointmentService.deleteAppointment(appointmentId);
                LOGGER.info("Cleaned up failed payment appointment: " + appointmentId);
            }
            response.sendRedirect(request.getContextPath()
                    + "/doctors?error=Payment+was+not+completed.+Please+try+booking+again.");
        }
    }

    /** Shows the patient's payment history. */
    private void showPaymentHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<Payment> payments = paymentService.getPatientPayments(user.getId());
        request.setAttribute("payments", payments);
        request.setAttribute("pageTitle", "Payment History - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/patient/payments.jsp")
                .forward(request, response);
    }
}
