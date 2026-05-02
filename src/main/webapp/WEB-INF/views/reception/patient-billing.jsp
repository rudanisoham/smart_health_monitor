<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patient Billing");
    request.setAttribute("pageSubtitle", "Manage accounts and cash settlements");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Billing · Reception Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .billing-grid { display: grid; grid-template-columns: 1fr 350px; gap: 1.5rem; }
        .summary-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 20px; padding: 2rem; }
        .balance-card { background: white; color: #1e293b; border: 1px solid #e2e8f0; border-radius: 20px; padding: 1.5rem; text-align: center; margin-bottom: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .stat-row { display: flex; justify-content: space-between; margin-bottom: 0.75rem; font-size: 0.9rem; }
        .stat-row.total { border-top: 1px dashed #cbd5e1; padding-top: 1rem; margin-top: 1rem; font-weight: 800; font-size: 1.1rem; color: #0f172a; }
        .cash-input-group { background: white; border: 2px solid #e2e8f0; border-radius: 16px; padding: 1.5rem; transition: border-color 0.2s; }
        .cash-input-group:focus-within { border-color: #3b82f6; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">
            <div style="margin-bottom: 2rem; display: flex; align-items: center; gap: 1rem;">
                <a href="<%= request.getContextPath() %>/reception/patients" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Back</a>
                <h2 style="margin:0; font-weight:800;">Billing: ${patient.user.fullName}</h2>
            </div>

            <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

            <div class="billing-grid">
                <div>
                    <div class="card">
                        <div class="card-header"><div class="section-title">Diagnostic & Lab Services</div></div>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Investigation</th>
                                        <th>Date</th>
                                        <th>Doctor</th>
                                        <th>Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="req" items="${labRequests}">
                                        <tr>
                                            <td><strong>${req.labTest.name}</strong></td>
                                            <td class="muted">${req.requestedAt.toString().substring(0,10)}</td>
                                            <td>Dr. ${req.doctor.user.fullName}</td>
                                            <td style="font-weight:700;">₹${req.labTest.price}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty labRequests}">
                                        <tr><td colspan="4" style="text-align:center; padding:2rem;">No diagnostic charges found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card mt-4">
                        <div class="card-header"><div class="section-title">Transaction History</div></div>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Description</th>
                                        <th>Method</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${payments}">
                                        <tr>
                                            <td class="muted">${p.createdAt.toString().substring(0,16)}</td>
                                            <td>${p.description}</td>
                                            <td><span class="badge-pill">${p.method}</span></td>
                                            <td style="font-weight:700; color:${p.amount > 0 ? '#2563eb' : '#ef4444'};">₹${p.amount}</td>
                                            <td><span class="chip ${p.status == 'COMPLETED' ? '' : 'chip-warning'}">${p.status}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div>
                    <div class="balance-card">
                        <div style="font-size:0.8rem; opacity:0.8; text-transform:uppercase; margin-bottom:0.5rem;">Current Balance Due</div>
                        <div style="font-size:2.5rem; font-weight:900;" id="liveBalanceDisplay">₹${balance}</div>
                    </div>

                    <div class="summary-box">
                        <h4 style="margin-top:0; margin-bottom:1.5rem; font-weight:800;">Statement Summary</h4>
                        <div class="stat-row">
                            <span>Bed Stay Charges</span>
                            <strong>₹${totalBedCost}</strong>
                        </div>
                        <div class="stat-row">
                            <span>Diagnostic Fees</span>
                            <strong>₹${totalLabCost}</strong>
                        </div>
                        <div class="stat-row" style="color:#ef4444;">
                            <span>Total Payments</span>
                            <strong>- ₹${totalPaid}</strong>
                        </div>
                        <div class="stat-row total">
                            <span>Total Outstanding</span>
                            <span id="outstandingValue">₹${balance}</span>
                        </div>

                        <div class="mt-4">
                            <h4 style="font-weight:800; margin-bottom:1rem;">Collect Cash Payment</h4>
                            <form action="<%= request.getContextPath() %>/reception/patient/${patient.id}/pay-cash" method="post">
                                <div class="cash-input-group">
                                    <label style="display:block; font-size:0.75rem; font-weight:700; color:#64748b; margin-bottom:0.5rem;">Amount to Collect</label>
                                    <div style="display:flex; align-items:center; gap:0.5rem;">
                                        <span style="font-size:1.5rem; font-weight:700; color:#1e293b;">₹</span>
                                        <input type="number" name="amount" id="cashAmount" step="0.01" class="form-control" style="font-size:1.5rem; font-weight:800; border:none; padding:0;" placeholder="0.00" required oninput="calculateChange()">
                                    </div>
                                </div>
                                
                                <div id="changeLogic" style="display:none; margin-top:1rem; padding:1rem; background:#f0fdf4; border-radius:12px; border:1px solid #bbf7d0;">
                                    <div style="display:flex; justify-content:space-between; font-size:0.85rem; color:#166534;">
                                        <span>New Balance:</span>
                                        <strong id="newBalanceVal">₹0.00</strong>
                                    </div>
                                    <div id="advanceNotice" style="display:none; font-size:0.75rem; color:#059669; margin-top:0.5rem; font-weight:600;">
                                        <i class="fas fa-info-circle"></i> Extra payment will be credited as advance.
                                    </div>
                                </div>

                                <div class="form-group mt-3">
                                    <textarea name="description" class="form-control" rows="2" placeholder="Payment notes (e.g. Received from brother)"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 mt-3" style="padding:1rem; border-radius:12px; font-weight:800;">
                                    <i class="fas fa-money-bill-wave"></i> RECORD SETTLEMENT
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    const currentBalance = parseFloat('${balance}');
    function calculateChange() {
        const input = document.getElementById('cashAmount').value;
        const amount = parseFloat(input) || 0;
        const changeLogic = document.getElementById('changeLogic');
        const newBalanceVal = document.getElementById('newBalanceVal');
        const advanceNotice = document.getElementById('advanceNotice');

        if (amount > 0) {
            changeLogic.style.display = 'block';
            const remaining = currentBalance - amount;
            newBalanceVal.textContent = '₹' + Math.max(0, remaining).toFixed(2);
            
            if (remaining < 0) {
                advanceNotice.style.display = 'block';
                newBalanceVal.textContent = '₹0.00 (Advance: ₹' + Math.abs(remaining).toFixed(2) + ')';
            } else {
                advanceNotice.style.display = 'none';
            }
        } else {
            changeLogic.style.display = 'none';
        }
    }
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
