<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "profile");
    request.setAttribute("pageTitle", "Profile");
    request.setAttribute("pageSubtitle", "Personal info, emergency contacts and account security");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Profile · Smart Health Monitor</title>
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

            <div class="grid grid-2">
                <!-- Personal Information -->
                <div class="card">
                    <div class="section-title">Personal Information</div>
                    <p class="section-subtitle mt-1">Update your basic details</p>

                    <form action="${pageContext.request.contextPath}/patient/profile/update" method="post" class="form-grid form-2 mt-3">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input id="fullName" name="fullName" class="form-control" type="text"
                                   value="${patient != null ? patient.user.fullName : ''}" required minlength="2">
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input id="phone" name="phone" class="form-control" type="tel"
                                   value="${patient != null ? patient.phone : ''}" placeholder="+91 98765 43210" pattern="^\+?[0-9]{10,15}$">
                        </div>
                        <div class="form-group">
                            <label for="bloodGroup">Blood Group</label>
                            <select id="bloodGroup" name="bloodGroup" class="form-select">
                                <option value="">-- Select --</option>
                                <c:forEach var="bg" items="${['A+','A-','B+','B-','AB+','AB-','O+','O-']}">
                                    <option value="${bg}" ${patient != null and patient.bloodGroup == bg ? 'selected' : ''}>${bg}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="emergencyEmail">Emergency Email</label>
                            <input id="emergencyEmail" name="emergencyEmail" class="form-control" type="email"
                                   value="${patient != null ? patient.emergencyEmail : ''}" placeholder="emergency@example.com">
                        </div>
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="address">Address</label>
                            <textarea id="address" name="address" class="form-control" rows="2"
                                      placeholder="Your current address"><c:if test="${patient != null}">${patient.address}</c:if></textarea>
                        </div>
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <div class="flex justify-between items-center">
                                <span class="text-xs text-muted">Email: <strong>${patient != null ? patient.user.email : ''}</strong> (cannot be changed)</span>
                                <button class="btn btn-primary btn-sm" type="submit">Save Profile</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Profile Info Summary -->
                <div class="card">
                    <div class="section-title">Health Profile</div>
                    <p class="section-subtitle mt-1">Your medical identity card</p>
                    <div class="mt-3">
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Full Name</span>
                                <span class="stat-value" style="font-size:1rem;">${patient != null ? patient.user.fullName : '—'}</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Email</span>
                                <span class="stat-value" style="font-size:1rem;">${patient != null ? patient.user.email : '—'}</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Blood Group</span>
                                <span class="stat-value" style="font-size:1rem;">
                                    <c:choose>
                                        <c:when test="${patient != null and patient.bloodGroup != null}"><span class="chip">${patient.bloodGroup}</span></c:when>
                                        <c:otherwise>Not set</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Phone</span>
                                <span class="stat-value" style="font-size:1rem;">${patient != null and patient.phone != null ? patient.phone : '—'}</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Emergency Email</span>
                                <span class="stat-value" style="font-size:1rem;">${patient != null and patient.emergencyEmail != null ? patient.emergencyEmail : '—'}</span>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Address</span>
                                <span class="stat-value" style="font-size:1rem;">${patient != null and patient.address != null ? patient.address : '—'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Appearance -->
            <div class="card mt-4">
                <div class="section-title">Appearance</div>
                <p class="section-subtitle mt-1">Choose your preferred theme</p>
                <div class="mt-3 filter-group">
                    <button type="button" class="btn btn-outline btn-sm" data-theme-mode="dark">Dark theme</button>
                    <button type="button" class="btn btn-outline btn-sm" data-theme-mode="light">Light theme</button>
                </div>
                <div class="mt-2 text-xs text-muted">Saved on this device for future visits.</div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
