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
                                    <div class="section-subtitle">Medical metadata & identity</div>
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
                                        <span class="stat-label">Date of Birth</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.dateOfBirth != null ? patient.dateOfBirth : '—'}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Known Allergies</span>
                                        <span class="stat-value" style="font-size:0.95rem; color:#ef4444;">${patient.allergies != null ? patient.allergies : 'No known allergies'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-2 mt-4">
                        <%-- Contact & Privacy Card --%>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">Contact & Residency</div>
                                    <div class="section-subtitle">Personal communication details</div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Registered Phone</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.phone != null ? patient.phone : 'Not provided'}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Primary Address</span>
                                        <span class="stat-value" style="font-size:0.95rem; line-height:1.4;">${patient.address != null ? patient.address : 'No address on file'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Emergency Card --%>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">Emergency Protocols</div>
                                    <div class="section-subtitle">Contacts for critical situations</div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Emergency Email</span>
                                        <span class="stat-value" style="font-size:0.95rem; color:#3b82f6;">${patient.emergencyEmail != null ? patient.emergencyEmail : 'Not set'}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Primary Facility</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.department != null ? patient.department.name : 'Unassigned'}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="grid grid-2 mt-4">
                        <%-- Vitals Overview (Latest) --%>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">Latest Recorded Vitals</div>
                                    <div class="section-subtitle">Real-time health telemetry</div>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty metrics[0]}">
                                        <c:set var="m" value="${metrics[0]}"/>
                                        <c:choose>
                                            <c:when test="${m.riskLevel == 'HIGH'}"><span class="chip-danger">⚠ HIGH RISK</span></c:when>
                                            <c:when test="${m.riskLevel == 'MEDIUM'}"><span class="chip-warning">⚠ MEDIUM RISK</span></c:when>
                                            <c:otherwise><span class="chip">✓ LOW RISK</span></c:otherwise>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                            </div>
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${not empty metrics}">
                                        <c:set var="lastM" value="${metrics[0]}"/>
                                        <div style="margin-bottom:0.75rem;font-size:0.8rem;color:var(--text-muted);">
                                            Recorded on: ${lastM.timestamp.toString().replace('T',' ').substring(0,16)}
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-info">
                                                <span class="stat-label">❤ Heart Rate</span>
                                                <span class="stat-value" style="font-size:1rem;">${lastM.heartRate != null ? lastM.heartRate.toString().concat(' bpm') : '—'}</span>
                                            </div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-info">
                                                <span class="stat-label">🩺 Blood Pressure</span>
                                                <span class="stat-value" style="font-size:1rem;">${lastM.bloodPressureSys != null ? lastM.bloodPressureSys.toString().concat('/').concat(lastM.bloodPressureDia.toString()).concat(' mmHg') : '—'}</span>
                                            </div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-info">
                                                <span class="stat-label">💧 SpO2 (Oxygen)</span>
                                                <span class="stat-value" style="font-size:1rem;">${lastM.spo2 != null ? lastM.spo2.toString().concat('%') : '—'}</span>
                                            </div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-info">
                                                <span class="stat-label">🌡 Temperature</span>
                                                <span class="stat-value" style="font-size:1rem;">${lastM.temperature != null ? lastM.temperature.toString().concat('°C') : '—'}</span>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="muted text-center" style="padding:2rem;">No health vitals recorded by this patient.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <%-- Clinical History Card --%>
                        <div class="card">
                            <div class="card-header pb-3">
                                <div>
                                    <div class="section-title">Clinical Record Logs</div>
                                    <div class="section-subtitle">Prescriptions and official medical history</div>
                                </div>
                            </div>
                            <div class="table-container mt-2" style="max-height: 400px; overflow-y: auto;">
                                <table>
                                    <thead>
                                    <tr>
                                        <th>Date Issued</th>
                                        <th>Diagnosis</th>
                                        <th>Medicines</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty prescriptions}">
                                            <c:forEach var="p" items="${prescriptions}">
                                                <tr>
                                                    <td style="font-size:0.75rem;">${p.createdAt.toString().substring(0, 10)}</td>
                                                    <td style="font-weight:600;">${p.diagnosis}</td>
                                                    <td><div style="font-size:0.75rem; color:var(--text-muted);">${p.medicines}</div></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr><td colspan="3" class="muted text-center" style="padding: 2rem;">No clinical records found.</td></tr>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <%-- Patient Uploaded Reports Section --%>
                    <div class="card mt-4">
                        <div class="card-header">
                            <div>
                                <div class="section-title">Patient Uploaded Reports & Documentation</div>
                                <div class="section-subtitle">Files provided for system review</div>
                            </div>
                        </div>
                        <div class="table-container mt-2">
                            <table>
                                <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Report Title</th>
                                    <th>Description</th>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty reports}">
                                        <c:forEach var="r" items="${reports}">
                                            <tr>
                                                <td>${r.createdAt.toString().substring(0, 10)}</td>
                                                <td style="font-weight:600;">${r.title}</td>
                                                <td class="muted">${r.description}</td>
                                                <td><a href="${pageContext.request.contextPath}/admin/reports/${r.id}" class="btn btn-outline btn-sm">Audit Report</a></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="4" class="muted text-center" style="padding: 2rem;">No documentation uploaded.</td></tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
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
