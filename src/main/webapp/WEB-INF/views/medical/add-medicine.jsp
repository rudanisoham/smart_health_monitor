<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "medicines");
    request.setAttribute("pageTitle", "Add Medicine");
    request.setAttribute("pageSubtitle", "Add a new medicine to the inventory");
    String today = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Medicine · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <div style="margin-bottom:1.5rem;">
                <a href="${pageContext.request.contextPath}/medical/medicines" class="btn btn-outline btn-sm">← Back to Inventory</a>
            </div>

            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/medical/medicines/add" method="post">
                <div class="card" style="max-width:800px;margin:0 auto;">
                    <div style="border-bottom:1px solid var(--border);padding-bottom:1.25rem;margin-bottom:1.5rem;">
                        <div class="section-title">Medicine Details</div>
                        <div class="section-subtitle">Fill in all available information</div>
                    </div>

                    <div class="form-grid form-2">
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="name">Medicine Name <span style="color:#ef4444;">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" required placeholder="e.g. Paracetamol">
                        </div>
                        <div class="form-group">
                            <label for="category">Category</label>
                            <select id="category" name="category" class="form-select">
                                <option value="">-- Select Category --</option>
                                <option>Analgesic</option>
                                <option>Antibiotic</option>
                                <option>Antiviral</option>
                                <option>Antifungal</option>
                                <option>Anti-inflammatory</option>
                                <option>Antihistamine</option>
                                <option>Antacid</option>
                                <option>Antidiabetic</option>
                                <option>Antihypertensive</option>
                                <option>Bronchodilator</option>
                                <option>Statin</option>
                                <option>Vitamin/Supplement</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="dosageForm">Dosage Form</label>
                            <select id="dosageForm" name="dosageForm" class="form-select">
                                <option value="">-- Select Form --</option>
                                <option>Tablet</option>
                                <option>Capsule</option>
                                <option>Syrup</option>
                                <option>Injection</option>
                                <option>Cream</option>
                                <option>Drops</option>
                                <option>Inhaler</option>
                                <option>Patch</option>
                                <option>Powder</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="strength">Strength</label>
                            <input type="text" id="strength" name="strength" class="form-control" placeholder="e.g. 500mg, 250ml">
                        </div>
                        <div class="form-group">
                            <label for="stockQuantity">Stock Quantity <span style="color:#ef4444;">*</span></label>
                            <input type="number" id="stockQuantity" name="stockQuantity" class="form-control" min="0" value="0" required>
                        </div>
                        <div class="form-group">
                            <label for="expiryDate">Expiry Date</label>
                            <input type="date" id="expiryDate" name="expiryDate" class="form-control" min="<%= today %>">
                        </div>
                        <div class="form-group">
                            <label for="price">Price per Unit (₹)</label>
                            <input type="number" id="price" name="price" class="form-control" min="0" step="0.01" placeholder="0.00">
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Price of a single tablet/ml/unit.</span>
                        </div>
                        <div class="form-group">
                            <label for="unitsPerPack">Units per Pack/Strip</label>
                            <input type="number" id="unitsPerPack" name="unitsPerPack" class="form-control" min="1" value="1" placeholder="10">
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">e.g. 10 tablets per strip, 100ml per bottle.</span>
                        </div>
                        <div class="form-group">
                            <label for="pricePerPack">Price per Pack/Strip (₹)</label>
                            <input type="number" id="pricePerPack" name="pricePerPack" class="form-control" min="0" step="0.01" placeholder="0.00">
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Price of one full pack/strip/bottle. Used for billing.</span>
                        </div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label for="description">Description / Notes</label>
                            <textarea id="description" name="description" class="form-control" rows="3" placeholder="Usage notes, side effects, storage instructions..."></textarea>
                        </div>
                    </div>

                    <div style="border-top:1px solid var(--border);padding-top:1.5rem;margin-top:1.5rem;display:flex;justify-content:flex-end;gap:1rem;">
                        <a href="${pageContext.request.contextPath}/medical/medicines" class="btn btn-outline">Cancel</a>
                        <button type="submit" class="btn btn-primary">Add to Inventory</button>
                    </div>
                </div>
            </form>
        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
