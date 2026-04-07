<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Health Reports");
    request.setAttribute("pageSubtitle", "Overview of your appointments, prescriptions and vitals");
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
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1.5rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;margin-bottom:1.5rem;">${error}</div>
            </c:if>
            <!-- Summary Cards -->
            <div class="grid grid-4" style="margin-bottom:1.5rem;">
                <div class="card">
                    <div class="card-title">Total Medical Reports</div>
                    <div class="card-value">${reports != null ? reports.size() : 0}</div>
                </div>
            </div>

            <!-- Medical Reports Section -->
            <div class="grid grid-2" style="margin-bottom: 2rem;">
                <div class="card">
                    <div class="section-title">Add New Report</div>
                    <div class="section-subtitle mt-1">Upload or record results from your medical tests</div>
                    <form action="<%= request.getContextPath() %>/patient/reports/add" method="post" enctype="multipart/form-data" class="form-grid mt-3">
                        <div class="form-group">
                            <label for="reportTitle">Report Title / Test Name</label>
                            <input id="reportTitle" name="title" class="form-control" type="text" placeholder="e.g. Blood Test, Chest X-Ray" required>
                        </div>
                        <div class="form-group">
                            <label for="reportDesc">Description (Optional)</label>
                            <input id="reportDesc" name="description" class="form-control" type="text" placeholder="Reason for test or further details">
                        </div>
                        <div class="form-group">
                            <label for="reportResults">Test Results / Findings</label>
                            <textarea id="reportResults" name="results" class="form-control" rows="4" placeholder="Enter findings, conclusions, or paste text report here..." required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="reportFile">Attach File (Optional - PDF, Image)</label>
                            <input id="reportFile" name="reportFile" class="form-control" type="file" accept=".pdf,image/*">
                            <span class="muted" style="font-size:0.75rem;">Max file size: 5MB</span>
                        </div>
                        <div class="mt-2 text-right">
                            <button type="submit" class="btn btn-primary">Save Report</button>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Reports History</div>
                            <div class="section-subtitle">Your self-added medical documentation</div>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Title</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty reports}">
                                    <c:forEach var="rep" items="${reports}">
                                        <tr>
                                            <td class="muted">${rep.createdAt.toString().replace('T', ' ').substring(0, 10)}</td>
                                            <td style="font-weight:600;">
                                                ${rep.title}
                                                <c:if test="${not empty rep.filePath}">
                                                    <span style="font-size:0.7rem; color:var(--success); margin-left:0.5rem; border:1px solid var(--success); padding:0.1rem 0.4rem; border-radius:4px;">📎 Attachment</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/patient/reports/${rep.id}">View Details</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="3" class="muted" style="text-align:center;padding:1.5rem;">No reports added yet.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=5"></script>
</body>
</html>
