<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Diagnostic Reports");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Diagnostic Reports · Patient Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .report-card { border: 2px solid #e2e8f0; border-radius: 20px; padding: 1.75rem; background: white; margin-bottom: 2rem; }
        .status-badge { padding: 0.35rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .status-PENDING { background: #fef3c7; color: #d97706; }
        .status-IN_PROGRESS { background: #e0e7ff; color: #4338ca; }
        .status-COMPLETED { background: #d1fae5; color: #059669; }
        .test-tag { background: #f1f5f9; color: #475569; padding: 0.25rem 0.75rem; border-radius: 100px; font-size: 0.75rem; font-weight: 600; margin-right: 0.5rem; margin-top: 0.5rem; display: inline-block; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>
        
        <div class="admin-content">
            <div style="margin-bottom:2rem;">
                <h2 style="font-size:1.75rem; font-weight:800; color:#1e293b; margin:0;">Diagnostic History</h2>
                <p class="muted">Access your session-based laboratory findings and reports.</p>
            </div>

            <c:if test="${not empty success}"><div style="padding:1rem; background:#d1fae5; color:#059669; border-radius:8px; margin-bottom:1.5rem;">${success}</div></c:if>

            <c:if test="${empty groupedLabRequests}">
                <div class="card" style="padding:4rem 2rem; text-align:center;">
                    <div style="font-size:3rem; margin-bottom:1rem; opacity:0.3;">🔬</div>
                    <h3 class="muted">No diagnostic history</h3>
                    <p class="muted mt-1">Your official hospital lab reports will appear here.</p>
                </div>
            </c:if>

            <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem;">
                <c:forEach var="entry" items="${groupedLabRequests}">
                    <c:set var="group" value="${entry.value}" />
                    <c:set var="first" value="${group[0]}" />
                    
                    <div class="report-card">
                        <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:1.5rem; flex-wrap: wrap; gap: 0.5rem;">
                            <div>
                                <h3 style="font-size:1.4rem; font-weight:800; color:#1e293b; margin:0;">
                                    <c:if test="${group.size() > 1}">Diagnostic Session</c:if>
                                    <c:if test="${group.size() == 1}">${first.labTest.name}</c:if>
                                </h3>
                                <div style="font-size:0.85rem; color:#64748b; margin-top:0.25rem;">Physician: <strong>Dr. ${first.doctor.user.fullName}</strong></div>
                            </div>
                            <span class="status-badge status-${first.status}">${first.status}</span>
                        </div>
                        
                        <div style="margin-bottom:1.5rem;">
                            <c:forEach var="req" items="${group}">
                                <span class="test-tag"><i class="fas fa-flask"></i> ${req.labTest.name}</span>
                            </c:forEach>
                        </div>

                        <div style="font-size:0.85rem; color:#64748b; padding:1rem; background:#f8fafc; border-radius:12px; margin-bottom:1.5rem;">
                            <div style="display:flex; justify-content:space-between; margin-bottom:0.5rem; flex-wrap: wrap;">
                                <span>Requested On</span>
                                <strong style="color:#1e293b;">${first.requestedAt.toString().replace('T', ' ').substring(0,16)}</strong>
                            </div>
                            <c:if test="${first.status == 'COMPLETED'}">
                                <div style="display:flex; justify-content:space-between; flex-wrap: wrap;">
                                    <span>Completed On</span>
                                    <strong style="color:#1e293b;">${first.completedAt.toString().replace('T', ' ').substring(0,16)}</strong>
                                </div>
                            </c:if>
                        </div>

                        <c:if test="${first.status == 'COMPLETED'}">
                            <div style="margin-top:1rem; display:flex; gap:1rem; flex-wrap: wrap;">
                                <c:if test="${not empty first.resultFileUrl}">
                                    <a href="<%= request.getContextPath() %>${first.resultFileUrl}" target="_blank" class="btn btn-primary" style="flex:1; min-width: 150px; justify-content:center; padding:0.85rem;">
                                        <i class="fas fa-file-pdf"></i> Download Report
                                    </a>
                                </c:if>
                                <a href="<%= request.getContextPath() %>/patient/lab-group/${entry.key}" class="btn btn-outline" style="flex:1; min-width: 150px; justify-content:center; padding:0.85rem;">
                                    <i class="fas fa-info-circle"></i> View Details
                                </a>
                            </div>
                        </c:if>
                        
                        <c:if test="${first.status != 'COMPLETED'}">
                            <div style="margin-top:1rem; padding:1rem; background:#fff7ed; border:1px solid #ffedd5; border-radius:12px; color:#c2410c; font-size:0.85rem; text-align:center;">
                                <i class="fas fa-clock"></i> Testing in progress. Check back soon for results.
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
