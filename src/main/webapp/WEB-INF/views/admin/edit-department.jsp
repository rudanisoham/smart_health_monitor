<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "departments");
    request.setAttribute("pageTitle", "Edit Department");
    request.setAttribute("pageSubtitle", "Update department details and bed configuration");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Department · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">

            <div style="display:flex;gap:0.75rem;margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-outline btn-sm">← Back to Departments</a>
                <a href="${pageContext.request.contextPath}/admin/departments/${department.id}/view" class="btn btn-outline btn-sm">View Details</a>
            </div>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/departments/${department.id}/edit" method="post">
                <div class="card" style="max-width:860px;margin:0 auto;">
                    <div style="border-bottom:1px solid var(--border);padding-bottom:1.25rem;margin-bottom:1.5rem;">
                        <div class="section-title">Edit: ${department.name}</div>
                        <div class="section-subtitle">All fields are editable including bed capacity</div>
                    </div>

                    <!-- Basic Info -->
                    <div style="font-size:0.85rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:var(--text-muted);margin-bottom:1rem;">Basic Information</div>
                    <div class="form-grid form-2">
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="name">Department Name</label>
                            <input type="text" id="name" name="name" class="form-control" required value="${department.name}">
                        </div>
                        <div class="form-group">
                            <label for="code">Department Code</label>
                            <input type="text" id="code" name="code" class="form-control" required value="${department.code}">
                        </div>
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" class="form-select">
                                <option value="ACTIVE"    ${department.status == 'ACTIVE'    ? 'selected' : ''}>Active</option>
                                <option value="INACTIVE"  ${department.status == 'INACTIVE'  ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3">${department.description}</textarea>
                        </div>
                        <div class="form-group">
                            <label for="targetCapacity">Target Capacity</label>
                            <input type="number" id="targetCapacity" name="targetCapacity" class="form-control" min="1" required value="${department.targetCapacity}">
                        </div>
                        <div class="form-group">
                            <label for="headName">Department Head</label>
                            <input type="text" id="headName" name="headName" class="form-control" value="${department.headName}">
                        </div>
                        <div class="form-group">
                            <label for="physicalLocation">Physical Location</label>
                            <input type="text" id="physicalLocation" name="physicalLocation" class="form-control" value="${department.physicalLocation}">
                        </div>
                        <div class="form-group">
                            <label for="emergencyPhone">Emergency Phone</label>
                            <input type="text" id="emergencyPhone" name="emergencyPhone" class="form-control" value="${department.emergencyPhone}">
                        </div>
                    </div>

                    <!-- Bed Configuration -->
                    <div style="border-top:1px solid var(--border);margin-top:1.5rem;padding-top:1.5rem;">
                        <div style="font-size:0.85rem;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:var(--text-muted);margin-bottom:0.5rem;">🛏️ Bed Configuration</div>
                        <div style="font-size:0.875rem;color:var(--text-muted);margin-bottom:1rem;">
                            Changing bed counts will add new beds or remove excess <strong>available</strong> beds.
                            Occupied beds are never removed automatically.
                        </div>

                        <!-- Current status info -->
                        <div style="display:flex;gap:1rem;flex-wrap:wrap;margin-bottom:1.25rem;">
                            <div style="padding:0.6rem 1rem;background:#f8fafc;border-radius:8px;border:1px solid var(--border);font-size:0.875rem;">
                                Currently occupied: <strong style="color:#ef4444;">${department.occupiedBeds != null ? department.occupiedBeds : 0}</strong> beds
                                <span style="color:var(--text-muted);"> (cannot be removed)</span>
                            </div>
                        </div>

                        <div class="form-grid form-2">
                            <div class="form-group">
                                <label for="totalBeds">Total Beds</label>
                                <input type="number" id="totalBeds" name="totalBeds" class="form-control" min="0"
                                       value="${department.totalBeds != null ? department.totalBeds : 0}"
                                       oninput="validateBeds()">
                                <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Total number of beds in this department.</span>
                            </div>
                            <div class="form-group">
                                <label for="icuBeds">ICU Beds (included in total)</label>
                                <input type="number" id="icuBeds" name="icuBeds" class="form-control" min="0"
                                       value="${department.icuBeds != null ? department.icuBeds : 0}"
                                       oninput="validateBeds()">
                                <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Must be ≤ total beds. Remaining will be Normal beds.</span>
                            </div>
                        </div>

                        <!-- Live preview -->
                        <div id="bedPreview" style="padding:0.75rem 1rem;background:#eff6ff;border-radius:8px;border:1px solid #bfdbfe;font-size:0.875rem;margin-top:0.5rem;display:flex;gap:1.5rem;flex-wrap:wrap;">
                            <span>Normal beds: <strong id="previewNormal">0</strong></span>
                            <span>ICU beds: <strong id="previewIcu">0</strong></span>
                            <span>Total: <strong id="previewTotal">0</strong></span>
                        </div>
                        <div id="bedError" style="display:none;padding:0.6rem 1rem;background:rgba(239,68,68,0.1);border:1px solid #ef4444;border-radius:8px;color:#ef4444;font-size:0.875rem;margin-top:0.5rem;"></div>
                    </div>

                    <div style="border-top:1px solid var(--border);padding-top:1.5rem;margin-top:1.5rem;display:flex;justify-content:flex-end;gap:1rem;">
                        <a href="${pageContext.request.contextPath}/admin/departments" class="btn btn-outline">Cancel</a>
                        <button type="submit" id="submitBtn" class="btn btn-primary">Save All Changes</button>
                    </div>
                </div>
            </form>

        </div>

        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>
<script>
const occupiedBeds = ${department.occupiedBeds != null ? department.occupiedBeds : 0};

function validateBeds() {
    const total = parseInt(document.getElementById('totalBeds').value) || 0;
    const icu   = parseInt(document.getElementById('icuBeds').value)   || 0;
    const normal = total - icu;
    const errEl = document.getElementById('bedError');
    const submitBtn = document.getElementById('submitBtn');

    document.getElementById('previewNormal').textContent = Math.max(0, normal);
    document.getElementById('previewIcu').textContent    = icu;
    document.getElementById('previewTotal').textContent  = total;

    if (icu > total) {
        errEl.textContent = 'ICU beds cannot exceed total beds.';
        errEl.style.display = 'block';
        submitBtn.disabled = true;
        return;
    }
    if (total < occupiedBeds) {
        errEl.textContent = 'Total beds cannot be less than currently occupied beds (' + occupiedBeds + ').';
        errEl.style.display = 'block';
        submitBtn.disabled = true;
        return;
    }
    errEl.style.display = 'none';
    submitBtn.disabled = false;
}

// Run on load to show initial preview
validateBeds();
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
