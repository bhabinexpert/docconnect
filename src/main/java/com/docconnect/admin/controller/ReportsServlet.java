package com.docconnect.admin.controller;

import com.docconnect.payment.model.Payment;
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
 * Admin reports and analytics controller.
 */
@WebServlet(name = "ReportsServlet", urlPatterns = {"/admin/reports"})
public class ReportsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReportsServlet.class.getName());
    private final AppointmentService appointmentService = new AppointmentService();
    private final PaymentService paymentService = new PaymentService();
    private final DoctorService doctorService = new DoctorService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Summary statistics
        request.setAttribute("totalAppointments", appointmentService.countAll());
        request.setAttribute("rescheduledCount", appointmentService.countByStatus("rescheduled"));
        request.setAttribute("confirmedCount", appointmentService.countByStatus("confirmed"));
        request.setAttribute("completedCount", appointmentService.countByStatus("completed"));
        request.setAttribute("cancelledCount", appointmentService.countByStatus("cancelled"));
        request.setAttribute("totalRevenue", paymentService.getTotalRevenue());
        request.setAttribute("totalDoctors", doctorService.countActiveDoctors());
        request.setAttribute("totalPatients", userService.countPatients());

        // Status distribution
        List<Object[]> statusCounts = appointmentService.getStatusDistribution();
        request.setAttribute("statusCounts", statusCounts);

        // All payments
        List<Payment> payments = paymentService.getAllPayments();
        request.setAttribute("payments", payments);

        request.setAttribute("pageTitle", "Reports & Analytics - Admin");
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
    }
}
