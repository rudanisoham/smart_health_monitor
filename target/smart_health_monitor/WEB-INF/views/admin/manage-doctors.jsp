<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "doctors");
    request.setAttribute("pageTitle", "Manage Doctors");
    request.setAttribute("pageSubtitle", "View and filter all registered medical professionals");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Doctors · Smart Health Monitor</title>
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

            <div class="grid grid-3" style="margin-bottom: 2rem;">
                <div class="card">
                    <div class="card-title">Total Doctors</div>
                    <div class="card-value">${not empty doctors ? doctors.size() : 0}</div>
                </div>
                <div class="card" style="display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <div class="card-title" style="color:#f59e0b;">Pending Approvals</div>
                        <div class="card-value">${pendingCount != null ? pendingCount : 0}</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/doctors/requests" class="btn btn-outline btn-sm">Review All</a>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="search-bar">
                        <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" placeholder="Search by name, specialty, or department..." onkeyup="filterTable(this, 'doctorTable')">
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/doctors/add" class="btn btn-primary">+ Register Doctor</a>
                </div>
                
                <div class="table-container mt-3">
                    <table id="doctorTable">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Contact</th>
                            <th>Specialty</th>
                            <th>Department</th>
                            <th>Status/Account</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty doctors}">
                                <c:forEach var="doc" items="${doctors}">
                                    <tr>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:0.75rem;">
                                                <div style="width:36px;height:36px;border-radius:50%;background:#1e293b;display:flex;align-items:center;justify-content:center;font-weight:600;font-size:14px;color:#cbd5e1;">${doc.user.fullName.substring(0,1)}</div>
                                                <div>
                                                    <div style="font-weight:600;">Dr. ${doc.user.fullName}</div>
                                                    <div class="muted text-xs">Lic: ${doc.licenseNumber}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="text-sm">${doc.user.email}</div>
                                            <div class="muted text-xs">${doc.phone != null ? doc.phone : '—'}</div>
                                        </td>
                                        <td>${doc.specialty}</td>
                                        <td><span class="chip-neutral">${doc.department != null ? doc.department.name : 'Unassigned'}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${!doc.approved}"><span class="chip-warning">Pending</span></c:when>
                                                <c:when test="${doc.status == 'ACTIVE'}"><span class="chip">Active</span></c:when>
                                                <c:otherwise><span class="chip-danger">${doc.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <div class="table-actions">
                                                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/doctors/${doc.id}/view">View</a>
                                                <c:if test="${doc.approved}">
                                                    <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/doctors/${doc.id}/toggle" onclick="return confirm('Toggle status between ACTIVE/INACTIVE for this doctor?')">Toggle Status</a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="muted text-center" style="padding: 3rem;">No doctors registered in the system.</td>
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
