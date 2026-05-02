<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab Report History | Smart Health</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .history-card { border: 1px solid #e2e8f0; border-radius: 16px; background: white; margin-bottom: 1.5rem; overflow: hidden; }
        .history-header { background: #f8fafc; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .history-body { padding: 0; }
        .test-row { display: grid; grid-template-columns: 1fr 1fr 150px 100px 100px; padding: 1rem 1.5rem; border-bottom: 1px solid #f1f5f9; align-items: center; }
        .test-row:last-child { border-bottom: none; }
    </style>
</head>
<%
    request.setAttribute("activePage", "history");
%>
<body>
    <div class="admin-app">
        <%@ include file="/WEB-INF/views/layout/lab-sidebar.jsp" %>
        <main class="admin-main">
            <%@ include file="/WEB-INF/views/layout/lab-header.jsp" %>
            <div class="admin-content">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem;">
                    <div>
                        <h2 style="font-size:1.75rem; font-weight:800; color:#1e293b; margin:0;">Completed Reports</h2>
                        <p class="muted">Archived records of all processed diagnostics.</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/lab/dashboard" class="btn btn-primary btn-sm">
                        <i class="fas fa-arrow-left"></i> Back to Queue
                    </a>
                </div>

                <c:if test="${empty groupedHistory}">
                    <div class="card" style="padding:4rem 2rem; text-align:center;">
                        <div style="font-size:3rem; margin-bottom:1rem; opacity:0.3;">📂</div>
                        <p class="muted">No history records found.</p>
                    </div>
                </c:if>

                <c:forEach var="entry" items="${groupedHistory}">
                    <c:set var="group" value="${entry.value}" />
                    <c:set var="first" value="${group[0]}" />
                    
                    <div class="history-card">
                        <div class="history-header">
                            <div>
                                <strong style="font-size:1.1rem; color:#1e293b;">${first.patient.user.fullName}</strong>
                                <span class="muted" style="margin-left:1rem; font-size:0.85rem;">Dr. ${first.doctor.user.fullName}</span>
                            </div>
                            <div class="muted" style="font-size:0.8rem;">
                                <fmt:parseDate value="${first.requestedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedReqDate" type="both" />
                                Requested: <fmt:formatDate value="${parsedReqDate}" pattern="MMM dd, yyyy" />
                            </div>
                        </div>
                        <div class="history-body">
                            <div class="test-row" style="background:#f8fafc; font-weight:700; font-size:0.75rem; text-transform:uppercase; color:#64748b; border-bottom:2px solid #e2e8f0;">
                                <div>Test Name</div>
                                <div>Result Notes</div>
                                <div>Completed At</div>
                                <div>Report</div>
                                <div>Billing</div>
                            </div>
                            <c:forEach var="req" items="${group}">
                                <div class="test-row">
                                    <div style="font-weight:600; color:#334155;">${req.labTest.name}</div>
                                    <div style="font-size:0.85rem; color:#64748b;">${not empty req.resultNotes ? req.resultNotes : '—'}</div>
                                    <div style="font-size:0.85rem; color:#64748b;">
                                        <c:if test="${not empty req.completedAt}">
                                            <fmt:parseDate value="${req.completedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedCompDate" type="both" />
                                            <fmt:formatDate value="${parsedCompDate}" pattern="MMM dd, HH:mm" />
                                        </c:if>
                                    </div>
                                    <div>
                                        <c:if test="${not empty req.resultFileUrl}">
                                            <a href="${pageContext.request.contextPath}${req.resultFileUrl}" target="_blank" class="btn btn-outline btn-sm" style="padding:0.25rem 0.5rem;">
                                                <i class="fas fa-file-pdf"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                    <div>
                                        <span class="badge" style="background:#d1fae5; color:#059669; font-size:0.65rem;">BILLED</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </main>
    </div>
    <script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
