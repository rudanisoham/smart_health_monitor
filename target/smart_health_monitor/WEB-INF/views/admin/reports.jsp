<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Platform Reports");
    request.setAttribute("pageSubtitle", "System analytics and financial overviews");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=5">
    <!-- Chart.js for rendering dynamic graphs -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            
            <div class="card" style="margin-bottom:2rem;">
                <div class="card-header border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 1.5rem;">
                    <div>
                        <div class="section-title">System Allocation Chart</div>
                        <div class="section-subtitle">Real-time breakdown of user roles and structural departments</div>
                    </div>
                </div>
                <div class="mt-4" style="height: 300px; max-width: 600px; margin: 0 auto; display: flex; justify-content: center;">
                    <canvas id="systemChart"></canvas>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">All Historical Appointments</div>
                        <div class="section-subtitle">Comprehensive ledger of all clinical meetings</div>
                    </div>
                    <div class="search-bar">
                        <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" placeholder="Search report ledger..." onkeyup="filterTable(this, 'reportTable')">
                    </div>
                </div>
                <div class="table-container mt-3">
                    <table id="reportTable">
                        <thead>
                        <tr>
                            <th>DateTime</th>
                            <th>Doctor</th>
                            <th>Patient</th>
                            <th>Status Result</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appt" items="${appointments}">
                                    <tr>
                                        <td class="muted">${appt.scheduledAt.toString().replace('T', ' ').substring(0,16)}</td>
                                        <td><strong>Dr. ${appt.doctor.user.fullName}</strong></td>
                                        <td>${appt.patient.user.fullName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">Confirmed</span></c:when>
                                                <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                                <c:otherwise><span class="chip-danger">${appt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="muted text-center" style="padding: 3rem;">No clinical appointments booked in the system history yet.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script>
    // Embedded script to initialize a dynamic chart using the backend DB numbers
    document.addEventListener("DOMContentLoaded", function () {
        const ctx = document.getElementById('systemChart').getContext('2d');
        const systemChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Registered Patients', 'Verified Doctors', 'Active Departments'],
                datasets: [{
                    label: 'System Metrics',
                    data: [${totalPatients}, ${totalDoctors}, ${activeDepartments}],
                    backgroundColor: [
                        '#2C5F2D', // Blue
                        '#97BC62', // Emerald
                        '#7A2048'  // Purple
                    ],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { color: '#94a3b8' }
                    }
                }
            }
        });
    });

    function filterTable(input, tableId) {
        let filter = input.value.toLowerCase();
        let table = document.getElementById(tableId);
        let tr = table.getElementsByTagName("tr");
        for (let i = 1; i < tr.length; i++) {
            let rowText = tr[i].innerText || tr[i].textContent;
            tr[i].style.display = rowText.toLowerCase().indexOf(filter) > -1 ? "" : "none";
        }
    }
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
