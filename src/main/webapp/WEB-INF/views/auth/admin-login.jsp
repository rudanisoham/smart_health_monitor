<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-main">
            <div class="login-badge">
                <span>Smart Health Monitor · Admin</span>
            </div>
            <h1 class="login-title">Welcome back, Admin</h1>
            <p class="login-subtitle">
                Monitor your hospital in real-time. Review doctors, patients, departments and analytics from one clean console.
            </p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="margin-bottom:1rem;padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="margin-bottom:1rem;padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;">${success}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/auth/login" method="post" class="form-grid">
                <input type="hidden" name="roleStr" value="ADMIN">
                <input type="hidden" id="loginLat" name="latitude">
                <input type="hidden" id="loginLng" name="longitude">
                <div class="form-group">
                    <label for="email">Work email</label>
                    <input id="email" name="email" type="email" class="form-control"
                           placeholder="admin@hospital.com" value="admin@health.com" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input id="password" name="password" type="password" class="form-control"
                           placeholder="••••••••" required minlength="6">
                </div>
                <div class="flex justify-between items-center mt-1">
                    <span class="text-xs text-muted">Default: admin@health.com / admin123</span>
                    <a href="${pageContext.request.contextPath}/auth/forgot" class="text-xs" style="color:#38bdf8;">Forgot password?</a>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-primary w-full">
                        <span>Sign in to Admin Panel</span>
                    </button>
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
                <span>Secured access · Role-based control</span>
                <span>Need help? Contact your IT team.</span>
            </div>
        </div>

        <div class="login-extra" style="display: flex; flex-direction: column; justify-content: center; height: 100%;">
            <div class="login-kpi" style="background: transparent; border: none; padding: 0;">
                <h3 style="font-size: 1.5rem; margin-bottom: 1rem; color: #fff;">Enterprise Hospital Management</h3>
                <ul style="list-style: none; padding: 0; margin: 0; color: #94a3b8; font-size: 0.95rem; line-height: 1.6;">
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Real-time occupancy tracking and bed management
                    </li>
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Advanced doctor and staff scheduling algorithms
                    </li>
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Encrypted patient data and secure access logs
                    </li>
                    <li style="display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Comprehensive financial and clinical reporting
                    </li>
                </ul>
            </div>
            <div class="mt-8">
                <div class="login-badge-secondary">
                    <span>●</span>
                    <span>Encrypted admin session</span>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
