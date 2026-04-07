<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Application · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="login-page">
    <div class="login-card">
        <div class="login-main">
            <div class="login-badge">
                <span>Smart Health Monitor · Careers</span>
            </div>
            <h1 class="login-title">Apply to join</h1>
            <p class="login-subtitle">
                Submit your medical credentials below. Our hospital administration will review your application.
            </p>

            <c:if test="${not empty error}">
                <div style="margin-bottom:1rem;padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/doctor/register" method="post" class="form-grid form-2">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input id="fullName" name="fullName" class="form-control" type="text" placeholder="Dr. Full Name" required minlength="2">
                </div>
                <div class="form-group">
                    <label for="registerEmail">Professional Email</label>
                    <input id="registerEmail" name="email" class="form-control" type="email" placeholder="doctor@hospital.com" required>
                </div>
                
                <div class="form-group">
                    <label for="specialty">Medical Specialty</label>
                    <select id="specialty" name="specialty" class="form-select" required>
                        <option value="">Select Specialty...</option>
                        <option value="Cardiology">Cardiology</option>
                        <option value="Neurology">Neurology</option>
                        <option value="Emergency Medicine">Emergency Medicine</option>
                        <option value="Pediatrics">Pediatrics</option>
                        <option value="General Practice">General Practice</option>
                        <option value="Orthopedics">Orthopedics</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="departmentId">Assign Department</label>
                    <select id="departmentId" name="departmentId" class="form-select" required>
                        <option value="">Select Department...</option>
                        <c:forEach var="dept" items="${departments}">
                            <option value="${dept.id}">${dept.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group" style="grid-column: 1 / -1;">
                    <label for="licenseNum">Medical License ID</label>
                    <input id="licenseNum" name="licenseNumber" class="form-control" type="text" placeholder="MD-12345678" required minlength="5">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input id="phone" name="phone" class="form-control" type="tel" placeholder="+1234567890" pattern="^\+?[0-9]{10,15}$" required>
                </div>
                <div class="form-group">
                    <label for="experience">Years of Experience</label>
                    <input id="experience" name="experience" class="form-control" type="number" placeholder="5" min="0" max="60" required>
                </div>

                <div class="form-group">
                    <label for="registerPassword">Desired Password</label>
                    <input id="registerPassword" name="password" class="form-control" type="password" placeholder="••••••••" required minlength="6">
                </div>
                <div class="form-group">
                    <label for="confirmRegisterPassword">Confirm Password</label>
                    <input id="confirmRegisterPassword" class="form-control" type="password" placeholder="••••••••" required>
                </div>
                
                <div class="form-group" style="grid-column: 1 / -1;">
                    <label class="flex items-center gap-2 text-xs text-muted">
                        <input type="checkbox" style="margin:0 4px 0 0;">
                        <span>I certify that all credentials provided are accurate and authorize verification.</span>
                    </label>
                </div>
                <div class="form-group" style="grid-column: 1 / -1;">
                    <button type="submit" class="btn btn-primary w-full">
                        <span>Submit Application for Review</span>
                    </button>
                    <p class="text-xs text-muted text-center mt-2">
                        Applications typically take 24-48 hours for administrative approval.
                    </p>
                </div>
            </form>

            <div class="login-footer">
                <span>Already an approved doctor?</span>
                <a href="<%= request.getContextPath() %>/auth/doctor/login" class="text-xs" style="color:#38bdf8; text-decoration: none; font-weight: 500;">Sign in here</a>
            </div>
        </div>

        <div class="login-extra" style="display: flex; flex-direction: column; justify-content: center; height: 100%;">
            <div class="login-kpi" style="background: transparent; border: none; padding: 0;">
                <h3 style="font-size: 1.5rem; margin-bottom: 1rem; color: #fff;">Join a World-Class Team</h3>
                <ul style="list-style: none; padding: 0; margin: 0; color: #94a3b8; font-size: 0.95rem; line-height: 1.6;">
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Instantly access advanced longitudinal patient records
                    </li>
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Utilize AI diagnostics to enhance treatment plans
                    </li>
                    <li style="margin-bottom: 0.75rem; display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Enjoy fully integrated cross-departmental communications
                    </li>
                    <li style="display: flex; align-items: flex-start; gap: 0.75rem;">
                        <span style="color: #38bdf8;">✓</span> Flexible schedule generation across all intensive care units
                    </li>
                </ul>
            </div>
            <div class="mt-8">
                <div class="login-badge-secondary">
                    <span>●</span>
                    <span>Rigorous credential verification</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
