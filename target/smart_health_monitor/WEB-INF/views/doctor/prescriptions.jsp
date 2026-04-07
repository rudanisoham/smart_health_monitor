<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "prescriptions");
    request.setAttribute("pageTitle", "Prescriptions");
    request.setAttribute("pageSubtitle", "Manage and issue patient prescriptions");
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

            <div class="grid grid-2">
                <%-- Issue New Prescription Form --%>
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Issue Prescription</div>
                            <div class="section-subtitle">Add a new record for a patient</div>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/doctor/prescriptions/add" method="post" class="mt-3">
                        <div class="form-group">
                            <label for="patientId">Select Patient</label>
                            <select id="patientId" name="patientId" class="form-select" required>
                                <option value="">Choose patient...</option>
                                <c:forEach var="pt" items="${patients}">
                                    <option value="${pt.id}">${pt.user.fullName} (${pt.user.email})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="diagnosis">Diagnosis</label>
                            <input type="text" id="diagnosis" name="diagnosis" class="form-control" placeholder="e.g. Acute Bronchitis" required>
                        </div>
                        <div class="form-group">
                            <label for="medicines">Medicines</label>
                            <textarea id="medicines" name="medicines" class="form-control" rows="3" placeholder="List medicines and dosages..." required></textarea>
                        </div>
                        <div class="form-group mt-3">
                            <label for="instructions">Special Instructions (Optional)</label>
                            <textarea id="instructions" name="instructions" class="form-control" rows="2" placeholder="Take with food, avoid alcohol, etc."></textarea>
                        </div>
                        <div class="form-group mt-3">
                            <label for="validUntil">Valid Until (Optional)</label>
                            <input id="validUntil" name="validUntil" class="form-control" type="date" min="<%= java.time.LocalDate.now() %>">
                            <span class="muted" style="font-size:0.75rem;">Set an expiration date for this prescription.</span>
                        </div>
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Save & Issue Prescription</button>
                        </div>
                    </form>
                </div>

                <%-- Prescription History --%>
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Recent Prescriptions</div>
                            <div class="section-subtitle">Last prescriptions issued by you</div>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Patient</th>
                                <th>Diagnosis</th>
                                <th>Expiry</th>
                                <th class="text-right">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty prescriptions}">
                                    <c:forEach var="p" items="${prescriptions}">
                                        <tr>
                                            <td style="white-space:nowrap;">${p.createdAt.toString().substring(0,10)}</td>
                                            <td><strong>${p.patient.user.fullName}</strong></td>
                                            <td>${p.diagnosis}</td>
                                            <td class="muted">${p.validUntil != null ? p.validUntil.toString() : 'Ongoing'}</td>
                                            <td class="text-right">
                                                <button class="btn btn-outline btn-sm" onclick="alert('Medicines:\n${p.medicines}\n\nInstructions:\n${p.instructions}')">Details</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="muted text-center" style="padding: 2rem;">No prescriptions issued yet.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
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
