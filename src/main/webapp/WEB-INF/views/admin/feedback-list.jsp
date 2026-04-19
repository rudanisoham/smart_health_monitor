<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "feedback");
    request.setAttribute("pageTitle", "Feedback & Inquiries");
    request.setAttribute("pageSubtitle", "Manage messages from visitors and patients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback · Smart Health Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div class="chip" style="margin-bottom: 1.5rem; width: 100%; justify-content: center; padding: 1rem;">
                    <span style="font-size: 1rem;">✅ ${success}</span>
                </div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Messages</div>
                        <div class="section-subtitle">Ordered by most recent</div>
                    </div>
                </div>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Status</th>
                                <th>Sender</th>
                                <th>Subject</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="msg" items="${messages}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${msg.status == 'PENDING'}">
                                                <span class="chip-warning">PENDING</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="chip">REPLIED</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="font-weight: 700;">${msg.fullName}</div>
                                        <div class="muted" style="font-size: 0.8rem;">${msg.email}</div>
                                    </td>
                                    <td>${msg.subject}</td>
                                    <td class="muted">${msg.createdAt.toString().replace('T',' ').substring(0,16)}</td>
                                    <td>
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="<%= request.getContextPath() %>/admin/feedback/${msg.id}/view" class="btn btn-outline btn-sm">
                                                ${msg.status == 'PENDING' ? 'Reply' : 'View'}
                                            </a>
                                            <a href="<%= request.getContextPath() %>/admin/feedback/${msg.id}/delete" class="btn btn-icon btn-sm" onclick="return confirm('Delete this message?')">
                                                🗑️
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty messages}">
                                <tr>
                                    <td colspan="5" class="muted text-center" style="padding: 3rem;">No feedback messages found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
</body>
</html>
