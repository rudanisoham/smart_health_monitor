<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Appointment Queue");
    request.setAttribute("pageSubtitle", "Assign doctors and schedule patient appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointment Queue · Smart Health Monitor</title>
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
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <!-- Pending Queue -->
            <div class="card" style="margin-bottom:1.5rem;">
                <div class="card-header">
                    <div>
                        <div class="section-title">⏳ Awaiting Assignment</div>
                        <div class="section-subtitle">These patients need a doctor and time slot assigned</div>
                    </div>
                    <span class="chip-warning">${not empty pendingQueue ? pendingQueue.size() : 0} pending</span>
                </div>
                <div class="table-container mt-2">
                    <table>
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Contact</th>
                                <th>Preferred Time / Notes</th>
                                <th>Requested On</th>
                                <th class="text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty pendingQueue}">
                                <c:forEach var="appt" items="${pendingQueue}">
                                    <tr>
                                        <td>
                                            <strong>${appt.patient.user.fullName}</strong>
                                            <div class="muted" style="font-size:0.8rem;">${appt.patient.bloodGroup != null ? appt.patient.bloodGroup : ''}</div>
                                        </td>
                                        <td>
                                            <div style="font-size:0.875rem;">${appt.patient.user.email}</div>
                                            <div class="muted" style="font-size:0.8rem;">${appt.patient.user.phone != null ? appt.patient.user.phone : '—'}</div>
                                        </td>
                                        <td>
                                            <div style="font-size:0.875rem;">${not empty appt.preferredDateNote ? appt.preferredDateNote : '—'}</div>
                                            <div class="muted" style="font-size:0.8rem;">${not empty appt.notes ? appt.notes : ''}</div>
                                        </td>
                                        <td class="muted" style="font-size:0.85rem;">
                                            ${appt.createdAt.toString().replace('T',' ').substring(0,16)}
                                        </td>
                                        <td class="text-right">
                                            <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
                                                <a href="${pageContext.request.contextPath}/reception/appointments/${appt.id}/assign" class="btn btn-primary btn-sm">Assign Doctor</a>
                                                <form action="${pageContext.request.contextPath}/reception/appointments/${appt.id}/cancel" method="post" style="display:inline;">
                                                    <button class="btn btn-outline btn-sm" type="submit" onclick="return confirm('Cancel this appointment request?')" style="border-color:#ef4444;color:#ef4444;">Cancel</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="5" class="muted" style="text-align:center;padding:2rem;">
                                    <div style="font-size:2rem;margin-bottom:0.5rem;">✅</div>
                                    No pending appointment requests. All caught up!
                                </td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- All Appointments -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Appointments</div>
                        <div class="section-subtitle">Complete appointment history</div>
                    </div>
                </div>
                <div class="table-container mt-2">
                    <table>
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Scheduled</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty allAppointments}">
                                <c:forEach var="appt" items="${allAppointments}">
                                    <tr>
                                        <td><strong>${appt.patient.user.fullName}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.doctor != null}">Dr. ${appt.doctor.user.fullName}</c:when>
                                                <c:otherwise><span class="muted">Not assigned</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="muted" style="font-size:0.875rem;">
                                            <c:choose>
                                                <c:when test="${appt.scheduledAt != null}">${appt.scheduledAt.toString().replace('T',' ').substring(0,16)}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'AWAITING_ASSIGNMENT'}"><span class="chip-warning">⏳ Awaiting</span></c:when>
                                                <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">Confirmed</span></c:when>
                                                <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                <c:when test="${appt.status == 'CANCELLED'}"><span class="chip-danger">Cancelled</span></c:when>
                                                <c:otherwise><span class="chip-neutral">${appt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="4" class="muted" style="text-align:center;padding:2rem;">No appointments found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
