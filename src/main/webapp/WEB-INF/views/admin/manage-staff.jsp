<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Object roleObj = request.getAttribute("roleKey");
    String roleKey = (roleObj != null) ? roleObj.toString() : "";
    String activePage = roleKey.equalsIgnoreCase("RECEPTIONIST") ? "receptionists" : "medical-staff";
    request.setAttribute("activePage", activePage);
    request.setAttribute("pageTitle", "Staff Management");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${roleTitle} Management · Smart Health Monitor</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>
        <div class="admin-content">
            
            <div class="card-header">
                <div>
                    <h2 class="section-title">Manage ${roleTitle}</h2>
                    <p class="section-subtitle">System users with ${roleTitle} administrative privileges</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/staff/add?role=${roleKey}" class="btn btn-primary">
                    <span>+</span> Add New ${roleTitle.substring(0, roleTitle.length()-1)}
                </a>
            </div>

            <div class="card mt-3">
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Phone</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty staff}">
                                <c:forEach var="u" items="${staff}">
                                    <tr>
                                        <td style="font-weight:600;">${u.fullName}</td>
                                        <td>${u.email}</td>
                                        <td>${u.phone != null ? u.phone : '<span class="muted">—</span>'}</td>
                                        <td class="muted">${u.lastLogin != null ? u.lastLogin.toString().replace('T',' ').substring(0,16) : 'Never'}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/staff/${u.id}/delete?role=${roleKey}" 
                                               class="btn btn-icon" title="Delete Account" 
                                               onclick="return confirm('Permanently delete this ${roleKey}?')">
                                                <svg class="nav-icon" style="width:16px;height:16px;stroke:#ef4444;" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align:center; padding:3rem;" class="muted">No ${roleTitle.toLowerCase()} registered in the system.</td>
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
