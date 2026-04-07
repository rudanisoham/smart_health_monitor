<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "notifications");
    request.setAttribute("pageTitle", "Notifications");
    request.setAttribute("pageSubtitle", "Health alerts and system reminders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Notifications · Smart Health Monitor</title>
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
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Notifications</div>
                        <div class="section-subtitle">${unreadCount != null ? unreadCount : 0} unread</div>
                    </div>
                    <c:if test="${not empty notifications}">
                        <form action="${pageContext.request.contextPath}/patient/notifications/mark-read" method="post">
                            <button class="btn btn-outline btn-sm" type="submit">Mark all as read</button>
                        </form>
                    </c:if>
                </div>

                <div class="timeline mt-3">
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <c:forEach var="notif" items="${notifications}">
                                <div class="timeline-item" style="${notif.read ? 'opacity:0.6;' : ''}">
                            <c:set var="bulletColor" value="#38bdf8"/>
                                    <c:if test="${notif.type == 'ALERT'}"><c:set var="bulletColor" value="#f87171"/></c:if>
                                    <c:if test="${notif.type == 'WARNING'}"><c:set var="bulletColor" value="#fbbf24"/></c:if>
                                    <div class="timeline-bullet" style="background:${bulletColor};"></div>
                                    <div class="timeline-content">
                                        <div style="display:flex;align-items:center;gap:0.5rem;">
                                            <strong>${notif.title}</strong>
                                            <c:if test="${!notif.read}"><span class="chip" style="font-size:0.65rem;padding:0.15rem 0.4rem;">New</span></c:if>
                                            <c:choose>
                                                <c:when test="${notif.type == 'ALERT'}"><span class="chip-danger" style="font-size:0.65rem;">Alert</span></c:when>
                                                <c:when test="${notif.type == 'WARNING'}"><span class="chip-warning" style="font-size:0.65rem;">Warning</span></c:when>
                                                <c:otherwise><span class="chip-neutral" style="font-size:0.65rem;">Info</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="timeline-meta">${notif.message}</div>
                                        <div class="timeline-meta" style="font-size:0.75rem;margin-top:0.25rem;">
                                            ${notif.createdAt.toString().replace('T', ' ').substring(0, 16)}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align:center;padding:2rem;" class="muted">
                                No notifications yet. You're all caught up!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
