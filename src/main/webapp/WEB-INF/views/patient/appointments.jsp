<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Appointments");
    request.setAttribute("pageSubtitle", "Request and track your appointments");
    String today = java.time.LocalDate.now().toString();
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
                    <div class="section-title">Request an Appointment</div>
                    <p class="section-subtitle mt-1">Fill in your preferred date and reason — reception will assign a doctor and confirm</p>

                    <div style="padding:0.875rem 1rem;background:#eff6ff;border-radius:8px;border-left:4px solid #3b82f6;margin:1rem 0;font-size:0.875rem;color:#1d4ed8;">
                        <strong>How it works:</strong> Submit your request → Reception reviews and assigns a doctor → You receive a token number and estimated time via email and notification.
                    </div>

                    <form action="${pageContext.request.contextPath}/patient/appointments/book" method="post" class="form-grid mt-2">

                        <div class="form-group">
                            <label for="preferredDate">Preferred Date <span style="color:#ef4444;">*</span></label>
                            <input id="preferredDate" name="preferredDate" class="form-control" type="date"
                                   min="<%= today %>" required>
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Select your preferred appointment date.</span>
                        </div>

                        <div class="form-group">
                            <label for="preferredDateNote">Preferred Time (optional)</label>
                            <input id="preferredDateNote" name="preferredDateNote" class="form-control" type="text"
                                   placeholder="e.g. Morning, 10:00 AM, After 2 PM">
                        </div>

                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="notes">Reason / Symptoms <span style="color:#ef4444;">*</span></label>
                            <textarea id="notes" name="notes" class="form-control" rows="3" required
                                      placeholder="Describe your concern, symptoms, or reason for visit..."></textarea>
                        </div>

                        <div class="form-group" style="grid-column:1/-1;">
                            <button class="btn btn-primary w-full" type="submit">Submit Appointment Request</button>
                        </div>
                    </form>
                </div>

                <!-- Appointment List -->
                <div class="card">
                    <div class="section-title">Your Appointments</div>
                    <p class="section-subtitle mt-1">All your requests and scheduled visits</p>
                    <div class="table-container mt-3">
                        <table>
                            <thead>
                            <tr>
                                <th>Date & Token</th>
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
                                                <c:choose>
                                                    <c:when test="${appt.scheduledAt != null}">
                                                        <div>${appt.scheduledAt.toString().replace('T', ' ').substring(0, 16)}</div>
                                                        <c:if test="${appt.tokenNumber != null}">
                                                            <div style="margin-top:0.2rem;">
                                                                <span style="background:#eff6ff;color:#1d4ed8;padding:0.2rem 0.5rem;border-radius:4px;font-size:0.75rem;font-weight:700;">Token #${appt.tokenNumber}</span>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${appt.estimatedTime != null}">
                                                            <div class="muted" style="font-size:0.75rem;margin-top:0.2rem;">Est. arrival: ${appt.estimatedTime.toString().replace('T',' ').substring(0,16)}</div>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="muted">Awaiting assignment</span>
                                                        <c:if test="${appt.preferredDate != null}">
                                                            <div style="font-size:0.78rem;color:var(--text-muted);">Pref date: ${appt.preferredDate}</div>
                                                        </c:if>
                                                        <c:if test="${not empty appt.preferredDateNote}">
                                                            <div style="font-size:0.78rem;color:var(--text-muted);">Time: ${appt.preferredDateNote}</div>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appt.doctor != null}">
                                                        Dr. ${appt.doctor.user.fullName}
                                                        <c:if test="${appt.doctor.specialty != null}">
                                                            <br><span class="muted" style="font-size:0.8rem;">${appt.doctor.specialty}</span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise><span class="muted">Being assigned...</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appt.status == 'AWAITING_ASSIGNMENT'}"><span class="chip-warning">⏳ Awaiting</span></c:when>
                                                    <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                    <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">✓ Confirmed</span></c:when>
                                                    <c:when test="${appt.status == 'CANCELLED'}"><span class="chip-danger">Cancelled</span></c:when>
                                                    <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                    <c:otherwise><span class="chip-warning">${appt.status}</span></c:otherwise>
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
                                    <tr><td colspan="4" style="text-align:center;padding:2rem;" class="muted">No appointments yet. Submit your first request!</td></tr>
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
