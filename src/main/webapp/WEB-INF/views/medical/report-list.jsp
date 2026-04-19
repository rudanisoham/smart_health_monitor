<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Medical Reports");
    request.setAttribute("pageSubtitle", "All uploaded patient reports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Reports</div>
                        <div class="section-subtitle">${not empty reports ? reports.size() : 0} total reports</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/medical/reports/upload" class="btn btn-primary">+ Upload Report</a>
                </div>
                <div class="table-container mt-3">
                    <table>
                        <thead>
                            <tr><th>Date</th><th>Patient</th><th>Title</th><th>Type</th><th>Status</th><th>Uploaded By</th><th class="text-right">Action</th></tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty reports}">
                                <c:forEach var="r" items="${reports}">
                                    <tr>
                                        <td class="muted" style="font-size:0.85rem;">${r.createdAt.toString().replace('T',' ').substring(0,10)}</td>
                                        <td><strong>${r.patient.user.fullName}</strong></td>
                                        <td>${r.title}</td>
                                        <td><span class="chip-neutral" style="font-size:0.75rem;">${r.type != null ? r.type.toString().replace('_',' ') : '—'}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                <c:when test="${r.status == 'REVIEWED'}"><span class="chip">Reviewed</span></c:when>
                                                <c:when test="${r.status == 'NORMAL'}"><span class="chip">Normal</span></c:when>
                                                <c:when test="${r.status == 'ABNORMAL'}"><span class="chip-danger">Abnormal</span></c:when>
                                                <c:otherwise><span class="chip-neutral">${r.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="muted" style="font-size:0.85rem;">${r.uploadedBy != null ? r.uploadedBy : '—'}</td>
                                        <td class="text-right">
                                            <a href="${pageContext.request.contextPath}/medical/reports/${r.id}" class="btn btn-outline btn-sm">View</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="7" class="muted" style="text-align:center;padding:2.5rem;">
                                    <div style="font-size:2rem;margin-bottom:0.5rem;">📁</div>
                                    No reports uploaded yet. <a href="${pageContext.request.contextPath}/medical/reports/upload">Upload the first one</a>.
                                </td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
