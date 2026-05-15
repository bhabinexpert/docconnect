package com.docconnect.admin.controller;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.appointment.service.AppointmentService;
import com.docconnect.payment.model.Payment;
import com.docconnect.payment.service.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Admin appointments management controller.
 */
public class AdminAppointmentsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminAppointmentsServlet.class.getName());
    private final AppointmentService appointmentService = new AppointmentService();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> appointments = appointmentService.getAllAppointments();
        request.setAttribute("appointments", appointments);
        request.setAttribute("pageTitle", "Manage Appointments - Admin");

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            try {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                String status = request.getParameter("status");

                // Validate allowed status values
                if (status == null || !status.matches("confirmed|completed|cancelled|rescheduled")) {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/appointments?error=Invalid+status+value.");
                    return;
                }

                if (status.matches("confirmed|completed|rescheduled")) {
                    Payment payment = paymentService.getPaymentByAppointmentId(appointmentId);
                    if (payment == null || !payment.isCompleted()) {
                        response.sendRedirect(request.getContextPath() +
                                "/admin/appointments?error=Cannot+confirm+an+unpaid+appointment.");
                        return;
                    }
                }

                if (appointmentService.updateStatus(appointmentId, status)) {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/appointments?success=Appointment+status+updated.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/appointments?error=Failed+to+update+status.");
                }
            } catch (Exception e) {
                LOGGER.severe("Error updating appointment: " + e.getMessage());
                response.sendRedirect(request.getContextPath() +
                        "/admin/appointments?error=Error+updating+appointment.");
            }
        }
    }
}
