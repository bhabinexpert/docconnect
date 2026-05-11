package com.docconnect.slot.model.dao;

import com.docconnect.slot.model.Slot;
import com.docconnect.util.DbConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Slot entity.
 */
public class SlotDAO {

    private static final Logger LOGGER = Logger.getLogger(SlotDAO.class.getName());

    /**
     * Finds all active slots for a specific doctor.
     */
    public List<Slot> findByDoctorId(int doctorId) {
        List<Slot> slots = new ArrayList<>();
        String sql = "SELECT s.*, d.full_name AS doctor_name FROM slots s "
                + "JOIN doctors d ON s.doctor_id = d.id "
                + "WHERE s.doctor_id = ? AND s.is_active = TRUE "
                + "ORDER BY s.specific_date, FIELD(s.day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), s.start_time";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slots.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding slots for doctor: " + doctorId, e);
        }
        return slots;
    }

    /**
     * Finds available slots for a doctor on a specific date.
     * Excludes slots already booked for that date.
     */
    public List<Slot> findAvailableSlots(int doctorId, LocalDate date) {
        List<Slot> slots = new ArrayList<>();
        String dayOfWeek = date.getDayOfWeek().name();
        // Convert Java's enum to match MySQL enum
        dayOfWeek = dayOfWeek.charAt(0) + dayOfWeek.substring(1).toLowerCase();

        String sql = "SELECT s.*, d.full_name AS doctor_name FROM slots s "
                + "JOIN doctors d ON s.doctor_id = d.id "
                + "WHERE s.doctor_id = ? AND (s.specific_date = ? OR (s.specific_date IS NULL AND s.day_of_week = ?)) AND s.is_active = TRUE "
                + "AND s.id NOT IN ("
                + "    SELECT a.slot_id FROM appointments a "
                + "    WHERE a.doctor_id = ? AND a.appointment_date = ? "
                + "    AND a.status IN ('pending', 'confirmed')"
                + ") ORDER BY s.start_time";

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, Date.valueOf(date));
            ps.setString(3, dayOfWeek);
            ps.setInt(4, doctorId);
            ps.setDate(5, Date.valueOf(date));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slots.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding available slots.", e);
        }
        return slots;
    }

    /**
     * Finds a slot by ID.
     */
    public Slot findById(int id) {
        String sql = "SELECT s.*, d.full_name AS doctor_name FROM slots s "
                + "JOIN doctors d ON s.doctor_id = d.id WHERE s.id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding slot by id: " + id, e);
        }
        return null;
    }

    /**
     * Creates a new slot. Returns the generated ID.
     */
    public int create(Slot slot) {
        String sql = "INSERT INTO slots (doctor_id, day_of_week, specific_date, start_time, end_time, max_patients, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, slot.getDoctorId());
            ps.setString(2, slot.getDayOfWeek());
            ps.setDate(3, slot.getSpecificDate() != null ? Date.valueOf(slot.getSpecificDate()) : null);
            ps.setTime(4, slot.getStartTime());
            ps.setTime(5, slot.getEndTime());
            ps.setInt(6, slot.getMaxPatients());
            ps.setBoolean(7, slot.isActive());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating slot.", e);
        }
        return -1;
    }

    /**
     * Deletes a slot by ID.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM slots WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting slot: " + id, e);
        }
        return false;
    }

    /**
     * Toggles slot active status.
     */
    public boolean toggleActive(int slotId, boolean isActive) {
        String sql = "UPDATE slots SET is_active = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);
            ps.setInt(2, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error toggling slot status: " + slotId, e);
        }
        return false;
    }

    /**
     * Finds all slots (for admin management).
     */
    public List<Slot> findAll() {
        List<Slot> slots = new ArrayList<>();
        String sql = "SELECT s.*, d.full_name AS doctor_name FROM slots s "
                + "JOIN doctors d ON s.doctor_id = d.id "
                + "ORDER BY d.full_name, FIELD(s.day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), s.start_time";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                slots.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all slots.", e);
        }
        return slots;
    }

    private Slot mapResultSet(ResultSet rs) throws SQLException {
        Slot slot = new Slot();
        slot.setId(rs.getInt("id"));
        slot.setDoctorId(rs.getInt("doctor_id"));
        slot.setDayOfWeek(rs.getString("day_of_week"));
        Date sDate = rs.getDate("specific_date");
        if (sDate != null) {
            slot.setSpecificDate(sDate.toLocalDate());
        }
        slot.setStartTime(rs.getTime("start_time"));
        slot.setEndTime(rs.getTime("end_time"));
        slot.setMaxPatients(rs.getInt("max_patients"));
        slot.setActive(rs.getBoolean("is_active"));

        try {
            slot.setDoctorName(rs.getString("doctor_name"));
        } catch (SQLException e) {
            // Column may not exist
        }

        return slot;
    }
}
