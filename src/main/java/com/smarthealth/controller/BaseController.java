package com.smarthealth.controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public abstract class BaseController extends HttpServlet {

    protected void forward(HttpServletRequest req, HttpServletResponse resp, String viewPath)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        RequestDispatcher dispatcher = req.getRequestDispatcher(viewPath);
        dispatcher.forward(req, resp);
    }

    protected static String path(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        return (pathInfo == null || pathInfo.isBlank()) ? "/" : pathInfo;
    }
}

