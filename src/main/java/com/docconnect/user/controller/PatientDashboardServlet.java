package com.docconnect.user.controller;

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
 * Patient dashboard controller.
 */
public class PatientDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PatientDashboardServlet.class.getName());
    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<Appointment> appointments = appointmentService.getPatientAppointments(user.getId());

        // Count by status
        long upcoming = appointments.stream()
                .filter(a -> "completed".equals(a.getPaymentStatus()) && (a.isConfirmed() || a.isRescheduled()))
                .count();
        long completed = appointments.stream()
                .filter(Appointment::isCompleted)
                .count();
        long cancelled = appointments.stream()
                .filter(Appointment::isCancelled)
                .count();

        request.setAttribute("appointments", appointments);
        request.setAttribute("upcomingCount", upcoming);
        request.setAttribute("completedCount", completed);
        request.setAttribute("cancelledCount", cancelled);
        request.setAttribute("totalCount", appointments.size());
        request.setAttribute("pageTitle", "Dashboard - DocConnect Nepal");

        request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp").forward(request, response);
    }
}
