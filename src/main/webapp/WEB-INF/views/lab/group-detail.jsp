<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab Session Details | Smart Health</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .detail-header { background: white; border-radius: 20px; padding: 2rem; margin-bottom: 2rem; border: 1px solid #e2e8f0; }
        .test-item { background: white; border-radius: 16px; padding: 1.5rem; margin-bottom: 1rem; border: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .status-badge { padding: 0.35rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }
        .status-COMPLETED { background: #d1fae5; color: #059669; }
        .status-PENDING { background: #fef3c7; color: #d97706; }
    </style>
</head>
<body>
    <div class="admin-app">
        <c:choose>
            <c:when test="${userType == 'DOCTOR'}"><%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %></c:when>
            <c:otherwise><%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %></c:otherwise>
        </c:choose>

        <main class="admin-main">
            <c:set var="pageTitle" value="Diagnostic Details" scope="request"/>
            <c:set var="pageSubtitle" value="Session Investigation Report" scope="request"/>
            <c:choose>
                <c:when test="${userType == 'DOCTOR'}"><%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %></c:when>
                <c:otherwise><%@ include file="/WEB-INF/views/layout/patient-header.jsp" %></c:otherwise>
            </c:choose>

            <div class="admin-content">
                <div style="margin-bottom:2rem;">
                    <a href="javascript:history.back()" class="btn btn-outline btn-sm">
                        <i class="fas fa-arrow-left"></i> Back
                    </a>
                </div>

                <div class="detail-header">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                        <div>
                            <span class="status-badge status-${first.status}">${first.status}</span>
                            <h2 style="font-size:2rem; font-weight:800; color:#1e293b; margin:0.5rem 0;">Diagnostic Investigation</h2>
                            <p class="muted">Patient: <strong>${first.patient.user.fullName}</strong> | Physician: <strong>Dr. ${first.doctor.user.fullName}</strong></p>
                        </div>
                        <div style="text-align:right;">
                            <div class="muted">Session Date</div>
                            <strong style="font-size:1.2rem;">${first.requestedAt.toString().replace('T',' ').substring(0,16)}</strong>
                        </div>
                    </div>
                </div>

                <h3 style="margin-bottom:1.5rem; font-weight:800; color:#1e293b;">Investigations Included</h3>
                
                <c:forEach var="req" items="${group}">
                    <div class="test-item">
                        <div>
                            <div style="font-weight:700; font-size:1.1rem; color:#1e293b;">${req.labTest.name}</div>
                            <div class="muted" style="font-size:0.85rem;">Reference ID: #${req.id}</div>
                        </div>
                        <div style="text-align:right;">
                            <div style="font-weight:700; color:#3b82f6;">₹${req.labTest.price}</div>
                        </div>
                    </div>
                </c:forEach>

                <div class="card mt-4" style="padding:2rem;">
                    <h3 style="margin-bottom:1rem; font-weight:800; color:#1e293b;">Clinical Findings & Reports</h3>
                    
                    <div style="margin-bottom:2rem;">
                        <label class="muted" style="font-size:0.8rem; text-transform:uppercase; font-weight:700;">Diagnostic Notes</label>
                        <div style="margin-top:0.5rem; line-height:1.6; color:#334155;">
                            ${not empty first.resultNotes ? first.resultNotes : 'Notes will be available once tests are completed.'}
                        </div>
                    </div>

                    <c:if test="${not empty first.resultFileUrl}">
                        <div style="background:#f8fafc; padding:1.5rem; border-radius:12px; display:flex; justify-content:space-between; align-items:center;">
                            <div>
                                <div style="font-weight:700;">Consolidated Report File</div>
                                <div class="muted" style="font-size:0.8rem;">Click the button to download the PDF document.</div>
                            </div>
                            <a href="${pageContext.request.contextPath}${first.resultFileUrl}" target="_blank" class="btn btn-primary">
                                <i class="fas fa-download"></i> Download Report
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js?v=3"></script>
</body>
</html>
