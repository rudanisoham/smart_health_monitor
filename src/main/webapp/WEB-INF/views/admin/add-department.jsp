<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "departments");
    request.setAttribute("pageTitle", "Create Department");
    request.setAttribute("pageSubtitle", "Add a new specialized unit to the hospital network");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Department · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-outline btn-sm">← Back to Departments</a>
            </div>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/departments/add" method="post">
                <div class="card" style="max-width:860px;margin:0 auto;">
                    <div class="card-header" style="border-bottom:1px solid var(--border);padding-bottom:1.5rem;">
                        <div>
                            <div class="section-title">Department Details</div>
                            <div class="section-subtitle">Unit operations, capacity, and bed configuration</div>
                        </div>
                    </div>

                    <div style="padding:1.5rem 0;">
                        <div class="form-grid form-2">
                            <div class="form-group" style="grid-column:1/-1;">
                                <label for="name">Department Name</label>
                                <input type="text" id="name" name="name" class="form-control" required placeholder="e.g. Cardiology Wing">
                            </div>
                            <div class="form-group">
                                <label for="code">Department Code</label>
                                <input type="text" id="code" name="code" class="form-control" required placeholder="e.g. CARD">
                            </div>
                            <div class="form-group">
                                <label for="targetCapacity">Target Capacity</label>
                                <input type="number" id="targetCapacity" name="targetCapacity" class="form-control" min="1" required placeholder="50">
                                <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Max concurrent active cases.</span>
                            </div>
                            <div class="form-group" style="grid-column:1/-1;">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" class="form-control" rows="3" placeholder="Services rendered in this department..."></textarea>
                            </div>

                            <!-- Bed Configuration Section -->
                            <div style="grid-column:1/-1;margin-top:0.5rem;">
                                <div style="font-size:1rem;font-weight:700;color:var(--text-main);margin-bottom:0.25rem;">🛏️ Bed Configuration</div>
                                <div style="font-size:0.875rem;color:var(--text-muted);margin-bottom:1rem;">Individual bed records will be auto-created based on these numbers. Reception can then assign patients to specific beds.</div>
                            </div>
                            <div class="form-group">
                                <label for="totalBeds">Total Beds</label>
                                <input type="number" id="totalBeds" name="totalBeds" class="form-control" min="0" value="0" placeholder="0" oninput="updateIcuMax()">
                                <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Total number of beds in this department.</span>
                            </div>
                            <div class="form-group">
                                <label for="icuBeds">ICU Beds (included in total)</label>
                                <input type="number" id="icuBeds" name="icuBeds" class="form-control" min="0" value="0" placeholder="0">
                                <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Must be ≤ total beds. Remaining will be Normal beds.</span>
                            </div>

                            <!-- Optional fields -->
                            <div class="form-group">
                                <label for="headName">Department Head</label>
                                <input type="text" id="headName" name="headName" class="form-control" placeholder="Dr. Name">
                            </div>
                            <div class="form-group">
                                <label for="physicalLocation">Physical Location</label>
                                <input type="text" id="physicalLocation" name="physicalLocation" class="form-control" placeholder="e.g. Block B, Floor 2">
                            </div>
                            <div class="form-group">
                                <label for="emergencyPhone">Emergency Phone</label>
                                <input type="text" id="emergencyPhone" name="emergencyPhone" class="form-control" placeholder="+91-9000000001">
                            </div>
                        </div>
                    </div>

                    <div style="border-top:1px solid var(--border);padding-top:1.5rem;display:flex;justify-content:flex-end;gap:1rem;">
                        <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-outline">Cancel</a>
                        <button type="submit" class="btn btn-primary">Create Department & Generate Beds</button>
                    </div>
                </div>
            </form>
        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script>
function updateIcuMax() {
    const total = parseInt(document.getElementById('totalBeds').value) || 0;
    const icuInput = document.getElementById('icuBeds');
    icuInput.max = total;
    if (parseInt(icuInput.value) > total) icuInput.value = total;
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
