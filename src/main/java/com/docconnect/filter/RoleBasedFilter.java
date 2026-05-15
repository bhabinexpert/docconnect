package com.docconnect.filter;

import com.docconnect.user.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Role-based access control filter.
 * Ensures admin routes are only accessible by admin users.
 */
public class RoleBasedFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(RoleBasedFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("RoleBasedFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                String requestURI = httpRequest.getRequestURI();

                // Admin routes require admin role
                if (requestURI.contains("/admin/")) {
                    if (!user.isAdmin()) {
                        LOGGER.warning("Access denied: " + user.getEmail() + " attempted to access admin route " + requestURI);
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied");
                        return;
                    }
                }

                // Patient routes should NOT be accessible by admins (admins should only manage)
                if (requestURI.contains("/patient/")) {
                    if (user.isAdmin()) {
                        LOGGER.warning("Restriction: Admin " + user.getEmail() + " attempted to access patient route " + requestURI);
                        // Redirect admin to their own dashboard instead of a hard error
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard");
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("RoleBasedFilter destroyed.");
    }
}
