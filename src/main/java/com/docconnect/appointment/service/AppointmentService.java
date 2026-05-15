package com.docconnect.appointment.service;

import com.docconnect.appointment.model.dao.AppointmentDAO;
import com.docconnect.appointment.model.Appointment;
import com.docconnect.slot.service.SlotService;

import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service layer for Appointment-related business logic.
 */
public class AppointmentService {

    private static final Logger LOGGER = Logger.getLogger(AppointmentService.class.getName());
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    /**
     * Validates booking parameters without creating the appointment.
     * Returns an error message or null if everything is valid.
     */
    public String validateBooking(int patientId, int doctorId, int slotId, LocalDate date) {
        if (date == null) return "Appointment date is required.";
        if (date.isBefore(LocalDate.now())) return "Cannot book appointments in the past.";

        SlotService slotService = new SlotService();
        com.docconnect.slot.model.Slot slot = slotService.getSlotById(slotId);
        if (slot == null) return "Invalid slot selected.";

        boolean dateMatches = false;
        if (slot.getSpecificDate() != null) {
            dateMatches = slot.getSpecificDate().equals(date);
        } else if (slot.getDayOfWeek() != null) {
            dateMatches = date.getDayOfWeek().name().equalsIgnoreCase(slot.getDayOfWeek());
        }
        if (!dateMatches) return "The selected slot does not apply to the chosen date.";
        if (appointmentDAO.isSlotBooked(slotId, date)) return "This time slot is already booked. Please choose another.";
        return null;
    }

    /**
     * Books a new appointment.
     *
     * @return error message or null on success
     */
    public String bookAppointment(int patientId, int doctorId, int slotId, LocalDate date, String notes) {
        // Validation
        if (date == null) {
            return "Appointment date is required.";
        }

        if (date.isBefore(LocalDate.now())) {
            return "Cannot book appointments in the past.";
        }

        // Check if slot is valid for the date
        SlotService slotService = new SlotService();
        com.docconnect.slot.model.Slot slot = slotService.getSlotById(slotId);

        if (slot == null) {
            return "Invalid slot selected.";
        }

        // Validate if slot applies to this date
        boolean dateMatches = false;
        if (slot.getSpecificDate() != null) {
            dateMatches = slot.getSpecificDate().equals(date);
        } else if (slot.getDayOfWeek() != null) {
            dateMatches = date.getDayOfWeek().name().equalsIgnoreCase(slot.getDayOfWeek());
        }

        if (!dateMatches) {
            return "The selected slot does not apply to the chosen date.";
        }

        // Check if slot is available
        if (appointmentDAO.isSlotBooked(slotId, date)) {
            return "This time slot is already booked for the selected date. Please choose another.";
        }

        // Create appointment
        Appointment appointment = new Appointment();
        appointment.setPatientId(patientId);
        appointment.setDoctorId(doctorId);
        appointment.setSlotId(slotId);
        appointment.setAppointmentDate(date);
        appointment.setStatus("pending_payment");
        appointment.setNotes(notes);

        int id = appointmentDAO.create(appointment);
        if (id > 0) {
            LOGGER.info("Appointment booked: ID=" + id + " Patient=" + patientId + " Doctor=" + doctorId);
            return null; // Success
        }

        return "Failed to book appointment. Please try again.";
    }

    /**
     * Gets the ID of the most recently created appointment for a patient.
     * Uses MAX(id) for reliability — auto-increment ids are monotonically increasing.
     */
    public int getLastCreatedAppointmentId(int patientId) {
        return appointmentDAO.findLastInsertedIdForPatient(patientId);
    }

    /**
     * Deletes an appointment (used to clean up when payment fails).
     */
    public boolean deleteAppointment(int id) {
        return appointmentDAO.delete(id);
    }

    /**
     * Cancels an appointment.
     */
    public boolean cancelAppointment(int appointmentId, int patientId) {
        Appointment appointment = appointmentDAO.findById(appointmentId);
        if (appointment == null || appointment.getPatientId() != patientId) {
            return false;
        }
        if (appointment.isCompleted() || appointment.isCancelled() || appointment.isRescheduled()) {
            return false;
        }
        return appointmentDAO.updateStatus(appointmentId, "cancelled");
    }

    /**
     * Updates appointment status (admin).
     */
    public boolean updateStatus(int appointmentId, String status) {
        return appointmentDAO.updateStatus(appointmentId, status);
    }

    /**
     * Gets an appointment by ID.
     */
    public Appointment getAppointmentById(int id) {
        return appointmentDAO.findById(id);
    }

    /**
     * Gets all appointments for a patient.
     */
    public List<Appointment> getPatientAppointments(int patientId) {
        return appointmentDAO.findByPatientId(patientId);
    }

    /**
     * Gets all appointments (admin).
     */
    public List<Appointment> getAllAppointments() {
        return appointmentDAO.findAll();
    }

    /**
     * Gets recent appointments.
     */
    public List<Appointment> getRecentAppointments(int limit) {
        return appointmentDAO.findRecent(limit);
    }

    /**
     * Gets counts by status.
     */
    public int countByStatus(String status) {
        return appointmentDAO.countByStatus(status);
    }

    /**
     * Gets total appointment count.
     */
    public int countAll() {
        return appointmentDAO.countAll();
    }

    /**
     * Gets status distribution for reports.
     */
    public List<Object[]> getStatusDistribution() {
        return appointmentDAO.getStatusCounts();
    }
}
