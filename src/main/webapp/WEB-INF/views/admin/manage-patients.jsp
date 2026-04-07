<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Manage Patients");
    request.setAttribute("pageSubtitle", "View and manage all registered patients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Patients · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=5">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div class="search-bar">
                        <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" id="searchInput" placeholder="Search by name, email, or phone..." onkeyup="filterTable(this, 'patientTable')">
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/patients/add" class="btn btn-primary">+ Register Patient</a>
                </div>

                <div class="table-container mt-3">
                    <table id="patientTable">
                        <thead>
                        <tr>
                            <th>Patient Name</th>
                            <th>Contact</th>
                            <th>Blood Group</th>
                            <th>Sex</th>
                            <th>Registered On</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty patients}">
                                <c:forEach var="pt" items="${patients}">
                                    <tr>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:0.75rem;">
                                                <div style="width:36px;height:36px;border-radius:50%;background:#0ea5e9;display:flex;align-items:center;justify-content:center;font-weight:600;font-size:14px;color:#fff;">${pt.user.fullName.substring(0,1)}</div>
                                                <div style="font-weight:600;">${pt.user.fullName}</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="text-sm">${pt.user.email}</div>
                                            <div class="muted text-xs">${pt.phone != null ? pt.phone : '—'}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${pt.bloodGroup != null}"><span class="chip-danger">${pt.bloodGroup}</span></c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${pt.gender != null ? pt.gender : '—'}</td>
                                        <td class="muted">${pt.user.createdAt.toString().substring(0,10)}</td>
                                        <td class="text-right">
                                            <div class="table-actions">
                                                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/patients/${pt.id}/view">Details</a>
                                                <form action="${pageContext.request.contextPath}/admin/patients/${pt.id}/delete" method="get" style="display:inline;">
                                                    <button type="submit" class="btn btn-outline btn-sm" style="border-color:#ef4444;color:#ef4444;" onclick="return confirm('Permanently delete this patient? This deletes all health records, appointments, and vitals associated with them.')">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="muted text-center" style="padding: 3rem;">No patients registered in the system.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script>
    function filterTable(input, tableId) {
        let filter = input.value.toLowerCase();
        let table = document.getElementById(tableId);
        let tr = table.getElementsByTagName("tr");
        for (let i = 1; i < tr.length; i++) {
            let rowText = tr[i].innerText || tr[i].textContent;
            tr[i].style.display = rowText.toLowerCase().indexOf(filter) > -1 ? "" : "none";
        }
    }
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
