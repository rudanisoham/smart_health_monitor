<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "settings");
    request.setAttribute("pageTitle", "Admin Settings");
    request.setAttribute("pageSubtitle", "System configurations and profile");
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
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Admin Profile</div>
                            <div class="section-subtitle">Manage your personal credentials</div>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/settings/update" method="post" class="mt-3">
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" class="form-control" value="${admin.email}" readonly style="opacity:0.7;">
                            <span class="text-xs muted mt-1">Superuser emails cannot be changed.</span>
                        </div>
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-control" value="${admin.fullName}" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Contact Number</label>
                            <input type="text" id="phone" name="phone" class="form-control" value="${admin.phone != null ? admin.phone : ''}">
                        </div>

                        <div class="mt-4 pt-3 border-t" style="border-color: rgba(255,255,255,0.06);">
                            <div class="section-subtitle mb-2" style="color:#ef4444;">Change Password (Optional)</div>
                            <div class="form-group">
                                <label for="currentPassword">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" placeholder="Required if changing password">
                            </div>
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="••••••••">
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                        <div>
                            <div class="section-title">System Status</div>
                            <div class="section-subtitle">Realtime health monitor</div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <div style="display:flex; justify-content:space-between; margin-bottom:1rem;">
                            <span class="muted">Database Connection</span>
                            <span class="chip" style="font-size:0.75rem;">Healthy</span>
                        </div>
                        <div style="display:flex; justify-content:space-between; margin-bottom:1rem;">
                            <span class="muted">Security Logger</span>
                            <span class="chip" style="font-size:0.75rem;">Active</span>
                        </div>
                        <div style="display:flex; justify-content:space-between; margin-bottom:1rem;">
                            <span class="muted">Timezone</span>
                            <span class="chip-neutral" style="font-size:0.75rem;">Asia/Kolkata</span>
                        </div>
                        <div style="display:flex; justify-content:space-between; margin-bottom:1rem;">
                            <span class="muted">App Version</span>
                            <span class="chip-neutral" style="font-size:0.75rem;">v1.3.0</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
