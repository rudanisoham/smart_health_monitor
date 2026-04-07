<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "profile");
    request.setAttribute("pageTitle", "My Profile");
    request.setAttribute("pageSubtitle", "Manage your personal and professional details");
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
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/doctor/profile/update" method="post">
                <div class="card" style="max-width: 800px; margin: 0 auto;">
                    <div class="card-header" style="border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                        <div style="display:flex; align-items:center; gap:1.5rem;">
                            <div style="width:72px; height:72px; border-radius:50%; background:linear-gradient(135deg,#3b82f6,#06b6d4); display:flex; align-items:center; justify-content:center; font-size:2rem; color:#fff; font-weight:700; text-transform:uppercase;">
                                ${doctor.user.fullName.substring(0,1)}
                            </div>
                            <div>
                                <h2 style="font-size:1.5rem; margin:0 0 0.25rem 0;">Dr. ${doctor.user.fullName}</h2>
                                <div class="muted">${doctor.specialty} · ${doctor.department != null ? doctor.department.name : 'No Department'}</div>
                                <div class="mt-1">
                                    <c:choose>
                                        <c:when test="${doctor.approved}"><span class="chip" style="font-size:0.7rem;">Verified Practitioner</span></c:when>
                                        <c:otherwise><span class="chip-warning" style="font-size:0.7rem;">Pending Verification</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div style="padding: 1.5rem 0;">
                        <div class="section-title mb-3">Personal & Contact Info</div>
                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" class="form-control" value="${doctor.user.fullName}" required minlength="2">
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="${doctor.user.phone != null ? doctor.user.phone : ''}" pattern="^\+?[0-9]{10,15}$">
                                <small class="text-muted" style="font-size:0.7rem;">Format: +1234567890</small>
                            </div>
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label for="email">Email Address <span class="muted">(Login ID - cannot be changed)</span></label>
                                <input type="email" id="email" class="form-control" value="${doctor.user.email}" readonly style="opacity: 0.7; cursor: not-allowed;">
                            </div>
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label for="bio">Professional Bio</label>
                                <textarea id="bio" name="bio" class="form-control" rows="4">${doctor.bio != null ? doctor.bio : ''}</textarea>
                            </div>
                        </div>

                        <div class="section-title mb-3 mt-4" style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem;">Verified Medical Credentials</div>
                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label>Specialty</label>
                                <div class="form-control" style="background:rgba(255,255,255,0.02); color:var(--text-muted); padding:0.6rem 1rem;">${doctor.specialty}</div>
                            </div>
                            <div class="form-group">
                                <label>Medical License Number</label>
                                <div class="form-control" style="background:rgba(255,255,255,0.02); color:var(--text-muted); padding:0.6rem 1rem;">${doctor.licenseNumber}</div>
                            </div>
                            <div class="form-group">
                                <label>Years of Experience</label>
                                <div class="form-control" style="background:rgba(255,255,255,0.02); color:var(--text-muted); padding:0.6rem 1rem;">${doctor.experience != null ? doctor.experience : '0'}</div>
                            </div>
                            <div class="form-group">
                                <label>Department</label>
                                <div class="form-control" style="background:rgba(255,255,255,0.02); color:var(--text-muted); padding:0.6rem 1rem;">${doctor.department != null ? doctor.department.name : '—'}</div>
                            </div>
                        </div>
                        <p class="text-xs text-muted mt-2">Credentials are locked after registration. To modify your license or specialty, please contact the hospital administration.</p>
                    </div>

                    <div style="border-top: 1px solid rgba(255,255,255,0.06); padding-top: 1.5rem; display: flex; justify-content: flex-end;">
                        <button type="submit" class="btn btn-primary px-4">💾 Save Changes</button>
                    </div>
                </div>
            </form>
        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
