package com.docconnect;

import com.docconnect.doctor.model.Doctor;
import com.docconnect.doctor.service.DoctorService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * API end point for live search functionality.
 */
public class SearchApiServlet extends HttpServlet {

    private final DoctorService doctorService = new DoctorService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            if (query == null || query.trim().length() < 2) {
                out.print("[]");
                out.flush();
                return;
            }

            List<Doctor> results = doctorService.searchDoctors(query, null, null);
            // Limit to top 5 results
            if (results.size() > 5) {
                results = results.subList(0, 5);
            }

            out.print(gson.toJson(results));
            out.flush();
        }
    }
}
