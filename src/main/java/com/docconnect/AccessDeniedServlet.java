package com.docconnect;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Access denied page controller.
 */
public class AccessDeniedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Access Denied - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/error/access-denied.jsp").forward(request, response);
    }
}
