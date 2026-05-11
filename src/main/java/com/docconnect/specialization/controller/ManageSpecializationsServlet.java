package com.docconnect.specialization.controller;

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
 * Admin specialization management controller.
 */
@WebServlet(name = "ManageSpecializationsServlet", urlPatterns = {"/admin/specializations"})
public class ManageSpecializationsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ManageSpecializationsServlet.class.getName());
    private final DoctorService doctorService = new DoctorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Specialization spec = doctorService.getSpecializationById(id);
                request.setAttribute("specialization", spec);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/specializations");
                return;
            }
        }

        List<Specialization> specializations = doctorService.getAllSpecializations();
        request.setAttribute("specializations", specializations);
        request.setAttribute("pageTitle", "Manage Specializations - Admin");

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-specializations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("save".equals(action)) {
            Specialization spec = new Specialization();
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                spec.setId(Integer.parseInt(idStr));
            }
            spec.setName(request.getParameter("name"));
            spec.setDescription(request.getParameter("description"));
            spec.setIconClass(request.getParameter("iconClass"));

            String error;
            if (spec.getId() > 0) {
                error = doctorService.updateSpecialization(spec);
            } else {
                error = doctorService.createSpecialization(spec);
            }

            if (error == null) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/specializations?success=Specialization+saved+successfully.");
            } else {
                request.setAttribute("error", error);
                request.setAttribute("specialization", spec);
                request.setAttribute("specializations", doctorService.getAllSpecializations());
                request.setAttribute("pageTitle", "Manage Specializations - Admin");
                request.getRequestDispatcher("/WEB-INF/views/admin/manage-specializations.jsp").forward(request, response);
            }

        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                if (doctorService.deleteSpecialization(id)) {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/specializations?success=Specialization+deleted+successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/specializations?error=Cannot+delete+specialization.+It+may+be+linked+to+doctors.");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/specializations?error=Error+deleting+specialization.");
            }
        }
    }
}
