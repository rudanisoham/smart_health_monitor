<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reception Login · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body class="login-page">
<div class="login-card">
    <div class="login-main">
        <div class="login-badge">Reception Portal</div>
        <h1 class="login-title">Front Desk<br>Sign In</h1>
        <p class="login-subtitle">Manage appointments, assign doctors, and handle bed allocation.</p>

        <c:if test="${not empty error}">
            <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">${error}</div>
        </c:if>
        <c:if test="${param.error == 'unauthorized'}">
            <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">Access denied. Please sign in as Reception.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post" class="form-grid">
            <input type="hidden" name="roleStr" value="RECEPTIONIST">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="reception@health.com" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary w-full" style="margin-top:0.5rem;">Sign In to Reception</button>
        </form>

        <div class="login-footer">
            <span>Smart Health Monitor © 2026</span>
            <a href="${pageContext.request.contextPath}/" style="color:var(--text-muted);">← Back to Home</a>
        </div>
    </div>

    <div class="login-extra">
        <div class="login-kpi">
            <h3>Reception Hub</h3>
            <div class="login-kpi-value">24/7</div>
            <div class="login-kpi-caption">Manage patient appointment queues, assign doctors, and track bed availability across all departments in real time.</div>
        </div>
        <div style="margin-top:2.5rem;display:flex;flex-direction:column;gap:1rem;">
            <div class="login-badge-secondary"><span>📋</span> Appointment Queue Management</div>
            <div class="login-badge-secondary"><span>🛏️</span> Bed Assignment & Tracking</div>
            <div class="login-badge-secondary"><span>📧</span> Automated Patient Notifications</div>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
