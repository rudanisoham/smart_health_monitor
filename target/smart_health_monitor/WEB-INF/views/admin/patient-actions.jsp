<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patient Record Profile");
    request.setAttribute("pageSubtitle", "View system data for a registered patient");
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
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-outline btn-sm">← Back to Patient List</a>
            </div>

            <c:choose>
                <c:when test="${not empty patient}">
                    <div class="grid grid-2">
                        <%-- Patient Profile Status Card --%>
                        <div class="card">
                            <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                                <div style="display:flex; align-items:center; gap:1.5rem;">
                                    <div style="width:72px; height:72px; border-radius:50%; background:linear-gradient(135deg,#0ea5e9,#3b82f6); display:flex; align-items:center; justify-content:center; font-size:2rem; color:#fff; font-weight:700;">
                                        ${patient.user.fullName.substring(0,1)}
                                    </div>
                                    <div>
                                        <h2 style="font-size:1.5rem; margin:0 0 0.25rem 0;">${patient.user.fullName}</h2>
                                        <div class="muted">Joined: ${patient.user.createdAt.toString().substring(0,10)}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">System Account ID</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.user.id}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Email</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.user.email}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Account Role</span>
                                        <span class="stat-value" style="font-size:0.95rem;"><span class="chip">Patient</span></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Patient Demographic Credentials Card --%>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">Health Demographics</div>
                                    <div class="section-subtitle">Basic medical metadata</div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Blood Group</span>
                                        <span class="stat-value" style="font-size:0.95rem;">
                                            <c:choose>
                                                <c:when test="${patient.bloodGroup != null}"><span class="chip-danger">${patient.bloodGroup}</span></c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Biological Sex</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.gender != null ? patient.gender : '—'}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Registered Phone</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.phone != null ? patient.phone : 'Not provided'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 p-3" style="background:rgba(59,130,246,0.05); border:1px solid #3b82f6; border-radius:8px; display:flex; gap:1rem; align-items:flex-start;">
                        <span style="font-size:1.5rem; margin-top:-2px;">🔒</span>
                        <div style="font-size:0.9rem; color:var(--text-muted); line-height: 1.5;">
                            <strong>HIPAA Privacy Lock:</strong> As a system administrator, you cannot view the clinical diagnostic records, issued prescriptions, or detailed vital metrics for this patient. Only assigned registered doctors can view specific Personal Health Information (PHI).
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
                        <div class="mt-3">
                            <form action="${pageContext.request.contextPath}/admin/patients/${patient.id}/delete" method="get" style="display:inline;">
                                <button type="submit" class="btn btn-outline" style="border-color:#ef4444; color:#ef4444;" onclick="return confirm('Permanently delete this patient? This completely scrubs their appointments, prescriptions, vitals, and system login account.')">
                                    Hard Delete Patient Record
                                </button>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card text-center" style="padding: 4rem 2rem;">
                        <span style="font-size:3rem;opacity:0.5;">🚫</span>
                        <h2 class="mt-2 text-xl">Patient Not Found</h2>
                        <div class="muted">The requested patient ID does not exist in the system.</div>
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
