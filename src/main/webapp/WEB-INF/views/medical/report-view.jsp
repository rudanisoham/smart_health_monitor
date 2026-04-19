<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Report Details");
    request.setAttribute("pageSubtitle", "Full report view");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report Details · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/medical/reports" class="btn btn-outline btn-sm">← Back to Reports</a>
            </div>

            <div class="grid grid-2">
                <div class="card">
                    <div class="section-title" style="margin-bottom:1rem;">Report Information</div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Title</span><span class="stat-value" style="font-size:1rem;">${report.title}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Patient</span><span class="stat-value" style="font-size:1rem;">${report.patient.user.fullName}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Type</span><span class="stat-value" style="font-size:1rem;">${report.type != null ? report.type.toString().replace('_',' ') : '—'}</span></div></div>
                    <div class="stat-item">
                        <div class="stat-info"><span class="stat-label">Status</span>
                            <span class="stat-value">
                                <c:choose>
                                    <c:when test="${report.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                    <c:when test="${report.status == 'REVIEWED'}"><span class="chip">Reviewed</span></c:when>
                                    <c:when test="${report.status == 'NORMAL'}"><span class="chip">Normal</span></c:when>
                                    <c:when test="${report.status == 'ABNORMAL'}"><span class="chip-danger">Abnormal</span></c:when>
                                    <c:otherwise><span class="chip-neutral">${report.status}</span></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Uploaded By</span><span class="stat-value" style="font-size:1rem;">${report.uploadedBy != null ? report.uploadedBy : '—'}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Date</span><span class="stat-value" style="font-size:1rem;">${report.createdAt.toString().replace('T',' ').substring(0,16)}</span></div></div>

                    <c:if test="${not empty report.description}">
                        <div style="margin-top:1rem;padding:1rem;background:#f8fafc;border-radius:8px;">
                            <div style="font-weight:700;margin-bottom:0.5rem;font-size:0.875rem;color:var(--text-muted);">DESCRIPTION</div>
                            <div>${report.description}</div>
                        </div>
                    </c:if>

                    <c:if test="${not empty report.results}">
                        <div style="margin-top:1rem;padding:1rem;background:#f8fafc;border-radius:8px;">
                            <div style="font-weight:700;margin-bottom:0.5rem;font-size:0.875rem;color:var(--text-muted);">RESULTS / FINDINGS</div>
                            <div style="white-space:pre-wrap;">${report.results}</div>
                        </div>
                    </c:if>

                    <c:if test="${not empty report.doctorComments}">
                        <div style="margin-top:1rem;padding:1rem;background:#eff6ff;border-radius:8px;border-left:4px solid #3b82f6;">
                            <div style="font-weight:700;margin-bottom:0.5rem;font-size:0.875rem;color:#1d4ed8;">DOCTOR COMMENTS</div>
                            <div>${report.doctorComments}</div>
                        </div>
                    </c:if>

                    <c:if test="${not empty report.filePath}">
                        <div style="margin-top:1rem;">
                            <a href="${pageContext.request.contextPath}${report.filePath}" target="_blank" class="btn btn-outline">📎 View Attached File</a>
                        </div>
                    </c:if>
                </div>

                <div class="card">
                    <div class="section-title" style="margin-bottom:1rem;">Patient Summary</div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Name</span><span class="stat-value" style="font-size:1rem;">${report.patient.user.fullName}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Email</span><span class="stat-value" style="font-size:0.9rem;">${report.patient.user.email}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Blood Group</span><span class="stat-value" style="font-size:1rem;">${report.patient.bloodGroup != null ? report.patient.bloodGroup : '—'}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Allergies</span><span class="stat-value" style="font-size:0.9rem;">${report.patient.allergies != null ? report.patient.allergies : 'None'}</span></div></div>
                    <div style="margin-top:1rem;">
                        <a href="${pageContext.request.contextPath}/medical/patients/${report.patient.id}" class="btn btn-outline w-full" style="justify-content:center;">View Full Patient Profile</a>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
