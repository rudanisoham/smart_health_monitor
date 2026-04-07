<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "alerts");
    request.setAttribute("pageTitle", "Alerts & Notifications");
    request.setAttribute("pageSubtitle", "Clinical updates, system alerts and messages");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Alerts · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .notification-card { border-left: 4px solid var(--border); padding: 1.25rem 1.5rem; display: flex; gap: 1rem; align-items: flex-start; margin-bottom: 0.75rem; background: var(--card-bg); border-radius: 0 8px 8px 0; }
        .notification-card.unread { border-left-color: #3b82f6; background: rgba(59,130,246,0.04); }
        .notification-card.type-URGENT { border-left-color: #ef4444; }
        .notification-card.type-WARNING { border-left-color: #f59e0b; }
        .notification-icon { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; flex-shrink: 0; background: rgba(255,255,255,0.05); }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">Your Alerts</div>
                        <div class="section-subtitle">
                             <c:choose>
                                 <c:when test="${unreadCount > 0}"><span style="color:#3b82f6;font-weight:600;">${unreadCount} unread emails/alerts</span></c:when>
                                 <c:otherwise>All caught up!</c:otherwise>
                             </c:choose>
                        </div>
                    </div>
                    <c:if test="${unreadCount > 0}">
                        <form action="${pageContext.request.contextPath}/doctor/alerts/mark-read" method="post">
                            <button class="btn btn-outline btn-sm" type="submit">Mark all as read</button>
                        </form>
                    </c:if>
                </div>
                <div class="mt-3">
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <c:forEach var="n" items="${notifications}">
                                <div class="notification-card ${n.read ? '' : 'unread'} ${'type-'.concat(n.type)}">
                                    <div class="notification-icon">
                                        <c:choose>
                                            <c:when test="${n.type == 'URGENT'}">🚨</c:when>
                                            <c:when test="${n.type == 'WARNING'}">⚠️</c:when>
                                            <c:when test="${n.type == 'SYSTEM'}">⚙️</c:when>
                                            <c:otherwise>🔔</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="flex:1;">
                                        <div style="display:flex;justify-content:space-between;margin-bottom:0.25rem;">
                                            <div style="font-weight:600;font-size:1rem;color:${n.read ? 'var(--text-muted)' : 'inherit'};">${n.title}</div>
                                            <div class="muted text-xs">${n.createdAt.toString().replace('T',' ').substring(0,16)}</div>
                                        </div>
                                        <div style="color:var(--text-muted);font-size:0.95rem;line-height:1.5;">${n.message}</div>
                                    </div>
                                    <c:if test="${!n.read}">
                                        <div style="width:8px;height:8px;background:#3b82f6;border-radius:50%;margin-top:0.5rem;"></div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="muted" style="text-align:center;padding:3rem;">
                                <div style="font-size:2.5rem;margin-bottom:1rem;opacity:0.5;">📭</div>
                                You have no alerts or notifications.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
