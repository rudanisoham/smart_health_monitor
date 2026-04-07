<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "settings");
    request.setAttribute("pageTitle", "Settings");
    request.setAttribute("pageSubtitle", "Manage your account security");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Settings · Smart Health Monitor</title>
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
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="card" style="max-width: 600px;">
                <div class="section-title">Change Password</div>
                <p class="section-subtitle mt-1">Keep your account secure with a strong password</p>

                <form action="${pageContext.request.contextPath}/patient/settings/update" method="post" class="form-grid mt-3">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input id="currentPassword" name="currentPassword" class="form-control" type="password" placeholder="••••••••" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input id="newPassword" name="newPassword" class="form-control" type="password" placeholder="••••••••" minlength="6" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input id="confirmPassword" class="form-control" type="password" placeholder="••••••••" required>
                    </div>
                    <div class="form-group">
                        <button class="btn btn-primary btn-sm" type="submit"
                                onclick="if(document.getElementById('newPassword').value !== document.getElementById('confirmPassword').value){alert('Passwords do not match!');return false;}">
                            Update Password
                        </button>
                    </div>
                </form>
            </div>

            <div class="card mt-4" style="max-width: 600px;">
                <div class="section-title">Danger Zone</div>
                <p class="section-subtitle mt-1">Irreversible account actions</p>
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline btn-sm"
                       onclick="return confirm('Are you sure you want to logout?')">
                        Logout from Account
                    </a>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
