package com.docconnect;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Access denied page controller.
 */
@WebServlet(name = "AccessDeniedServlet", urlPatterns = {"/access-denied"})
public class AccessDeniedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Access Denied - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/error/access-denied.jsp").forward(request, response);
    }
}
