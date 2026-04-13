<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patient-entry");
    request.setAttribute("pageTitle", "Patient Entry");
    request.setAttribute("pageSubtitle", "Register or assign patients to departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Entry · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h3>Reception Portal</h3>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/reception/dashboard" class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                <span>🏠 Dashboard</span>
            </a>
            <a href="<%= request.getContextPath() %>/reception/patient-entry" class="nav-item ${activePage == 'patient-entry' ? 'active' : ''}">
                <span>👥 Patient Entry & Assignment</span>
            </a>
            <a href="<%= request.getContextPath() %>/auth/logout" class="nav-item" style="margin-top:auto; color:#ef4444;">
                <span>🚪 Logout</span>
            </a>
        </nav>
    </aside>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>
        <div class="admin-content">
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <div class="card">
                    <div class="card-header">
                        <div class="section-title">Assign Existing Patient</div>
                    </div>
                    <form action="<%= request.getContextPath() %>/reception/patient-entry/assign" method="post" class="mt-3">
                        <div class="form-group mb-3">
                            <label class="form-label">Select Patient</label>
                            <select name="patientId" class="form-control" required>
                                <option value="">-- Choose Patient --</option>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}">${p.user.fullName} (ID: ${p.id})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Assign to Department</label>
                            <select name="departmentId" class="form-control" required>
                                <option value="">-- Choose Department --</option>
                                <c:forEach var="d" items="${departments}">
                                    <option value="${d.id}">${d.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Assign Patient</button>
                    </form>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <div class="section-title">Register New Patient</div>
                    </div>
                    <div class="mt-3">
                        <p class="muted">To register a completely new patient into the system, direct them to the self-registration portal or use the admin capabilities.</p>
                        <a href="<%= request.getContextPath() %>/auth/patient/register" class="btn btn-outline" target="_blank">Open Registration Portal</a>
                    </div>
                </div>
            </div>
            
        </div>
        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
