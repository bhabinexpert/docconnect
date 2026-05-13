package com.docconnect.appointment.controller;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.slot.model.Slot;
import com.docconnect.user.model.User;
import com.docconnect.appointment.service.AppointmentService;
import com.docconnect.doctor.service.DoctorService;
import com.docconnect.slot.service.SlotService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Book appointment controller.
 */
@WebServlet(name = "BookAppointmentServlet", urlPatterns = {"/patient/book"})
public class BookAppointmentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());
    private final DoctorService doctorService = new DoctorService();
    private final SlotService slotService = new SlotService();
    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String doctorIdStr = request.getParameter("doctorId");
        String dateStr = request.getParameter("date");

        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            showBookingForm(request, response, doctorId, dateStr);
        } catch (Exception e) {
            LOGGER.severe("Error in book appointment GET: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctors");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String doctorIdStr = request.getParameter("doctorId");
        String slotIdStr = request.getParameter("slotId");
        String dateStr = request.getParameter("appointmentDate");
        String notes = request.getParameter("notes");

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            int slotId = Integer.parseInt(slotIdStr);
            LocalDate date = LocalDate.parse(dateStr);

            // Validate only — do NOT create appointment yet.
            // Appointment is created only after payment is initiated.
            String error = appointmentService.validateBooking(user.getId(), doctorId, slotId, date);

            if (error == null) {
                // Store booking details in session; appointment will be created at payment time
                HttpSession session = request.getSession();
                session.setAttribute("bookingDoctorId", doctorId);
                session.setAttribute("bookingSlotId", slotId);
                session.setAttribute("bookingDate", date.toString());
                session.setAttribute("bookingNotes", notes != null ? notes : "");
                response.sendRedirect(request.getContextPath() + "/patient/payment?pending=true");
            } else {
                request.setAttribute("error", error);
                showBookingForm(request, response, doctorId, dateStr);
            }

        } catch (Exception e) {
            LOGGER.severe("Error booking appointment: " + e.getMessage());
            request.setAttribute("error", "An error occurred. Please try again.");
            try {
                int doctorId = Integer.parseInt(doctorIdStr);
                showBookingForm(request, response, doctorId, dateStr);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/doctors");
            }
        }
    }

    /**
     * Loads doctor info, available dates, and slots for the chosen date,
     * then forwards to the booking JSP.
     * Shared by both GET and the error path in POST so the slot grid is
     * always visible when the form is displayed.
     */
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response,
                                 int doctorId, String dateStr)
            throws ServletException, IOException {

        Doctor doctor = doctorService.getDoctorById(doctorId);
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        }
        request.setAttribute("doctor", doctor);

        // Build the list of dates in the next 14 days on which this doctor has slots
        List<Slot> allActiveSlots = slotService.getDoctorSlots(doctorId);
        List<LocalDate> availableDates = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (int i = 0; i < 14; i++) {
            LocalDate date = today.plusDays(i);
            String dayName = date.getDayOfWeek().name();
            dayName = dayName.charAt(0) + dayName.substring(1).toLowerCase();

            final String currentDay = dayName;
            boolean hasSlot = allActiveSlots.stream().anyMatch(s ->
                    (s.getSpecificDate() != null && s.getSpecificDate().equals(date)) ||
                            (s.getSpecificDate() == null && s.getDayOfWeek() != null
                                    && s.getDayOfWeek().equalsIgnoreCase(currentDay))
            );

            if (hasSlot) {
                availableDates.add(date);
            }
        }
        request.setAttribute("availableDates", availableDates);

        // Load slots for the selected (or default first) date
        if (dateStr != null && !dateStr.isEmpty()) {
            LocalDate date = LocalDate.parse(dateStr);
            List<Slot> availableSlots = slotService.getAvailableSlots(doctorId, date);
            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("selectedDate", dateStr);
        } else if (!availableDates.isEmpty()) {
            LocalDate date = availableDates.get(0);
            List<Slot> availableSlots = slotService.getAvailableSlots(doctorId, date);
            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("selectedDate", date.toString());
        }

        request.setAttribute("pageTitle", "Book Appointment - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/patient/book.jsp").forward(request, response);
    }
}
