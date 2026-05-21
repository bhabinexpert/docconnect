package com.docconnect.user.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Streams files from the external upload directory
 * URL pattern: /uploads/<subdir>/<filename>
 */
public class UploadServlet extends HttpServlet {

    private static final Path UPLOAD_ROOT = Paths.get(System.getProperty("user.dir"), "uploads")
            .toAbsolutePath().normalize();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path requested = UPLOAD_ROOT.resolve(pathInfo.substring(1)).normalize();

        // Path-traversal guard
        if (!requested.startsWith(UPLOAD_ROOT) || !Files.isRegularFile(requested)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(requested);
        if (contentType == null) {
            contentType = URLConnection.guessContentTypeFromName(requested.getFileName().toString());
        }
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        long size = Files.size(requested);
        if (size <= Integer.MAX_VALUE) {
            response.setContentLength((int) size);
        } else {
            response.setHeader("Content-Length", Long.toString(size));
        }
        response.setHeader("Cache-Control", "public, max-age=3600");

        try (OutputStream out = response.getOutputStream()) {
            Files.copy(requested, out);
        }
    }
}
