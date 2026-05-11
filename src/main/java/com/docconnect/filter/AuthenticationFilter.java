package com.docconnect.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Authentication filter that protects patient and admin routes.
 * Redirects unauthenticated users to the login page.
 */
@WebFilter(urlPatterns = {"/patient/*", "/admin/*"})
public class AuthenticationFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(AuthenticationFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("AuthenticationFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // Set no-cache headers for protected pages
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);

            chain.doFilter(request, response);
        } else {
            LOGGER.info("Unauthorized access attempt to: " + httpRequest.getRequestURI());
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=Please+login+to+continue");
        }
    }

    @Override
    public void destroy() {
        LOGGER.info("AuthenticationFilter destroyed.");
    }
}
