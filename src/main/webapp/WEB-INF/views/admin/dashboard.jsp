<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "dashboard");
    request.setAttribute("pageTitle", "Admin Dashboard");
    request.setAttribute("pageSubtitle", "System overview and realtime metrics");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div class="grid grid-4" style="margin-bottom: 2rem;">
                <div class="card">
                    <div class="card-title">Total Patients</div>
                    <div class="card-value">${totalPatients != null ? totalPatients : 0}</div>
                    <div class="muted mt-1 text-xs">Registered in system</div>
                </div>
                <div class="card">
                    <div class="card-title">Verified Doctors</div>
                    <div class="card-value" style="color: #3b82f6;">${totalDoctors != null ? totalDoctors : 0}</div>
                    <div class="muted mt-1 text-xs">Active practitioners</div>
                </div>
                <div class="card">
                    <div class="card-title">Total Appointments</div>
                    <div class="card-value" style="color: #10b981;">${totalAppointments != null ? totalAppointments : 0}</div>
                    <div class="muted mt-1 text-xs">Over all time</div>
                </div>
                <div class="card">
                    <div class="card-title">Departments</div>
                    <div class="card-value" style="color: #8b5cf6;">${activeDepartments != null ? activeDepartments : 0}</div>
                    <div class="muted mt-1 text-xs">Hospital units</div>
                </div>
            </div>

            <div class="grid grid-2">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Quick Actions</div>
                            <div class="section-subtitle">Common administrative tasks</div>
                        </div>
                    </div>
                    <div class="mt-3" style="display:flex; flex-direction:column; gap:0.5rem;">
                        <a href="<%= request.getContextPath() %>/admin/doctors/requests" class="btn btn-outline" style="justify-content:flex-start;">
                            <span style="margin-right:0.5rem;">🛎️</span> Review Pending Doctors
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/doctors/add" class="btn btn-outline" style="justify-content:flex-start;">
                            <span style="margin-right:0.5rem;">👨‍⚕️</span> Register New Doctor
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/departments/add" class="btn btn-outline" style="justify-content:flex-start;">
                            <span style="margin-right:0.5rem;">🏥</span> Add Department
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/patients/add" class="btn btn-outline" style="justify-content:flex-start;">
                            <span style="margin-right:0.5rem;">👥</span> Register Patient On-Site
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Recent System Logs</div>
                            <div class="section-subtitle">Auditing and security trails</div>
                        </div>
                        <a href="<%= request.getContextPath() %>/admin/logs" class="btn btn-outline btn-sm">View all</a>
                    </div>
                    <div class="mt-2" style="max-height: 250px; overflow-y: auto;">
                        <c:choose>
                            <c:when test="${not empty recentLogs}">
                                <c:forEach var="log" items="${recentLogs}" begin="0" end="4">
                                    <div style="padding:0.75rem; border-bottom:1px solid rgba(255,255,255,0.05);">
                                        <div style="display:flex; justify-content:space-between; margin-bottom:0.25rem;">
                                            <span style="font-weight:600; font-size:0.9rem;">${log.action}</span>
                                            <span class="muted text-xs">${log.timestamp.toString().replace('T',' ').substring(0,16)}</span>
                                        </div>
                                        <div class="muted text-xs">By: ${log.performedBy}</div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="muted text-center" style="padding: 2rem;">No system logs generated yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
