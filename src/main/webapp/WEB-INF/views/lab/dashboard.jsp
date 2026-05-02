<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Lab Portal Dashboard");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard · Laboratory Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .group-card { border: 2px solid #e2e8f0; border-radius: 20px; padding: 2rem; background: white; margin-bottom: 2rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .group-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid #f1f5f9; }
        .test-list-pill { display: inline-flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.5rem; }
        .test-pill { background: #f1f5f9; color: #475569; padding: 0.25rem 0.75rem; border-radius: 100px; font-size: 0.75rem; font-weight: 600; border: 1px solid #e2e8f0; }
        .status-badge { padding: 0.35rem 0.75rem; border-radius: 20px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; }
        .status-PENDING { background: #fef3c7; color: #d97706; }
        .status-IN_PROGRESS { background: #e0e7ff; color: #4338ca; }
        .status-COMPLETED { background: #d1fae5; color: #059669; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/lab-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/lab-header.jsp" %>
        <div class="admin-content">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem;">
                <div>
                    <h2 style="font-size:1.75rem; font-weight:800; color:#1e293b; margin:0;">Diagnostic Queue</h2>
                    <p class="muted">Finalize diagnostic sessions and upload consolidated reports.</p>
                </div>
                <a href="<%= request.getContextPath() %>/lab/history" class="btn btn-outline btn-sm">
                    <i class="fas fa-history"></i> View Completed History
                </a>
            </div>

            <c:if test="${not empty success}"><div style="padding:1rem; background:#d1fae5; color:#059669; border-radius:8px; margin-bottom:1.5rem;">${success}</div></c:if>
            <c:if test="${not empty error}"><div style="padding:1rem; background:#fee2e2; color:#dc2626; border-radius:8px; margin-bottom:1.5rem;">${error}</div></c:if>

            <c:if test="${empty groupedRequests}">
                <div class="card" style="padding:4rem 2rem; text-align:center;">
                    <div style="font-size:3rem; margin-bottom:1rem; opacity:0.3;">🧪</div>
                    <h3 class="muted">All clear!</h3>
                    <p class="muted mt-1">No pending diagnostic sessions.</p>
                </div>
            </c:if>

            <c:forEach var="entry" items="${groupedRequests}">
                <c:set var="group" value="${entry.value}" />
                <c:set var="first" value="${group[0]}" />
                
                <div class="group-card">
                    <div class="group-header">
                        <div>
                            <div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:0.5rem;">
                                <h3 style="font-size:1.6rem; font-weight:800; color:#1e293b; margin:0;">${first.patient.user.fullName}</h3>
                                <span class="status-badge status-${first.status}">${first.status}</span>
                            </div>
                            <div style="font-size:0.9rem; color:#64748b;">
                                <strong>Doctor:</strong> Dr. ${first.doctor.user.fullName} | 
                                <strong>Requested:</strong> ${first.requestedAt.toString().replace('T', ' ').substring(0,16)}
                            </div>
                            <div class="test-list-pill">
                                <c:forEach var="req" items="${group}">
                                    <span class="test-pill"><i class="fas fa-flask"></i> ${req.labTest.name}</span>
                                </c:forEach>
                            </div>
                        </div>
                        <div style="text-align:right;">
                            <div style="font-size:0.7rem; color:#94a3b8; font-weight:700; text-transform:uppercase;">Group ID</div>
                            <code style="color:#3b82f6;">
                                <c:choose>
                                    <c:when test="${entry.key.length() > 13}">${entry.key.substring(0,13)}...</c:when>
                                    <c:otherwise>${entry.key}</c:otherwise>
                                </c:choose>
                            </code>
                        </div>
                    </div>

                    <form action="<%= request.getContextPath() %>/lab/requests/group/${entry.key}/update" method="post" enctype="multipart/form-data">
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:2rem;">
                            <div>
                                <div class="form-group">
                                    <label style="font-weight:700; color:#1e293b;">Overall Diagnostic Notes</label>
                                    <textarea name="resultNotes" class="form-control" rows="4" placeholder="Enter findings for all tests in this session...">${first.resultNotes}</textarea>
                                </div>
                            </div>
                            <div>
                                <div class="form-group">
                                    <label style="font-weight:700; color:#1e293b;">Update Status</label>
                                    <select name="status" class="form-control" onchange="toggleGroupUpload(this, 'upload-${entry.key}')">
                                        <option value="PENDING" ${first.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                        <option value="IN_PROGRESS" ${first.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                        <option value="COMPLETED" ${first.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                    </select>
                                </div>
                                <div id="upload-${entry.key}" style="display: ${first.status == 'COMPLETED' ? 'block' : 'none'}; margin-top:1rem;">
                                    <div class="form-group">
                                        <label style="font-weight:700; color:#1e293b;">Consolidated Report (PDF)</label>
                                        <input type="file" name="resultFile" class="form-control" accept=".pdf">
                                        <p class="muted" style="font-size:0.75rem; margin-top:0.25rem;">Upload one file containing all test results.</p>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="width:100%; justify-content:center; margin-top:1rem; padding:1rem;">
                                    <i class="fas fa-save"></i> Finalize Entire Session
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </c:forEach>
        </div>
    </main>
</div>
<script>
function toggleGroupUpload(selectEl, uploadId) {
    document.getElementById(uploadId).style.display = selectEl.value === 'COMPLETED' ? 'block' : 'none';
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
