<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "reminders");
    request.setAttribute("pageTitle", "Health Reminders");
    request.setAttribute("pageSubtitle", "Manage your medicine and health notifications");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reminders · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div class="alert alert-success mb-3">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error mb-3">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <!-- Medicine Preferences -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Medicine Timings</div>
                            <div class="section-subtitle">Set your preferred times for automated medicine reminders</div>
                        </div>
                    </div>
                    <form action="<%= request.getContextPath() %>/patient/reminders/preferences" method="post" class="mt-2">
                        <div class="form-group mb-3">
                            <label class="form-label" style="display:flex;align-items:center;gap:0.5rem;cursor:pointer;">
                                <input type="checkbox" name="enabled" value="true" <c:if test="${patient.medicineRemindersEnabled != null && patient.medicineRemindersEnabled}">checked</c:if>>
                                <strong>Enable automated medicine reminders</strong>
                            </label>
                            <div class="muted" style="margin-left:1.5rem;font-size:0.85rem;">Automatically pulls medicines prescribed by your doctors and alerts you at the correct times.</div>
                        </div>
                        
                        <div class="grid grid-3" style="gap: 1rem;">
                            <div class="form-group">
                                <label class="form-label">Morning</label>
                                <input type="time" name="morningTime" class="form-control" value="${patient.morningReminderTime}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Afternoon</label>
                                <input type="time" name="afternoonTime" class="form-control" value="${patient.afternoonReminderTime}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Night</label>
                                <input type="time" name="nightTime" class="form-control" value="${patient.nightReminderTime}" required>
                            </div>
                        </div>
                        
                        <div class="mt-3" style="text-align:right;">
                            <button type="submit" class="btn btn-primary">Save Preferences</button>
                        </div>
                    </form>
                </div>

                <!-- Active Medicines Detected -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Active Prescribed Medicines</div>
                            <div class="section-subtitle">Medicines automatically synced from your doctor</div>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                                <tr>
                                    <th>Medicine</th>
                                    <th>Timing</th>
                                    <th>Doctor</th>
                                    <th>End Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="foundMedicine" value="false" />
                                <c:forEach var="rx" items="${activePrescriptions}">
                                    <c:forEach var="med" items="${rx.prescribedMedicinesList}">
                                        <c:set var="foundMedicine" value="true" />
                                        <tr>
                                            <td><strong>${med.medicineName}</strong><br><small class="muted">${med.dosage}</small></td>
                                            <td>
                                                <c:set var="t" value="${med.timing}" />
                                                <c:choose>
                                                    <c:when test="${t == '1-1-1'}">
                                                        <span class="badge-soft" style="background:#fef3c7;color:#d97706;font-size:0.75rem;margin-right:2px;">☀ Morning</span>
                                                        <span class="badge-soft" style="background:#eff6ff;color:#3b82f6;font-size:0.75rem;margin-right:2px;">🌤 Afternoon</span>
                                                        <span class="badge-soft" style="background:#ede9fe;color:#7c3aed;font-size:0.75rem;">🌙 Night</span>
                                                    </c:when>
                                                    <c:when test="${t == '1-0-1'}">
                                                        <span class="badge-soft" style="background:#fef3c7;color:#d97706;font-size:0.75rem;margin-right:2px;">☀ Morning</span>
                                                        <span class="badge-soft" style="background:#ede9fe;color:#7c3aed;font-size:0.75rem;">🌙 Night</span>
                                                    </c:when>
                                                    <c:when test="${t == '1-1-0'}">
                                                        <span class="badge-soft" style="background:#fef3c7;color:#d97706;font-size:0.75rem;margin-right:2px;">☀ Morning</span>
                                                        <span class="badge-soft" style="background:#eff6ff;color:#3b82f6;font-size:0.75rem;">🌤 Afternoon</span>
                                                    </c:when>
                                                    <c:when test="${t == '0-1-1'}">
                                                        <span class="badge-soft" style="background:#eff6ff;color:#3b82f6;font-size:0.75rem;margin-right:2px;">🌤 Afternoon</span>
                                                        <span class="badge-soft" style="background:#ede9fe;color:#7c3aed;font-size:0.75rem;">🌙 Night</span>
                                                    </c:when>
                                                    <c:when test="${t == '1-0-0'}">
                                                        <span class="badge-soft" style="background:#fef3c7;color:#d97706;font-size:0.75rem;">☀ Morning</span>
                                                    </c:when>
                                                    <c:when test="${t == '0-1-0'}">
                                                        <span class="badge-soft" style="background:#eff6ff;color:#3b82f6;font-size:0.75rem;">🌤 Afternoon</span>
                                                    </c:when>
                                                    <c:when test="${t == '0-0-1'}">
                                                        <span class="badge-soft" style="background:#ede9fe;color:#7c3aed;font-size:0.75rem;">🌙 Night</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-soft" style="background:#eff6ff;color:#3b82f6;font-size:0.75rem;">${med.timing}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>Dr. ${rx.doctor.user.fullName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty rx.validUntil}">${rx.validUntil}</c:when>
                                                    <c:otherwise>—</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:forEach>
                                <c:if test="${!foundMedicine}">
                                    <tr>
                                        <td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">No active prescribed medicines found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="grid grid-2 mt-4">
                <!-- Add Custom Reminder -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Add Custom Reminder</div>
                            <div class="section-subtitle">Water, exercise, or custom health notes</div>
                        </div>
                    </div>
                    <form action="<%= request.getContextPath() %>/patient/reminders/add" method="post" class="mt-2">
                        <div class="form-group mb-3">
                            <label class="form-label">Reminder Title</label>
                            <input type="text" name="title" class="form-control" placeholder="e.g., Drink Water" required>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Description (Optional)</label>
                            <textarea name="description" class="form-control" rows="2" placeholder="Any extra notes..."></textarea>
                        </div>
                        <div class="grid grid-2" style="gap:1rem;">
                            <div class="form-group mb-3">
                                <label class="form-label">Type</label>
                                <select name="type" class="form-control" id="reminderType" required onchange="toggleDate()">
                                    <option value="DAILY">Every Day</option>
                                    <option value="ONE_TIME">One Time (Specific Date)</option>
                                </select>
                            </div>
                            <div class="form-group mb-3" id="dateGroup" style="display:none;">
                                <label class="form-label">Date</label>
                                <input type="date" name="reminderDate" class="form-control">
                            </div>
                        </div>
                        <div class="form-group mb-3">
                            <label class="form-label">Time</label>
                            <input type="time" name="reminderTime" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width:100%;">Create Reminder</button>
                    </form>
                </div>

                <!-- Custom Reminders List -->
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Your Custom Reminders</div>
                            <div class="section-subtitle">Active manual reminders</div>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Type / Date</th>
                                    <th>Time</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty customReminders}">
                                        <c:forEach var="rem" items="${customReminders}">
                                            <tr>
                                                <td><strong>${rem.title}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${rem.type == 'DAILY'}"><span class="chip-neutral">Every Day</span></c:when>
                                                        <c:otherwise><span class="chip-warning">${rem.reminderDate}</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong>${rem.reminderTime}</strong></td>
                                                <td>
                                                    <form action="<%= request.getContextPath() %>/patient/reminders/${rem.id}/delete" method="post" style="display:inline;" onsubmit="return confirm('Delete this reminder?');">
                                                        <button type="submit" class="btn btn-danger btn-sm" style="padding:0.25rem 0.5rem;font-size:0.75rem;">Delete</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="4" class="muted" style="text-align:center;padding:1.5rem;">No custom reminders set.</td></tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
<script>
    function toggleDate() {
        const type = document.getElementById('reminderType').value;
        const dateGroup = document.getElementById('dateGroup');
        const dateInput = document.querySelector('input[name="reminderDate"]');
        if (type === 'ONE_TIME') {
            dateGroup.style.display = 'block';
            dateInput.required = true;
        } else {
            dateGroup.style.display = 'none';
            dateInput.required = false;
        }
    }
</script>
</body>
</html>
