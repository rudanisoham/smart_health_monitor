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
                    <div style="display:flex; gap:1rem; align-items:center;">
                        <div class="search-bar">
                            <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                            <input type="text" placeholder="Search patients..." onkeyup="filterTable(this, 'patientTable')">
                        </div>
                        <button onclick="toggleBedFilter(this)" class="btn btn-outline btn-sm" style="height:2.5rem; white-space:nowrap;">
                            🛏️ Assigned Only
                        </button>
                    </div>
                </div>
                <div class="table-container mt-2">
                    <table id="patientTable">
                        <thead>
                            <tr><th>Name</th><th>Contact</th><th>Bed Status</th><th>Department</th><th>Actions</th></tr>
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
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty bedMap[p.id]}">
                                                    <div style="font-weight:600; color:var(--primary);">${bedMap[p.id].bedNumber}</div>
                                                    <div class="muted" style="font-size:0.75rem;">Occupied</div>
                                                </c:when>
                                                <c:otherwise><span class="muted">No Bed</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.department != null}"><span class="chip">${p.department.name}</span></c:when>
                                                <c:otherwise><span class="muted">N/A</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/reception/patient/${p.id}/billing" class="btn btn-outline btn-sm">Billing & Payments</a>
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

let bedFilterActive = false;
function toggleBedFilter(btn) {
    bedFilterActive = !bedFilterActive;
    const rows = document.getElementById('patientTable').getElementsByTagName("tr");
    
    if (bedFilterActive) {
        btn.classList.remove('btn-outline');
        btn.classList.add('btn-primary');
        for (let i = 1; i < rows.length; i++) {
            const bedCell = rows[i].getElementsByTagName("td")[2];
            if (bedCell.innerText.includes('No Bed')) {
                rows[i].style.display = "none";
            } else {
                rows[i].style.display = "";
            }
        }
    } else {
        btn.classList.add('btn-outline');
        btn.classList.remove('btn-primary');
        for (let i = 1; i < rows.length; i++) {
            rows[i].style.display = "";
        }
    }
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
