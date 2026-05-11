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
import java.time.LocalDate;
import java.util.logging.Logger;

/**
 * Patient profile management controller.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/patient/profile"})
public class ProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Refresh user data from DB
        User freshUser = userService.getUserById(user.getId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
            request.setAttribute("user", freshUser);
        }

        request.setAttribute("pageTitle", "My Profile - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/patient/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            user.setFullName(request.getParameter("fullName"));
            user.setPhone(request.getParameter("phone"));
            user.setAddress(request.getParameter("address"));
            user.setGender(request.getParameter("gender"));

            String dob = request.getParameter("dateOfBirth");
            if (dob != null && !dob.isEmpty()) {
                user.setDateOfBirth(LocalDate.parse(dob));
            }

            if (userService.updateProfile(user)) {
                session.setAttribute("user", user);
                session.setAttribute("userName", user.getFullName());
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?success=Profile+updated+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=Failed+to+update+profile.");
            }

        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            String error = userService.changePassword(user.getId(), currentPassword, newPassword, confirmPassword);
            if (error == null) {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?success=Password+changed+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=" + error.replace(" ", "+"));
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        }
    }
}
