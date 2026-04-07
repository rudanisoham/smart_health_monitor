<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("activePage", "reports");
    request.setAttribute("pageTitle", "Report preview");
    request.setAttribute("pageSubtitle", "Quick look before exporting");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report preview · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <div class="card">
                <div class="section-title">Preview sample report</div>
                <p class="section-subtitle mt-1">
                    This is a static preview layout where you can later inject data from the backend.
                </p>
                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Metric</th>
                            <th>This month</th>
                            <th>Last month</th>
                            <th>Change</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>Total appointments</td>
                            <td>4,215</td>
                            <td>3,980</td>
                            <td><span class="chip">+5.9%</span></td>
                        </tr>
                        <tr>
                            <td>Admissions</td>
                            <td>1,920</td>
                            <td>1,845</td>
                            <td><span class="chip">+4.1%</span></td>
                        </tr>
                        <tr>
                            <td>Discharges</td>
                            <td>1,750</td>
                            <td>1,702</td>
                            <td><span class="chip-neutral">+2.8%</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="mt-4 flex justify-between items-center">
                    <a href="<%= request.getContextPath() %>/admin/reports" class="text-xs text-muted">Back to reports</a>
                    <button type="button" class="btn btn-primary">Export this report</button>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js"></script>
</body>
</html>



