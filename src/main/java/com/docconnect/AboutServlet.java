package com.docconnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Serves the About page.
 */
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "About Us - DocConnect Nepal");
        request.getRequestDispatcher("/WEB-INF/views/guest/about.jsp").forward(request, response);
    }
}
