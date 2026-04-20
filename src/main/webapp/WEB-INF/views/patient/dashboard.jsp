<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "dashboard");
    request.setAttribute("pageTitle", "Dashboard");
    request.setAttribute("pageSubtitle", "Your health summary and upcoming schedule");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Dashboard · Smart Health Monitor</title>
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
                <div class="alert alert-success mb-3" style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <!-- KPI Cards -->
            <div class="grid grid-4">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Risk Status</div>
                            <div class="muted mt-1">AI Health Assessment</div>
                        </div>
                        <c:choose>
                            <c:when test="${latestMetric.riskLevel == 'HIGH'}"><span class="chip-danger">High Risk</span></c:when>
                            <c:when test="${latestMetric.riskLevel == 'MEDIUM'}"><span class="chip-warning">Medium Risk</span></c:when>
                            <c:otherwise><span class="chip">Low Risk</span></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-value">
                        <c:choose>
                            <c:when test="${not empty latestMetric.riskLevel}">${latestMetric.riskLevel}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Blood Pressure</div>
                            <div class="muted mt-1">Latest reading</div>
                        </div>
                        <span class="chip-neutral">mmHg</span>
                    </div>
                    <div class="card-value" style="font-size:1.5rem;">
                        <c:choose>
                            <c:when test="${not empty latestMetric and latestMetric.bloodPressureSys != null}">${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Upcoming Appointments</div>
                            <div class="muted mt-1">Total scheduled</div>
                        </div>
                        <span class="chip-warning">Booked</span>
                    </div>
                    <div class="card-value">${appointments != null ? appointments.size() : 0}</div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Unread Notifications</div>
                            <div class="muted mt-1">Alerts & reminders</div>
                        </div>
                        <span class="chip-danger">Review</span>
                    </div>
                    <div class="card-value">${not empty unreadCount ? unreadCount : 0}</div>
                </div>
            </div>

            <!-- ── AI Check-in Banner ────────────────────────── -->
            <c:if test="${not empty aiInsight}">
                <div class="card mb-4" style="background: #ffffff; border: 1px solid #f1f5f9; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-radius: 20px;">
                    <div style="display: flex; align-items: center; gap: 1.25rem;">
                        <div style="width: 54px; height: 54px; border-radius: 14px; background: #eff6ff; display: flex; align-items: center; justify-content: center; font-size: 1.75rem; flex-shrink: 0;">✨</div>
                        <div style="flex: 1;">
                            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.25rem;">
                                <span class="badge-soft" style="background: #e0f2fe; color: #0369a1; font-weight: 800; font-size: 0.65rem;">AI HEALTH ASSISTANT</span>
                                <span style="font-size: 0.75rem; color: #94a3b8; font-weight: 500;">Just now</span>
                            </div>
                            <p style="font-size: 1.1rem; font-weight: 600; color: #1e293b; margin: 0; line-height: 1.4;">
                                "${aiInsight}"
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/patient/ai" class="btn btn-outline btn-sm" style="background: #f8fafc; border-color: #e2e8f0; color: #1e293b; font-weight: 700;">Details</a>
                    </div>
                </div>
            </c:if>

            <div class="grid grid-2 mt-4">
                <!-- Health Stats -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Latest Vitals</div>
                            <div class="section-subtitle">Most recent health readings</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/patient/health" class="btn btn-outline btn-sm">Add Data</a>
                    </div>
                    <div class="mt-1">
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Heart Rate</span>
                                <span class="stat-value">
                            <c:if test="${not empty latestMetric and latestMetric.heartRate != null}">${latestMetric.heartRate} <span class="stat-unit">bpm</span></c:if>
                                        <c:if test="${not empty latestMetric and latestMetric.heartRate == null}"><span class="muted">No data</span></c:if>
                                        <c:if test="${empty latestMetric}"><span class="muted">No data</span></c:if>
                                </span>
                            </div>
                            <div class="stat-icon red">
                                <svg viewBox="0 0 24 24"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">SpO2</span>
                                <span class="stat-value">
                                    <c:choose>
                                        <c:when test="${not empty latestMetric and latestMetric.spo2 != null}">${latestMetric.spo2} <span class="stat-unit">%</span></c:when>
                                        <c:otherwise><span class="muted">No data</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="stat-icon blue">
                                <svg viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Temperature</span>
                                <span class="stat-value">
                                    <c:choose>
                                        <c:when test="${not empty latestMetric and latestMetric.temperature != null}">${latestMetric.temperature} <span class="stat-unit">°C</span></c:when>
                                        <c:otherwise><span class="muted">No data</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="stat-icon yellow">
                                <svg viewBox="0 0 24 24"><path d="M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"/></svg>
                            </div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info">
                                <span class="stat-label">Weight</span>
                                <span class="stat-value">
                                    <c:choose>
                                        <c:when test="${not empty latestMetric and latestMetric.weight != null}">${latestMetric.weight} <span class="stat-unit">kg</span></c:when>
                                        <c:otherwise><span class="muted">No data</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="stat-icon blue">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="6"/><path d="M8 14l-2 7h12l-2-7"/></svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Upcoming Appointments</div>
                            <div class="section-subtitle">Your scheduled visits</div>
                        </div>
                        <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/patient/appointments">View all</a>
                    </div>
                    <div class="timeline mt-2">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appt" items="${appointments}" end="4">
                                    <div class="timeline-item">
                                        <div class="timeline-bullet"></div>
                                        <div class="timeline-content">
                                            <div>
                                            Dr. ${appt.doctor.user.fullName} <span class="chip-neutral" style="font-size:0.7rem;">${appt.status}</span>
                                        </div>
                                        <div class="timeline-meta">
                                            ${appt.scheduledAt.toString().replace('T', ' ').substring(0, 16)}
                                        </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="muted" style="padding:1rem 0;">No upcoming appointments. <a href="${pageContext.request.contextPath}/patient/appointments">Book one</a></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Prescriptions Preview -->
            <div class="card mt-4">
                <div class="card-header">
                    <div>
                        <div class="section-title">Active Prescriptions</div>
                        <div class="section-subtitle">Medicines prescribed by your doctors</div>
                    </div>
                    <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/patient/prescriptions">View all</a>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th>Diagnosis</th>
                            <th>Doctor</th>
                            <th>Medicines</th>
                            <th>Valid Until</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty prescriptions}">
                                <c:forEach var="rx" items="${prescriptions}" end="4">
                                    <tr>
                                        <td>${rx.diagnosis}</td>
                                        <td>Dr. ${rx.doctor.user.fullName}</td>
                                        <td style="max-width:200px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${rx.medicines}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${rx.validUntil != null}">${rx.validUntil}</c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">No prescriptions yet.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
