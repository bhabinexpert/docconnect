package com.docconnect.user.service;

import com.docconnect.user.model.dao.UserDAO;
import com.docconnect.user.model.User;
import com.docconnect.util.PasswordUtil;

import java.util.List;
import java.util.logging.Logger;

/**
 * Service layer for User-related business logic.
 */
public class UserService {

    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());
    private final UserDAO userDAO = new UserDAO();

    /**
     * Authenticates a user with email and password.
     *
     * @return User object if authenticated, null otherwise
     */
    public User authenticate(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        User user = userDAO.findByEmail(email.trim());
        if (user == null) {
            LOGGER.info("Authentication failed: user not found - " + email);
            return null;
        }

        if (!user.isActive()) {
            LOGGER.info("Authentication failed: account deactivated - " + email);
            return null;
        }

        if (PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            LOGGER.info("User authenticated successfully: " + email);
            return user;
        }

        LOGGER.info("Authentication failed: incorrect password - " + email);
        return null;
    }

    /**
     * Registers a new patient user.
     *
     * @return error message or null on success
     */
    public String register(String fullName, String email, String password, String confirmPassword,
                           String phone, String gender) {
        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }
        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "Please enter a valid email address.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        if (phone != null && !phone.isEmpty() && !phone.matches("^\\d{10}$")) {
            return "Phone number must be 10 digits.";
        }

        // Check if email exists
        if (userDAO.emailExists(email.trim())) {
            return "An account with this email already exists.";
        }

        // Create user
        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setPhone(phone);
        user.setGender(gender);
        user.setRole("patient");
        user.setActive(true);

        int id = userDAO.create(user);
        if (id > 0) {
            LOGGER.info("New user registered: " + email);
            return null; // Success
        }

        return "Registration failed. Please try again.";
    }

    /**
     * Updates user profile.
     */
    public boolean updateProfile(User user) {
        return userDAO.update(user);
    }

    /**
     * Changes user password.
     */
    public String changePassword(int userId, String currentPassword, String newPassword, String confirmPassword) {
        User user = userDAO.findById(userId);
        if (user == null) {
            return "User not found.";
        }

        if (!PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
            return "Current password is incorrect.";
        }

        if (newPassword == null || newPassword.length() < 6) {
            return "New password must be at least 6 characters.";
        }

        if (!newPassword.equals(confirmPassword)) {
            return "New passwords do not match.";
        }

        boolean updated = userDAO.updatePassword(userId, PasswordUtil.hashPassword(newPassword));
        return updated ? null : "Password update failed.";
    }

    /**
     * Gets user by ID.
     */
    public User getUserById(int id) {
        return userDAO.findById(id);
    }

    /**
     * Gets all users with optional role filter.
     */
    public List<User> getAllUsers(String roleFilter) {
        return userDAO.findAll(roleFilter);
    }

    /**
     * Resets user password to a default value (admin function).
     */
    public boolean adminPasswordReset(int userId, String newPassword) {
        return userDAO.updatePassword(userId, PasswordUtil.hashPassword(newPassword));
    }

    /**
     * Toggles user active status (admin function).
     */
    public boolean toggleUserActive(int userId, boolean isActive) {
        return userDAO.toggleActive(userId, isActive);
    }

    /**
     * Counts patients.
     */
    public int countPatients() {
        return userDAO.countByRole("patient");
    }
}
