<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("activePage", "billing");
    request.setAttribute("pageTitle", "Billing & Payments");
    request.setAttribute("pageSubtitle", "Consolidated statement of your hospital dues");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        .bill-summary-card { background: white; color: #1e293b; border-radius: 24px; padding: 2.5rem; margin-bottom: 2rem; position: relative; overflow: hidden; border: 1px solid #e2e8f0; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); }
        .bill-summary-card::after { content: ''; position: absolute; top: -50%; right: -20%; width: 300px; height: 300px; background: rgba(59, 130, 246, 0.05); border-radius: 50%; filter: blur(50px); }
        .breakdown-item { display: flex; justify-content: space-between; padding: 1rem 0; border-bottom: 1px solid #f1f5f9; }
        .breakdown-item:last-child { border-bottom: none; }
        .total-row { display: flex; justify-content: space-between; padding-top: 1.5rem; margin-top: 1rem; border-top: 2px dashed #e2e8f0; font-size: 1.5rem; font-weight: 800; color: #0f172a; }
        .btn-pay-master { background: #3b82f6; color: white; border: none; padding: 1.25rem; border-radius: 16px; font-weight: 800; width: 100%; font-size: 1.1rem; cursor: pointer; transition: all 0.2s; box-shadow: 0 10px 15px -3px rgba(59,130,246,0.3); }
        .btn-pay-master:hover { transform: translateY(-2px); box-shadow: 0 20px 25px -5px rgba(59,130,246,0.4); background: #2563eb; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>
        
        <div class="admin-content">
            <div class="grid grid-3 billing-grid">
                <div class="billing-main-col billing-col-span-2">
                    <div class="bill-summary-card">
                        <div class="flex-mobile-stack" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem;">
                            <div>
                                <div style="text-transform:uppercase; letter-spacing:0.1em; font-size:0.75rem; opacity:0.7; font-weight:700;">Account Statement</div>
                                <h2 style="font-size:1.5rem; font-weight:900; margin-top:0.25rem;">Unified Balance</h2>
                            </div>
                            <div class="w-mobile-full" style="text-align:right;">
                                <div style="font-size:0.85rem; opacity:0.7;">Patient ID</div>
                                <div style="font-weight:700;">#PT-${patient.id}</div>
                            </div>
                        </div>

                        <div class="breakdown-item">
                            <span>Hospital Stay (Bed Charges)</span>
                            <strong>₹${totalBedCost}</strong>
                        </div>
                        <div class="breakdown-item">
                            <span>Laboratory & Diagnostics Total</span>
                            <strong>₹${totalLabCost}</strong>
                        </div>
                        <div class="breakdown-item" style="color:#64748b;">
                            <span>Total Payments Credited</span>
                            <strong>- ₹${totalPaid}</strong>
                        </div>

                        <div class="total-row">
                            <span>Net Outstanding</span>
                            <span style="${balance > 0 ? 'color:#60a5fa;' : 'color:#34d399;'}">₹${balance > 0 ? balance : 0}</span>
                        </div>

                        <c:if test="${balance > 0}">
                            <div style="margin-top:2.5rem;">
                                <button onclick="payEverything()" class="btn-pay-master">
                                    <i class="fas fa-lock"></i> SETTLE OUTSTANDING DUES (₹${balance})
                                </button>
                                <p style="text-align:center; font-size:0.75rem; opacity:0.5; margin-top:1rem;">Secure encrypted payment via Razorpay</p>
                            </div>
                        </c:if>
                        <c:if test="${balance <= 0}">
                            <div style="margin-top:2.5rem; background:rgba(52,211,153,0.1); border:1px solid #34d399; border-radius:16px; padding:1.5rem; text-align:center; color:#34d399; font-weight:700;">
                                <i class="fas fa-check-circle"></i> ALL DUES SETTLED. NO OUTSTANDING BALANCE.
                            </div>
                        </c:if>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <div class="section-title">Diagnostic Fee Breakdown</div>
                        </div>
                        <div class="table-container mt-2">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Investigation</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th>Charge</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="req" items="${labRequests}">
                                        <tr>
                                            <td style="font-weight:600;">${req.labTest.name}</td>
                                            <td class="muted">${req.requestedAt.toString().replace('T',' ').substring(0,10)}</td>
                                            <td><span class="chip" style="${req.status == 'COMPLETED' ? 'background:#d1fae5; color:#059669;' : ''}">${req.status}</span></td>
                                            <td style="font-weight:700;">₹${req.labTest.price}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty labRequests}">
                                        <tr><td colspan="4" style="text-align:center; padding:2rem;">No diagnostic history found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div>
                    <div class="card">
                        <div class="card-header"><div class="section-title">Payment Help</div></div>
                        <div style="padding:1.5rem;">
                            <div style="margin-bottom:1.5rem;">
                                <div style="font-weight:700; color:#1e293b; margin-bottom:0.5rem;">Bed Charges</div>
                                <div style="font-size:0.85rem; color:#64748b;">Calculated daily from time of admission. Current stay: ${stayDays != null ? stayDays : '—'} days.</div>
                            </div>
                            <div style="margin-bottom:1.5rem;">
                                <div style="font-weight:700; color:#1e293b; margin-bottom:0.5rem;">Lab Reports</div>
                                <div style="font-size:0.85rem; color:#64748b;">Charged per investigation ordered by your physician.</div>
                            </div>
                            <div style="background:#f8fafc; border-radius:12px; padding:1rem; font-size:0.8rem; color:#64748b; border:1px solid #e2e8f0;">
                                <i class="fas fa-info-circle"></i> For corporate insurance or manual billing inquiries, please visit the reception desk.
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Transaction History --%>
            <div class="card mt-4">
                <div class="card-header">
                    <div>
                        <div class="section-title">Transaction History</div>
                        <div class="section-subtitle">Detailed log of all credits and debits</div>
                    </div>
                </div>
                <div class="table-container mt-2">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Type</th>
                                <th>Method</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${payments}">
                                <tr>
                                    <td class="muted" style="font-size:0.85rem;">${p.createdAt.toString().replace('T',' ').substring(0,16)}</td>
                                    <td>
                                        <div style="font-weight:600;">${not empty p.razorpayPaymentId ? p.razorpayPaymentId : 'HOSP-TXN'}</div>
                                        <div class="muted" style="font-size:0.75rem;">${p.description}</div>
                                    </td>
                                    <td><span class="badge-pill">${p.type}</span></td>
                                    <td><strong>${p.method}</strong></td>
                                    <td style="font-weight:700; color:#2563eb;">₹${p.amount}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'COMPLETED'}"><span class="chip">Success</span></c:when>
                                            <c:when test="${p.status == 'PENDING'}"><span class="chip-warning">Pending</span></c:when>
                                            <c:otherwise><span class="chip-danger">Failed</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
async function payEverything() {
    try {
        const response = await fetch('<%= request.getContextPath() %>/patient/billing/pay-all', { method: 'POST' });
        const data = await response.json();
        
        if (data.error) {
            alert(data.error);
            return;
        }

        const options = {
            "key": data.key,
            "amount": data.amount,
            "currency": "INR",
            "name": data.name,
            "description": data.description,
            "order_id": data.orderId,
            "handler": function (response){
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/patient/billing/verify';
                const fields = {
                    razorpay_order_id: data.orderId,
                    razorpay_payment_id: response.razorpay_payment_id,
                    razorpay_signature: response.razorpay_signature
                };
                for (const key in fields) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = fields[key];
                    form.appendChild(input);
                }
                document.body.appendChild(form);
                form.submit();
            },
            "prefill": {
                "name": data.user_name,
                "email": data.user_email,
                "contact": data.user_phone
            },
            "theme": { "color": "#3b82f6" }
        };
        const rzp1 = new Razorpay(options);
        rzp1.open();
    } catch (err) {
        alert("System error. Please try again later.");
    }
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
