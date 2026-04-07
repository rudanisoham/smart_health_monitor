<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "dashboard");
    request.setAttribute("pageTitle", "Dashboard");
    request.setAttribute("pageSubtitle", "Your clinical overview and upcoming appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">

            <%-- Approval Warning Banner --%>
            <c:if test="${doctor != null and !doctor.approved}">
                <div style="padding:1rem 1.25rem;background:rgba(251,191,36,0.15);border:1px solid #fbbf24;border-radius:10px;color:#fbbf24;margin-bottom:1.5rem;display:flex;align-items:center;gap:0.75rem;">
                    <span style="font-size:1.25rem;">⏳</span>
                    <div>
                        <strong>Application Under Review</strong>
                        <div style="font-size:0.875rem;margin-top:0.2rem;opacity:0.85;">Your account is pending admin approval. Some features may be restricted until approved.</div>
                    </div>
                </div>
            </c:if>

            <%-- KPI Cards --%>
            <div class="grid grid-4">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Total Appointments</div>
                            <div class="muted mt-1">All time</div>
                        </div>
                        <span class="chip">📅</span>
                    </div>
                    <div class="card-value">${appointmentCount != null ? appointmentCount : 0}</div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Pending</div>
                            <div class="muted mt-1">Awaiting confirmation</div>
                        </div>
                        <span class="chip-warning">⚠</span>
                    </div>
                    <div class="card-value">
                        <c:set var="pendingCount" value="0"/>
                        <c:forEach var="a" items="${appointments}">
                            <c:if test="${a.status == 'PENDING'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
                        </c:forEach>
                        ${pendingCount}
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Confirmed</div>
                            <div class="muted mt-1">Ready to attend</div>
                        </div>
                        <span class="chip">✓</span>
                    </div>
                    <div class="card-value">
                        <c:set var="confirmedCount" value="0"/>
                        <c:forEach var="a" items="${appointments}">
                            <c:if test="${a.status == 'CONFIRMED'}"><c:set var="confirmedCount" value="${confirmedCount + 1}"/></c:if>
                        </c:forEach>
                        ${confirmedCount}
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">Unread Alerts</div>
                            <div class="muted mt-1">Notifications</div>
                        </div>
                        <span class="chip-danger">🔔</span>
                    </div>
                    <div class="card-value">${unreadCount != null ? unreadCount : 0}</div>
                </div>
            </div>

            <%-- Doctor Profile Summary + Appointments --%>
            <div class="grid grid-2 mt-4">

                <%-- Doctor Info Card --%>
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Your Profile</div>
                            <div class="section-subtitle">Clinical identity and department</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-outline btn-sm">Edit</a>
                    </div>
                    <div class="mt-3">
                        <c:if test="${doctor != null}">
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">Full Name</span>
                                    <span class="stat-value" style="font-size:1rem;">Dr. ${doctor.user.fullName}</span>
                                </div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">Email</span>
                                    <span class="stat-value" style="font-size:0.9rem;">${doctor.user.email}</span>
                                </div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">Specialty</span>
                                    <span class="stat-value" style="font-size:1rem;"><span class="chip">${doctor.specialty}</span></span>
                                </div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">License #</span>
                                    <span class="stat-value" style="font-size:0.9rem;">${doctor.licenseNumber}</span>
                                </div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">Department</span>
                                    <span class="stat-value" style="font-size:1rem;">
                                        <c:choose>
                                            <c:when test="${doctor.department != null}">${doctor.department.name}</c:when>
                                            <c:otherwise><span class="muted">Not assigned</span></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">Experience</span>
                                    <span class="stat-value" style="font-size:1rem;">${doctor.experience != null ? doctor.experience.toString().concat(' years') : '—'}</span>
                                </div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-info">
                                    <span class="stat-label">Status</span>
                                    <span class="stat-value">
                                        <c:choose>
                                            <c:when test="${doctor.approved}"><span class="chip">✓ Approved</span></c:when>
                                            <c:otherwise><span class="chip-warning">⏳ Pending Approval</span></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${doctor == null}">
                            <div class="muted" style="padding:1.5rem;text-align:center;">Doctor profile not found.</div>
                        </c:if>
                    </div>
                </div>

                <%-- Upcoming Appointments --%>
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Recent Appointments</div>
                            <div class="section-subtitle">Latest 5 from your schedule</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-outline btn-sm">View all</a>
                    </div>
                    <div class="timeline mt-2">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:set var="shown" value="0"/>
                                <c:forEach var="appt" items="${appointments}">
                                    <c:if test="${shown < 5}">
                                        <div class="timeline-item">
                                            <div class="timeline-bullet"></div>
                                            <div class="timeline-content">
                                                <div><strong>${appt.patient.user.fullName}</strong>
                                                    <c:choose>
                                                        <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning" style="font-size:0.7rem;margin-left:0.4rem;">Pending</span></c:when>
                                                        <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip" style="font-size:0.7rem;margin-left:0.4rem;">Confirmed</span></c:when>
                                                        <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral" style="font-size:0.7rem;margin-left:0.4rem;">Done</span></c:when>
                                                        <c:otherwise><span class="chip-danger" style="font-size:0.7rem;margin-left:0.4rem;">${appt.status}</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="timeline-meta">${appt.scheduledAt.toString().replace('T',' ').substring(0,16)}
                                                    <c:if test="${appt.notes != null}"> · ${appt.notes}</c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <c:set var="shown" value="${shown + 1}"/>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="muted" style="padding:1.5rem;text-align:center;">No appointments yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
