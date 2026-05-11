package com.docconnect.slot.service;

import com.docconnect.slot.model.dao.SlotDAO;
import com.docconnect.slot.model.Slot;

import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service layer for Slot-related business logic.
 */
public class SlotService {

    private static final Logger LOGGER = Logger.getLogger(SlotService.class.getName());
    private final SlotDAO slotDAO = new SlotDAO();

    /**
     * Gets all slots for a doctor.
     */
    public List<Slot> getDoctorSlots(int doctorId) {
        return slotDAO.findByDoctorId(doctorId);
    }

    /**
     * Gets available slots for a doctor on a specific date.
     */
    public List<Slot> getAvailableSlots(int doctorId, LocalDate date) {
        return slotDAO.findAvailableSlots(doctorId, date);
    }

    /**
     * Gets a slot by ID.
     */
    public Slot getSlotById(int id) {
        return slotDAO.findById(id);
    }

    /**
     * Creates a new slot.
     *
     * @return error message or null on success
     */
    public String createSlot(Slot slot) {
        if (slot.getDoctorId() <= 0) {
            return "Please select a doctor.";
        }
        if (slot.getDayOfWeek() == null || slot.getDayOfWeek().trim().isEmpty()) {
            return "Day of week is required.";
        }
        if (slot.getStartTime() == null || slot.getEndTime() == null) {
            return "Start and end times are required.";
        }
        if (slot.getStartTime().after(slot.getEndTime()) || slot.getStartTime().equals(slot.getEndTime())) {
            return "End time must be after start time.";
        }

        int id = slotDAO.create(slot);
        return id > 0 ? null : "Failed to create slot. It may already exist.";
    }

    /**
     * Deletes a slot.
     */
    public boolean deleteSlot(int id) {
        return slotDAO.delete(id);
    }

    /**
     * Toggles slot active status.
     */
    public boolean toggleSlotActive(int slotId, boolean isActive) {
        return slotDAO.toggleActive(slotId, isActive);
    }

    /**
     * Gets all slots (admin).
     */
    public List<Slot> getAllSlots() {
        return slotDAO.findAll();
    }
}
