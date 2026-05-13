package com.docconnect.admin.controller;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.appointment.service.AppointmentService;
import com.docconnect.doctor.service.DoctorService;
import com.docconnect.payment.service.PaymentService;
import com.docconnect.user.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Admin dashboard controller.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private final UserService userService = new UserService();
    private final DoctorService doctorService = new DoctorService();
    private final AppointmentService appointmentService = new AppointmentService();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Statistics
        request.setAttribute("totalPatients", userService.countPatients());
        request.setAttribute("totalDoctors", doctorService.countActiveDoctors());
        request.setAttribute("totalAppointments", appointmentService.countAll());
        request.setAttribute("pendingAppointments", appointmentService.countByStatus("pending"));
        request.setAttribute("totalRevenue", paymentService.getTotalRevenue());

        // Recent appointments
        List<Appointment> recentAppointments = appointmentService.getRecentAppointments(10);
        request.setAttribute("recentAppointments", recentAppointments);

        request.setAttribute("pageTitle", "Admin Dashboard - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
