<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Clinical Report Review");
    request.setAttribute("pageSubtitle", "Diagnostic documentation review");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Report · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=5">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">
            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/doctor/patient/${patient.id}" class="btn btn-outline btn-sm">← Back to Patient Profile</a>
            </div>

            <c:choose>
                <c:when test="${report != null}">
                    <div class="card">
                        <div class="card-header border-bottom pb-4 mb-4">
                            <div>
                                <h1 class="section-title" style="font-size:1.75rem;">${report.title}</h1>
                                <div class="muted mt-1">Clinical context provided by: ${patient.user.fullName}</div>
                                <div class="muted" style="font-size:0.85rem;">Date Added: ${report.createdAt.toString().substring(0, 16).replace('T', ' ')}</div>
                            </div>
                            <c:if test="${not empty report.filePath}">
                                <a href="${pageContext.request.contextPath}${report.filePath}" target="_blank" class="btn btn-primary">
                                    <svg class="nav-icon" style="width:18px; height:18px; margin-right:0.5rem;" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                                    View Raw Document
                                </a>
                            </c:if>
                        </div>

                        <div class="grid grid-2 mt-4" style="gap:2rem;">
                            <div>
                                <h3 style="font-size:1.1rem; margin-bottom:0.75rem;">Patient Notes</h3>
                                <p class="muted" style="line-height:1.7;">
                                    ${not empty report.description ? report.description : 'The patient did not provide additional notes for this record.'}
                                </p>
                            </div>
                            <div>
                                <h3 style="font-size:1.1rem; margin-bottom:0.75rem;">Summary/Findings</h3>
                                <div style="background:var(--bg-main); padding:1.5rem; border-radius:12px; border:1px solid var(--border); line-height:1.8; white-space:pre-wrap; color:var(--text-main);">
                                    ${report.results}
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty report.filePath}">
                            <div class="mt-8 pt-6 border-top">
                                <h3 style="font-size:1.1rem; margin-bottom:1.25rem;">Diagnostic View</h3>
                                <c:choose>
                                    <c:when test="${report.filePath.endsWith('.pdf')}">
                                        <embed src="${pageContext.request.contextPath}${report.filePath}" type="application/pdf" width="100%" height="700px" style="border-radius:12px; border:1px solid var(--border);" />
                                    </c:when>
                                    <c:otherwise>
                                        <div style="text-align:center; background:#f8fafc; padding:2rem; border-radius:12px;">
                                            <img src="${pageContext.request.contextPath}${report.filePath}" style="max-width:100%; border-radius:8px; box-shadow:var(--shadow-lg);" alt="Diagnostic Image" />
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <div class="mt-8 pt-6 border-top">
                            <h3 style="font-size:1.1rem; margin-bottom:1.25rem;">Doctor's Review</h3>
                            <form action="${pageContext.request.contextPath}/doctor/reports/${report.id}/review" method="post" style="background:#f8fafc; padding: 2rem; border-radius: 12px; border: 1px solid var(--border);">
                                <div class="form-group mb-3">
                                    <label class="form-label">Status</label>
                                    <select name="status" class="form-control" style="width: auto;" required>
                                        <option value="PENDING" ${report.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                        <option value="REVIEWED" ${report.status == 'REVIEWED' ? 'selected' : ''}>Reviewed</option>
                                    </select>
                                </div>
                                <div class="form-group mb-3">
                                    <label class="form-label">Doctor's Comments</label>
                                    <textarea name="doctorComments" class="form-control" rows="4" placeholder="Add your clinical observations here...">${report.doctorComments}</textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Save Review & Notify Patient</button>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card" style="text-align:center; padding:4rem 2rem;">
                        <h2 class="section-title">Record Not Found</h2>
                        <p class="muted">The medical report detail could not be retrieved.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=5"></script>
</body>
</html>
