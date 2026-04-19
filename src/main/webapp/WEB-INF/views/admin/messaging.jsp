<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "messaging");
    request.setAttribute("pageTitle", "Broadcast Center");
    request.setAttribute("pageSubtitle", "Send targeted emails and alerts to patients or doctors");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Broadcast Center · Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .filter-panel { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 25px; transition: all 0.3s ease; }
        .filter-header { display: flex; align-items: center; justify-content: space-between; cursor: pointer; user-select: none; }
        .filter-header h3 { margin: 0; font-size: 1.1rem; color: #1e293b; display: flex; align-items: center; gap: 8px; }
        .filter-content { margin-top: 20px; overflow: hidden; display: none; }
        .filter-content.active { display: block; animation: slideDown 0.3s ease-out; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        .target-selector { display: flex; gap: 15px; margin-bottom: 20px; }
        .target-card { flex: 1; border: 2px solid #e2e8f0; border-radius: 10px; padding: 15px; text-align: center; cursor: pointer; transition: all 0.2s; background: white; }
        .target-card:hover { border-color: #cbd5e1; transform: translateY(-2px); }
        .target-card.active { border-color: #3b82f6; background: #eff6ff; color: #1d4ed8; }
        .target-card input[type="radio"] { display: none; }
        .target-icon { font-size: 2rem; margin-bottom: 10px; display: block; }
        .form-row { display: flex; gap: 15px; margin-bottom: 15px; }
        .form-col { flex: 1; }
        .message-history { margin-top: 40px; }
        .history-card { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 15px; margin-bottom: 15px; }
        .history-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .badge-patient { background: #dcfce7; color: #166534; padding: 4px 8px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; }
        .badge-doctor { background: #e0e7ff; color: #3730a3; padding: 4px 8px; border-radius: 20px; font-size: 0.75rem; font-weight: bold; }
        .filter-tag { background: #f1f5f9; color: #475569; padding: 3px 8px; border-radius: 4px; font-size: 0.75rem; margin-right: 5px; display: inline-block; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/admin-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/admin-header.jsp" %>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <!-- Compose Form -->
            <div class="card">
                <form action="<%= request.getContextPath() %>/admin/messaging/send" method="post" id="broadcastForm">
                    
                    <!-- Target Selection -->
                    <h3 style="margin-top: 0; margin-bottom: 15px;">Select Audience</h3>
                    <div class="target-selector">
                        <label class="target-card active" onclick="switchTarget('PATIENT')">
                            <input type="radio" name="targetRole" value="PATIENT" checked>
                            <span class="target-icon">👥</span>
                            <strong>Patients</strong>
                        </label>
                        <label class="target-card" onclick="switchTarget('DOCTOR')">
                            <input type="radio" name="targetRole" value="DOCTOR">
                            <span class="target-icon">👨‍⚕️</span>
                            <strong>Doctors</strong>
                        </label>
                        <label class="target-card" onclick="switchTarget('ALL')">
                            <input type="radio" name="targetRole" value="ALL">
                            <span class="target-icon">🏥</span>
                            <strong>Everyone</strong>
                        </label>
                    </div>

                    <!-- Filter Options -->
                    <div class="filter-panel" id="filterPanel">
                        <div class="filter-header" onclick="toggleFilters()">
                            <h3>
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon></svg>
                                Target Specific Audience Constraints
                            </h3>
                            <span id="filterToggleIcon" style="font-size: 1.2rem; display: inline-block; transition: transform 0.3s;">▼</span>
                        </div>
                        
                        <div class="filter-content" id="filterContent">
                            <div class="alert alert-info" style="margin-bottom: 20px;">
                                Leave filters empty to send to all users in the selected category.
                            </div>
                            
                            <!-- Patient Filters -->
                            <div id="patientFilters" class="form-row">
                                <div class="form-col text-input">
                                    <label>Blood Group</label>
                                    <select name="filterBloodGroup" class="form-control">
                                        <option value="">Any Blood Group</option>
                                        <option value="A+">A+</option>
                                        <option value="A-">A-</option>
                                        <option value="B+">B+</option>
                                        <option value="B-">B-</option>
                                        <option value="AB+">AB+</option>
                                        <option value="AB-">AB-</option>
                                        <option value="O+">O+</option>
                                        <option value="O-">O-</option>
                                    </select>
                                </div>
                                <div class="form-col text-input">
                                    <label>Gender</label>
                                    <select name="filterGender" class="form-control">
                                        <option value="">Any Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Doctor Filters -->
                            <div id="doctorFilters" class="form-row" style="display: none;">
                                <div class="form-col text-input">
                                    <label>Specialty</label>
                                    <select name="filterSpecialty" class="form-control">
                                        <option value="">Any Specialty</option>
                                        <c:forEach var="spec" items="${specialties}">
                                            <option value="${spec}">${spec}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- Common Filters -->
                            <div id="commonFilters" class="form-row mt-2">
                                <div class="form-col text-input">
                                    <label>Department</label>
                                    <select name="filterDepartment" class="form-control">
                                        <option value="">Any Department</option>
                                        <c:forEach var="dept" items="${departments}">
                                            <option value="${dept.id}">${dept.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Message Body -->
                    <div class="text-input" style="margin-bottom: 20px;">
                        <label>Delivery Method</label>
                        <select name="deliveryMethod" class="form-control" style="max-width: 300px;">
                            <option value="EMAIL">Email Only</option>
                            <option value="IN_APP">In-App Notification Only</option>
                            <option value="BOTH">Email + In-App Notification</option>
                        </select>
                    </div>

                    <div class="text-input" style="margin-bottom: 20px;">
                        <label>Message Subject</label>
                        <input type="text" name="subject" class="form-control" required placeholder="e.g. Important Update on Hospital Hours">
                    </div>

                    <div class="text-input">
                        <label>Message Content</label>
                        <textarea name="body" class="form-control" rows="8" required placeholder="Write your broadcast message here..."></textarea>
                    </div>

                    <div style="margin-top: 25px; display: flex; justify-content: flex-end;">
                        <button type="button" class="btn btn-outline" style="margin-right: 15px;" onclick="document.getElementById('broadcastForm').reset()">Clear</button>
                        <button type="submit" class="btn btn-primary" onclick="return confirm('Depending on the recipients, this might take a moment. Proceed?');">Send Broadcast 🚀</button>
                    </div>
                </form>
            </div>

            <!-- History -->
            <div class="message-history">
                <h2>Recent Broadcasts</h2>
                
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach var="msg" items="${messages}">
                            <div class="history-card">
                                <div class="history-header">
                                    <div>
                                        <span class="badge-${msg.targetRole.toLowerCase()}">${msg.targetRole}</span>
                                        <strong style="font-size: 1.1rem; margin-left: 10px;">${msg.subject}</strong>
                                    </div>
                                    <div class="muted text-sm">
                                        🗓️ ${msg.sentAt.toString().replace('T', ' ').substring(0,16)}
                                    </div>
                                </div>
                                <div style="margin-bottom: 10px; color: #475569;">
                                    ${msg.body.length() > 150 ? msg.body.substring(0, 150) += '...' : msg.body}
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f1f5f9; padding-top: 10px; margin-top: 10px;">
                                    <div style="display: flex; flex-wrap: wrap; gap: 5px;">
                                        <span class="filter-tag">📬 ${msg.deliveryMethod}</span>
                                        <span class="filter-tag">👥 ${msg.recipientCount} Recipients</span>
                                        <c:if test="${not empty msg.filterBloodGroup}">
                                            <span class="filter-tag">🩸 ${msg.filterBloodGroup}</span>
                                        </c:if>
                                        <c:if test="${not empty msg.filterGender}">
                                            <span class="filter-tag">👤 ${msg.filterGender}</span>
                                        </c:if>
                                        <c:if test="${not empty msg.filterDepartment}">
                                            <span class="filter-tag">🏥 Dept ID: ${msg.filterDepartment}</span>
                                        </c:if>
                                        <c:if test="${not empty msg.filterSpecialty}">
                                            <span class="filter-tag">⚕️ ${msg.filterSpecialty}</span>
                                        </c:if>
                                    </div>
                                    <div class="text-sm">
                                        <span style="color: ${msg.status == 'SENT' ? '#10b981' : '#f59e0b'}; font-weight: bold;">
                                            ${msg.status}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="card" style="text-align: center; padding: 40px;">
                            <h3 class="muted">No broadcast history</h3>
                            <p class="muted">Your past broadcast messages will appear here.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
        <%@ include file="/WEB-INF/views/layout/admin-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
<script>
    function toggleFilters() {
        const content = document.getElementById('filterContent');
        const icon = document.getElementById('filterToggleIcon');
        if (content.classList.contains('active')) {
            content.classList.remove('active');
            icon.style.transform = 'rotate(0deg)';
        } else {
            content.classList.add('active');
            icon.style.transform = 'rotate(180deg)';
        }
    }

    function switchTarget(role) {
        // Handle UI
        document.querySelectorAll('.target-card').forEach(card => card.classList.remove('active'));
        event.currentTarget.classList.add('active');

        // Handle Filter Visibility
        const patFilters = document.getElementById('patientFilters');
        const docFilters = document.getElementById('doctorFilters');
        const comFilters = document.getElementById('commonFilters');
        const filterPanel = document.getElementById('filterPanel');

        // Clear existing values
        document.querySelectorAll('#filterContent select').forEach(select => select.value = '');

        if (role === 'PATIENT') {
            filterPanel.style.display = 'block';
            patFilters.style.display = 'flex';
            docFilters.style.display = 'none';
            comFilters.style.display = 'flex';
        } else if (role === 'DOCTOR') {
            filterPanel.style.display = 'block';
            patFilters.style.display = 'none';
            docFilters.style.display = 'flex';
            comFilters.style.display = 'flex';
        } else {
            // ALL selected - hide filters entirely
            filterPanel.style.display = 'none';
            document.getElementById('filterContent').classList.remove('active');
            document.getElementById('filterToggleIcon').style.transform = 'rotate(0deg)';
        }
    }
</script>
</body>
</html>
