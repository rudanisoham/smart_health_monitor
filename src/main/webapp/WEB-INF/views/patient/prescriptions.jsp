<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "prescriptions");
    request.setAttribute("pageTitle", "Prescriptions");
    request.setAttribute("pageSubtitle", "View all your medicines and doctor instructions");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Prescriptions · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">Your Prescriptions</div>
                        <div class="section-subtitle">All prescriptions issued by your doctors</div>
                    </div>
                    <span class="chip-neutral">${prescriptions != null ? prescriptions.size() : 0} Total</span>
                </div>

                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Date</th>
                            <th>Diagnosis</th>
                            <th>Doctor</th>
                            <th>Medicines</th>
                            <th>Instructions</th>
                            <th>Valid Until</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty prescriptions}">
                                <c:forEach var="rx" items="${prescriptions}">
                                    <tr>
                                        <td>
                                            ${rx.createdAt.toString().replace('T', ' ').substring(0, 10)}
                                        </td>
                                        <td><strong>${rx.diagnosis}</strong></td>
                                        <td>Dr. ${rx.doctor.user.fullName}
                                            <c:if test="${rx.doctor.specialty != null}">
                                                <br><span class="muted" style="font-size:0.8rem;">${rx.doctor.specialty}</span>
                                            </c:if>
                                        </td>
                                        <td style="max-width:200px;">${rx.medicines}</td>
                                        <td style="max-width:180px;" class="muted">
                                            <c:choose>
                                                <c:when test="${rx.instructions != null}">${rx.instructions}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${rx.validUntil != null}">
                                                    <span class="chip">${rx.validUntil}</span>
                                                </c:when>
                                                <c:otherwise><span class="muted">Ongoing</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align:center;padding:2.5rem;" class="muted">
                                        No prescriptions issued yet. Book an appointment to consult a doctor.
                                    </td>
                                </tr>
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
