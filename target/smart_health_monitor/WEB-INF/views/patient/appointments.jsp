<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Appointments");
    request.setAttribute("pageSubtitle", "Book, view and manage your visits");
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
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <!-- Book Appointment Form -->
                <div class="card">
                    <div class="section-title">Book Appointment</div>
                    <p class="section-subtitle mt-1">Choose your doctor and preferred time</p>
                    <form action="${pageContext.request.contextPath}/patient/appointments/book" method="post" class="form-grid mt-3">
                        <div class="form-group">
                            <label for="doctorId">Select Doctor</label>
                            <select id="doctorId" name="doctorId" class="form-select" required>
                                <option value="">-- Choose a Doctor --</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}">Dr. ${doc.user.fullName}
                                        <c:if test="${doc.specialty != null}"> (${doc.specialty})</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="scheduledAt">Date & Time</label>
                            <% 
                                String now = java.time.LocalDateTime.now()
                                    .withSecond(0).withNano(0).toString();
                            %>
                            <input id="scheduledAt" name="scheduledAt" class="form-control" type="datetime-local" required min="<%= now %>">
                        </div>
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="notes">Reason / Notes</label>
                            <textarea id="notes" name="notes" class="form-control" rows="3" placeholder="Short description of your concern (optional)"></textarea>
                        </div>
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <button class="btn btn-primary btn-sm" type="submit">Request Appointment</button>
                        </div>
                    </form>
                </div>

                <!-- Appointment List -->
                <div class="card">
                    <div class="section-title">Your Appointments</div>
                    <p class="section-subtitle mt-1">All your scheduled and past visits</p>
                    <div class="table-container mt-3">
                        <table>
                            <thead>
                            <tr>
                                <th>Date & Time</th>
                                <th>Doctor</th>
                                <th>Status</th>
                                <th class="text-right">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty appointments}">
                                    <c:forEach var="appt" items="${appointments}">
                                        <tr>
                                            <td style="font-size:0.875rem;">
                                            ${appt.scheduledAt.toString().replace('T', ' ').substring(0, 16)}
                                        </td>
                                            <td>Dr. ${appt.doctor.user.fullName}
                                                <c:if test="${appt.doctor.specialty != null}">
                                                    <br><span class="muted" style="font-size:0.8rem;">${appt.doctor.specialty}</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">Confirmed</span></c:when>
                                                    <c:when test="${appt.status == 'CANCELLED'}"><span class="chip-danger">Cancelled</span></c:when>
                                                    <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                    <c:otherwise><span class="chip-warning">Pending</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-right">
                                                <c:if test="${appt.status != 'CANCELLED' and appt.status != 'COMPLETED'}">
                                                    <form action="${pageContext.request.contextPath}/patient/appointments/${appt.id}/cancel" method="post" style="display:inline;">
                                                        <button class="btn btn-outline btn-sm" type="submit" onclick="return confirm('Cancel this appointment?')">Cancel</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4" style="text-align:center;padding:2rem;" class="muted">No appointments found. Book your first one!</td></tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
