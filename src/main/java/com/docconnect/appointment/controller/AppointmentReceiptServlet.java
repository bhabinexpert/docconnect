package com.docconnect.appointment.controller;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.payment.model.Payment;
import com.docconnect.user.model.User;
import com.docconnect.appointment.service.AppointmentService;
import com.docconnect.payment.service.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller to display appointment receipt for printing.
 * Only accessible after successful payment.
 */
public class AppointmentReceiptServlet extends HttpServlet {

    private final AppointmentService appointmentService = new AppointmentService();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }

        boolean isAdmin = "admin".equals(session.getAttribute("userRole"));
        String backUrl = isAdmin
                ? request.getContextPath() + "/admin/appointments"
                : request.getContextPath() + "/patient/appointments";

        try {
            int appointmentId = Integer.parseInt(idStr);
            Appointment appointment = appointmentService.getAppointmentById(appointmentId);

            // Admin can view any appointment; patient can only view their own
            if (appointment == null || (!isAdmin && appointment.getPatientId() != user.getId())) {
                response.sendRedirect(backUrl + "?error=Invalid+appointment");
                return;
            }

            Payment payment = paymentService.getPaymentByAppointmentId(appointmentId);
            if (payment == null || !payment.isCompleted()) {
                response.sendRedirect(backUrl + "?error=Receipt+not+available+for+this+appointment");
                return;
            }

            request.setAttribute("appointment", appointment);
            request.setAttribute("payment", payment);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("backUrl", backUrl);
            request.setAttribute("pageTitle", "Appointment Receipt #" + appointment.getId());

            request.getRequestDispatcher("/WEB-INF/views/patient/appointment-receipt.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(backUrl);
        }
    }
}
