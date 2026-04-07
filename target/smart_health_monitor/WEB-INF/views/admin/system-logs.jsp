<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "logs");
    request.setAttribute("pageTitle", "System Logs");
    request.setAttribute("pageSubtitle", "Security audit trails and tracking");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Logs · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=5">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">Audit Trail</div>
                        <div class="section-subtitle">Real-time system events</div>
                    </div>
                    <div class="search-bar">
                        <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        <input type="text" placeholder="Search logs..." onkeyup="filterTable(this, 'logsTable')">
                    </div>
                </div>
                
                <div class="table-container mt-3">
                    <table id="logsTable">
                        <thead>
                        <tr>
                            <th>Level/Action</th>
                            <th>Description</th>
                            <th>Performed By</th>
                            <th class="text-right">Timestamp</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty logs}">
                                <c:forEach var="log" items="${logs}">
                                    <tr>
                                        <td>
                                            <div style="display:flex; align-items:center; gap:0.5rem;">
                                                <div style="width:8px;height:8px;border-radius:50%;background:${log.level == 'INFO' ? '#3b82f6' : (log.level == 'WARN' ? '#f59e0b' : '#ef4444')};"></div>
                                                <span style="font-family:monospace; font-size:0.85rem;" class="${log.level == 'WARN' ? 'text-warning' : (log.level == 'ERROR' ? 'text-danger' : '')}">${log.level}</span>
                                            </div>
                                        </td>
                                        <td style="font-weight: 500;">${log.action}</td>
                                        <td class="muted">${log.performedBy}</td>
                                        <td class="text-right muted text-sm">${log.timestamp.toString().replace('T',' ').substring(0,19)}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="muted text-center" style="padding: 3rem;">Logging hasn't initialized any records yet.</td>
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
