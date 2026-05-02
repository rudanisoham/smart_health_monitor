<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "site-content");
    request.setAttribute("pageTitle", "Site Configuration");
    request.setAttribute("pageSubtitle", "Manage project metadata, contact details and branding");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Site Content · Smart Health Monitor</title>
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

            <div class="card" style="max-width: 900px; margin: 0 auto;">
                <div class="card-header">
                    <div>
                        <div class="section-title">Site Branding & Content</div>
                        <div class="section-subtitle">Information displayed on landing page and patient portal</div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/site-content/update" method="post" class="mt-4">
                    <input type="hidden" name="id" value="${content.id}">
                    
                    <div class="form-grid form-2">
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="projectTitle">Project Title</label>
                            <input type="text" id="projectTitle" name="projectTitle" class="form-control" value="${content.projectTitle}" required>
                        </div>
                        
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="tagline">Marketing Tagline</label>
                            <input type="text" id="tagline" name="tagline" class="form-control" value="${content.tagline}" required>
                        </div>

                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="aboutDescription">About Description</label>
                            <textarea id="aboutDescription" name="aboutDescription" class="form-control" rows="5" required>${content.aboutDescription}</textarea>
                            <small class="muted">A brief overview of the system for the landing page.</small>
                        </div>

                        <div class="form-group">
                            <label for="contactEmail">Public Contact Email</label>
                            <input type="email" id="contactEmail" name="contactEmail" class="form-control" value="${content.contactEmail}" required>
                        </div>

                        <div class="form-group">
                            <label for="contactPhone">Public Phone Number</label>
                            <input type="text" id="contactPhone" name="contactPhone" class="form-control" value="${content.contactPhone}" required>
                        </div>

                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="address">Hospital Address</label>
                            <input type="text" id="address" name="address" class="form-control" value="${content.address}" required>
                        </div>
                    </div>

                    <div style="margin-top: 2rem; border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem; display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn btn-primary px-5">💾 Save System Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
