<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Set New Password · Smart Health Monitor</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
        </head>

        <body>
            <div class="login-page">
                <div class="login-card">
                    <div class="login-main">
                        <div class="login-badge">
                            <span>Last Step</span>
                        </div>
                        <h1 class="login-title">New Password</h1>
                        <p class="login-subtitle">
                            Set a strong, secure password you haven't used before.
                        </p>

                        <c:if test="${not empty error}">
                            <div
                                style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">
                                ${error}</div>
                        </c:if>

                        <form action="<%= request.getContextPath() %>/auth/forgot/reset-password" method="post"
                            class="form-grid">
                            <div class="form-group">
                                <label for="password">New Password</label>
                                <input id="password" name="password" class="form-control" type="password"
                                    placeholder="Enter New Password" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <input id="confirmPassword" name="confirmPassword" class="form-control" type="password"
                                    placeholder="Enter Confirm Password" required>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary w-full">
                                    <span>Save & Sign In</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="login-extra" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);">
                        <div class="login-kpi">
                            <h3 style="color:white;">Strong Security</h3>
                            <div class="login-kpi-value" style="color:white;">Finalizing</div>
                            <p class="login-kpi-caption" style="color:rgba(255,255,255,0.8);">
                                Once you save your new password, previous OTP codes for this reset will be invalidated
                                for your safety.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
        </body>

        </html>