<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "profile");
    request.setAttribute("pageTitle", "My Profile");
    request.setAttribute("pageSubtitle", "Update your reception desk profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <div class="card" style="max-width:600px;">
                <div class="section-title">Profile Information</div>
                <form action="${pageContext.request.contextPath}/reception/profile/update" method="post" class="form-grid mt-3">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" class="form-control" value="${user.email}" disabled style="opacity:0.6;">
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" class="form-control" value="${user.phone}">
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
