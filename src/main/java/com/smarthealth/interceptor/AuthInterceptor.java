package com.smarthealth.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.smarthealth.model.User;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        HttpSession session = request.getSession();

        User sessionUser = (User) session.getAttribute("sessionUser");

        // Admin Access Control
        if (path.startsWith("/admin")) {
            if (sessionUser == null || sessionUser.getRole() != com.smarthealth.model.Role.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/auth/admin/login?error=unauthorized");
                return false;
            }
        }

        // Doctor Access Control
        if (path.startsWith("/doctor")) {
            if (sessionUser == null || sessionUser.getRole() != com.smarthealth.model.Role.DOCTOR) {
                response.sendRedirect(request.getContextPath() + "/auth/doctor/login?error=unauthorized");
                return false;
            }
        }

        // Patient Access Control
        if (path.startsWith("/patient")) {
            if (sessionUser == null || sessionUser.getRole() != com.smarthealth.model.Role.PATIENT) {
                response.sendRedirect(request.getContextPath() + "/auth/patient/login?error=unauthorized");
                return false;
            }
        }

        return true;
    }
}
