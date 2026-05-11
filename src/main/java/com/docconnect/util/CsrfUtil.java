package com.docconnect.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * CSRF (Cross-Site Request Forgery) token management utility.
 * Generates and validates tokens stored in the user session.
 */
public class CsrfUtil {

    private static final String CSRF_TOKEN_ATTR = "csrfToken";
    private static final SecureRandom secureRandom = new SecureRandom();

    private CsrfUtil() {
        // Prevent instantiation
    }

    /**
     * Generates a new CSRF token and stores it in the session.
     *
     * @param request the HTTP request
     * @return the generated CSRF token
     */
    public static String generateToken(HttpServletRequest request) {
        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);

        HttpSession session = request.getSession(true);
        session.setAttribute(CSRF_TOKEN_ATTR, token);
        return token;
    }

    /**
     * Gets the current CSRF token from the session, generating one if needed.
     *
     * @param request the HTTP request
     * @return the CSRF token
     */
    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null) {
            token = generateToken(request);
        }
        return token;
    }

    /**
     * Validates the CSRF token from the form submission against the session token.
     *
     * @param request the HTTP request
     * @return true if the token is valid
     */
    public static boolean validateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        String requestToken = request.getParameter("csrfToken");

        if (sessionToken == null || requestToken == null) {
            return false;
        }

        // Constant-time comparison to prevent timing attacks
        return java.security.MessageDigest.isEqual(
                sessionToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                requestToken.getBytes(java.nio.charset.StandardCharsets.UTF_8)
        );
    }
}
