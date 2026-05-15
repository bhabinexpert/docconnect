package com.docconnect.appointment.model.dao;

import com.docconnect.appointment.model.Appointment;
import com.docconnect.util.DbConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Appointment entity.
 */
public class AppointmentDAO {

    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());

    private static final String SELECT_FULL =
            "SELECT a.*, u.full_name AS patient_name, u.email AS patient_email, "
                    + "d.full_name AS doctor_name, d.consultation_fee, "
                    + "sp.name AS specialization_name, "
                    + "s.day_of_week AS slot_day, "
                    + "CONCAT(TIME_FORMAT(s.start_time, '%H:%i'), ' - ', TIME_FORMAT(s.end_time, '%H:%i')) AS slot_time, "
                    + "COALESCE(p.status, 'unpaid') AS payment_status "
                    + "FROM appointments a "
                    + "JOIN users u ON a.patient_id = u.id "
                    + "JOIN doctors d ON a.doctor_id = d.id "
                    + "JOIN specializations sp ON d.specialization_id = sp.id "
                    + "JOIN slots s ON a.slot_id = s.id "
                    + "LEFT JOIN payments p ON a.id = p.appointment_id";

    /**
     * Finds an appointment by ID with all related data.
     */
    public Appointment findById(int id) {
        String sql = SELECT_FULL + " WHERE a.id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding appointment by id: " + id, e);
        }
        return null;
    }

    /**
     * Finds all appointments for a specific patient.
     */
    public List<Appointment> findByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL + " WHERE a.patient_id = ? ORDER BY a.appointment_date DESC, s.start_time DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding appointments for patient: " + patientId, e);
        }
        return list;
    }

    /**
     * Finds all appointments (for admin).
     */
    public List<Appointment> findAll() {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL + " ORDER BY a.created_at DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all appointments.", e);
        }
        return list;
    }

    /**
     * Creates a new appointment with auto-generated daily token number.
     * Token numbers reset per doctor per day.
     */
    public int create(Appointment appointment) {
        try (Connection conn = DbConnection.getConnection()) {
            int token = 1;
            String tokenSql = "SELECT COALESCE(MAX(turn_number), 0) + 1 FROM appointments "
                    + "WHERE doctor_id = ? AND appointment_date = ? AND status != 'cancelled'";

            try (PreparedStatement psToken = conn.prepareStatement(tokenSql)) {
                psToken.setInt(1, appointment.getDoctorId());
                psToken.setDate(2, Date.valueOf(appointment.getAppointmentDate()));
                try (ResultSet rs = psToken.executeQuery()) {
                    if (rs.next()) {
                        token = rs.getInt(1);
                    }
                }
            }

            String insertSql = "INSERT INTO appointments (patient_id, doctor_id, slot_id, appointment_date, "
                    + "turn_number, status, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, appointment.getPatientId());
                ps.setInt(2, appointment.getDoctorId());
                ps.setInt(3, appointment.getSlotId());
                ps.setDate(4, Date.valueOf(appointment.getAppointmentDate()));
                ps.setInt(5, token);
                ps.setString(6, appointment.getStatus() != null ? appointment.getStatus() : "pending_payment");
                ps.setString(7, appointment.getNotes());

                int affected = ps.executeUpdate();
                if (affected > 0) {
                    int id = -1;
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            id = keys.getInt(1);
                        }
                    }

                    if (id <= 0) {
                        try (Statement s = conn.createStatement();
                             ResultSet rs = s.executeQuery("SELECT LAST_INSERT_ID()")) {
                            if (rs.next()) {
                                id = rs.getInt(1);
                            }
                        }
                    }

                    if (id > 0) {
                        return id;
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating appointment.", e);
        }
        return -1;
    }



    /**
     * Returns the highest appointment id belonging to a patient.
     * Used to retrieve the id of the appointment just inserted.
     * MAX(id) is reliable because auto-increment ids are monotonically increasing.
     */
    public int findLastInsertedIdForPatient(int patientId) {
        String sql = "SELECT MAX(id) FROM appointments WHERE patient_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding last appointment id for patient: " + patientId, e);
        }
        return -1;
    }

    /**
     * Gets the next token number for a doctor on a specific date.
     * Tokens reset daily — starts at 1 each day per doctor.
     */
    private int getNextTokenNumber(Connection conn, int doctorId, java.time.LocalDate date) throws SQLException {
        // This is now handled inside create() for transaction safety
        return 1;
    }

    /**
     * Deletes an appointment by ID.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting appointment: " + id, e);
        }
        return false;
    }

    /**
     * Updates appointment status.
     */
    public boolean updateStatus(int appointmentId, String status) {
        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating appointment status: " + appointmentId, e);
        }
        return false;
    }

    /**
     * Counts appointments by status.
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting appointments by status: " + status, e);
        }
        return 0;
    }

    /**
     * Counts total appointments.
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM appointments";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting all appointments.", e);
        }
        return 0;
    }

    /**
     * Gets recent appointments (for admin dashboard).
     */
    public List<Appointment> findRecent(int limit) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_FULL + " ORDER BY a.created_at DESC LIMIT ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding recent appointments.", e);
        }
        return list;
    }

    /**
     * Checks if a slot is already booked on a specific date.
     */
    public boolean isSlotBooked(int slotId, java.time.LocalDate date) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE slot_id = ? AND appointment_date = ? "
                + "AND status IN ('pending_payment', 'confirmed', 'rescheduled')";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ps.setDate(2, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking slot availability.", e);
        }
        return true; // Default to booked for safety
    }

    /**
     * Gets appointment counts grouped by status (for reports).
     */
    public List<Object[]> getStatusCounts() {
        List<Object[]> counts = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) as cnt FROM appointments GROUP BY status";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                counts.add(new Object[]{rs.getString("status"), rs.getInt("cnt")});
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting status counts.", e);
        }
        return counts;
    }

    private Appointment mapResultSet(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setId(rs.getInt("id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setDoctorId(rs.getInt("doctor_id"));
        a.setSlotId(rs.getInt("slot_id"));

        Date date = rs.getDate("appointment_date");
        if (date != null) {
            a.setAppointmentDate(date.toLocalDate());
        }

        a.setTurnNumber(rs.getInt("turn_number"));
        a.setStatus(rs.getString("status"));
        a.setNotes(rs.getString("notes"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));

        try {
            a.setPatientName(rs.getString("patient_name"));
            a.setPatientEmail(rs.getString("patient_email"));
            a.setDoctorName(rs.getString("doctor_name"));
            a.setSpecializationName(rs.getString("specialization_name"));
            a.setSlotDay(rs.getString("slot_day"));
            a.setSlotTime(rs.getString("slot_time"));
            a.setPaymentStatus(rs.getString("payment_status"));
            BigDecimal fee = rs.getBigDecimal("consultation_fee");
            a.setConsultationFee(fee);
        } catch (SQLException e) {
            // Transient columns may not exist in all queries
        }

        return a;
    }
}
