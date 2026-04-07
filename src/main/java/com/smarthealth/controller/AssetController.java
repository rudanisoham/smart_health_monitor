package com.smarthealth.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AssetController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.isEmpty() || pathInfo.contains("..")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String internalPath = "/WEB-INF/views/assets" + pathInfo;
        InputStream is = getServletContext().getResourceAsStream(internalPath);

        if (is == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mimeType = getServletContext().getMimeType(internalPath);
        if (mimeType == null) {
            if (internalPath.endsWith(".css")) {
                mimeType = "text/css";
            } else if (internalPath.endsWith(".js")) {
                mimeType = "application/javascript";
            } else {
                mimeType = "application/octet-stream";
            }
        }
        resp.setContentType(mimeType);

        try (OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        } finally {
            is.close();
        }
    }
}
