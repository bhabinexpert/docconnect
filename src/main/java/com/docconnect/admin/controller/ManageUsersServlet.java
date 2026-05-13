package com.docconnect.admin.controller;

import com.docconnect.user.model.User;
import com.docconnect.user.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Admin user management controller.
 */
@WebServlet(name = "ManageUsersServlet", urlPatterns = {"/admin/users"})
public class ManageUsersServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ManageUsersServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleFilter = request.getParameter("role");
        List<User> users = userService.getAllUsers(roleFilter);

        request.setAttribute("users", users);
        request.setAttribute("selectedRole", roleFilter);
        request.setAttribute("pageTitle", "Manage Users - Admin");

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("toggle".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean isActive = "true".equals(request.getParameter("isActive"));
                userService.toggleUserActive(userId, isActive);

                response.sendRedirect(request.getContextPath() +
                        "/admin/users?success=User+status+updated.");
            } catch (Exception e) {
                LOGGER.severe("Error toggling user: " + e.getMessage());
                response.sendRedirect(request.getContextPath() +
                        "/admin/users?error=Error+updating+user.");
            }
        } else if ("resetPassword".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                // Reset to default password
                userService.adminPasswordReset(userId, "reset123");
                response.sendRedirect(request.getContextPath() +
                        "/admin/users?success=User+password+has+been+reset+to+reset123.");
            } catch (Exception e) {
                LOGGER.severe("Error resetting password: " + e.getMessage());
                response.sendRedirect(request.getContextPath() +
                        "/admin/users?error=Error+resetting+password.");
            }
        }
    }
}
