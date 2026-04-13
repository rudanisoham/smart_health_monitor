<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "beds");
    request.setAttribute("pageTitle", "Bed Management");
    request.setAttribute("pageSubtitle", "Assign and release beds for patients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bed Management · Smart Health Monitor</title>
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
            <a href="<%= request.getContextPath() %>/department/${department.id}/dashboard" class="nav-item">
                <span>🏠 Dashboard</span>
            </a>
            <a href="<%= request.getContextPath() %>/department/${department.id}/beds" class="nav-item ${activePage == 'beds' ? 'active' : ''}">
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
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <div class="card">
                    <div class="card-header">
                        <div class="section-title">Assign Bed</div>
                    </div>
                    <form action="<%= request.getContextPath() %>/department/beds/assign" method="post" class="mt-3">
                        <input type="hidden" name="departmentId" value="${department.id}" />
                        <div class="form-group mb-3">
                            <label class="form-label">Available Beds</label>
                            <select name="bedId" class="form-control" required>
                                <option value="">-- Choose Bed --</option>
                                <c:forEach var="b" items="${beds}">
                                    <c:if test="${b.status == 'AVAILABLE'}">
                                        <option value="${b.id}">${b.bedNumber} (${b.type})</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Patient</label>
                            <select name="patientId" class="form-control" required>
                                <option value="">-- Choose Patient --</option>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}">${p.user.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Assign Bed</button>
                    </form>
                </div>
            </div>

            <div class="card mt-4">
                <div class="card-header">
                    <div class="section-title">All Beds</div>
                </div>
                <div class="table-responsive mt-3">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Bed Number</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Patient</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${beds}">
                                <tr>
                                    <td>${b.bedNumber}</td>
                                    <td>${b.type}</td>
                                    <td>
                                        <span class="badge ${b.status == 'AVAILABLE' ? 'badge-success' : 'badge-danger'}">
                                            ${b.status}
                                        </span>
                                    </td>
                                    <td>${b.patient != null ? b.patient.user.fullName : 'N/A'}</td>
                                    <td>
                                        <c:if test="${b.status == 'OCCUPIED'}">
                                            <form action="<%= request.getContextPath() %>/department/beds/release" method="post" style="display:inline;">
                                                <input type="hidden" name="departmentId" value="${department.id}" />
                                                <input type="hidden" name="bedId" value="${b.id}" />
                                                <button type="submit" class="btn btn-outline btn-sm" onclick="return confirm('Release this bed?')">Release</button>
                                            </form>
                                        </c:if>
                                    </td>
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
