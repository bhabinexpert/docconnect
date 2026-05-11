package com.docconnect.user.controller;

import com.docconnect.user.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Registration controller.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Register - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/guest/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");

        String error = userService.register(fullName, email, password, confirmPassword, phone, gender);

        if (error == null) {
            // Registration successful
            LOGGER.info("New user registered: " + email);
            response.sendRedirect(request.getContextPath() + "/login?success=Registration+successful!+Please+login.");
        } else {
            // Registration failed
            request.setAttribute("error", error);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("gender", gender);
            request.setAttribute("pageTitle", "Register - DocConnect Nepal");
            request.getRequestDispatcher("/WEB-INF/views/guest/register.jsp").forward(request, response);
        }
    }
}
