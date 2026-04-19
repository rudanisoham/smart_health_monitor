<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "dashboard");
    request.setAttribute("pageTitle", "Medical Dashboard");
    request.setAttribute("pageSubtitle", "Overview of medicines, reports and patient activity");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medical Dashboard · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <div class="grid grid-4" style="margin-bottom:2rem;">
                <div class="card">
                    <div class="card-title">Total Patients</div>
                    <div class="card-value">${totalPatients}</div>
                    <div class="muted mt-1">Registered</div>
                </div>
                <div class="card">
                    <div class="card-title">Medicines</div>
                    <div class="card-value" style="color:#3b82f6;">${totalMedicines}</div>
                    <div class="muted mt-1">In inventory</div>
                </div>
                <div class="card">
                    <div class="card-title">Total Reports</div>
                    <div class="card-value" style="color:#10b981;">${totalReports}</div>
                    <div class="muted mt-1">All time</div>
                </div>
                <div class="card">
                    <div class="card-title">Pending Review</div>
                    <div class="card-value" style="color:#f59e0b;">${pendingReports}</div>
                    <div class="muted mt-1">Reports awaiting doctor</div>
                </div>
            </div>

            <div class="grid grid-2">
                <div class="card">
                    <div class="card-header">
                        <div><div class="section-title">Quick Actions</div></div>
                    </div>
                    <div style="display:flex;flex-direction:column;gap:0.5rem;margin-top:1rem;">
                        <a href="${pageContext.request.contextPath}/medical/patients" class="btn btn-outline" style="justify-content:flex-start;">🔍 Search Patient</a>
                        <a href="${pageContext.request.contextPath}/medical/medicines/add" class="btn btn-outline" style="justify-content:flex-start;">💊 Add Medicine</a>
                        <a href="${pageContext.request.contextPath}/medical/reports/upload" class="btn btn-outline" style="justify-content:flex-start;">📁 Upload Report</a>
                        <a href="${pageContext.request.contextPath}/medical/medicines" class="btn btn-outline" style="justify-content:flex-start;">📦 View Inventory</a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div><div class="section-title">Recent Reports</div></div>
                        <a href="${pageContext.request.contextPath}/medical/reports" class="btn btn-outline btn-sm">View all</a>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead><tr><th>Patient</th><th>Title</th><th>Status</th></tr></thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentReports}">
                                    <c:forEach var="r" items="${recentReports}">
                                        <tr>
                                            <td>${r.patient.user.fullName}</td>
                                            <td>${r.title}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                    <c:when test="${r.status == 'REVIEWED'}"><span class="chip">Reviewed</span></c:when>
                                                    <c:otherwise><span class="chip-neutral">${r.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="3" class="muted" style="text-align:center;padding:1.5rem;">No reports yet.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
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
