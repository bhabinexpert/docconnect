package com.docconnect.doctor.controller;

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
 * Doctor listing and search controller.
 */
@WebServlet(name = "DoctorListServlet", urlPatterns = {"/doctors"})
public class DoctorListServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DoctorListServlet.class.getName());
    private final DoctorService doctorService = new DoctorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String specIdStr = request.getParameter("specialization");
        String sortBy = request.getParameter("sortBy");
        Integer specializationId = null;

        if (specIdStr != null && !specIdStr.isEmpty()) {
            try {
                specializationId = Integer.parseInt(specIdStr);
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }

        List<Doctor> doctors = doctorService.searchDoctors(keyword, specializationId, sortBy);

        List<Specialization> specializations = doctorService.getAllSpecializations();

        request.setAttribute("doctors", doctors);
        request.setAttribute("specializations", specializations);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedSpecialization", specializationId);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("pageTitle", "Our Doctors - DocConnect Nepal");

        request.getRequestDispatcher("/WEB-INF/views/guest/doctor-list.jsp").forward(request, response);
    }
}
