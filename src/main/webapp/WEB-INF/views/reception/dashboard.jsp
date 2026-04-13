<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "dashboard");
    request.setAttribute("pageTitle", "Reception Dashboard");
    request.setAttribute("pageSubtitle", "Appointment queue and bed overview");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reception Dashboard · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>

            <!-- KPI Cards -->
            <div class="grid grid-4" style="margin-bottom:2rem;">
                <div class="card">
                    <div class="card-title">Awaiting Assignment</div>
                    <div class="card-value" style="color:#f59e0b;">${pendingCount != null ? pendingCount : 0}</div>
                    <div class="muted mt-1">Patients in queue</div>
                </div>
                <div class="card">
                    <div class="card-title">Total Appointments</div>
                    <div class="card-value">${totalAppointments != null ? totalAppointments : 0}</div>
                    <div class="muted mt-1">All time</div>
                </div>
                <div class="card">
                    <div class="card-title">Total Patients</div>
                    <div class="card-value">${totalPatients != null ? totalPatients : 0}</div>
                    <div class="muted mt-1">Registered</div>
                </div>
                <div class="card">
                    <div class="card-title">Departments</div>
                    <div class="card-value">${not empty departments ? departments.size() : 0}</div>
                    <div class="muted mt-1">Active units</div>
                </div>
            </div>

            <div class="grid grid-2">
                <!-- Pending Queue -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Appointment Queue</div>
                            <div class="section-subtitle">Patients awaiting doctor assignment</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-primary btn-sm">Manage All</a>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                                <tr><th>Patient</th><th>Preferred Time</th><th>Action</th></tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty pendingQueue}">
                                    <c:forEach var="appt" items="${pendingQueue}" end="4">
                                        <tr>
                                            <td>
                                                <strong>${appt.patient.user.fullName}</strong>
                                                <div class="muted" style="font-size:0.8rem;">${appt.patient.user.email}</div>
                                            </td>
                                            <td class="muted" style="font-size:0.85rem;">
                                                <c:choose>
                                                    <c:when test="${not empty appt.preferredDateNote}">${appt.preferredDateNote}</c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/reception/appointments/${appt.id}/assign" class="btn btn-primary btn-sm">Assign</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="3" class="muted" style="text-align:center;padding:1.5rem;">No pending requests. All caught up!</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Bed Overview -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Bed Overview</div>
                            <div class="section-subtitle">Capacity by department</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/reception/beds" class="btn btn-outline btn-sm">Manage Beds</a>
                    </div>
                    <div class="mt-2">
                        <c:choose>
                            <c:when test="${not empty departments}">
                                <c:forEach var="dept" items="${departments}">
                                    <div class="stat-item">
                                        <div class="stat-info">
                                            <span class="stat-label">${dept.name}</span>
                                            <span style="font-size:0.85rem;color:var(--text-muted);">
                                                ${dept.availableBeds} available / ${dept.totalBeds} total
                                            </span>
                                        </div>
                                        <c:choose>
                                            <c:when test="${dept.availableBeds > 0}"><span class="chip">Available</span></c:when>
                                            <c:otherwise><span class="chip-danger">Full</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="muted" style="padding:1.5rem;text-align:center;">No departments configured.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
