<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Verify OTP · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-main">
            <div class="login-badge">
                <span>Verification</span>
            </div>
            <h1 class="login-title">Check your email</h1>
            <p class="login-subtitle">
                We've sent a 6-digit code to <strong>${sessionScope.resetEmail}</strong>. Enter it below to proceed.
            </p>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.1);border:1px solid #10b981;border-radius:8px;color:#10b981;margin-bottom:1.5rem;">${success}</div>
            </c:if>

            <form action="<%= request.getContextPath() %>/auth/forgot/verify-otp" method="post" class="form-grid">
                <div class="form-group">
                    <label for="otp">Enter 6-Digit OTP</label>
                    <input id="otp" name="otp" class="form-control" type="text" maxlength="6" pattern="\d{6}" placeholder="000000" style="letter-spacing: 0.5rem; text-align: center; font-size: 1.5rem; font-weight: bold;" required>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary w-full">
                        <span>Verify Code</span>
                    </button>
                </div>
            </form>

            <div class="login-footer">
                <p class="text-xs muted">Didn't receive code? <a href="<%= request.getContextPath() %>/auth/forgot" style="color:var(--primary); text-decoration: underline;">Resend</a></p>
            </div>
        </div>

        <div class="login-extra" style="background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);">
            <div class="login-kpi">
                <h3 style="color:white;">2-Step Verification</h3>
                <div class="login-kpi-value" style="color:white;">Active</div>
                <p class="login-kpi-caption" style="color:rgba(255,255,255,0.8);">
                    OTP verification adds an extra layer of security to ensure only you can access your account reset.
                </p>
            </div>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
