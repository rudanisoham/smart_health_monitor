<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "upload");
    request.setAttribute("pageTitle", "Upload Report");
    request.setAttribute("pageSubtitle", "Upload a medical report and link it to a patient");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload Report · Smart Health Monitor</title>
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

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/medical/reports/upload" method="post" enctype="multipart/form-data">
                <div class="card" style="max-width:800px;margin:0 auto;">
                    <div style="border-bottom:1px solid var(--border);padding-bottom:1.25rem;margin-bottom:1.5rem;">
                        <div class="section-title">Report Details</div>
                        <div class="section-subtitle">Fill in report information and attach file</div>
                    </div>

                    <div class="form-grid form-2">
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="patientId">Select Patient <span style="color:#ef4444;">*</span></label>
                            <select id="patientId" name="patientId" class="form-select" required>
                                <option value="">-- Choose Patient --</option>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}" ${param.patientId == p.id.toString() ? 'selected' : ''}>${p.user.fullName} (#${p.id}) — ${p.user.email}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="title">Report Title <span style="color:#ef4444;">*</span></label>
                            <input type="text" id="title" name="title" class="form-control" required placeholder="e.g. Complete Blood Count, Chest X-Ray">
                        </div>
                        <div class="form-group">
                            <label for="type">Report Type</label>
                            <select id="type" name="type" class="form-select">
                                <option value="">-- Select Type --</option>
                                <option value="BLOOD_TEST">Blood Test</option>
                                <option value="X_RAY">X-Ray</option>
                                <option value="MRI">MRI</option>
                                <option value="ECG">ECG</option>
                                <option value="CT_SCAN">CT Scan</option>
                                <option value="URINE_TEST">Urine Test</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="reportFile">Attach File (PDF/Image)</label>
                            <input type="file" id="reportFile" name="reportFile" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                        </div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="2" placeholder="Brief description of the report..."></textarea>
                        </div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="results">Results / Findings</label>
                            <textarea id="results" name="results" class="form-control" rows="4" placeholder="Enter test results, findings, or observations..."></textarea>
                        </div>
                    </div>

                    <div style="border-top:1px solid var(--border);padding-top:1.5rem;margin-top:1.5rem;display:flex;justify-content:flex-end;gap:1rem;">
                        <a href="${pageContext.request.contextPath}/medical/reports" class="btn btn-outline">Cancel</a>
                        <button type="submit" class="btn btn-primary">Upload Report</button>
                    </div>
                </div>
            </form>
        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
