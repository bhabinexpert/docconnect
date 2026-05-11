package com.docconnect.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for password hashing using SHA-256.
 */
public class PasswordUtil {

    private static final Logger LOGGER = Logger.getLogger(PasswordUtil.class.getName());

    private PasswordUtil() {
        // Prevent instantiation
    }

    /**
     * Hashes a password using SHA-256 algorithm.
     *
     * @param password the plain-text password
     * @return hex-encoded SHA-256 hash
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "SHA-256 algorithm not available.", e);
            throw new RuntimeException("Password hashing failed.", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored hash.
     *
     * @param password   the plain-text password
     * @param storedHash the stored hash to compare against
     * @return true if the password matches
     */
    public static boolean verifyPassword(String password, String storedHash) {
        String hash = hashPassword(password);
        return hash.equals(storedHash);
    }

    /**
     * Converts byte array to hexadecimal string.
     *
     * @param bytes the byte array
     * @return hex string
     */
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
