package com.docconnect.user.controller;

import com.docconnect.user.model.User;
import com.docconnect.user.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Login controller.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Redirect if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(user, request, response);
            return;
        }

        request.setAttribute("pageTitle", "Login - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/guest/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        if (email != null) {
            email = email.trim();
        }
        String password = request.getParameter("password");

        User user = userService.authenticate(email, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            LOGGER.info("User logged in: " + email);
            redirectByRole(user, request, response);
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.setAttribute("email", email);
            request.setAttribute("pageTitle", "Login - DocConnect Nepal");
            request.getRequestDispatcher("/WEB-INF/views/guest/login.jsp").forward(request, response);
        }
    }

    private void redirectByRole(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
        }
    }
}
