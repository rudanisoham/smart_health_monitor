<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Appointments");
    request.setAttribute("pageSubtitle", "Request and track your appointments");
    String today = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointments · Smart Health Monitor</title>
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
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div style="display: grid; grid-template-columns: 1fr; gap: 2rem; align-items: start;" class="main-booking-layout">
                <style>
                    @media (min-width: 1024px) {
                        .main-booking-layout { grid-template-columns: 2fr 1fr !important; }
                    }
                    .preview-card {
                        background: white; border-radius: 16px; border: 1px solid #e2e8f0; overflow: hidden;
                        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); sticky: top 2rem;
                    }
                    .preview-card-placeholder {
                        display: flex; flex-direction: column; align-items: center; justify-content: center;
                        padding: 3rem 2rem; text-align: center; color: #94a3b8; border: 2px dashed #e2e8f0;
                        border-radius: 16px; min-height: 400px; background: #f8fafc;
                    }
                    .preview-avatar {
                        width: 100px; height: 100px; border-radius: 50%; background: #1e293b;
                        display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem;
                        font-size: 2.5rem; color: #cbd5e1; font-weight: 700;
                    }
                    .preview-badge {
                        display: inline-block; padding: 0.25rem 0.75rem; background: #eff6ff;
                        color: #1d4ed8; border-radius: 9999px; font-size: 0.8rem; font-weight: 600;
                        margin-bottom: 0.5rem;
                    }
                </style>

                <!-- Left: Booking Form -->
                <div class="card" style="margin:0;">
                    <div class="section-title">Request an Appointment</div>
                    <p class="section-subtitle mt-1">Fill in details and select your preferred doctor</p>

                    <form action="${pageContext.request.contextPath}/patient/appointments/book" method="post" class="form-grid mt-4">

                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="doctorSearch">Search & Select Doctor (Optional)</label>
                            <div style="position:relative; margin-bottom:0.5rem;">
                                <input type="text" id="doctorSearch" class="form-control" placeholder="Type to filter doctors by name or specialty..." onkeyup="filterDoctors()">
                                <svg style="position:absolute; right:12px; top:50%; transform:translateY(-50%); color:#94a3b8;" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                            </div>
                            <select id="doctorId" name="doctorId" class="form-control" onchange="updateProfilePreview()">
                                <option value="" data-bio="" data-specialty="" data-exp="" data-rating="0">No preference — assign any available doctor</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}" 
                                            data-name="Dr. ${doc.user.fullName}"
                                            data-specialty="${doc.specialty}"
                                            data-bio="${doc.bio}"
                                            data-exp="${doc.experience != null ? doc.experience : '0'}"
                                            data-rating="${ratings[doc.id]}"
                                            data-search="Dr. ${doc.user.fullName} ${doc.specialty}">
                                        Dr. ${doc.user.fullName} <c:if test="${not empty doc.specialty}">— ${doc.specialty}</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="preferredDate">Preferred Date <span style="color:#ef4444;">*</span></label>
                            <input id="preferredDate" name="preferredDate" class="form-control" type="date" min="<%= today %>" required>
                        </div>

                        <div class="form-group">
                            <label for="preferredDateNote">Preferred Time (optional)</label>
                            <input id="preferredDateNote" name="preferredDateNote" class="form-control" type="text" placeholder="e.g. 10:00 AM">
                        </div>

                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="notes">Reason / Symptoms <span style="color:#ef4444;">*</span></label>
                            <textarea id="notes" name="notes" class="form-control" rows="3" required placeholder="Describe your concern here..."></textarea>
                        </div>

                        <div class="form-group" style="grid-column:1/-1;">
                            <button class="btn btn-primary w-full" type="submit">Confirm & Request Appointment</button>
                        </div>
                    </form>
                </div>

                <!-- Right: Doctor Preview Panel -->
                <div id="doctorPreviewPanel">
                    <div id="previewPlaceholder" class="preview-card-placeholder">
                        <svg width="48" height="48" fill="none" stroke="currentColor" style="margin-bottom:1rem; opacity:0.5;"><path d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/><path d="M22 21h-2m-1-4l1 3 1-3"/></svg>
                        <p style="font-weight:600; color:#64748b;">Select a doctor</p>
                        <p style="font-size:0.85rem;">To view their profile summary and patient ratings</p>
                    </div>

                    <div id="previewCard" class="preview-card" style="display:none; position: sticky; top: 2rem;">
                        <div style="background: linear-gradient(135deg, #1e293b, #334155); padding: 2rem 1.5rem; text-align: center;">
                            <div id="pAvatar" class="preview-avatar">D</div>
                            <h3 id="pName" style="color:white; font-size:1.25rem; font-weight:700; margin:0;">Dr. Name</h3>
                            <p id="pSpecialty" style="color:rgba(255,255,255,0.7); font-size:0.9rem; margin-top:0.25rem;">Specialist</p>
                        </div>
                        <div style="padding: 1.5rem;">
                            <div style="display:flex; justify-content:space-between; margin-bottom:1.5rem;">
                                <div style="text-align:center;">
                                    <div id="pRating" style="color:#f59e0b; font-weight:700; font-size:1.1rem;">★ 0.0</div>
                                    <div class="muted" style="font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px;">Avg Rating</div>
                                </div>
                                <div style="width:1px; background:#e2e8f0;"></div>
                                <div style="text-align:center;">
                                    <div id="pExp" style="color:#1e293b; font-weight:700; font-size:1.1rem;">0 Yrs</div>
                                    <div class="muted" style="font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px;">Experience</div>
                                </div>
                            </div>
                            <div style="margin-bottom:1.5rem;">
                                <p style="font-weight:700; font-size:0.85rem; text-transform:uppercase; color:#94a3b8; margin-bottom:0.5rem; letter-spacing:0.5px;">About Doctor</p>
                                <p id="pBio" style="color:#475569; font-size:0.9rem; line-height:1.5; height: 4.5rem; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical;">No bio available for this doctor.</p>
                            </div>
                            <a id="pFullProfile" href="#" target="_blank" class="btn btn-outline w-full" style="justify-content:center;">View Full Profile & Reviews</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mt-4">
                <div class="section-title">Your Appointments</div>
                <div class="table-container mt-3">
                    <table>
                        <thead>
                        <tr>
                            <th>Date & Token</th>
                            <th>Doctor</th>
                            <th>Status</th>
                            <th class="text-right">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appt" items="${appointments}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.scheduledAt != null}">
                                                    <div style="font-weight:600;">${appt.scheduledAt.toString().replace('T', ' ').substring(0, 16)}</div>
                                                    <c:if test="${appt.tokenNumber != null}">
                                                        <span class="chip" style="background:#eff6ff; color:#1d4ed8; font-weight:700;">Token #${appt.tokenNumber}</span>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="muted">Awaiting scheduling</span>
                                                    <c:if test="${appt.preferredDate != null}"><div class="text-xs muted">Pref: ${appt.preferredDate}</div></c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.doctor != null}">
                                                    <div style="font-weight:600;">Dr. ${appt.doctor.user.fullName}</div>
                                                    <div class="muted text-xs">${appt.doctor.specialty}</div>
                                                </c:when>
                                                <c:otherwise><span class="muted">To be assigned</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'AWAITING_ASSIGNMENT'}"><span class="chip-warning">Awaiting</span></c:when>
                                                <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">Confirmed</span></c:when>
                                                <c:when test="${appt.status == 'CANCELLED'}"><span class="chip-danger">Cancelled</span></c:when>
                                                <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">Completed</span></c:when>
                                                <c:otherwise><span class="chip-warning">${appt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <div style="display:flex; gap:0.5rem; justify-content:flex-end;">
                                                <c:if test="${appt.status == 'AWAITING_ASSIGNMENT'}">
                                                    <button class="btn btn-outline btn-sm" style="border-color:#3b82f6; color:#3b82f6;"
                                                            onclick="openEditModal('${appt.id}', '${appt.doctor != null ? appt.doctor.id : ""}', '${appt.preferredDate}', '${appt.preferredDateNote}', '${appt.notes}')">Edit Request</button>
                                                </c:if>
                                                <c:if test="${appt.status != 'CANCELLED' and appt.status != 'COMPLETED'}">
                                                    <form action="${pageContext.request.contextPath}/patient/appointments/${appt.id}/cancel" method="post">
                                                        <button class="btn btn-outline btn-sm" onclick="return confirm('Cancel?')">Cancel</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="4" class="muted text-center" style="padding:2rem;">No appointments found.</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>



        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>

    </main>
</div>

<!-- Edit Request Modal -->
<div id="editModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div class="card" style="width:100%; max-width:500px; margin:1rem; position:relative;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
            <h3 style="font-size:1.25rem; font-weight:700;">Update Appointment Request</h3>
            <button onclick="closeEditModal()" style="background:none; border:none; font-size:1.5rem; cursor:pointer; color:#64748b;">&times;</button>
        </div>
        <form id="editForm" method="post">
            <div class="form-group">
                <label>Select Doctor</label>
                <select name="doctorId" id="editDoctorId" class="form-select">
                    <option value="">-- No preference / Any --</option>
                    <c:forEach var="doc" items="${doctors}">
                        <option value="${doc.id}">Dr. ${doc.user.fullName} (${doc.specialty})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Preferred Date</label>
                <input type="date" name="preferredDate" id="editDate" class="form-control" min="<%= java.time.LocalDate.now() %>">
            </div>
            <div class="form-group">
                <label>Preferred Time (Note)</label>
                <input type="text" name="preferredDateNote" id="editTimeNote" class="form-control" placeholder="e.g. Morning, 10:00 AM">
            </div>
            <div class="form-group">
                <label>Reason / Symptoms</label>
                <textarea name="notes" id="editNotes" class="form-control" rows="3"></textarea>
            </div>
            <div style="margin-top:1.5rem; display:flex; gap:1rem;">
                <button type="submit" class="btn btn-primary" style="flex:1;">Save Changes</button>
                <button type="button" class="btn btn-outline" style="flex:1;" onclick="closeEditModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, docId, date, timeNote, notes) {
        const modal = document.getElementById('editModal');
        const form = document.getElementById('editForm');
        form.action = '${pageContext.request.contextPath}/patient/appointments/' + id + '/update';
        
        document.getElementById('editDoctorId').value = docId;
        document.getElementById('editDate').value = date;
        document.getElementById('editTimeNote').value = timeNote;
        document.getElementById('editNotes').value = notes;
        
        modal.style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Existing functions...
    function filterDoctors() {
        const filter = document.getElementById('doctorSearch').value.toLowerCase();
        const options = document.getElementById('doctorId').getElementsByTagName('option');
        for (let i = 1; i < options.length; i++) {
            const text = options[i].getAttribute('data-search').toLowerCase();
            options[i].style.display = text.includes(filter) ? "" : "none";
        }
    }

    function updateProfilePreview() {
        const sel = document.getElementById('doctorId');
        const opt = sel.options[sel.selectedIndex];
        const card = document.getElementById('previewCard');
        const placeholder = document.getElementById('previewPlaceholder');

        if (sel.value) {
            placeholder.style.display = 'none';
            card.style.display = 'block';
            
            document.getElementById('pAvatar').innerText = opt.getAttribute('data-name').replace('Dr. ', '').substring(0,1);
            document.getElementById('pName').innerText = opt.getAttribute('data-name');
            document.getElementById('pSpecialty').innerText = opt.getAttribute('data-specialty') || 'General Physician';
            document.getElementById('pRating').innerText = '★ ' + (parseFloat(opt.getAttribute('data-rating')) || 0).toFixed(1);
            document.getElementById('pExp').innerText = (opt.getAttribute('data-exp') || '0') + ' Yrs';
            document.getElementById('pBio').innerText = opt.getAttribute('data-bio') || 'No bio provided for this doctor.';
            document.getElementById('pFullProfile').href = '${pageContext.request.contextPath}/patient/doctor/' + sel.value + '/profile';
        } else {
            placeholder.style.display = 'flex';
            card.style.display = 'none';
        }
    }
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>

