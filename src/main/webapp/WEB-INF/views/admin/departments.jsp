<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "departments");
    request.setAttribute("pageTitle", "Departments");
    request.setAttribute("pageSubtitle", "Manage hospital units, beds and capacities");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Departments · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
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
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <!-- Summary Cards -->
            <div class="grid grid-4" style="margin-bottom:1.5rem;">
                <div class="card">
                    <div class="card-title">Total Departments</div>
                    <div class="card-value">${not empty departments ? departments.size() : 0}</div>
                    <div class="muted mt-1">Hospital units</div>
                </div>
                <div class="card">
                    <div class="card-title">Active Units</div>
                    <div class="card-value" style="color:#10b981;">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach var="d" items="${departments}">
                            <c:if test="${d.status == 'ACTIVE'}"><c:set var="activeCount" value="${activeCount+1}"/></c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                    <div class="muted mt-1">Currently operational</div>
                </div>
                <div class="card">
                    <div class="card-title">Total Beds</div>
                    <div class="card-value" style="color:#3b82f6;">
                        <c:set var="totalBeds" value="0"/>
                        <c:forEach var="d" items="${departments}">
                            <c:set var="totalBeds" value="${totalBeds + (d.totalBeds != null ? d.totalBeds : 0)}"/>
                        </c:forEach>
                        ${totalBeds}
                    </div>
                    <div class="muted mt-1">Across all departments</div>
                </div>
                <div class="card">
                    <div class="card-title">Available Beds</div>
                    <div class="card-value" style="color:#10b981;">
                        <c:set var="availBeds" value="0"/>
                        <c:forEach var="d" items="${departments}">
                            <c:set var="availBeds" value="${availBeds + (d.availableBeds != null ? d.availableBeds : 0)}"/>
                        </c:forEach>
                        ${availBeds}
                    </div>
                    <div class="muted mt-1">Ready for patients</div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Departments</div>
                        <div class="section-subtitle">View, edit or delete hospital units</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/departments/add" class="btn btn-primary">+ Add Department</a>
                </div>
                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Department</th>
                            <th>Head / Location</th>
                            <th>Beds</th>
                            <th>Occupancy</th>
                            <th>Status</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty departments}">
                                <c:forEach var="dept" items="${departments}">
                                    <tr>
                                        <td>
                                            <div style="font-weight:700;">${dept.name}</div>
                                            <div class="muted" style="font-size:0.8rem;">Code: ${dept.code}</div>
                                        </td>
                                        <td>
                                            <div style="font-size:0.875rem;">${not empty dept.headName ? dept.headName : '—'}</div>
                                            <div class="muted" style="font-size:0.8rem;">${not empty dept.physicalLocation ? dept.physicalLocation : ''}</div>
                                        </td>
                                        <td>
                                            <div style="display:flex;gap:0.4rem;flex-wrap:wrap;">
                                                <span class="chip-neutral" style="font-size:0.75rem;">${dept.totalBeds != null ? dept.totalBeds : 0} total</span>
                                                <span class="chip" style="font-size:0.75rem;">${dept.availableBeds != null ? dept.availableBeds : 0} free</span>
                                                <c:if test="${dept.icuBeds != null and dept.icuBeds > 0}">
                                                    <span class="chip-danger" style="font-size:0.75rem;">${dept.icuBeds} ICU</span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <c:set var="pct" value="${dept.targetCapacity > 0 ? (dept.currOccupancy * 100 / dept.targetCapacity) : 0}"/>
                                            <div style="display:flex;align-items:center;gap:0.5rem;">
                                                <div style="background:#f1f5f9;height:6px;width:80px;border-radius:3px;overflow:hidden;">
                                                    <div style="background:${pct > 90 ? '#ef4444' : (pct > 75 ? '#f59e0b' : '#10b981')};height:100%;width:${pct}%;border-radius:3px;"></div>
                                                </div>
                                                <span style="font-size:0.8rem;font-family:monospace;">${dept.currOccupancy}/${dept.targetCapacity}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dept.status == 'ACTIVE'}"><span class="chip">Active</span></c:when>
                                                <c:otherwise><span class="chip-danger">${dept.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <div style="display:flex;justify-content:flex-end;gap:0.5rem;flex-wrap:wrap;">
                                                <a href="${pageContext.request.contextPath}/admin/departments/${dept.id}/view"
                                                   class="btn btn-outline btn-sm">View</a>
                                                <a href="${pageContext.request.contextPath}/admin/departments/${dept.id}/edit"
                                                   class="btn btn-outline btn-sm" style="border-color:#3b82f6;color:#3b82f6;">Edit</a>
                                                <form action="${pageContext.request.contextPath}/admin/departments/${dept.id}/delete" method="get" style="margin:0;">
                                                    <button type="submit" class="btn btn-outline btn-sm"
                                                            style="border-color:#ef4444;color:#ef4444;"
                                                            onclick="return confirm('Delete ${dept.name}? This cannot be undone.')">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="muted" style="text-align:center;padding:3rem;">
                                        No departments configured yet.
                                        <a href="${pageContext.request.contextPath}/admin/departments/add">Add the first one</a>
                                    </td>
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
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
