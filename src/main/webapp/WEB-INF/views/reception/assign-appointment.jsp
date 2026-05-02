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

                <!-- Right: Assignment & Availability -->
                <div class="card">
                    <c:if test="${appointment.doctor != null}">
                        <div style="padding:1rem; background:#fff7ed; border:1px solid #fed7aa; border-radius:12px; margin-bottom:1.5rem;">
                            <div style="display:flex; justify-content:space-between; align-items:start;">
                                <div style="flex:1;">
                                    <div style="color:#9a3412; font-size:0.85rem; font-weight:700; text-transform:uppercase; letter-spacing:0.5px;">Patient's Choice</div>
                                    <h4 style="color:#ea580c; font-size:1.15rem; margin:0.25rem 0;">Dr. ${appointment.doctor.user.fullName}</h4>
                                    <p style="font-size:0.875rem; color:#c2410c; margin-top:0.25rem;">Specialty: ${appointment.doctor.specialty != null ? appointment.doctor.specialty : 'General'}</p>
                                </div>
                                <div style="background:#ffedd5; padding:0.5rem; border-radius:8px;">
                                    <svg width="24" height="24" fill="none" stroke="#ea580c" stroke-width="2"><path d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="section-title">Assign Doctor & Schedule</div>
                    <div class="section-subtitle mt-1">Select doctor, set time — token is auto-generated</div>

                    <form action="${pageContext.request.contextPath}/reception/appointments/${appointment.id}/assign" method="post" class="form-grid mt-3">
                        <style>
                            .searchable-dropdown { position: relative; }
                            .dropdown-list {
                                position: absolute; top: calc(100% + 5px); left: 0; right: 0;
                                background: white; border: 1px solid #e2e8f0;
                                border-radius: 16px; max-height: 320px; overflow-y: auto; z-index: 1000;
                                box-shadow: 0 15px 40px -10px rgba(0,0,0,0.12), 0 10px 20px -10px rgba(0,0,0,0.08);
                                display: none; transition: all 0.2s;
                            }
                            .dropdown-item {
                                padding: 0.9rem 1.25rem; cursor: pointer;
                                transition: all 0.2s; border-bottom: 1px solid #f8fafc;
                            }
                            .dropdown-item:last-child { border-bottom: none; }
                            .dropdown-item:hover { background: #f1f5f9; }
                            .dropdown-item.active { background: #eff6ff; }
                            .dropdown-item-title { font-weight: 700; color: #1e293b; font-size: 0.95rem; line-height: 1.4; }
                            .dropdown-item-subtitle { color: #64748b; font-size: 0.8rem; margin-top: 0.15rem; }
                            .form-control { border-radius: 12px !important; }
                        </style>

                        <div class="form-group" style="grid-column:1/-1;">
                            <label>Quick Filters</label>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.75rem; margin-bottom:0.75rem;">
                                <select id="filterSpecialty" class="form-control" onchange="filterSearchDropdown()">
                                    <option value="">All Specialties</option>
                                    <c:forEach var="spec" items="${specialties}">
                                        <option value="${spec}">${spec}</option>
                                    </c:forEach>
                                </select>
                                <select id="filterDepartment" class="form-control" onchange="filterSearchDropdown()">
                                    <option value="">All Departments</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.name}">${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <label for="doctorSearch">Confirm / Select Doctor</label>
                            <div class="searchable-dropdown">
                                <input type="text" id="doctorSearch" class="form-control" 
                                       placeholder="Search by doctor name or keywords..." 
                                       autocomplete="off"
                                       value="Dr. ${appointment.doctor.user.fullName}"
                                       onfocus="toggleDropdown(true)" 
                                       oninput="filterSearchDropdown()">
                                <input type="hidden" id="doctorId" name="doctorId" value="${appointment.doctor.id}">
                                <svg style="position:absolute; right:14px; top:50%; transform:translateY(-50%); color:#94a3b8; pointer-events:none;" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                                
                                <div id="doctorDropdownList" class="dropdown-list">
                                    <c:forEach var="doc" items="${doctors}">
                                        <div class="dropdown-item doctor-opt" 
                                             data-id="${doc.id}"
                                             data-name="Dr. ${doc.user.fullName}"
                                             data-specialty="${doc.specialty}"
                                             data-dept="${doc.department != null ? doc.department.name : ''}"
                                             data-available-days="${doc.availableDays}"
                                             data-search="Dr. ${doc.user.fullName} ${doc.specialty} ${doc.department.name}"
                                             onclick="selectDoctor('${doc.id}', 'Dr. ${doc.user.fullName}', '${doc.availableDays}')">
                                            <div class="dropdown-item-title">Dr. ${doc.user.fullName}</div>
                                            <div class="dropdown-item-subtitle">${doc.specialty} <c:if test="${doc.department != null}">• ${doc.department.name}</c:if></div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="scheduledAt">Appointment Date & Time</label>
                            <input type="datetime-local" id="scheduledAt" name="scheduledAt" class="form-control"
                                   required min="<%= minDt %>"
                                   value="${appointment.preferredDate != null ? appointment.preferredDate.toString().concat('T09:00') : ''}"
                                   onchange="filterDoctorsByDate(); updateTokenPreview();">
                        </div>

                        <!-- Token Preview -->
                        <div id="tokenPreview" style="display:none;padding:0.875rem 1rem;background:#eff6ff;border-radius:8px;border:1px solid #bfdbfe;font-size:0.875rem;margin-bottom:1rem;">
                            <div style="font-weight:700;color:#1d4ed8;margin-bottom:0.25rem;">Token Preview</div>
                            <div>Token #: <strong id="previewToken">—</strong></div>
                            <div>Estimated arrival: <strong id="previewEst">—</strong></div>
                        </div>

                        <div style="display:flex;gap:1rem;margin-top:0.5rem;">
                            <button type="submit" class="btn btn-primary" style="flex:1;">✓ Assign & Payment</button>
                        </div>
                    </form>

                    <div style="margin-top:2rem; padding-top:1.5rem; border-top:1px solid #e2e8f0;">
                        <details style="background:#f8fafc; border-radius:8px; border:1px solid #e2e8f0;">
                            <summary style="padding:1rem; cursor:pointer; font-weight:600; color:#475569; user-select:none;">
                                ⚠️ Doctor Unavailable? Suggest Reschedule
                            </summary>
                            <div style="padding:0 1rem 1rem 1rem;">
                                <p style="font-size:0.85rem; color:#64748b; margin-bottom:1rem;">If the patient's selected doctor is busy or not available on the requested date, use this form to notify them.</p>
                                <form action="${pageContext.request.contextPath}/reception/appointments/${appointment.id}/notify-unavailable" method="post">
                                    <div class="form-group">
                                        <label>Next Available From</label>
                                        <input type="date" name="availableFrom" class="form-control" required min="<%= minDt.substring(0,10) %>">
                                    </div>
                                    <div class="form-group">
                                        <label>Short Message to Patient</label>
                                        <textarea name="message" class="form-control" rows="2" placeholder="e.g. Doctor is in surgery today. Available from tomorrow morning."></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-outline btn-sm w-full" style="color:#d97706; border-color:#d97706; justify-content:center;">Send Reschedule Notice</button>
                                </form>
                            </div>
                        </details>
                    </div>
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
function toggleDropdown(show) {
    const list = document.getElementById('doctorDropdownList');
    if (show) {
        list.style.display = 'block';
        filterSearchDropdown(); 
    } else {
        setTimeout(() => { list.style.display = 'none'; }, 200);
    }
}

function filterSearchDropdown() {
    const query = document.getElementById('doctorSearch').value.toLowerCase();
    const specFilter = document.getElementById('filterSpecialty').value;
    const deptFilter = document.getElementById('filterDepartment').value;
    
    const items = document.querySelectorAll('.doctor-opt');
    items.forEach(item => {
        const searchTerms = item.getAttribute('data-search').toLowerCase();
        const specialty = item.getAttribute('data-specialty');
        const dept = item.getAttribute('data-dept');
        
        const matchesSearch = searchTerms.includes(query);
        const matchesSpec = specFilter === "" || specialty === specFilter;
        const matchesDept = deptFilter === "" || dept === deptFilter;
        
        item.style.display = (matchesSearch && matchesSpec && matchesDept) ? 'block' : 'none';
    });
}

function selectDoctor(id, name, availableDays) {
    document.getElementById('doctorId').value = id;
    document.getElementById('doctorSearch').value = name;
    toggleDropdown(false);
    
    // Original logic: Show schedule and check availability
    showSchedule(id);
    filterDoctorsByDate();
}

document.addEventListener('click', function(e) {
    if (!e.target.closest('.searchable-dropdown')) {
        document.getElementById('doctorDropdownList').style.display = 'none';
    }
});

function filterDoctorsByDate() {
    const dtVal = document.getElementById('scheduledAt').value;
    if (!dtVal) return;

    const date = new Date(dtVal);
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const selectedDay = days[date.getDay()];

    const doctorId = document.getElementById('doctorId').value;
    const items = document.querySelectorAll('.doctor-opt');
    let selectedStillValid = (doctorId === "");

    items.forEach(item => {
        const availableDays = item.getAttribute('data-available-days') || "";
        if (availableDays.includes(selectedDay)) {
            item.style.opacity = "1";
            item.style.pointerEvents = "auto";
            if (item.getAttribute('data-id') === doctorId) selectedStillValid = true;
        } else {
            item.style.opacity = "0.4";
            if (item.getAttribute('data-id') === doctorId) { /* Invalid */ }
        }
    });

    if (doctorId !== "" && !selectedStillValid) {
        alert("Note: " + document.getElementById('doctorSearch').value + " is not scheduled to work on " + selectedDay + ". Please select another doctor or date.");
        document.getElementById('doctorId').value = "";
        document.getElementById('doctorSearch').value = "";
        showSchedule("");
    }
}

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

    const doctorName = document.getElementById('doctorSearch').value;
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

    // Auto-advance the time based on the doctor's existing schedule
    autoAdvanceScheduleTime(appts);

    updateTokenPreview();
}

function autoAdvanceScheduleTime(appts) {
    if (appts.length === 0) return;
    
    // Find the latest appointment time among the existing appointments
    let latestTimeMs = 0;
    appts.forEach(a => {
        if (a.time !== '—') {
            const t = new Date(a.time.replace(' ', 'T')).getTime();
            if (!isNaN(t) && t > latestTimeMs) latestTimeMs = t;
        }
    });
    
    if (latestTimeMs > 0) {
        // Add 20 mins to the latest appointment
        const nextTime = new Date(latestTimeMs + 20 * 60000);
        
        // Format for datetime-local: YYYY-MM-DDThh:mm
        const ft = nextTime.getFullYear() + '-' +
            String(nextTime.getMonth()+1).padStart(2,'0') + '-' +
            String(nextTime.getDate()).padStart(2,'0') + 'T' +
            String(nextTime.getHours()).padStart(2,'0') + ':' +
            String(nextTime.getMinutes()).padStart(2,'0');
            
        document.getElementById('scheduledAt').value = ft;
    }
}

function updateTokenPreview() {
    const doctorId = document.getElementById('doctorId').value;
    const dtVal    = document.getElementById('scheduledAt').value;
    if (!doctorId || !dtVal) { document.getElementById('tokenPreview').style.display = 'none'; return; }

    const selectedDateStr = dtVal.substring(0, 10);
    const targetDateStr = '${targetDate}';
    const isTargetDate = selectedDateStr === targetDateStr;
    const dt = new Date(dtVal);

    // Estimated time is EXACTLY what is in the scheduled field now
    const estStr = dt.getFullYear() + '-' +
        String(dt.getMonth()+1).padStart(2,'0') + '-' +
        String(dt.getDate()).padStart(2,'0') + ' ' +
        String(dt.getHours()).padStart(2,'0') + ':' +
        String(dt.getMinutes()).padStart(2,'0');

    if (isTargetDate) {
        const appts = scheduleMap[doctorId] || [];
        let maxToken = 0;
        appts.forEach(a => {
            const t = parseInt(a.token);
            if (!isNaN(t) && t > maxToken) {
                maxToken = t;
            }
        });
        const nextToken = maxToken + 1;
        document.getElementById('previewToken').textContent = nextToken;
        document.getElementById('previewEst').textContent   = estStr;
        document.getElementById('tokenPreview').style.display = 'block';
    } else {
        // Fetch max token dynamically for the new date!
        const apiUrl = '<%= request.getContextPath() %>/reception/api/maxToken?doctorId=' + doctorId + '&date=' + selectedDateStr;
        fetch(apiUrl)
            .then(res => res.json())
            .then(data => {
                const nextToken = (data.maxToken || 0) + 1;
                
                let nextTimeStr = estStr;
                if (data.latestTime) {
                    const latestMs = new Date(data.latestTime).getTime();
                    const nextTime = new Date(latestMs + 20 * 60000);
                    nextTimeStr = nextTime.getFullYear() + '-' +
                        String(nextTime.getMonth()+1).padStart(2,'0') + '-' +
                        String(nextTime.getDate()).padStart(2,'0') + ' ' +
                        String(nextTime.getHours()).padStart(2,'0') + ':' +
                        String(nextTime.getMinutes()).padStart(2,'0');
                    document.getElementById('scheduledAt').value = nextTimeStr.replace(' ', 'T');
                } else {
                    // Blank day! Reset to 09:00 AM.
                    const resetTime = selectedDateStr + 'T09:00';
                    document.getElementById('scheduledAt').value = resetTime;
                    nextTimeStr = selectedDateStr + ' 09:00';
                }

                document.getElementById('previewToken').textContent = nextToken;
                document.getElementById('previewEst').textContent   = nextTimeStr;
                document.getElementById('tokenPreview').style.display = 'block';
            })
            .catch(err => {
                document.getElementById('previewToken').textContent = "Auto on save";
                document.getElementById('previewEst').textContent   = estStr;
                document.getElementById('tokenPreview').style.display = 'block';
            });
    }
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
