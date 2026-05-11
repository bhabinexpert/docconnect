package com.docconnect.doctor.model.dao;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.util.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Doctor entity.
 */
public class DoctorDAO {

    private static final Logger LOGGER = Logger.getLogger(DoctorDAO.class.getName());

    private static final String SELECT_WITH_SPEC =
            "SELECT d.*, s.name AS specialization_name FROM doctors d "
            + "LEFT JOIN specializations s ON d.specialization_id = s.id";

    /**
     * Finds a doctor by ID with specialization name.
     */
    public Doctor findById(int id) {
        String sql = SELECT_WITH_SPEC + " WHERE d.id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding doctor by id: " + id, e);
        }
        return null;
    }

    /**
     * Returns all active doctors with specialization info.
     */
    public List<Doctor> findAllActive(String sortBy) {
        return search(null, null, sortBy);
    }

    /**
     * Returns all doctors (including inactive) for admin.
     */
    public List<Doctor> findAll() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = SELECT_WITH_SPEC + " ORDER BY d.created_at DESC";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                doctors.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all doctors.", e);
        }
        return doctors;
    }

    /**
     * Searches doctors by name or specialization.
     */
    public List<Doctor> search(String keyword, Integer specializationId, String sortBy) {
        List<Doctor> doctors = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_WITH_SPEC + " WHERE d.is_active = TRUE");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (d.full_name LIKE ? OR s.name LIKE ? OR d.qualification LIKE ?)");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (specializationId != null && specializationId > 0) {
            sql.append(" AND d.specialization_id = ?");
            params.add(specializationId);
        }

        // Apply sorting
        if ("experience".equals(sortBy)) {
            sql.append(" ORDER BY d.experience_years DESC");
        } else if ("fee_low".equals(sortBy)) {
            sql.append(" ORDER BY d.consultation_fee ASC");
        } else if ("fee_high".equals(sortBy)) {
            sql.append(" ORDER BY d.consultation_fee DESC");
        } else {
            sql.append(" ORDER BY d.full_name ASC");
        }

        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    doctors.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching doctors.", e);
        }
        return doctors;
    }

    /**
     * Creates a new doctor. Returns the generated ID.
     */
    public int create(Doctor doctor) {
        String sql = "INSERT INTO doctors (full_name, email, phone, specialization_id, qualification, "
                + "experience_years, consultation_fee, bio, gender, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getEmail());
            ps.setString(3, doctor.getPhone());
            ps.setInt(4, doctor.getSpecializationId());
            ps.setString(5, doctor.getQualification());
            ps.setInt(6, doctor.getExperienceYears());
            ps.setBigDecimal(7, doctor.getConsultationFee());
            ps.setString(8, doctor.getBio());
            ps.setString(9, doctor.getGender());
            ps.setBoolean(10, doctor.isActive());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating doctor: " + doctor.getFullName(), e);
        }
        return -1;
    }

    /**
     * Updates an existing doctor.
     */
    public boolean update(Doctor doctor) {
        String sql = "UPDATE doctors SET full_name = ?, email = ?, phone = ?, specialization_id = ?, "
                + "qualification = ?, experience_years = ?, consultation_fee = ?, bio = ?, "
                + "gender = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getEmail());
            ps.setString(3, doctor.getPhone());
            ps.setInt(4, doctor.getSpecializationId());
            ps.setString(5, doctor.getQualification());
            ps.setInt(6, doctor.getExperienceYears());
            ps.setBigDecimal(7, doctor.getConsultationFee());
            ps.setString(8, doctor.getBio());
            ps.setString(9, doctor.getGender());
            ps.setBoolean(10, doctor.isActive());
            ps.setInt(11, doctor.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating doctor: " + doctor.getId(), e);
        }
        return false;
    }

    /**
     * Deletes a doctor by ID.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM doctors WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting doctor: " + id, e);
        }
        return false;
    }

    /**
     * Counts total active doctors.
     */
    public int countActive() {
        String sql = "SELECT COUNT(*) FROM doctors WHERE is_active = TRUE";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting active doctors.", e);
        }
        return 0;
    }

    /**
     * Finds doctors by specialization.
     */
    public List<Doctor> findBySpecialization(int specializationId) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = SELECT_WITH_SPEC + " WHERE d.specialization_id = ? AND d.is_active = TRUE ORDER BY d.full_name";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, specializationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    doctors.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding doctors by specialization: " + specializationId, e);
        }
        return doctors;
    }

    /**
     * Maps a ResultSet row to a Doctor object.
     */
    private Doctor mapResultSet(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setId(rs.getInt("id"));
        doctor.setFullName(rs.getString("full_name"));
        doctor.setEmail(rs.getString("email"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setSpecializationId(rs.getInt("specialization_id"));
        doctor.setQualification(rs.getString("qualification"));
        doctor.setExperienceYears(rs.getInt("experience_years"));
        doctor.setConsultationFee(rs.getBigDecimal("consultation_fee"));
        doctor.setBio(rs.getString("bio"));
        doctor.setGender(rs.getString("gender"));
        doctor.setActive(rs.getBoolean("is_active"));
        doctor.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            doctor.setSpecializationName(rs.getString("specialization_name"));
        } catch (SQLException e) {
            // Column may not exist in all queries
        }

        return doctor;
    }
}
