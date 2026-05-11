package com.docconnect.filter;

import com.docconnect.util.CsrfUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * CSRF protection filter for all POST requests.
 * Validates CSRF token on form submissions.
 */
@WebFilter(urlPatterns = {"/*"})
public class CsrfFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(CsrfFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("CsrfFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Only validate CSRF on POST requests
        if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
            // Skip CSRF for payment callback URLs
            String uri = httpRequest.getRequestURI();
            if (uri.contains("/payment/verify") || uri.contains("/payment/callback")) {
                chain.doFilter(request, response);
                return;
            }

            if (!CsrfUtil.validateToken(httpRequest)) {
                LOGGER.warning("CSRF token validation failed for: " + uri);
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token.");
                return;
            }
        }

        // Always ensure a CSRF token is available for forms
        if (httpRequest.getSession(false) != null || "GET".equalsIgnoreCase(httpRequest.getMethod())) {
            String token = CsrfUtil.getToken(httpRequest);
            httpRequest.setAttribute("csrfToken", token);
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        LOGGER.info("CsrfFilter destroyed.");
    }
}
