<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "doctors");
    request.setAttribute("pageTitle", "Doctor Profile");
    request.setAttribute("pageSubtitle", "View and manage clinical staff details");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Profile · Smart Health Monitor</title>
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
                <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-outline btn-sm">← Back to Doctors List</a>
            </div>

            <c:choose>
                <c:when test="${not empty doctor}">
                    <div class="grid grid-2">
                        <%-- Profile Status Card --%>
                        <div class="card">
                            <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                                <div style="display:flex; align-items:center; gap:1.5rem;">
                                    <div style="width:72px; height:72px; border-radius:50%; background:linear-gradient(135deg,#3b82f6,#06b6d4); display:flex; align-items:center; justify-content:center; font-size:2rem; color:#fff; font-weight:700;">
                                        ${doctor.user.fullName.substring(0,1)}
                                    </div>
                                    <div>
                                        <h2 style="font-size:1.5rem; margin:0 0 0.25rem 0;">Dr. ${doctor.user.fullName}</h2>
                                        <div class="muted">${doctor.specialty} · ${doctor.department != null ? doctor.department.name : 'No Department'}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">System Account ID</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${doctor.user.id}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Email</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${doctor.user.email}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Status</span>
                                        <span class="stat-value" style="font-size:0.95rem;">
                                            <c:choose>
                                                <c:when test="${!doctor.approved}"><span class="chip-warning">Pending</span></c:when>
                                                <c:when test="${doctor.status == 'ACTIVE'}"><span class="chip">Active</span></c:when>
                                                <c:otherwise><span class="chip-danger">${doctor.status}</span></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Professional Credentials Card --%>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">Credentials</div>
                                    <div class="section-subtitle">Verified professional qualifications</div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">License Number</span>
                                        <span class="stat-value" style="font-size:0.95rem;font-family:monospace;">${doctor.licenseNumber}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Specialty</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${doctor.specialty}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Experience</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${doctor.experience != null ? doctor.experience.toString().concat(' years') : 'Not provided'}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Contact Phone</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${doctor.phone != null ? doctor.phone : 'Not provided'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Danger Zone --%>
                    <div class="card mt-4" style="border-width:0; box-shadow: 0 0 0 1px rgba(239,68,68,0.2); background: rgba(239,68,68,0.02);">
                        <div class="card-header" style="border-bottom-color: rgba(239,68,68,0.1);">
                            <div>
                                <div class="section-title" style="color: #ef4444;">Danger Zone</div>
                                <div class="section-subtitle text-xs" style="color: rgba(239,68,68,0.7);">Administrative overrides</div>
                            </div>
                        </div>
                        <div class="mt-3" style="display:flex; gap:1rem; flex-wrap:wrap;">
                            <c:if test="${doctor.approved}">
                                <a href="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/toggle" class="btn btn-outline" style="border-color:#f59e0b; color:#f59e0b;" onclick="return confirm('Suspend/Activate this Doctor account?')">
                                    Toggle Active Status (Current: ${doctor.status})
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/admin/doctors/${doctor.id}/delete" class="btn btn-outline" style="border-color:#ef4444; color:#ef4444;" onclick="return confirm('Permanently delete this doctor? This removes their account entirely.')">
                                Delete Doctor Account
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card text-center" style="padding: 4rem 2rem;">
                        <span style="font-size:3rem;opacity:0.5;">🚫</span>
                        <h2 class="mt-2 text-xl">Doctor Not Found</h2>
                        <div class="muted">The doctor ID requested does not exist in the system.</div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
