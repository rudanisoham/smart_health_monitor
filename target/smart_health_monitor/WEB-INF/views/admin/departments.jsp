<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "departments");
    request.setAttribute("pageTitle", "Departments");
    request.setAttribute("pageSubtitle", "Manage hospital units and capacities");
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

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Departments</div>
                        <div class="section-subtitle">Operational metrics by hospital wing</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/departments/add" class="btn btn-primary">+ Add Department</a>
                </div>
                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Unit Name</th>
                            <th>Description</th>
                            <th>Occupancy</th>
                            <th>Status/Account</th>
                            <th class="text-right">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty departments}">
                                <c:forEach var="dept" items="${departments}">
                                    <tr>
                                        <td><strong>${dept.name}</strong></td>
                                        <td class="muted"><div style="max-width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="${dept.description}">${dept.description}</div></td>
                                        <td>
                                            <div style="display:flex; align-items:center; gap:0.5rem;">
                                                <div style="background:rgba(255,255,255,0.05); height:6px; width:100px; border-radius:3px;">
                                                    <c:set var="pct" value="${dept.targetCapacity > 0 ? (dept.currOccupancy * 100 / dept.targetCapacity) : 0}"/>
                                                    <div style="background:${pct > 90 ? '#ef4444' : (pct > 75 ? '#f59e0b' : '#34d399')}; height:100%; width:${pct}%; border-radius:3px;"></div>
                                                </div>
                                                <span class="text-xs" style="font-family:monospace;">${dept.currOccupancy}/${dept.targetCapacity}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dept.status == 'ACTIVE'}"><span class="chip">Active</span></c:when>
                                                <c:otherwise><span class="chip-danger">${dept.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <form action="${pageContext.request.contextPath}/admin/departments/${dept.id}/delete" method="get" style="margin:0;">
                                                <button type="submit" class="btn btn-outline btn-sm" style="border-color:#ef4444; color:#ef4444;" onclick="return confirm('Delete this department entirely? Doctors assigned might have a null department reference.')">Delete unit</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="muted text-center" style="padding: 3rem;">No departments configured in the network.</td>
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
