package com.docconnect.admin.controller;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.specialization.model.Specialization;
import com.docconnect.doctor.service.DoctorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Logger;

/**
 * Admin doctor management controller.
 */
@WebServlet(name = "ManageDoctorsServlet", urlPatterns = {"/admin/doctors"})
public class ManageDoctorsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ManageDoctorsServlet.class.getName());
    private final DoctorService doctorService = new DoctorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("edit".equals(action) || "add".equals(action)) {
            // Show form
            List<Specialization> specializations = doctorService.getAllSpecializations();
            request.setAttribute("specializations", specializations);

            if ("edit".equals(action)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Doctor doctor = doctorService.getDoctorById(id);
                    request.setAttribute("doctor", doctor);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/doctors");
                    return;
                }
            }

            request.setAttribute("pageTitle", ("edit".equals(action) ? "Edit" : "Add") + " Doctor - Admin");
            request.getRequestDispatcher("/WEB-INF/views/admin/doctor-form.jsp").forward(request, response);

        } else {
            // List all doctors
            List<Doctor> doctors = doctorService.getAllDoctors();
            request.setAttribute("doctors", doctors);
            request.setAttribute("pageTitle", "Manage Doctors - Admin");
            request.getRequestDispatcher("/WEB-INF/views/admin/manage-doctors.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("save".equals(action)) {
            Doctor doctor = new Doctor();
            try {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    doctor.setId(Integer.parseInt(idStr));
                }

                doctor.setFullName(request.getParameter("fullName"));
                doctor.setEmail(request.getParameter("email"));
                doctor.setPhone(request.getParameter("phone"));
                doctor.setSpecializationId(Integer.parseInt(request.getParameter("specializationId")));
                doctor.setQualification(request.getParameter("qualification"));
                doctor.setExperienceYears(Integer.parseInt(request.getParameter("experienceYears")));
                doctor.setConsultationFee(new BigDecimal(request.getParameter("consultationFee")));
                doctor.setBio(request.getParameter("bio"));
                doctor.setGender(request.getParameter("gender"));
                doctor.setActive("on".equals(request.getParameter("isActive")) || "true".equals(request.getParameter("isActive")));
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid number format in doctor form: " + e.getMessage());
                request.setAttribute("error", "Invalid value for fee, experience, or specialization.");
                request.setAttribute("doctor", doctor);
                request.setAttribute("specializations", doctorService.getAllSpecializations());
                request.setAttribute("pageTitle", "Doctor Form - Admin");
                request.getRequestDispatcher("/WEB-INF/views/admin/doctor-form.jsp").forward(request, response);
                return;
            }

            String error;
            if (doctor.getId() > 0) {
                error = doctorService.updateDoctor(doctor);
            } else {
                error = doctorService.createDoctor(doctor);
            }

            if (error == null) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/doctors?success=Doctor+saved+successfully.");
            } else {
                request.setAttribute("error", error);
                request.setAttribute("doctor", doctor);
                request.setAttribute("specializations", doctorService.getAllSpecializations());
                request.setAttribute("pageTitle", "Doctor Form - Admin");
                request.getRequestDispatcher("/WEB-INF/views/admin/doctor-form.jsp").forward(request, response);
            }

        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (doctorService.deleteDoctor(id)) {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/doctors?success=Doctor+deleted+successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/doctors?error=Cannot+delete+doctor.+They+may+have+existing+appointments.");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/doctors?error=Error+deleting+doctor.");
            }
        }
    }
}
