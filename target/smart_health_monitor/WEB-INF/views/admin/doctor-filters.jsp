<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("activePage", "doctors");
    request.setAttribute("pageTitle", "Doctor filters");
    request.setAttribute("pageSubtitle", "Save and reuse filter presets");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor filters · Smart Health Monitor</title>
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
                <div class="section-title">Create filter preset</div>
                <p class="section-subtitle mt-1">
                    Define common combinations (specialty, department, status) and apply them quickly on the doctors page.
                </p>
                <form action="#" method="post" class="form-grid form-2 mt-3">
                    <div class="form-group">
                        <label for="presetName">Preset name</label>
                        <input id="presetName" class="form-control" type="text" placeholder="On‑duty cardiologists">
                    </div>
                    <div class="form-group">
                        <label for="presetSpecialty">Specialty</label>
                        <input id="presetSpecialty" class="form-control" type="text" placeholder="Cardiology">
                    </div>
                    <div class="form-group">
                        <label for="presetDept">Department</label>
                        <select id="presetDept" class="form-select">
                            <option>Any</option>
                            <option>Cardiology</option>
                            <option>Emergency</option>
                            <option>Pediatrics</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-select">
                            <option>Any</option>
                            <option>On duty</option>
                            <option>Off duty</option>
                        </select>
                    </div>
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <div class="flex justify-between items-center">
                            <a href="<%= request.getContextPath() %>/admin/doctors" class="text-xs text-muted">Back to doctors list</a>
                            <button type="submit" class="btn btn-primary">Save preset</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js"></script>
</body>
</html>



