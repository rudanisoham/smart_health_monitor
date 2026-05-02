<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab Staff Login · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="login-page">
<div class="login-card">
    <div class="login-main">
        <a href="${pageContext.request.contextPath}/" class="btn-back-home">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>
        <div class="login-badge">Laboratory Portal</div>
        <h1 class="login-title">Lab Staff<br>Sign In</h1>
        <p class="login-subtitle">Process lab requests, upload results, and manage diagnostics.</p>

        <c:if test="${not empty error}">
            <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">${error}</div>
        </c:if>
        <c:if test="${param.error == 'unauthorized'}">
            <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">Access denied. Please sign in as Lab Staff.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post" class="form-grid">
            <input type="hidden" name="roleStr" value="LAB_STAFF">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="lab@health.com" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-primary w-full" style="margin-top:0.5rem;">Sign In to Lab Portal</button>
        </form>

        <div class="login-footer">
            <span>Smart Health Monitor © 2026</span>
            <a href="${pageContext.request.contextPath}/" style="color:var(--text-muted);">← Back to Home</a>
        </div>
    </div>

    <div class="login-extra">
        <div class="login-kpi">
            <h3>Laboratory Portal</h3>
            <div class="login-kpi-value">🔬</div>
            <div class="login-kpi-caption">Process incoming lab test requests from doctors, enter diagnostic results, and manage the laboratory workflow.</div>
        </div>
        <div style="margin-top:2.5rem;display:flex;flex-direction:column;gap:1rem;">
            <div class="login-badge-secondary"><span>🧪</span> Process Lab Requests</div>
            <div class="login-badge-secondary"><span>📊</span> Enter Diagnostic Results</div>
            <div class="login-badge-secondary"><span>📋</span> Track Test Status</div>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
