<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patient Profile");
    request.setAttribute("pageSubtitle", "Complete clinical history and records");
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
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <div style="display:flex;gap:0.75rem;margin-bottom:1.5rem;flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/medical/patients" class="btn btn-outline btn-sm">← Back to Search</a>
                <a href="${pageContext.request.contextPath}/medical/reports/upload?patientId=${patient.id}" class="btn btn-primary btn-sm">Upload Report</a>
            </div>

            <!-- Patient Header -->
            <div class="card" style="margin-bottom:1.5rem;">
                <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:1rem;">
                    <div style="display:flex;align-items:center;gap:1.25rem;">
                        <div style="width:60px;height:60px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-size:1.5rem;font-weight:800;color:var(--primary);">
                            ${patient.user.fullName.substring(0,1)}
                        </div>
                        <div>
                            <div style="font-size:1.5rem;font-weight:800;">${patient.user.fullName}</div>
                            <div class="muted">Patient ID: #${patient.id} · ${patient.user.email}</div>
                            <div style="margin-top:0.5rem;display:flex;gap:0.5rem;flex-wrap:wrap;">
                                <c:if test="${patient.bloodGroup != null}"><span class="chip-danger">${patient.bloodGroup}</span></c:if>
                                <c:if test="${patient.gender != null}"><span class="chip-neutral">${patient.gender}</span></c:if>
                                <c:if test="${patient.dateOfBirth != null}"><span class="chip-neutral">DOB: ${patient.dateOfBirth}</span></c:if>
                            </div>
                        </div>
                    </div>
                    <div>
                        <c:if test="${latestMetric != null}">
                            <c:choose>
                                <c:when test="${latestMetric.riskLevel == 'HIGH'}"><span class="chip-danger" style="font-size:0.9rem;padding:0.5rem 1rem;">🚨 HIGH RISK</span></c:when>
                                <c:when test="${latestMetric.riskLevel == 'MEDIUM'}"><span class="chip-warning" style="font-size:0.9rem;padding:0.5rem 1rem;">⚠ MEDIUM RISK</span></c:when>
                                <c:otherwise><span class="chip" style="font-size:0.9rem;padding:0.5rem 1rem;">✓ LOW RISK</span></c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="grid grid-2" style="margin-bottom:1.5rem;">
                <!-- Basic Info -->
                <div class="card">
                    <div class="section-title" style="margin-bottom:1rem;">Basic Information</div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Phone</span><span class="stat-value" style="font-size:0.95rem;">${patient.user.phone != null ? patient.user.phone : '—'}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Address</span><span class="stat-value" style="font-size:0.95rem;">${patient.address != null ? patient.address : '—'}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Allergies</span><span class="stat-value" style="font-size:0.95rem;">${patient.allergies != null ? patient.allergies : 'None recorded'}</span></div></div>
                    <div class="stat-item"><div class="stat-info"><span class="stat-label">Emergency Contact</span><span class="stat-value" style="font-size:0.95rem;">${patient.emergencyEmail != null ? patient.emergencyEmail : '—'}</span></div></div>
                </div>

                <!-- Latest Vitals -->
                <div class="card">
                    <div class="section-title" style="margin-bottom:1rem;">Latest Vitals</div>
                    <c:choose>
                        <c:when test="${latestMetric != null}">
                            <div class="stat-item"><div class="stat-info"><span class="stat-label">Heart Rate</span><span class="stat-value" style="font-size:0.95rem;">${latestMetric.heartRate != null ? latestMetric.heartRate.toString().concat(' bpm') : '—'}</span></div></div>
                            <div class="stat-item"><div class="stat-info"><span class="stat-label">Blood Pressure</span><span class="stat-value" style="font-size:0.95rem;">${latestMetric.bloodPressureSys != null ? latestMetric.bloodPressureSys.toString().concat('/').concat(latestMetric.bloodPressureDia.toString()).concat(' mmHg') : '—'}</span></div></div>
                            <div class="stat-item"><div class="stat-info"><span class="stat-label">SpO2</span><span class="stat-value" style="font-size:0.95rem;">${latestMetric.spo2 != null ? latestMetric.spo2.toString().concat('%') : '—'}</span></div></div>
                            <div class="stat-item"><div class="stat-info"><span class="stat-label">Temperature</span><span class="stat-value" style="font-size:0.95rem;">${latestMetric.temperature != null ? latestMetric.temperature.toString().concat(' °C') : '—'}</span></div></div>
                            <div class="muted" style="font-size:0.8rem;margin-top:0.5rem;">Recorded: ${latestMetric.timestamp.toString().replace('T',' ').substring(0,16)}</div>
                        </c:when>
                        <c:otherwise><div class="muted" style="padding:1rem;text-align:center;">No vitals recorded yet.</div></c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Prescriptions -->
            <div class="card" style="margin-bottom:1.5rem;" id="prescriptions">
                <div class="card-header">
                    <div><div class="section-title">Prescriptions</div><div class="section-subtitle">All issued prescriptions</div></div>
                </div>
                <div class="table-container mt-2">
                    <table>
                        <thead><tr><th>Date</th><th>Doctor</th><th>Diagnosis</th><th>Medicines</th><th>Valid Until</th><th class="text-right">Action</th></tr></thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty prescriptions}">
                                <c:forEach var="rx" items="${prescriptions}">
                                    <tr>
                                        <td class="muted" style="font-size:0.85rem;">${rx.createdAt.toString().replace('T',' ').substring(0,10)}</td>
                                        <td>Dr. ${rx.doctor.user.fullName}</td>
                                        <td>${rx.diagnosis}</td>
                                        <td style="max-width:200px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${rx.medicines}</td>
                                        <td>${rx.validUntil != null ? rx.validUntil : '—'}</td>
                                        <td class="text-right">
                                            <a href="${pageContext.request.contextPath}/medical/prescriptions/${rx.id}"
                                               class="btn btn-primary btn-sm">Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="6" class="muted" style="text-align:center;padding:1.5rem;">No prescriptions found.</td></tr></c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Reports -->
            <div class="card" style="margin-bottom:1.5rem;">
                <div class="card-header">
                    <div><div class="section-title">Medical Reports</div></div>
                    <a href="${pageContext.request.contextPath}/medical/reports/upload?patientId=${patient.id}" class="btn btn-primary btn-sm">+ Upload Report</a>
                </div>
                <div class="table-container mt-2">
                    <table>
                        <thead><tr><th>Date</th><th>Title</th><th>Type</th><th>Status</th><th>Uploaded By</th><th class="text-right">Action</th></tr></thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty reports}">
                                <c:forEach var="r" items="${reports}">
                                    <tr>
                                        <td class="muted" style="font-size:0.85rem;">${r.createdAt.toString().replace('T',' ').substring(0,10)}</td>
                                        <td><strong>${r.title}</strong></td>
                                        <td>${r.type != null ? r.type.toString().replace('_',' ') : '—'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                <c:when test="${r.status == 'REVIEWED'}"><span class="chip">Reviewed</span></c:when>
                                                <c:when test="${r.status == 'NORMAL'}"><span class="chip">Normal</span></c:when>
                                                <c:when test="${r.status == 'ABNORMAL'}"><span class="chip-danger">Abnormal</span></c:when>
                                                <c:otherwise><span class="chip-neutral">${r.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="muted">${r.uploadedBy != null ? r.uploadedBy : '—'}</td>
                                        <td class="text-right">
                                            <a href="${pageContext.request.contextPath}/medical/reports/${r.id}" class="btn btn-outline btn-sm">View</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="6" class="muted" style="text-align:center;padding:1.5rem;">No reports uploaded yet.</td></tr></c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Appointment History -->
            <div class="card">
                <div class="card-header">
                    <div><div class="section-title">Appointment History</div></div>
                </div>
                <div class="table-container mt-2">
                    <table>
                        <thead><tr><th>Date</th><th>Doctor</th><th>Status</th><th>Token</th></tr></thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="a" items="${appointments}">
                                    <tr>
                                        <td class="muted" style="font-size:0.85rem;">
                                            <c:choose>
                                                <c:when test="${a.scheduledAt != null}">${a.scheduledAt.toString().replace('T',' ').substring(0,16)}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${a.doctor != null ? 'Dr. '.concat(a.doctor.user.fullName) : 'Unassigned'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == 'CONFIRMED'}"><span class="chip">Confirmed</span></c:when>
                                                <c:when test="${a.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                <c:when test="${a.status == 'CANCELLED'}"><span class="chip-danger">Cancelled</span></c:when>
                                                <c:otherwise><span class="chip-warning">${a.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${a.tokenNumber != null ? '#'.concat(a.tokenNumber.toString()) : '—'}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise><tr><td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">No appointments found.</td></tr></c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
