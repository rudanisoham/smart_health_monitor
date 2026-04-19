<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "reviews");
    request.setAttribute("pageTitle", "Doctor Reviews");
    request.setAttribute("pageSubtitle", "Monitor patient feedback and ratings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Reviews · Smart Health Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .star-rating { color: #f59e0b; font-size: 1rem; letter-spacing: 1px; }
        .comment-cell { max-width: 300px; white-space: normal; line-height: 1.4; color: #475569; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div class="card">
                <div class="section-title">All Patient Reviews <c:if test="${not empty reviews}">(${reviews.size()})</c:if></div>
                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Rating</th>
                            <th>Comment</th>
                            <th>Date</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="rev" items="${reviews}">
                                    <tr>
                                        <td style="font-weight:600;">${rev.patient.user.fullName}</td>
                                        <td>Dr. ${rev.doctor.user.fullName}</td>
                                        <td class="star-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                ${rev.rating >= i ? '★' : '☆'}
                                            </c:forEach>
                                            <span style="color:#64748b; font-size:0.8rem; margin-left:0.25rem;">(${rev.rating})</span>
                                        </td>
                                        <td class="comment-cell">${rev.comment}</td>
                                        <td class="muted" style="font-size:0.875rem;">
                                            <c:out value="${rev.createdAt.toString().substring(0, 10)}" default="N/A" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align:center; padding:3rem;" class="muted">
                                        <div style="font-size:3rem; margin-bottom:1rem; opacity:0.2;">💬</div>
                                        No reviews submitted yet.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>

                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
