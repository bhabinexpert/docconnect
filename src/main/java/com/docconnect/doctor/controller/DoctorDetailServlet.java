package com.docconnect.doctor.controller;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.slot.model.Slot;
import com.docconnect.doctor.service.DoctorService;
import com.docconnect.slot.service.SlotService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Public doctor detail view for guests and members.
 * Shows availability and details.
 */
@WebServlet(name = "DoctorDetailServlet", urlPatterns = {"/doctor"})
public class DoctorDetailServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DoctorDetailServlet.class.getName());
    private final DoctorService doctorService = new DoctorService();
    private final SlotService slotService = new SlotService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            Doctor doctor = doctorService.getDoctorById(doctorId);

            if (doctor == null) {
                response.sendRedirect(request.getContextPath() + "/doctors");
                return;
            }

            // Get standard weekly slots
            List<Slot> slots = slotService.getDoctorSlots(doctorId);

            request.setAttribute("doctor", doctor);
            request.setAttribute("slots", slots);
            request.setAttribute("pageTitle", doctor.getFullName() + " - DocConnect Nepal");

            request.getRequestDispatcher("/WEB-INF/views/guest/doctor-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctors");
        } catch (Exception e) {
            LOGGER.severe("Error viewing doctor detail: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctors");
        }
    }
}
