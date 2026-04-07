<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot password Â· Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-main">
            <div class="login-badge">
                <span>Password reset</span>
            </div>
            <h1 class="login-title">Reset your password</h1>
            <p class="login-subtitle">
                Enter the email associated with your account. Weâ€™ll send reset instructions.
            </p>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.1);border:1px solid #10b981;border-radius:8px;color:#10b981;margin-bottom:1.5rem;">${success}</div>
            </c:if>

            <form action="<%= request.getContextPath() %>/auth/forgot/send-otp" method="post" class="form-grid">
                <div class="form-group">
                    <label for="resetEmail">Register Email Address</label>
                    <input id="resetEmail" name="email" class="form-control" type="email" placeholder="you@example.com" required>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary w-full">
                        <span>Send OTP Code</span>
                    </button>
                </div>
            </form>

            <div class="login-footer">
                <a href="<%= request.getContextPath() %>/" class="text-xs" style="color:inherit; text-decoration: underline;">Back to sign in</a>
            </div>
        </div>

        <div class="login-extra">
            <div class="login-kpi">
                <h3>Account security</h3>
                <div class="login-kpi-value">100%</div>
                <p class="login-kpi-caption">
                    Your health data is encrypted and protected with modern security standards.
                </p>
            </div>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>


