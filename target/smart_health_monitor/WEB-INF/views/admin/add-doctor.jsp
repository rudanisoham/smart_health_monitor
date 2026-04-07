<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "doctors");
    request.setAttribute("pageTitle", "Register Doctor");
    request.setAttribute("pageSubtitle", "Onboard a new medical professional");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Doctor · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-outline btn-sm">← Back to Doctors</a>
            </div>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/doctors/add" method="post">
                <div class="card" style="max-width: 800px; margin: 0 auto;">
                    <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                        <div>
                            <div class="section-title">Doctor Credentials</div>
                            <div class="section-subtitle">Account and professional qualifications</div>
                        </div>
                    </div>

                    <div style="padding: 1.5rem 0;">
                        <div class="section-title mb-3">Authentication</div>
                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" class="form-control" required placeholder="Dr. John Doe">
                            </div>
                            <div class="form-group">
                                <label for="email">Professional Email</label>
                                <input type="email" id="email" name="email" class="form-control" required placeholder="doctor@hospital.com">
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" id="phone" name="phone" class="form-control" placeholder="+1 (555) 000-0000">
                            </div>
                            <div class="form-group">
                                <label for="password">Initial Password</label>
                                <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
                            </div>
                        </div>

                        <div class="section-title mb-3 mt-4" style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem;">Clinical Identity</div>
                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label for="specialty">Medical Specialty</label>
                                <input type="text" id="specialty" name="specialty" class="form-control" required placeholder="e.g. Cardiology">
                            </div>
                            <div class="form-group">
                                <label for="licenseNumber">License Number</label>
                                <input type="text" id="licenseNumber" name="licenseNumber" class="form-control" required placeholder="MD-12345678">
                            </div>
                            <div class="form-group">
                                <label for="experience">Years of Experience</label>
                                <input type="number" id="experience" name="experience" class="form-control" min="0" max="60" placeholder="5">
                            </div>
                            <div class="form-group">
                                <label for="departmentId">Assign Department</label>
                                <select id="departmentId" name="departmentId" class="form-select">
                                    <option value="">No Department Assigned</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.id}">${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mt-4 p-3" style="background:rgba(52,211,153,0.05); border:1px solid #34d399; border-radius:8px; display:flex; gap:1rem; align-items:center;">
                            <span style="font-size:1.5rem;">ℹ️</span>
                            <div style="font-size:0.9rem; color:var(--text-muted);">
                                Doctors registered by an admin bypass the application review process. Their account will be instantly **approved and ACTIVE**, and they can begin issuing prescriptions immediately.
                            </div>
                        </div>
                    </div>

                    <div style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem; display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn btn-primary px-4">Register Doctor</button>
                    </div>
                </div>
            </form>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
