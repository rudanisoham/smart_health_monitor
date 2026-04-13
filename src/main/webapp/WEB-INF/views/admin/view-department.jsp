<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "departments");
    request.setAttribute("pageTitle", "Department Details");
    request.setAttribute("pageSubtitle", "Full overview of this hospital unit");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Department · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div style="display:flex;gap:0.75rem;margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-outline btn-sm">← Back</a>
                <a href="${pageContext.request.contextPath}/admin/departments/${department.id}/edit" class="btn btn-primary btn-sm">Edit Department</a>
            </div>

            <c:if test="${department == null}">
                <div style="padding:1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;">Department not found.</div>
            </c:if>

            <c:if test="${department != null}">

                <!-- Header Card -->
                <div class="card" style="margin-bottom:1.5rem;">
                    <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:1rem;">
                        <div>
                            <div style="font-size:1.75rem;font-weight:800;color:var(--text-main);">${department.name}</div>
                            <div style="font-size:0.9rem;color:var(--text-muted);margin-top:0.25rem;">Code: <strong>${department.code}</strong></div>
                            <c:if test="${not empty department.description}">
                                <div style="margin-top:0.75rem;font-size:0.95rem;color:var(--text-muted);max-width:600px;line-height:1.6;">${department.description}</div>
                            </c:if>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${department.status == 'ACTIVE'}"><span class="chip" style="font-size:0.9rem;padding:0.5rem 1.25rem;">● Active</span></c:when>
                                <c:otherwise><span class="chip-danger" style="font-size:0.9rem;padding:0.5rem 1.25rem;">${department.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Stats Row -->
                <div class="grid grid-4" style="margin-bottom:1.5rem;">
                    <div class="card">
                        <div class="card-title">Total Beds</div>
                        <div class="card-value">${department.totalBeds != null ? department.totalBeds : 0}</div>
                        <div class="muted mt-1">Configured beds</div>
                    </div>
                    <div class="card">
                        <div class="card-title">Available</div>
                        <div class="card-value" style="color:#10b981;">${department.availableBeds != null ? department.availableBeds : 0}</div>
                        <div class="muted mt-1">Ready for patients</div>
                    </div>
                    <div class="card">
                        <div class="card-title">Occupied</div>
                        <div class="card-value" style="color:#ef4444;">${department.occupiedBeds != null ? department.occupiedBeds : 0}</div>
                        <div class="muted mt-1">Currently in use</div>
                    </div>
                    <div class="card">
                        <div class="card-title">ICU Beds</div>
                        <div class="card-value" style="color:#f59e0b;">${department.icuBeds != null ? department.icuBeds : 0}</div>
                        <div class="muted mt-1">Intensive care</div>
                    </div>
                </div>

                <div class="grid grid-2" style="margin-bottom:1.5rem;">

                    <!-- Department Info -->
                    <div class="card">
                        <div class="section-title" style="margin-bottom:1rem;">Department Information</div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Department Head</span><span class="stat-value" style="font-size:1rem;">${not empty department.headName ? department.headName : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Physical Location</span><span class="stat-value" style="font-size:1rem;">${not empty department.physicalLocation ? department.physicalLocation : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Emergency Phone</span><span class="stat-value" style="font-size:1rem;">${not empty department.emergencyPhone ? department.emergencyPhone : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Target Capacity</span><span class="stat-value" style="font-size:1rem;">${department.targetCapacity}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Occupancy Rate</span>
                                <span class="stat-value" style="font-size:1rem;">
                                    <c:set var="pct" value="${department.targetCapacity > 0 ? (department.currOccupancy * 100 / department.targetCapacity) : 0}"/>
                                    ${department.currOccupancy} / ${department.targetCapacity} (${pct}%)
                                </span>
                            </div>
                        </div>
                        <div style="margin-top:0.75rem;">
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill ${pct > 90 ? 'danger' : (pct > 70 ? 'warning' : 'success')}" style="width:${pct}%;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Assigned Doctors -->
                    <div class="card">
                        <div class="section-title" style="margin-bottom:1rem;">Assigned Doctors</div>
                        <c:choose>
                            <c:when test="${not empty doctors}">
                                <c:forEach var="doc" items="${doctors}">
                                    <div class="stat-item">
                                        <div style="display:flex;align-items:center;gap:0.75rem;">
                                            <div style="width:36px;height:36px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-weight:700;color:var(--primary);">
                                                ${doc.user.fullName.substring(0,1)}
                                            </div>
                                            <div>
                                                <div style="font-weight:600;font-size:0.9rem;">Dr. ${doc.user.fullName}</div>
                                                <div class="muted" style="font-size:0.8rem;">${doc.specialty}</div>
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${doc.approved and doc.status == 'ACTIVE'}"><span class="chip" style="font-size:0.75rem;">Active</span></c:when>
                                            <c:when test="${!doc.approved}"><span class="chip-warning" style="font-size:0.75rem;">Pending</span></c:when>
                                            <c:otherwise><span class="chip-danger" style="font-size:0.75rem;">${doc.status}</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="muted" style="padding:1.5rem;text-align:center;">No doctors assigned to this department yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Bed List -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Bed Inventory</div>
                            <div class="section-subtitle">All beds in this department</div>
                        </div>
                        <div style="display:flex;gap:0.5rem;">
                            <span class="chip">${department.availableBeds} Available</span>
                            <span class="chip-danger">${department.occupiedBeds} Occupied</span>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                                <tr><th>Bed Number</th><th>Type</th><th>Status</th><th>Patient</th></tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty beds}">
                                    <c:forEach var="bed" items="${beds}">
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
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">No beds configured. Edit the department to set bed capacity.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </c:if>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
