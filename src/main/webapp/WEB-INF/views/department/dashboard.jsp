<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "dashboard");
    request.setAttribute("pageTitle", "Department Dashboard");
    request.setAttribute("pageSubtitle", "Manage department resources and patients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Department Dashboard · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h3>${department.name}</h3>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/department/${department.id}/dashboard" class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                <span>🏠 Dashboard</span>
            </a>
            <a href="<%= request.getContextPath() %>/department/${department.id}/beds" class="nav-item">
                <span>🛏️ Bed Management</span>
            </a>
            <a href="<%= request.getContextPath() %>/auth/logout" class="nav-item" style="margin-top:auto; color:#ef4444;">
                <span>🚪 Logout</span>
            </a>
        </nav>
    </aside>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>
        <div class="admin-content">
            <div class="grid grid-4" style="margin-bottom: 2rem;">
                <div class="card">
                    <div class="card-title">Patients Here</div>
                    <div class="card-value">${patients != null ? patients.size() : 0}</div>
                    <div class="muted mt-1 text-xs">Total assigned</div>
                </div>
                <div class="card">
                    <div class="card-title">Available Beds</div>
                    <div class="card-value" style="color: #10b981;">${department.availableBeds}</div>
                    <div class="muted mt-1 text-xs">Out of ${department.totalBeds}</div>
                </div>
                <div class="card">
                    <div class="card-title">Occupied Beds</div>
                    <div class="card-value" style="color: #ef4444;">${department.occupiedBeds}</div>
                    <div class="muted mt-1 text-xs">Currently in use</div>
                </div>
                <div class="card">
                    <div class="card-title">Doctors</div>
                    <div class="card-value" style="color: #3b82f6;">${doctors != null ? doctors.size() : 0}</div>
                </div>
            </div>

            <div class="card mt-4">
                <div class="card-header">
                    <div class="section-title">Patients in Department</div>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Assigned Doctor</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                            <tr>
                                <td>${p.id}</td>
                                <td>${p.user.fullName}</td>
                                <td>${p.assignedDoctor != null ? p.assignedDoctor.user.fullName : 'None'}</td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
