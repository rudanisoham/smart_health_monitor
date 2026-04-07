<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Register New Patient");
    request.setAttribute("pageSubtitle", "Register a patient manually on-site");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Patient · Smart Health Monitor</title>
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
                <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-outline btn-sm">← Back to Patient List</a>
            </div>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/patients/add" method="post">
                <div class="card" style="max-width: 800px; margin: 0 auto;">
                    <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                        <div>
                            <div class="section-title">Patient Demographics</div>
                            <div class="section-subtitle">Account registration details</div>
                        </div>
                    </div>

                    <div style="padding: 1.5rem 0;">
                        <div class="section-title mb-3">Login & Contact</div>
                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" class="form-control" required placeholder="Patient Name">
                            </div>
                            <div class="form-group">
                                <label for="email">Personal Email</label>
                                <input type="email" id="email" name="email" class="form-control" required placeholder="patient@example.com">
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" id="phone" name="phone" class="form-control" placeholder="10-digit number">
                            </div>
                            <div class="form-group">
                                <label for="password">Initial Access Password</label>
                                <input type="password" id="password" name="password" class="form-control" required placeholder="••••••••">
                            </div>
                        </div>

                        <div class="section-title mb-3 mt-4" style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem;">Medical Profile</div>
                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label for="gender">Sex (Assigned at Birth)</label>
                                <select id="gender" name="gender" class="form-select">
                                    <option value="">Choose...</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="bloodGroup">Blood Group</label>
                                <select id="bloodGroup" name="bloodGroup" class="form-select">
                                    <option value="">Unknown</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem; display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn btn-primary px-4">Register Patient Record</button>
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
