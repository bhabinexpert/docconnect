package com.docconnect.user.controller;

import com.docconnect.user.model.User;
import com.docconnect.user.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Patient profile management controller.
 */
public class ProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    private static final Path UPLOAD_ROOT = Paths.get(System.getProperty("user.dir"), "uploads")
            .toAbsolutePath().normalize();
    private static final Path PROFILE_DIR = UPLOAD_ROOT.resolve("profile");
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

        if ("uploadPhoto".equals(action)) {
            Part part = request.getPart("photo");
            if (part == null || part.getSize() == 0) {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=" + URLEncoder.encode("Please select a photo to upload.", "UTF-8"));
                return;
            }

            String submitted = extractFileName(part);
            if (submitted == null || !submitted.contains(".")) {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=" + URLEncoder.encode("Invalid file name.", "UTF-8"));
                return;
            }

            String ext = submitted.substring(submitted.lastIndexOf('.') + 1).toLowerCase();
            if (!isAllowedImageExtension(ext)) {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=" + URLEncoder.encode("Only JPG, PNG, GIF, or WEBP images are allowed.", "UTF-8"));
                return;
            }

            String fileName = user.getId() + "_" + System.currentTimeMillis() + "." + ext;
            Path target = PROFILE_DIR.resolve(fileName);
            try {
                Files.createDirectories(PROFILE_DIR);
                Files.copy(part.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Failed to save uploaded photo for user " + user.getId(), e);
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=" + URLEncoder.encode("Could not save the uploaded file.", "UTF-8"));
                return;
            }

            String publicUrl = request.getContextPath() + "/uploads/profile/" + fileName;
            user.setPhotoUrl(publicUrl);
            if (!userService.updateProfile(user)) {
                response.sendRedirect(request.getContextPath() +
                        "/patient/profile?error=" + URLEncoder.encode("Database update failed.", "UTF-8"));
                return;
            }
            session.setAttribute("user", user);
            session.setAttribute("userName", user.getFullName());
            response.sendRedirect(request.getContextPath() +
                    "/patient/profile?success=" + URLEncoder.encode("Profile photo updated successfully.", "UTF-8"));

        } else if ("updateProfile".equals(action)) {
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

    private static boolean isAllowedImageExtension(String ext) {
        return "jpg".equals(ext)
                || "jpeg".equals(ext)
                || "png".equals(ext)
                || "gif".equals(ext)
                || "webp".equals(ext);
    }

    /**
     * Extracts the original file name from a Part's Content-Disposition header.
     * Used instead of Part.getSubmittedFileName() so we stay compatible with
     * Servlet 3.0 (Tomcat 7), which doesn't have that method.
     */
    private static String extractFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            token = token.trim();
            if (token.toLowerCase().startsWith("filename=")) {
                String name = token.substring(token.indexOf('=') + 1).trim();
                if (name.startsWith("\"") && name.endsWith("\"") && name.length() >= 2) {
                    name = name.substring(1, name.length() - 1);
                }
                int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return slash >= 0 ? name.substring(slash + 1) : name;
            }
        }
        return null;
    }
}
