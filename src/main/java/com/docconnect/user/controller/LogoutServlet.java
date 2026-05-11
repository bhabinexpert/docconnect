package com.docconnect.user.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Logout controller - invalidates session and redirects to home.
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            String email = session.getAttribute("user") != null ?
                    ((com.docconnect.user.model.User) session.getAttribute("user")).getEmail() : "unknown";
            session.invalidate();
            LOGGER.info("User logged out: " + email);
        }

        response.sendRedirect(request.getContextPath() + "/login?success=You+have+been+logged+out+successfully.");
    }
}
