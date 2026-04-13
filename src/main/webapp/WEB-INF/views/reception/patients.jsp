<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patients");
    request.setAttribute("pageSubtitle", "View all registered patients and their department assignments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patients · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Patients</div>
                        <div class="section-subtitle">Registered patients and their current department</div>
                    </div>
                    <div class="search-bar">
                        <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" placeholder="Search patients..." onkeyup="filterTable(this, 'patientTable')">
                    </div>
                </div>
                <div class="table-container mt-2">
                    <table id="patientTable">
                        <thead>
                            <tr><th>Name</th><th>Contact</th><th>Blood Group</th><th>Department</th><th>Assigned Doctor</th></tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty patients}">
                                <c:forEach var="p" items="${patients}">
                                    <tr>
                                        <td><strong>${p.user.fullName}</strong></td>
                                        <td>
                                            <div style="font-size:0.875rem;">${p.user.email}</div>
                                            <div class="muted" style="font-size:0.8rem;">${p.user.phone != null ? p.user.phone : '—'}</div>
                                        </td>
                                        <td>${p.bloodGroup != null ? p.bloodGroup : '—'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.department != null}"><span class="chip">${p.department.name}</span></c:when>
                                                <c:otherwise><span class="muted">Not assigned</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.assignedDoctor != null}">Dr. ${p.assignedDoctor.user.fullName}</c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="5" class="muted" style="text-align:center;padding:2rem;">No patients registered.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>
<script>
function filterTable(input, tableId) {
    let filter = input.value.toLowerCase();
    let rows = document.getElementById(tableId).getElementsByTagName("tr");
    for (let i = 1; i < rows.length; i++) {
        rows[i].style.display = (rows[i].innerText || rows[i].textContent).toLowerCase().includes(filter) ? "" : "none";
    }
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
