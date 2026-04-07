<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "doctors");
    request.setAttribute("pageTitle", "Pending Approvals");
    request.setAttribute("pageSubtitle", "Review doctors waiting to join the hospital");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Approvals · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-outline btn-sm">← Back to Doctors</a>
            </div>

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">Applications Under Review</div>
                        <div class="section-subtitle">Awaiting credential verification</div>
                    </div>
                </div>

                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Contact</th>
                            <th>Specialty</th>
                            <th>License</th>
                            <th>Status/Account</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty doctors}">
                                <c:forEach var="doc" items="${doctors}">
                                    <tr>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:0.75rem;">
                                                <div style="width:36px;height:36px;border-radius:50%;background:#fbbf24;display:flex;align-items:center;justify-content:center;font-weight:600;font-size:14px;color:#fff;">${doc.user.fullName.substring(0,1)}</div>
                                                <div>
                                                    <div style="font-weight:600;">Dr. ${doc.user.fullName}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="text-sm">${doc.user.email}</div>
                                        </td>
                                        <td>${doc.specialty}</td>
                                        <td class="muted">${doc.licenseNumber}</td>
                                        <td>
                                            <span class="chip-warning">⏳ Pending</span>
                                        </td>
                                        <td class="text-right">
                                            <div class="table-actions" style="display:flex; justify-content:flex-end; gap:0.5rem;">
                                                <form action="${pageContext.request.contextPath}/admin/doctors/${doc.id}/approve" method="post" style="margin:0;">
                                                    <button type="submit" class="btn btn-primary btn-sm">Approve</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/doctors/${doc.id}/reject" method="post" style="margin:0;">
                                                    <button type="submit" class="btn btn-outline btn-sm" onclick="return confirm('Reject and permanently delete this application?')" style="border-color:#ef4444;color:#ef4444;">Reject</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="muted text-center" style="padding: 3rem;">
                                        <div style="font-size:2.5rem; opacity:0.5; margin-bottom:1rem;">✅</div>
                                        No pending applications. All caught up!
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
