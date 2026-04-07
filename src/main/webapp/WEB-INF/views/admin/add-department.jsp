<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "departments");
    request.setAttribute("pageTitle", "Create Department");
    request.setAttribute("pageSubtitle", "Add a new specialized unit to the hospital network");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Department · Smart Health Monitor</title>
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
                <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-outline btn-sm">← Back to Departments</a>
            </div>

            <form action="${pageContext.request.contextPath}/admin/departments/add" method="post">
                <div class="card" style="max-width: 800px; margin: 0 auto;">
                    <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                        <div>
                            <div class="section-title">Department Details</div>
                            <div class="section-subtitle">Unit operations and capacity constraints</div>
                        </div>
                    </div>

                    <div style="padding: 1.5rem 0;">
                        <div class="form-grid form-2">
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label for="name">Department Name</label>
                                <input type="text" id="name" name="name" class="form-control" required placeholder="Cardiology Wing">
                            </div>
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label for="code">Department Code</label>
                                <input type="text" id="code" name="code" class="form-control" required placeholder="CARD-WT">
                            </div>
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label for="description">Functional Description</label>
                                <textarea id="description" name="description" class="form-control" rows="4" placeholder="Description of services rendered in this department..."></textarea>
                            </div>
                            <div class="form-group">
                                <label for="targetCapacity">Target Capacity Limit</label>
                                <input type="number" id="targetCapacity" name="targetCapacity" class="form-control" min="1" max="1000" required placeholder="50">
                                <span class="text-xs muted mt-1">Bed count / concurrent active case limit.</span>
                            </div>
                        </div>
                    </div>

                    <div style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem; display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn btn-primary px-4">Create Department</button>
                    </div>
                </div>
            </form>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
