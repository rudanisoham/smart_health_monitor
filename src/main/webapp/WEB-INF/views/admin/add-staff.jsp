<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", request.getParameter("role").equals("RECEPTIONIST") ? "receptionists" : "medical-staff");
    request.setAttribute("pageTitle", "Register New Staff Member");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add ${role} · Smart Health Monitor</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>
        <div class="admin-content">
            
            <div style="margin-bottom:1.5rem;">
                <button onclick="history.back()" class="btn btn-outline btn-sm">← Back</button>
            </div>

            <div class="card" style="max-width: 600px;">
                <div class="card-header pb-4 border-bottom">
                    <div>
                        <h2 class="section-title">Account Registration</h2>
                        <p class="section-subtitle">Create a new system account for ${role}</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/staff/add" method="post" class="mt-4">
                    <input type="hidden" name="role" value="${role}">
                    
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" class="form-control" required placeholder="e.g. John Doe">
                    </div>

                    <div class="form-group mt-2">
                        <label>Email Address</label>
                        <input type="email" name="email" class="form-control" required placeholder="staff@example.com">
                    </div>

                    <div class="form-group mt-2">
                        <label>Initial Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="••••••••">
                    </div>

                    <div class="form-group mt-2">
                        <label>Phone Number (Optional)</label>
                        <input type="text" name="phone" class="form-control" placeholder="+1 234 567 890">
                    </div>

                    <div class="mt-4 pt-4 border-top">
                        <button type="submit" class="btn btn-primary w-full">Create ${role} Account</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
