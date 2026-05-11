package com.docconnect.payment.model.dao;

import com.docconnect.payment.model.Payment;
import com.docconnect.util.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Payment entity.
 */
public class PaymentDAO {

    private static final Logger LOGGER = Logger.getLogger(PaymentDAO.class.getName());

    /**
     * Creates a new payment record. Returns generated ID.
     */
    public int create(Payment payment) {
        String sql = "INSERT INTO payments (appointment_id, amount, payment_method, transaction_id, status, paid_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, payment.getAppointmentId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            ps.setString(4, payment.getTransactionId());
            ps.setString(5, payment.getStatus() != null ? payment.getStatus() : "pending");
            ps.setTimestamp(6, payment.getPaidAt());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating payment.", e);
        }
        return -1;
    }

    /**
     * Updates payment status and transaction ID after verification.
     */
    public boolean updateStatus(int paymentId, String status, String transactionId) {
        String sql = "UPDATE payments SET status = ?, transaction_id = ?, paid_at = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, transactionId);
            ps.setTimestamp(3, "completed".equals(status) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(4, paymentId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status: " + paymentId, e);
        }
        return false;
    }

    /**
     * Finds a payment by its Khalti pidx (stored in transaction_id during initiation).
     */
    public Payment findByPidx(String pidx) {
        String sql = "SELECT * FROM payments WHERE transaction_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pidx);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding payment by pidx: " + pidx, e);
        }
        return null;
    }

    /**
     * Finds a payment by appointment ID.
     */
    public Payment findByAppointmentId(int appointmentId) {
        String sql = "SELECT * FROM payments WHERE appointment_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding payment for appointment: " + appointmentId, e);
        }
        return null;
    }

    /**
     * Finds a payment by ID.
     */
    public Payment findById(int id) {
        String sql = "SELECT * FROM payments WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding payment by id: " + id, e);
        }
        return null;
    }

    /**
     * Returns all payments for a patient (via appointments).
     */
    public List<Payment> findByPatientId(int patientId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name AS patient_name, d.full_name AS doctor_name, "
                + "a.appointment_date "
                + "FROM payments p "
                + "JOIN appointments a ON p.appointment_id = a.id "
                + "JOIN users u ON a.patient_id = u.id "
                + "JOIN doctors d ON a.doctor_id = d.id "
                + "WHERE a.patient_id = ? ORDER BY p.paid_at DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment p = mapResultSet(rs);
                    try {
                        p.setPatientName(rs.getString("patient_name"));
                        p.setDoctorName(rs.getString("doctor_name"));
                        Date d = rs.getDate("appointment_date");
                        if (d != null) p.setAppointmentDate(d.toString());
                    } catch (SQLException e) { /* ignore */ }
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding payments for patient: " + patientId, e);
        }
        return list;
    }

    /**
     * Returns all payments (for admin).
     */
    public List<Payment> findAll() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name AS patient_name, d.full_name AS doctor_name, "
                + "a.appointment_date "
                + "FROM payments p "
                + "JOIN appointments a ON p.appointment_id = a.id "
                + "JOIN users u ON a.patient_id = u.id "
                + "JOIN doctors d ON a.doctor_id = d.id "
                + "ORDER BY p.paid_at DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Payment p = mapResultSet(rs);
                try {
                    p.setPatientName(rs.getString("patient_name"));
                    p.setDoctorName(rs.getString("doctor_name"));
                    Date d = rs.getDate("appointment_date");
                    if (d != null) p.setAppointmentDate(d.toString());
                } catch (SQLException e) { /* ignore */ }
                list.add(p);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all payments.", e);
        }
        return list;
    }

    /**
     * Deletes payment records for an appointment (clean up on failed payment).
     */
    public boolean deleteByAppointmentId(int appointmentId) {
        String sql = "DELETE FROM payments WHERE appointment_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting payment for appointment: " + appointmentId, e);
        }
        return false;
    }

    /**
     * Gets total revenue from completed payments.
     */
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'completed'";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total revenue.", e);
        }
        return 0;
    }

    private Payment mapResultSet(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setAppointmentId(rs.getInt("appointment_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setStatus(rs.getString("status"));
        p.setPaidAt(rs.getTimestamp("paid_at"));
        return p;
    }
}
