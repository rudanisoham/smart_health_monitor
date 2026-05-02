<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patient-entry");
    request.setAttribute("pageTitle", "Patient Entry");
    request.setAttribute("pageSubtitle", "Register or assign patients to departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Entry · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <aside class="admin-sidebar">
        <div class="sidebar-header">
            <h3>Reception Portal</h3>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/reception/dashboard" class="nav-item ${activePage == 'dashboard' ? 'active' : ''}">
                <span>🏠 Dashboard</span>
            </a>
            <a href="<%= request.getContextPath() %>/reception/patient-entry" class="nav-item ${activePage == 'patient-entry' ? 'active' : ''}">
                <span>👥 Patient Entry & Assignment</span>
            </a>
            <a href="<%= request.getContextPath() %>/auth/logout" class="nav-item" style="margin-top:auto; color:#ef4444;">
                <span>🚪 Logout</span>
            </a>
        </nav>
    </aside>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>
        <div class="admin-content">
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <div class="card">
                    <div class="card-header">
                        <div class="section-title">Assign Existing Patient</div>
                    </div>
                    <form action="<%= request.getContextPath() %>/reception/patient-entry/assign" method="post" class="mt-3">
                        <style>
                            .searchable-dropdown { position: relative; }
                            .dropdown-list {
                                position: absolute; top: calc(100% + 5px); left: 0; right: 0;
                                background: white; border: 1px solid #e2e8f0;
                                border-radius: 12px; max-height: 250px; overflow-y: auto; z-index: 1000;
                                box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1);
                                display: none;
                            }
                            .dropdown-item {
                                padding: 0.75rem 1rem; cursor: pointer;
                                border-bottom: 1px solid #f8fafc;
                            }
                            .dropdown-item:hover { background: #f1f5f9; }
                            .dropdown-item-title { font-weight: 600; color: #1e293b; font-size: 0.9rem; }
                            .dropdown-item-subtitle { color: #64748b; font-size: 0.75rem; }
                        </style>

                        <div class="form-group mb-3">
                            <label class="form-label">Select Patient</label>
                            <div class="searchable-dropdown">
                                <input type="text" id="patientSearch" class="form-control" placeholder="Search patient name or ID..." autocomplete="off" onfocus="toggleDrop('patientList', true)" oninput="filterDrop('patientList', 'patientSearch')">
                                <input type="hidden" id="patientId" name="patientId" required>
                                <div id="patientList" class="dropdown-list">
                                    <c:forEach var="p" items="${patients}">
                                        <div class="dropdown-item p-opt" data-id="${p.id}" data-search="${p.user.fullName} ${p.id}" onclick="setVal('patientId', 'patientSearch', '${p.id}', '${p.user.fullName}', 'patientList')">
                                            <div class="dropdown-item-title">${p.user.fullName}</div>
                                            <div class="dropdown-item-subtitle">Patient ID: ${p.id} • ${p.user.email}</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mb-4">
                            <label class="form-label">Assign to Department</label>
                            <div class="searchable-dropdown">
                                <input type="text" id="deptSearch" class="form-control" placeholder="Search department..." autocomplete="off" onfocus="toggleDrop('deptList', true)" oninput="filterDrop('deptList', 'deptSearch')">
                                <input type="hidden" id="departmentId" name="departmentId" required>
                                <div id="deptList" class="dropdown-list">
                                    <c:forEach var="d" items="${departments}">
                                        <div class="dropdown-item d-opt" data-id="${d.id}" data-search="${d.name}" onclick="setVal('departmentId', 'deptSearch', '${d.id}', '${d.name}', 'deptList')">
                                            <div class="dropdown-item-title">${d.name}</div>
                                            <div class="dropdown-item-subtitle">${d.availableBeds} beds available</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-full">Assign Patient</button>
                    </form>

                    <script>
                        function toggleDrop(id, show) {
                            document.getElementById(id).style.display = show ? 'block' : 'none';
                        }
                        function filterDrop(listId, inputId) {
                            const q = document.getElementById(inputId).value.toLowerCase();
                            const items = document.getElementById(listId).querySelectorAll('.dropdown-item');
                            items.forEach(it => {
                                it.style.display = it.getAttribute('data-search').toLowerCase().includes(q) ? 'block' : 'none';
                            });
                        }
                        function setVal(hidId, txtId, val, name, listId) {
                            document.getElementById(hidId).value = val;
                            document.getElementById(txtId).value = name;
                            toggleDrop(listId, false);
                        }
                        document.addEventListener('click', e => {
                            if (!e.target.closest('.searchable-dropdown')) {
                                document.querySelectorAll('.dropdown-list').forEach(l => l.style.display = 'none');
                            }
                        });
                    </script>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <div class="section-title">Register New Patient</div>
                    </div>
                    <div class="mt-3">
                        <p class="muted">To register a completely new patient into the system, direct them to the self-registration portal or use the admin capabilities.</p>
                        <a href="<%= request.getContextPath() %>/auth/patient/register" class="btn btn-outline" target="_blank">Open Registration Portal</a>
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
