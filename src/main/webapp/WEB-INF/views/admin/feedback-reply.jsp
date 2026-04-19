<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "feedback");
    request.setAttribute("pageTitle", "Respond to Inquiry");
    request.setAttribute("pageSubtitle", "Communicate with visitors regarding their feedback");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reply Feedback · Smart Health Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <div style="margin-bottom: 2rem;">
                <a href="<%= request.getContextPath() %>/admin/feedback" class="btn btn-outline btn-sm">← Back to List</a>
            </div>

            <div class="grid grid-2">
                <div class="card">
                    <div class="section-title">Original Message</div>
                    <div class="mt-4">
                        <div class="form-group mb-4">
                            <label>Sender</label>
                            <div class="insight-text">${message.fullName} (${message.email})</div>
                        </div>
                        <div class="form-group mb-4">
                            <label>Subject</label>
                            <div class="insight-text">${message.subject}</div>
                        </div>
                        <div class="form-group mb-4">
                            <label>Content</label>
                            <div style="background: #f8fafc; padding: 1.5rem; border-radius: 12px; border-left: 4px solid var(--primary); line-height: 1.6;">
                                ${message.message}
                            </div>
                        </div>
                        <div class="muted">
                            Submitted on ${message.createdAt.toString().replace('T',' ').substring(0,16)}
                        </div>
                    </div>
                </div>

                <div class="card">
                    <c:choose>
                        <c:when test="${message.status == 'PENDING'}">
                            <div class="section-title">Compose Reply</div>
                            <form action="<%= request.getContextPath() %>/admin/feedback/${message.id}/reply" method="POST" class="mt-4">
                                <div class="form-group mb-4">
                                    <label>Response Text</label>
                                    <textarea name="reply" class="form-control" rows="8" placeholder="Type your response here..." required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary w-full">Send Response Email</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="section-title">Reply Details</div>
                            <div class="mt-4">
                                <div class="form-group mb-4">
                                    <label>Sent Response</label>
                                    <div style="background: rgba(16, 185, 129, 0.05); padding: 1.5rem; border-radius: 12px; border-left: 4px solid var(--success); line-height: 1.6;">
                                        ${message.adminReply}
                                    </div>
                                </div>
                                <div class="chip">
                                    ✅ Replied on ${message.repliedAt.toString().replace('T',' ').substring(0,16)}
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
</body>
</html>
