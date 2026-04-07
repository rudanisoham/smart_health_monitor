<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patient List");
    request.setAttribute("pageSubtitle", "All patients who have booked appointments with you");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patients · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">My Patients</div>
                        <div class="section-subtitle">Patients who have booked appointments with you</div>
                    </div>
                    <span class="chip-neutral">
                        <%-- Count unique patients from appointments --%>
                        ${not empty appointments ? appointments.size() : 0} records
                    </span>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th>Patient Name</th>
                            <th>Email</th>
                            <th>Blood Group</th>
                            <th>Phone</th>
                            <th>Appointment Date</th>
                            <th>Status</th>
                            <th class="text-right">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appt" items="${appointments}">
                                    <tr>
                                        <td><strong>${appt.patient.user.fullName}</strong></td>
                                        <td class="muted">${appt.patient.user.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.patient.bloodGroup != null}"><span class="chip">${appt.patient.bloodGroup}</span></c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="muted">${appt.patient.phone != null ? appt.patient.phone : '—'}</td>
                                        <td>${appt.scheduledAt.toString().replace('T',' ').substring(0,16)}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">Confirmed</span></c:when>
                                                <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                <c:otherwise><span class="chip-danger">${appt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/doctor/patient/${appt.patient.id}">View Details</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align:center;padding:2.5rem;" class="muted">
                                        <div style="font-size:2rem;margin-bottom:0.5rem;">👥</div>
                                        No patients yet. Patients will appear here once they book appointments.
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
