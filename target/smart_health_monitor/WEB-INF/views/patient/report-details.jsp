<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Report Details");
    request.setAttribute("pageSubtitle", "In-depth review of your medical record");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report Details · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=5">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/patient/reports" class="btn btn-outline btn-sm">← Back to Records</a>
            </div>

            <c:choose>
                <c:when test="${report != null}">
                    <div class="card">
                        <div class="card-header border-bottom pb-4 mb-4">
                            <div>
                                <h1 class="section-title" style="font-size:1.75rem;">${report.title}</h1>
                                <div class="muted mt-1">Recorded on: ${report.createdAt.toString().replace('T', ' ').substring(0, 16)}</div>
                            </div>
                            <c:if test="${not empty report.filePath}">
                                <a href="${pageContext.request.contextPath}${report.filePath}" target="_blank" class="btn btn-primary">
                                    <svg class="nav-icon" style="width:18px; height:18px; margin-right:0.5rem;" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                                    Review Document
                                </a>
                            </c:if>
                        </div>

                        <div class="grid grid-2 mt-4" style="gap:2rem;">
                            <div>
                                <h3 style="font-size:1.1rem; margin-bottom:0.75rem; color:var(--text-main);">Clinical Context</h3>
                                <p class="muted" style="line-height:1.7; font-size:1rem;">
                                    ${not empty report.description ? report.description : 'No additional context or description was provided for this clinical record.'}
                                </p>
                            </div>
                            <div>
                                <h3 style="font-size:1.1rem; margin-bottom:0.75rem; color:var(--text-main);">Summary Findings</h3>
                                <div style="background:var(--bg-main); padding:1.5rem; border-radius:12px; border:1px solid var(--border); line-height:1.8; white-space:pre-wrap; font-size:0.95rem; color:var(--text-main);">
                                    ${report.results}
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty report.filePath}">
                            <div class="mt-8 pt-6 border-top">
                                <h3 style="font-size:1.1rem; margin-bottom:1.25rem;">Attached Document Preview</h3>
                                <c:choose>
                                    <c:when test="${report.filePath.endsWith('.pdf')}">
                                        <embed src="${pageContext.request.contextPath}${report.filePath}" type="application/pdf" width="100%" height="600px" style="border-radius:12px; border:1px solid var(--border);" />
                                    </c:when>
                                    <c:otherwise>
                                        <div style="text-align:center; background:#f1f5f9; padding:2rem; border-radius:12px;">
                                            <img src="${pageContext.request.contextPath}${report.filePath}" style="max-width:100%; border-radius:8px; box-shadow:var(--shadow-md);" alt="Medical Report Image" />
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card" style="text-align:center; padding:4rem 2rem;">
                        <h2 class="section-title">Report Not Found</h2>
                        <p class="muted">The requested medical record could not be located or you don't have permission to view it.</p>
                        <a href="${pageContext.request.contextPath}/patient/reports" class="btn btn-primary mt-4">Return to Reports</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=5"></script>
</body>
</html>
