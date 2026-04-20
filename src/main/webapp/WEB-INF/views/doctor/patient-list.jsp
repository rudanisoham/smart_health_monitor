<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "My Patients");
    request.setAttribute("pageSubtitle", "Unique patients who have booked appointments with you");
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
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">My Patients</div>
                        <div class="section-subtitle">${not empty uniquePatients ? uniquePatients.size() : 0} unique patient(s)</div>
                    </div>
                    <div class="search-bar" style="max-width:300px;">
                        <svg class="search-icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" placeholder="Search patients..." onkeyup="filterTable(this,'patTable')">
                    </div>
                </div>
                <div class="table-container mt-2">
                    <table id="patTable">
                        <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Email</th>
                            <th>Blood Group</th>
                            <th>Phone</th>
                            <th>Gender</th>
                            <th class="text-right">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty uniquePatients}">
                                <c:forEach var="appt" items="${uniquePatients}">
                                    <tr>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:0.75rem;">
                                                <div style="width:36px;height:36px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-weight:700;color:var(--primary);font-size:0.9rem;flex-shrink:0;">
                                                    ${appt.patient.user.fullName.substring(0,1)}
                                                </div>
                                                <strong>${appt.patient.user.fullName}</strong>
                                            </div>
                                        </td>
                                        <td class="muted" style="font-size:0.875rem;">${appt.patient.user.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.patient.bloodGroup != null}"><span class="chip-danger" style="font-size:0.75rem;">${appt.patient.bloodGroup}</span></c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="muted" style="font-size:0.875rem;">${appt.patient.phone != null ? appt.patient.phone : '—'}</td>
                                        <td class="muted" style="font-size:0.875rem;">${appt.patient.gender != null ? appt.patient.gender : '—'}</td>
                                        <td class="text-right">
                                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/doctor/patient/${appt.patient.id}">View Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align:center;padding:2.5rem;" class="muted">
                                        <div style="font-size:2rem;margin-bottom:0.5rem;">👥</div>
                                        No patients yet. Patients will appear here once they book appointments.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
<script>
function filterTable(input, tableId) {
    const filter = input.value.toLowerCase();
    document.getElementById(tableId).querySelectorAll('tbody tr').forEach(row => {
        row.style.display = (row.innerText || row.textContent).toLowerCase().includes(filter) ? '' : 'none';
    });
}
</script>
</body>
</html>
