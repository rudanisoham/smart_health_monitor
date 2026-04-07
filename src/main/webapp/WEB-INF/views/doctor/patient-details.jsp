<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patient Profile");
    request.setAttribute("pageSubtitle", "Clinical history and health records");
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
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">
            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/doctor/patients" class="btn btn-outline btn-sm">← Back to Patient List</a>
            </div>

            <c:choose>
                <c:when test="${patient != null}">
                    <div class="grid grid-2">
                        <%-- Patient Information --%>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <h2 style="font-size:1.5rem;margin:0;">${patient.user.fullName}</h2>
                                    <div class="muted">Age/DOB details typically here</div>
                                </div>
                                <span class="badge-pill">Patient</span>
                            </div>
                            <div class="mt-3">
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Email</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.user.email}</span>
                                    </div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-info">
                                        <span class="stat-label">Phone</span>
                                        <span class="stat-value" style="font-size:0.95rem;">${patient.phone != null ? patient.phone : '—'}</span>
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
                                        <span class="stat-label">Blood Group</span>
                                        <span class="stat-value" style="font-size:0.95rem;">
                                            <c:choose>
                                                <c:when test="${patient.bloodGroup != null}"><span class="chip-danger">${patient.bloodGroup}</span></c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

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
                    </div>

                    <%-- Clinical History (Prescriptions & Appointments) --%>
                    <div class="card mt-4">
                        <div class="card-header">
                            <div>
                                <div class="section-title">Clinical History</div>
                                <div class="section-subtitle">Past prescriptions and diagnosis</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/doctor/prescriptions" class="btn btn-outline btn-sm">Issue New Prescription</a>
                        </div>
                        <div class="table-container mt-2">
                            <table>
                                <thead>
                                <tr>
                                    <th>Date Issued</th>
                                    <th>Diagnosis</th>
                                    <th>Medicines</th>
                                    <th>Instructions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty prescriptions}">
                                        <c:forEach var="p" items="${prescriptions}">
                                            <tr>
                                                <td style="white-space:nowrap;">${p.createdAt.toString().replace('T',' ').substring(0,16)}</td>
                                                <td style="font-weight:600;">${p.diagnosis}</td>
                                                <td><div style="max-height:60px;overflow:auto;font-size:0.85rem;white-space:pre-wrap;">${p.medicines}</div></td>
                                                <td class="muted"><div style="max-height:60px;overflow:auto;font-size:0.85rem;white-space:pre-wrap;">${p.instructions != null ? p.instructions : '—'}</div></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="muted text-center" style="padding: 2rem;">No prescription history for this patient.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <%-- Patient Uploaded Reports --%>
                    <div class="card mt-4">
                        <div class="card-header pb-3">
                            <div>
                                <div class="section-title">Patient Uploaded Reports</div>
                                <div class="section-subtitle">Documentation provided by the patient for review</div>
                            </div>
                        </div>
                        <div class="table-container mt-2">
                            <table>
                                <thead>
                                <tr>
                                    <th>Submission Date</th>
                                    <th>Report Title</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty reports}">
                                        <c:forEach var="r" items="${reports}">
                                            <tr>
                                                <td style="white-space:nowrap;">${r.createdAt.toString().substring(0, 10)}</td>
                                                <td style="font-weight:600;">
                                                    ${r.title}
                                                    <c:if test="${not empty r.filePath}">
                                                        <span style="font-size:0.65rem; color:var(--success); margin-left:0.5rem; border:1px solid var(--success); padding:0.1rem 0.3rem; border-radius:4px;">📎 DOC</span>
                                                    </c:if>
                                                </td>
                                                <td><div style="font-size:0.85rem;color:var(--text-muted);">${r.description != null ? r.description : '—'}</div></td>
                                                <td>
                                                    <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/doctor/reports/${r.id}">Review Findings</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="muted text-center" style="padding: 2rem;">No documentation uploaded by the patient.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card" style="text-align:center;padding:4rem 2rem;">
                        <h2 class="section-title">Patient Not Found</h2>
                        <p class="muted">The requested patient record could not be located.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
