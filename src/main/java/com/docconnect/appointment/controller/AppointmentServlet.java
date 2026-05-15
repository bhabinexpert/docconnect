package com.docconnect.appointment.controller;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.user.model.User;
import com.docconnect.appointment.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Patient appointments listing and management controller.
 */
public class AppointmentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AppointmentServlet.class.getName());
    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<Appointment> appointments = appointmentService.getPatientAppointments(user.getId());
        request.setAttribute("appointments", appointments);
        request.setAttribute("pageTitle", "My Appointments - DocConnect Nepal");

        request.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("cancel".equals(action)) {
            try {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                boolean cancelled = appointmentService.cancelAppointment(appointmentId, user.getId());

                if (cancelled) {
                    response.sendRedirect(request.getContextPath() +
                            "/patient/appointments?success=Appointment+cancelled+successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/patient/appointments?error=Unable+to+cancel+appointment.");
                }
            } catch (Exception e) {
                LOGGER.severe("Error cancelling appointment: " + e.getMessage());
                response.sendRedirect(request.getContextPath() +
                        "/patient/appointments?error=An+error+occurred.");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
        }
    }
}
