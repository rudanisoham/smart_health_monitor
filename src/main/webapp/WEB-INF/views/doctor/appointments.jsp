<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Appointments");
    request.setAttribute("pageSubtitle", "Manage and respond to all your patient appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointments · Smart Health Monitor</title>
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
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <%-- Status Summary --%>
            <div class="grid grid-4" style="margin-bottom:1.5rem;">
                <div class="card">
                    <div class="card-title">Total</div>
                    <div class="card-value">${not empty appointments ? appointments.size() : 0}</div>
                </div>
                <div class="card">
                    <div class="card-title">Pending</div>
                    <div class="card-value" style="color:#fbbf24;">
                        <c:set var="p" value="0"/><c:forEach var="a" items="${appointments}"><c:if test="${a.status == 'PENDING'}"><c:set var="p" value="${p+1}"/></c:if></c:forEach>${p}
                    </div>
                </div>
                <div class="card">
                    <div class="card-title">Confirmed</div>
                    <div class="card-value" style="color:#34d399;">
                        <c:set var="cf" value="0"/><c:forEach var="a" items="${appointments}"><c:if test="${a.status == 'CONFIRMED'}"><c:set var="cf" value="${cf+1}"/></c:if></c:forEach>${cf}
                    </div>
                </div>
                <div class="card">
                    <div class="card-title">Completed</div>
                    <div class="card-value" style="color:#60a5fa;">
                        <c:set var="cp" value="0"/><c:forEach var="a" items="${appointments}"><c:if test="${a.status == 'COMPLETED'}"><c:set var="cp" value="${cp+1}"/></c:if></c:forEach>${cp}
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Appointments</div>
                        <div class="section-subtitle">Click Confirm, Complete or Cancel to update status</div>
                    </div>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th>Date & Time</th>
                            <th>Patient</th>
                            <th>Notes/Reason</th>
                            <th>Status</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appt" items="${appointments}">
                                    <tr>
                                        <td style="white-space:nowrap;">${appt.scheduledAt.toString().replace('T',' ').substring(0,16)}</td>
                                        <td>
                                            <strong>${appt.patient.user.fullName}</strong>
                                            <div class="muted text-xs">${appt.patient.user.email}</div>
                                        </td>
                                        <td class="muted" style="max-width:180px;">${appt.notes != null ? appt.notes : '—'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'AWAITING_ASSIGNMENT'}"><span class="chip-warning">⏳ Awaiting Reception</span></c:when>
                                                <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning">⏳ Pending</span></c:when>
                                                <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">✓ Confirmed</span></c:when>
                                                <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">✅ Completed</span></c:when>
                                                <c:when test="${appt.status == 'CANCELLED'}"><span class="chip-danger">✗ Cancelled</span></c:when>
                                                <c:otherwise><span class="chip-neutral">${appt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <div class="table-actions">
                                                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/doctor/patient/${appt.patient.id}">View Patient</a>
                                                <c:if test="${appt.status == 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/doctor/appointments/${appt.id}/confirm" method="post" style="display:inline;">
                                                        <button class="btn btn-primary btn-sm" type="submit">Confirm</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${appt.status == 'CONFIRMED'}">
                                                    <form action="${pageContext.request.contextPath}/doctor/appointments/${appt.id}/complete" method="post" style="display:inline;">
                                                        <button class="btn btn-primary btn-sm" type="submit">Complete</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${appt.status == 'PENDING' or appt.status == 'CONFIRMED'}">
                                                    <form action="${pageContext.request.contextPath}/doctor/appointments/${appt.id}/cancel" method="post" style="display:inline;">
                                                        <button class="btn btn-outline btn-sm" type="submit" onclick="return confirm('Cancel this appointment?')">Cancel</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align:center;padding:2.5rem;" class="muted">
                                        <div style="font-size:2rem;margin-bottom:0.5rem;">📅</div>
                                        No appointments found. Patients can book appointments through their portal.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
