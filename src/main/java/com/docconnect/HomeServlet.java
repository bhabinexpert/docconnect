package com.docconnect;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.specialization.model.Specialization;
import com.docconnect.doctor.service.DoctorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Home page controller.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());
    private final DoctorService doctorService = new DoctorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admins have no business on the landing page — send them straight to their dashboard
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null && "admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        List<Doctor> featuredDoctors = doctorService.getActiveDoctors(null);
        List<Specialization> specializations = doctorService.getAllSpecializations();

        // Limit to 6 featured doctors
        if (featuredDoctors.size() > 6) {
            featuredDoctors = featuredDoctors.subList(0, 6);
        }

        request.setAttribute("featuredDoctors", featuredDoctors);
        request.setAttribute("specializations", specializations);
        request.setAttribute("pageTitle", "DocConnect Nepal - Your Health, Our Priority");

        request.getRequestDispatcher("/WEB-INF/views/guest/home.jsp").forward(request, response);

    }
}
