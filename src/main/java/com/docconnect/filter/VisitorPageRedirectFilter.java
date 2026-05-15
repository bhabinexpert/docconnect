package com.docconnect.filter;

import com.docconnect.user.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Redirects authenticated users away from visitor-only pages.
 */
public class VisitorPageRedirectFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(VisitorPageRedirectFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("VisitorPageRedirectFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            chain.doFilter(request, response);
            return;
        }

        String path = getRequestPath(httpRequest);

        if (isGuestOnlyPage(path) || user.isAdmin()) {
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
            httpResponse.sendRedirect(httpRequest.getContextPath() + getDashboardPath(user));
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("VisitorPageRedirectFilter destroyed.");
    }

    private boolean isGuestOnlyPage(String path) {
        return "/".equals(path)
                || "/index.jsp".equals(path)
                || "/home".equals(path)
                || "/about".equals(path)
                || "/contact".equals(path)
                || "/login".equals(path)
                || "/register".equals(path);
    }

    private String getDashboardPath(User user) {
        return user.isAdmin() ? "/admin/dashboard" : "/patient/dashboard";
    }

    private String getRequestPath(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            return uri.substring(contextPath.length());
        }
        return uri;
    }
}
