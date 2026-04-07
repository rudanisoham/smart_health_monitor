<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Login · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-main">
            <div class="login-badge">
                <span>Smart Health Monitor · Patient</span>
            </div>
            <h1 class="login-title">Welcome back</h1>
            <p class="login-subtitle">
                View your health, appointments, prescriptions and alerts in one secure place.
            </p>

            <c:if test="${not empty error}">
                <div style="margin-bottom:1rem;padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="margin-bottom:1rem;padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;">${success}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/auth/login" method="post" class="form-grid">
                <input type="hidden" name="roleStr" value="PATIENT">
                <input type="hidden" id="loginLat" name="latitude">
                <input type="hidden" id="loginLng" name="longitude">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" class="form-control" placeholder="you@example.com" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input id="password" name="password" type="password" class="form-control" placeholder="••••••••" required minlength="6">
                </div>
                <div class="flex justify-between items-center mt-1">
                    <span class="text-xs text-muted">Login with your registered email</span>
                    <a href="${pageContext.request.contextPath}/auth/forgot" class="text-xs" style="color:inherit;text-decoration:underline;">Forgot password?</a>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-primary w-full"><span>Sign in</span></button>
                </div>
            </form>

            <script>
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function(pos) {
                        document.getElementById('loginLat').value = pos.coords.latitude;
                        document.getElementById('loginLng').value = pos.coords.longitude;
                    });
                }
            </script>

            <div class="login-footer">
                <span>New here?</span>
                <a href="<%= request.getContextPath() %>/auth/patient/register" class="text-xs" style="color:#38bdf8; text-decoration: none; font-weight: 500;">Create your account</a>
            </div>
        </div>

        <div class="login-extra" style="display: flex; flex-direction: column; justify-content: center; height: 100%;">
            <div class="login-kpi" style="background: transparent; border: none; padding: 0;">
                <h3 style="font-size: 1.5rem; margin-bottom: 1rem; color: #fff;">Your Health in Your Hands</h3>
                <ul style="list-style: none; padding: 0; margin: 0; color: #94a3b8; font-size: 0.95rem; line-height: 1.6;">
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Track vital signs and medical history 24/7
                    </li>
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Book appointments directly with your specialists
                    </li>
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> View and manage your digital prescriptions easily
                    </li>
                    <li style="display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Use the AI Health Checker for instant symptom analysis
                    </li>
                </ul>
            </div>
            <div class="mt-8">
                <div class="login-badge-secondary">
                    <span>●</span>
                    <span>Secure patient access</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
