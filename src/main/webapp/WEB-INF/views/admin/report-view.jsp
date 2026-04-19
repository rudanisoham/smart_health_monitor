<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Medical Report Audit");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report Audit · Smart Health Monitor</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>
        <div class="admin-content">
            <div style="margin-bottom:1.5rem;">
                <button onclick="history.back()" class="btn btn-outline btn-sm">← Back</button>
            </div>

            <c:choose>
                <c:when test="${not empty report}">
                    <div class="card">
                        <div class="card-header border-bottom">
                            <div>
                                <h2 style="margin:0;">${report.title}</h2>
                                <div class="muted">Patient: ${report.patient.user.fullName} | Submitted: ${report.createdAt.toString().substring(0,10)}</div>
                            </div>
                            <span class="chip">${report.status}</span>
                        </div>
                        <div class="mt-3">
                            <div class="grid grid-2">
                                <div>
                                    <h4 class="section-subtitle">Report Type</h4>
                                    <p>${report.type}</p>
                                </div>
                                <div>
                                    <h4 class="section-subtitle">Diagnosis/Results</h4>
                                    <p>${report.results}</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <h4 class="section-subtitle">Description</h4>
                                <p class="muted">${report.description}</p>
                            </div>
                            <c:if test="${not empty report.doctorComments}">
                                <div class="mt-3 p-3" style="background:rgba(59,130,246,0.05); border-left:4px solid #3b82f6; border-radius:4px;">
                                    <h4 style="margin:0 0 0.5rem 0; font-size:0.9rem;">Doctor's Findings:</h4>
                                    <p style="margin:0; font-size:0.95rem;">${report.doctorComments}</p>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty report.filePath}">
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}${report.filePath}" target="_blank" class="btn btn-primary">
                                        View Attached Document 📎
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card text-center">
                        <p class="muted">Report not found.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
</body>
</html>
