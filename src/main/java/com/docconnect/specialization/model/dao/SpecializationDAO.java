package com.docconnect.specialization.model.dao;

import com.docconnect.specialization.model.Specialization;
import com.docconnect.util.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Specialization entity.
 */
public class SpecializationDAO {

    private static final Logger LOGGER = Logger.getLogger(SpecializationDAO.class.getName());

    /**
     * Returns all specializations.
     */
    public List<Specialization> findAll() {
        List<Specialization> list = new ArrayList<>();
        String sql = "SELECT * FROM specializations ORDER BY name";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all specializations.", e);
        }
        return list;
    }

    /**
     * Finds a specialization by ID.
     */
    public Specialization findById(int id) {
        String sql = "SELECT * FROM specializations WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding specialization by id: " + id, e);
        }
        return null;
    }

    /**
     * Creates a new specialization.
     */
    public boolean create(Specialization spec) {
        String sql = "INSERT INTO specializations (name, description, icon_class) VALUES (?, ?, ?)";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, spec.getName());
            ps.setString(2, spec.getDescription());
            ps.setString(3, spec.getIconClass());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating specialization.", e);
        }
        return false;
    }

    /**
     * Updates an existing specialization.
     */
    public boolean update(Specialization spec) {
        String sql = "UPDATE specializations SET name = ?, description = ?, icon_class = ? WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, spec.getName());
            ps.setString(2, spec.getDescription());
            ps.setString(3, spec.getIconClass());
            ps.setInt(4, spec.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating specialization id: " + spec.getId(), e);
        }
        return false;
    }

    /**
     * Deletes a specialization.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM specializations WHERE id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting specialization id: " + id, e);
        }
        return false;
    }

    /**
     * Returns count of specializations.
     */
    public int count() {
        String sql = "SELECT COUNT(*) FROM specializations";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting specializations.", e);
        }
        return 0;
    }

    private Specialization mapResultSet(ResultSet rs) throws SQLException {
        Specialization spec = new Specialization();
        spec.setId(rs.getInt("id"));
        spec.setName(rs.getString("name"));
        spec.setDescription(rs.getString("description"));
        spec.setIconClass(rs.getString("icon_class"));
        return spec;
    }
}
