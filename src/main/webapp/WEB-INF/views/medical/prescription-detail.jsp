<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Prescription Details");
    request.setAttribute("pageSubtitle", "Full prescription record");
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
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <div class="no-print" style="display:flex;gap:0.75rem;margin-bottom:1.5rem;flex-wrap:wrap;">
                <a href="javascript:history.back()" class="btn btn-outline btn-sm">← Back</a>
                <a href="${pageContext.request.contextPath}/medical/patients/${prescription.patient.id}" class="btn btn-outline btn-sm">View Patient Profile</a>
                <button onclick="window.print()" class="btn btn-outline btn-sm">🖨 Print</button>
            </div>

            <!-- Header Banner -->
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
                <!-- Patient -->
                <div class="card">
                    <div class="rx-section-label">Patient</div>
                    <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1rem;">
                        <div style="width:48px;height:48px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-size:1.25rem;font-weight:800;color:var(--primary);">
                            ${prescription.patient.user.fullName.substring(0,1)}
                        </div>
                        <div>
                            <div style="font-weight:700;font-size:1rem;">${prescription.patient.user.fullName}</div>
                            <div class="muted" style="font-size:0.85rem;">${prescription.patient.user.email}</div>
                        </div>
                    </div>
                    <div class="info-row"><span class="info-label">Patient ID</span><span class="info-value">#${prescription.patient.id}</span></div>
                    <div class="info-row"><span class="info-label">Blood Group</span><span class="info-value">${prescription.patient.bloodGroup != null ? prescription.patient.bloodGroup : '—'}</span></div>
                    <div class="info-row"><span class="info-label">Phone</span><span class="info-value">${prescription.patient.user.phone != null ? prescription.patient.user.phone : '—'}</span></div>
                    <div class="info-row"><span class="info-label">Allergies</span><span class="info-value">${prescription.patient.allergies != null ? prescription.patient.allergies : 'None recorded'}</span></div>
                </div>

                <!-- Doctor + Diagnosis -->
                <div class="card">
                    <div class="rx-section-label">Issuing Doctor</div>
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
                        <span class="info-value"><c:choose><c:when test="${prescription.doctor.department != null}">${prescription.doctor.department.name}</c:when><c:otherwise>—</c:otherwise></c:choose></span>
                    </div>
                    <div class="info-row"><span class="info-label">License #</span><span class="info-value">${prescription.doctor.licenseNumber}</span></div>
                    <div class="info-row"><span class="info-label">Diagnosis</span><span class="info-value" style="font-weight:700;color:#1d4ed8;">${prescription.diagnosis}</span></div>
                    <div class="info-row"><span class="info-label">Issued On</span><span class="info-value">${prescription.createdAt.toString().replace('T',' ').substring(0,16)}</span></div>
                </div>
            </div>

            <!-- Medicines Bill -->
            <div class="card" style="margin-bottom:1.5rem;">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.25rem;flex-wrap:wrap;gap:0.75rem;">
                    <div>
                        <div class="rx-section-label" style="margin-bottom:0;">Medicine Bill</div>
                        <div style="font-size:0.85rem;color:#64748b;margin-top:0.2rem;">Quantities calculated from doctor's timing &amp; duration</div>
                    </div>
                    <div style="display:flex;gap:0.5rem;">
                        <span class="chip" style="font-size:0.8rem;">${availableCount} in-house</span>
                        <c:if test="${externalCount > 0}"><span class="chip-warning" style="font-size:0.8rem;">${externalCount} external</span></c:if>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty billItems or not empty externalItems}">

                        <%-- Available medicines bill table --%>
                        <c:if test="${not empty billItems}">
                            <div style="font-size:0.78rem;font-weight:800;color:#10b981;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:0.5rem;">✓ Available in Hospital Pharmacy</div>
                            <div class="table-container" style="margin-bottom:1.5rem;">
                                <table class="med-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Medicine</th>
                                            <th>Dosage</th>
                                            <th>Timing</th>
                                            <th>Duration</th>
                                            <th style="text-align:center;">Doses/Day</th>
                                            <th style="text-align:center;">Total Units</th>
                                            <th style="text-align:center;">Packs</th>
                                            <th style="text-align:right;">Pack Price</th>
                                            <th style="text-align:right;">Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${billItems}" varStatus="vs">
                                        <tr>
                                            <td style="color:#94a3b8;font-weight:700;">${vs.index + 1}</td>
                                            <td>
                                                <strong>${item.name}</strong>
                                                <c:if test="${not empty item.form}">
                                                    <div style="font-size:0.75rem;color:#64748b;">${item.form}</div>
                                                </c:if>
                                            </td>
                                            <td><span style="background:#eff6ff;color:#1d4ed8;padding:0.2rem 0.5rem;border-radius:4px;font-size:0.8rem;font-weight:700;">${item.dosage}</span></td>
                                            <td style="font-size:0.85rem;">${item.timing}</td>
                                            <td style="font-size:0.85rem;">${item.duration}</td>
                                            <td style="text-align:center;font-weight:600;">${item.dosesPerDay}×/day</td>
                                            <td style="text-align:center;">
                                                <span style="background:#f1f5f9;padding:0.2rem 0.5rem;border-radius:4px;font-size:0.82rem;font-weight:600;">${item.totalUnits} units</span>
                                            </td>
                                            <td style="text-align:center;">
                                                <span style="background:#dcfce7;color:#166534;padding:0.25rem 0.6rem;border-radius:4px;font-size:0.85rem;font-weight:700;">${item.packsNeeded} × ${item.unitsPerPack}/pack</span>
                                            </td>
                                            <td style="text-align:right;color:#64748b;">₹${item.packPrice}</td>
                                            <td style="text-align:right;font-weight:700;color:#0f172a;font-size:0.95rem;">₹${item.subtotal}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>

                        <%-- External medicines --%>
                        <c:if test="${not empty externalItems}">
                            <div style="font-size:0.78rem;font-weight:800;color:#f59e0b;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:0.5rem;">⚠ Purchase from External Pharmacy — Not Available Here</div>
                            <div style="padding:0.6rem 1rem;background:#fffbeb;border:1px solid #fde68a;border-radius:8px;margin-bottom:0.75rem;font-size:0.82rem;color:#92400e;">
                                These medicines are not stocked in our pharmacy. Please purchase from an external medical store.
                            </div>
                            <div class="table-container" style="margin-bottom:1.5rem;">
                                <table class="med-table">
                                    <thead>
                                        <tr><th>#</th><th>Medicine</th><th>Dosage</th><th>Timing</th><th>Duration</th><th>Note</th></tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="ext" items="${externalItems}" varStatus="vs">
                                        <tr style="background:#fffbeb;">
                                            <td style="color:#94a3b8;font-weight:700;">${vs.index + 1}</td>
                                            <td><strong>${ext.name}</strong></td>
                                            <td><span style="background:#fef3c7;color:#92400e;padding:0.2rem 0.5rem;border-radius:4px;font-size:0.8rem;font-weight:700;">${ext.dosage}</span></td>
                                            <td style="font-size:0.85rem;">${ext.timing}</td>
                                            <td style="font-size:0.85rem;">${ext.duration}</td>
                                            <td><span style="background:#fef3c7;color:#b45309;padding:0.2rem 0.6rem;border-radius:4px;font-size:0.75rem;font-weight:700;">🏪 External Pharmacy</span></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>

                        <%-- Grand Total --%>
                        <div style="border-top:2px solid #e2e8f0;padding-top:1.25rem;display:flex;justify-content:flex-end;">
                            <div style="min-width:320px;">
                                <div style="display:flex;justify-content:space-between;padding:0.4rem 0;font-size:0.9rem;color:#64748b;">
                                    <span>In-house medicines (${availableCount} items)</span>
                                    <span>₹${grandTotal}</span>
                                </div>
                                <c:if test="${externalCount > 0}">
                                    <div style="display:flex;justify-content:space-between;padding:0.4rem 0;font-size:0.9rem;color:#f59e0b;">
                                        <span>External pharmacy (${externalCount} items)</span>
                                        <span>Price varies</span>
                                    </div>
                                </c:if>
                                <div style="display:flex;justify-content:space-between;padding:0.75rem 1rem;background:linear-gradient(135deg,#1d4ed8,#0369a1);border-radius:10px;margin-top:0.5rem;color:white;">
                                    <span style="font-size:1rem;font-weight:700;">Total Amount</span>
                                    <span style="font-size:1.4rem;font-weight:800;">₹${grandTotal}</span>
                                </div>
                                <c:if test="${externalCount > 0}">
                                    <div style="font-size:0.75rem;color:#94a3b8;margin-top:0.4rem;text-align:right;">* External pharmacy costs not included</div>
                                </c:if>
                            </div>
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

            <!-- Instructions + Notes -->
            <div class="grid grid-2">
                <div class="card">
                    <div class="rx-section-label">Special Instructions</div>
                    <c:choose>
                        <c:when test="${not empty prescription.instructions}">
                            <div style="font-size:0.9rem;color:#0f172a;line-height:1.7;white-space:pre-wrap;">${prescription.instructions}</div>
                        </c:when>
                        <c:otherwise><div class="muted">No special instructions.</div></c:otherwise>
                    </c:choose>
                </div>
                <div class="card">
                    <div class="rx-section-label">Doctor Notes</div>
                    <c:choose>
                        <c:when test="${not empty prescription.notes}">
                            <div style="font-size:0.9rem;color:#0f172a;line-height:1.7;white-space:pre-wrap;">${prescription.notes}</div>
                        </c:when>
                        <c:otherwise><div class="muted">No additional notes.</div></c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
