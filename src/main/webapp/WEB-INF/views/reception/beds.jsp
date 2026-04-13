<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "beds");
    request.setAttribute("pageTitle", "Bed Management");
    request.setAttribute("pageSubtitle", "Assign and release beds across all departments");
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
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <!-- Department Bed Summary Cards -->
            <div class="grid grid-4" style="margin-bottom:2rem;">
                <c:forEach var="dept" items="${departments}">
                    <div class="card">
                        <div class="card-title">${dept.name}</div>
                        <div style="display:flex;gap:0.5rem;margin-top:0.75rem;flex-wrap:wrap;">
                            <span class="chip">${dept.availableBeds} Free</span>
                            <span class="chip-danger">${dept.occupiedBeds} Occupied</span>
                            <c:if test="${dept.icuBeds > 0}"><span class="chip-warning">${dept.icuBeds} ICU</span></c:if>
                        </div>
                        <div class="progress-container" style="margin-top:0.75rem;">
                            <c:set var="pct" value="${dept.totalBeds > 0 ? (dept.occupiedBeds * 100 / dept.totalBeds) : 0}"/>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill ${pct > 90 ? 'danger' : (pct > 70 ? 'warning' : 'success')}" style="width:${pct}%;"></div>
                            </div>
                            <div class="progress-label" style="margin-top:0.35rem;">
                                <span>${dept.occupiedBeds}/${dept.totalBeds} beds used</span>
                                <span>${pct}%</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Bed Detail Tables per Department -->
            <c:forEach var="dept" items="${departments}">
                <div class="card" style="margin-bottom:1.5rem;">
                    <div class="card-header">
                        <div>
                            <div class="section-title">${dept.name} — Beds</div>
                            <div class="section-subtitle">${dept.availableBeds} available · ${dept.occupiedBeds} occupied · ${dept.totalBeds} total</div>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                                <tr><th>Bed No.</th><th>Type</th><th>Status</th><th>Patient</th><th class="text-right">Action</th></tr>
                            </thead>
                            <tbody>
                            <c:set var="deptBeds" value="${bedMap[dept.id]}"/>
                            <c:choose>
                                <c:when test="${not empty deptBeds}">
                                    <c:forEach var="bed" items="${deptBeds}">
                                        <tr>
                                            <td><strong>${bed.bedNumber}</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bed.type == 'ICU'}"><span class="chip-danger">ICU</span></c:when>
                                                    <c:otherwise><span class="chip-neutral">Normal</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bed.status == 'AVAILABLE'}"><span class="chip">Available</span></c:when>
                                                    <c:when test="${bed.status == 'OCCUPIED'}"><span class="chip-danger">Occupied</span></c:when>
                                                    <c:otherwise><span class="chip-warning">Maintenance</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bed.patient != null}">${bed.patient.user.fullName}</c:when>
                                                    <c:otherwise><span class="muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-right">
                                                <c:choose>
                                                    <c:when test="${bed.status == 'AVAILABLE'}">
                                                        <button class="btn btn-primary btn-sm" onclick="showAssignModal(${bed.id}, '${bed.bedNumber}')">Assign Patient</button>
                                                    </c:when>
                                                    <c:when test="${bed.status == 'OCCUPIED'}">
                                                        <form action="${pageContext.request.contextPath}/reception/beds/${bed.id}/release" method="post" style="display:inline;">
                                                            <button class="btn btn-outline btn-sm" type="submit" onclick="return confirm('Release bed ${bed.bedNumber}?')" style="border-color:#ef4444;color:#ef4444;">Release</button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise><span class="muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="muted" style="text-align:center;padding:1.5rem;">No beds configured for this department. Add beds via Admin → Departments.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:forEach>

        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>

<!-- Assign Patient Modal -->
<div id="assignModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:1000;align-items:center;justify-content:center;">
    <div style="background:white;border-radius:1.25rem;padding:2rem;width:100%;max-width:440px;box-shadow:0 20px 60px rgba(0,0,0,0.2);">
        <div style="font-size:1.2rem;font-weight:700;margin-bottom:0.5rem;">Assign Patient to Bed</div>
        <div id="modalBedLabel" style="color:var(--text-muted);font-size:0.9rem;margin-bottom:1.5rem;"></div>
        <form id="assignForm" method="post" class="form-grid">
            <div class="form-group">
                <label for="patientSelect">Select Patient</label>
                <select id="patientSelect" name="patientId" class="form-select" required>
                    <option value="">-- Choose Patient --</option>
                    <c:forEach var="p" items="${patients}">
                        <option value="${p.id}">${p.user.fullName} (${p.user.email})</option>
                    </c:forEach>
                </select>
            </div>
            <div style="display:flex;gap:1rem;margin-top:0.5rem;">
                <button type="submit" class="btn btn-primary" style="flex:1;">Assign</button>
                <button type="button" class="btn btn-outline" style="flex:1;" onclick="closeModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function showAssignModal(bedId, bedNumber) {
    document.getElementById('assignModal').style.display = 'flex';
    document.getElementById('modalBedLabel').textContent = 'Bed: ' + bedNumber;
    document.getElementById('assignForm').action = '<%= request.getContextPath() %>/reception/beds/' + bedId + '/assign';
}
function closeModal() {
    document.getElementById('assignModal').style.display = 'none';
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
