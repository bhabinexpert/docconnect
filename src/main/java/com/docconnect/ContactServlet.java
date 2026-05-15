package com.docconnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Serves the Contact page and handles inquiry form submissions.
 */
public class ContactServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ContactServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Contact Us - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/guest/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name    = request.getParameter("name");
        String email   = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Basic validation
        if (name == null || name.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || message == null || message.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.setAttribute("pageTitle", "Contact Us - DocConnect Nepal");
            request.getRequestDispatcher("/WEB-INF/views/guest/contact.jsp").forward(request, response);
            return;
        }

        LOGGER.info("Contact inquiry from: " + email + " | Subject: " + subject);

        response.sendRedirect(request.getContextPath() + "/contact?success=true");
    }
}
