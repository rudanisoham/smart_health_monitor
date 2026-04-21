<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "prescriptions");
    request.setAttribute("pageTitle", "Prescription Details");
    request.setAttribute("pageSubtitle", "Full prescription information");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Prescription Details · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .rx-header {
            background: linear-gradient(135deg, #1d4ed8 0%, #0369a1 100%);
            border-radius: var(--radius-md); padding: 2rem; color: white; margin-bottom: 1.5rem;
        }
        .rx-header-title { font-size: 1.5rem; font-weight: 800; margin-bottom: 0.25rem; }
        .rx-header-sub { opacity: 0.8; font-size: 0.9rem; }
        .rx-section-label {
            font-size: 0.72rem; font-weight: 800; text-transform: uppercase;
            letter-spacing: 0.12em; color: var(--text-muted); margin-bottom: 0.75rem;
        }
        .med-table { width: 100%; border-collapse: collapse; }
        .med-table th {
            background: #f8fafc; font-size: 0.78rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.06em; color: var(--text-muted);
            padding: 0.75rem 1rem; border-bottom: 2px solid #e2e8f0; text-align: left;
        }
        .med-table td { padding: 0.875rem 1rem; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; color: #0f172a; }
        .med-table tbody tr:last-child td { border-bottom: none; }
        .med-table tbody tr:hover { background: #f8fafc; }
        .info-row { display: flex; justify-content: space-between; padding: 0.75rem 0; border-bottom: 1px solid #f1f5f9; }
        .info-row:last-child { border-bottom: none; }
        .info-label { font-size: 0.85rem; color: var(--text-muted); font-weight: 600; }
        .info-value { font-size: 0.9rem; color: #0f172a; font-weight: 500; text-align: right; max-width: 60%; }
        @media print {
            .no-print { display: none !important; }
            .admin-sidebar, .admin-header, .admin-footer { display: none !important; }
            .admin-main { margin: 0 !important; }
            .admin-content { padding: 0 !important; }
        }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>
        <div class="admin-content">

            <div class="no-print" style="display:flex;gap:0.75rem;margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/patient/prescriptions" class="btn btn-outline btn-sm">← Back to Prescriptions</a>
                <button onclick="window.print()" class="btn btn-outline btn-sm">🖨 Print</button>
            </div>

            <!-- Header -->
            <div class="rx-header">
                <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:1rem;">
                    <div>
                        <div class="rx-header-title">Prescription #${prescription.id}</div>
                        <div class="rx-header-sub">Issued on ${prescription.createdAt.toString().replace('T',' ').substring(0,16)}</div>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${prescription.validUntil == null}">
                                <span style="background:rgba(255,255,255,0.2);padding:0.4rem 1rem;border-radius:999px;font-size:0.85rem;font-weight:700;">Ongoing</span>
                            </c:when>
                            <c:otherwise>
                                <span style="background:rgba(255,255,255,0.2);padding:0.4rem 1rem;border-radius:999px;font-size:0.85rem;font-weight:700;">Valid until ${prescription.validUntil}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="grid grid-2" style="margin-bottom:1.5rem;">
                <!-- Doctor Info -->
                <div class="card">
                    <div class="rx-section-label">Prescribed By</div>
                    <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1rem;">
                        <div style="width:48px;height:48px;border-radius:50%;background:#eff6ff;display:flex;align-items:center;justify-content:center;font-size:1.25rem;font-weight:800;color:#1d4ed8;">
                            ${prescription.doctor.user.fullName.substring(0,1)}
                        </div>
                        <div>
                            <div style="font-weight:700;font-size:1rem;">Dr. ${prescription.doctor.user.fullName}</div>
                            <div class="muted" style="font-size:0.85rem;">${prescription.doctor.specialty}</div>
                        </div>
                    </div>
                    <div class="info-row"><span class="info-label">Department</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${prescription.doctor.department != null}">${prescription.doctor.department.name}</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row"><span class="info-label">License #</span><span class="info-value">${prescription.doctor.licenseNumber}</span></div>
                    <div class="info-row"><span class="info-label">Contact</span><span class="info-value">${prescription.doctor.user.phone != null ? prescription.doctor.user.phone : '—'}</span></div>
                </div>

                <!-- Diagnosis -->
                <div class="card">
                    <div class="rx-section-label">Diagnosis</div>
                    <div style="font-size:1.1rem;font-weight:700;color:#1d4ed8;padding:1rem;background:#eff6ff;border-radius:10px;border-left:4px solid #1d4ed8;">
                        ${prescription.diagnosis}
                    </div>
                    <div class="info-row" style="margin-top:1rem;"><span class="info-label">Issued On</span><span class="info-value">${prescription.createdAt.toString().replace('T',' ').substring(0,16)}</span></div>
                    <div class="info-row"><span class="info-label">Valid Until</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${prescription.validUntil != null}">${prescription.validUntil}</c:when>
                                <c:otherwise>Ongoing</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Medicines -->
            <div class="card" style="margin-bottom:1.5rem;">
                <div class="rx-section-label">Prescribed Medicines</div>
                <c:choose>
                    <c:when test="${not empty prescription.prescribedMedicinesList}">
                        <div class="table-container">
                            <table class="med-table">
                                <thead>
                                    <tr><th>#</th><th>Medicine Name</th><th>Dosage</th><th>Timing</th><th>Duration</th></tr>
                                </thead>
                                <tbody>
                                <c:forEach var="med" items="${prescription.prescribedMedicinesList}" varStatus="vs">
                                    <tr>
                                        <td style="color:#94a3b8;font-weight:700;">${vs.index + 1}</td>
                                        <td><strong>${med.medicineName}</strong></td>
                                        <td><span style="background:#eff6ff;color:#1d4ed8;padding:0.2rem 0.6rem;border-radius:4px;font-size:0.82rem;font-weight:700;">${med.dosage}</span></td>
                                        <td>${med.timing}</td>
                                        <td>${med.duration}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty prescription.medicines and prescription.medicines != 'See structured list'}">
                                <div style="padding:1rem;background:#f8fafc;border-radius:8px;white-space:pre-wrap;font-size:0.9rem;color:#0f172a;">${prescription.medicines}</div>
                            </c:when>
                            <c:otherwise>
                                <div class="muted" style="padding:1.5rem;text-align:center;">No medicine details recorded.</div>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Instructions -->
            <c:if test="${not empty prescription.instructions}">
                <div class="card" style="margin-bottom:1.5rem;">
                    <div class="rx-section-label">Special Instructions</div>
                    <div style="font-size:0.95rem;color:#0f172a;line-height:1.7;white-space:pre-wrap;">${prescription.instructions}</div>
                </div>
            </c:if>

            <!-- Notes (if any) -->
            <c:if test="${not empty prescription.notes}">
                <div class="card">
                    <div class="rx-section-label">Doctor Notes</div>
                    <div style="font-size:0.95rem;color:#0f172a;line-height:1.7;white-space:pre-wrap;">${prescription.notes}</div>
                </div>
            </c:if>

        </div>
        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
