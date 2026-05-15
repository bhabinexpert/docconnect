package com.docconnect.slot.controller;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.slot.model.Slot;
import com.docconnect.doctor.service.DoctorService;
import com.docconnect.slot.service.SlotService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Time;
import java.util.List;
import java.util.logging.Logger;

/**
 * Admin slot management controller.
 */
public class ManageSlotsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ManageSlotsServlet.class.getName());
    private final SlotService slotService = new SlotService();
    private final DoctorService doctorService = new DoctorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Slot> slots = slotService.getAllSlots();
        List<Doctor> doctors = doctorService.getAllDoctors();

        request.setAttribute("slots", slots);
        request.setAttribute("doctors", doctors);
        request.setAttribute("pageTitle", "Manage Slots - Admin");

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-slots.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                Slot slot = new Slot();
                slot.setDoctorId(Integer.parseInt(request.getParameter("doctorId")));

                String specificDateStr = request.getParameter("specificDate");
                if (specificDateStr != null && !specificDateStr.isEmpty()) {
                    slot.setSpecificDate(java.time.LocalDate.parse(specificDateStr));
                    slot.setDayOfWeek(null);
                } else {
                    slot.setDayOfWeek(request.getParameter("dayOfWeek"));
                    slot.setSpecificDate(null);
                }

                slot.setStartTime(Time.valueOf(request.getParameter("startTime") + ":00"));
                slot.setEndTime(Time.valueOf(request.getParameter("endTime") + ":00"));
                slot.setMaxPatients(1);
                slot.setActive(true);

                String error = slotService.createSlot(slot);
                if (error == null) {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/slots?success=Slot+added+successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/slots?error=" + error.replace(" ", "+"));
                }
            } catch (Exception e) {
                LOGGER.severe("Error adding slot: " + e.getMessage());
                response.sendRedirect(request.getContextPath() +
                        "/admin/slots?error=Invalid+slot+data.");
            }

        } else if ("delete".equals(action)) {
            try {
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                if (slotService.deleteSlot(slotId)) {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/slots?success=Slot+deleted+successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                            "/admin/slots?error=Cannot+delete+slot.");
                }
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/slots?error=Error+deleting+slot.");
            }

        } else if ("toggle".equals(action)) {
            try {
                int slotId = Integer.parseInt(request.getParameter("slotId"));
                boolean isActive = "true".equals(request.getParameter("isActive"));
                slotService.toggleSlotActive(slotId, isActive);
                response.sendRedirect(request.getContextPath() + "/admin/slots");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() +
                        "/admin/slots?error=Error+updating+slot.");
            }
        }
    }
}
