<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Assign Appointment");
    request.setAttribute("pageSubtitle", "Assign doctor, check schedule and generate token");
    String minDt = java.time.LocalDateTime.now().withSecond(0).withNano(0).toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Appointment · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">

            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-outline btn-sm">← Back to Queue</a>
            </div>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="grid grid-2" style="margin-bottom:1.5rem;">
                <!-- Patient Info -->
                <div class="card">
                    <div class="section-title">Patient Details</div>
                    <div class="section-subtitle mt-1">Appointment request information</div>
                    <div class="mt-3">
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Full Name</span>
                                <span class="stat-value" style="font-size:1rem;">${appointment.patient.user.fullName}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Email</span>
                                <span class="stat-value" style="font-size:0.9rem;">${appointment.patient.user.email}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Phone</span>
                                <span class="stat-value" style="font-size:0.9rem;">${appointment.patient.user.phone != null ? appointment.patient.user.phone : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Blood Group</span>
                                <span class="stat-value" style="font-size:0.9rem;">${appointment.patient.bloodGroup != null ? appointment.patient.bloodGroup : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Preferred Date</span>
                                <span class="stat-value" style="font-size:0.9rem;color:#1d4ed8;font-weight:700;">
                                    <c:choose>
                                        <c:when test="${appointment.preferredDate != null}">${appointment.preferredDate}</c:when>
                                        <c:otherwise>Not specified</c:otherwise>
                                    </c:choose>
                                </span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Preferred Time</span>
                                <span class="stat-value" style="font-size:0.9rem;">${not empty appointment.preferredDateNote ? appointment.preferredDateNote : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Reason / Symptoms</span>
                                <span class="stat-value" style="font-size:0.9rem;">${not empty appointment.notes ? appointment.notes : '—'}</span></div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-info"><span class="stat-label">Requested On</span>
                                <span class="stat-value" style="font-size:0.9rem;">${appointment.createdAt.toString().replace('T',' ').substring(0,16)}</span></div>
                        </div>
                    </div>
                </div>

                <!-- Assignment Form -->
                <div class="card">
                    <div class="section-title">Assign Doctor & Schedule</div>
                    <div class="section-subtitle mt-1">Select doctor, set time — token is auto-generated</div>

                    <form action="${pageContext.request.contextPath}/reception/appointments/${appointment.id}/assign" method="post" class="form-grid mt-3">
                        <div class="form-group">
                            <label for="doctorId">Select Doctor</label>
                            <select id="doctorId" name="doctorId" class="form-select" required onchange="showSchedule(this.value)">
                                <option value="">-- Choose a Doctor --</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}">
                                        Dr. ${doc.user.fullName}
                                        <c:if test="${doc.specialty != null}"> — ${doc.specialty}</c:if>
                                        <c:if test="${doc.department != null}"> (${doc.department.name})</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="scheduledAt">Appointment Date & Time</label>
                            <input type="datetime-local" id="scheduledAt" name="scheduledAt" class="form-control"
                                   required min="<%= minDt %>"
                                   value="${appointment.preferredDate != null ? appointment.preferredDate.toString().concat('T09:00') : ''}"
                                   onchange="updateTokenPreview()">
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">
                                Patient prefers: <strong>
                                    <c:choose>
                                        <c:when test="${appointment.preferredDate != null}">${appointment.preferredDate}</c:when>
                                        <c:otherwise>No date preference</c:otherwise>
                                    </c:choose>
                                </strong>
                                <c:if test="${not empty appointment.preferredDateNote}"> · ${appointment.preferredDateNote}</c:if>
                            </span>
                        </div>

                        <!-- Token Preview -->
                        <div id="tokenPreview" style="display:none;padding:0.875rem 1rem;background:#eff6ff;border-radius:8px;border:1px solid #bfdbfe;font-size:0.875rem;">
                            <div style="font-weight:700;color:#1d4ed8;margin-bottom:0.25rem;">Token Preview</div>
                            <div>Token #: <strong id="previewToken">—</strong></div>
                            <div>Estimated arrival: <strong id="previewEst">—</strong></div>
                            <div class="muted" style="font-size:0.78rem;margin-top:0.25rem;">Based on existing appointments for this doctor on the selected date (20 min/slot)</div>
                        </div>

                        <div style="display:flex;gap:1rem;margin-top:0.5rem;">
                            <button type="submit" class="btn btn-primary" style="flex:1;">✓ Assign & Generate Token</button>
                            <a href="${pageContext.request.contextPath}/reception/appointments" class="btn btn-outline" style="flex:1;text-align:center;">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Doctor Schedule Panel -->
            <div class="card" id="schedulePanel" style="display:none;">
                <div class="card-header">
                    <div>
                        <div class="section-title" id="scheduleTitle">Doctor's Schedule</div>
                        <div class="section-subtitle">Existing appointments on the selected date</div>
                    </div>
                    <span id="scheduleDateBadge" class="chip-neutral"></span>
                </div>
                <div id="scheduleContent" class="table-container mt-2">
                    <table>
                        <thead><tr><th>Token</th><th>Time</th><th>Patient</th><th>Status</th></tr></thead>
                        <tbody id="scheduleBody">
                            <tr><td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">Select a doctor to view schedule.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>

<script>
// Build schedule data from server-side model
const scheduleMap = {};
<c:forEach var="entry" items="${scheduleMap}">
scheduleMap['${entry.key}'] = [
    <c:forEach var="appt" items="${entry.value}" varStatus="vs">
    {
        token: '${appt.tokenNumber != null ? appt.tokenNumber : "—"}',
        time: '${appt.scheduledAt != null ? appt.scheduledAt.toString().replace("T"," ").substring(0,16) : "—"}',
        patient: '${appt.patient.user.fullName}',
        status: '${appt.status}'
    }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
];
</c:forEach>

function showSchedule(doctorId) {
    const panel = document.getElementById('schedulePanel');
    const body  = document.getElementById('scheduleBody');
    const title = document.getElementById('scheduleTitle');

    if (!doctorId) { panel.style.display = 'none'; return; }

    const sel = document.getElementById('doctorId');
    const doctorName = sel.options[sel.selectedIndex].text;
    title.textContent = doctorName + " — Schedule";
    panel.style.display = 'block';

    const appts = scheduleMap[doctorId] || [];
    const dateInput = document.getElementById('scheduledAt').value;
    const dateStr = dateInput ? dateInput.substring(0, 10) : '${targetDate}';
    document.getElementById('scheduleDateBadge').textContent = dateStr;

    if (appts.length === 0) {
        body.innerHTML = '<tr><td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">No appointments on this date. Doctor is free!</td></tr>';
    } else {
        body.innerHTML = appts.map(a => {
            const statusClass = a.status === 'CONFIRMED' ? 'chip' : a.status === 'CANCELLED' ? 'chip-danger' : 'chip-warning';
            return '<tr><td><strong>#' + a.token + '</strong></td><td>' + a.time + '</td><td>' + a.patient + '</td><td><span class="' + statusClass + '">' + a.status + '</span></td></tr>';
        }).join('');
    }

    updateTokenPreview();
}

function updateTokenPreview() {
    const doctorId = document.getElementById('doctorId').value;
    const dtVal    = document.getElementById('scheduledAt').value;
    if (!doctorId || !dtVal) { document.getElementById('tokenPreview').style.display = 'none'; return; }

    const appts = scheduleMap[doctorId] || [];
    const nextToken = appts.length + 1;
    const dt = new Date(dtVal);
    const estDt = new Date(dt.getTime() + (nextToken - 1) * 20 * 60000);
    const estStr = estDt.getFullYear() + '-' +
        String(estDt.getMonth()+1).padStart(2,'0') + '-' +
        String(estDt.getDate()).padStart(2,'0') + ' ' +
        String(estDt.getHours()).padStart(2,'0') + ':' +
        String(estDt.getMinutes()).padStart(2,'0');

    document.getElementById('previewToken').textContent = nextToken;
    document.getElementById('previewEst').textContent   = estStr;
    document.getElementById('tokenPreview').style.display = 'block';
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
