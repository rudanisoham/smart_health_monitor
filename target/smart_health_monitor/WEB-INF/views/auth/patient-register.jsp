<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Registration · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-main">
            <div class="login-badge">
                <span>Create your Smart Health account</span>
            </div>
            <h1 class="login-title">Sign up as patient</h1>
            <p class="login-subtitle">
                Track your health data, appointments, prescriptions and reports.
            </p>

            <c:if test="${not empty error}">
                <div style="margin-bottom:1rem;padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/patient/register" method="post" class="form-grid form-2">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input id="fullName" name="fullName" type="text" class="form-control" placeholder="John Doe" required minlength="2">
                </div>
                <div class="form-group mb-4">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" class="form-control" placeholder="john@example.com" required>
                </div>
                <div class="form-group mb-4">
                    <label for="registerPassword">Password</label>
                    <input id="registerPassword" name="password" type="password" class="form-control" placeholder="••••••••" required minlength="6">
                </div>
                <div class="form-group mb-4">
                    <label for="confirmRegisterPassword">Confirm Password</label>
                    <input id="confirmRegisterPassword" type="password" class="form-control" placeholder="••••••••" required>
                </div>
                <div class="form-group mb-4">
                    <label for="phone">Phone Number</label>
                    <input id="phone" name="phone" type="tel" class="form-control" placeholder="+1234567890" pattern="^\+?[0-9]{10,15}$">
                    <small class="text-muted">Format: +1234567890 (optional)</small>
                </div>
                <div class="form-group" style="grid-column: 1 / -1;">
                    <label class="flex items-center gap-2 text-xs text-muted">
                        <input type="checkbox" style="margin:0 4px 0 0;">
                        <span>I agree to the terms of use and privacy policy.</span>
                    </label>
                </div>
                <div class="form-group" style="grid-column: 1 / -1;">
                    <button type="submit" class="btn btn-primary w-full">
                        <span>Create account</span>
                    </button>
                </div>
            </form>

            <div class="login-footer">
                <span>Already have an account?</span>
                <a href="<%= request.getContextPath() %>/auth/patient/login" class="text-xs" style="color:#38bdf8; text-decoration: none; font-weight: 500;">Sign in</a>
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
                    <span>Secure patient onboarding</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
