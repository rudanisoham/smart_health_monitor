<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "medicines");
    request.setAttribute("pageTitle", "Edit Medicine");
    request.setAttribute("pageSubtitle", "Update medicine details and stock");
    String today = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Medicine · Smart Health Monitor</title>
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
            <form action="${pageContext.request.contextPath}/medical/medicines/${medicine.id}/edit" method="post">
                <div class="card" style="max-width:800px;margin:0 auto;">
                    <div style="border-bottom:1px solid var(--border);padding-bottom:1.25rem;margin-bottom:1.5rem;">
                        <div class="section-title">Edit: ${medicine.name}</div>
                    </div>
                    <div class="form-grid form-2">
                        <div class="form-group" style="grid-column:1/-1;">
                            <label>Medicine Name <span style="color:#ef4444;">*</span></label>
                            <input type="text" name="name" class="form-control" required value="${medicine.name}">
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select name="category" class="form-select">
                                <option value="">-- Select --</option>
                                <c:forEach var="cat" items="${['Analgesic','Antibiotic','Antiviral','Antifungal','Anti-inflammatory','Antihistamine','Antacid','Antidiabetic','Antihypertensive','Bronchodilator','Statin','Vitamin/Supplement','Other']}">
                                    <option ${medicine.category == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Dosage Form</label>
                            <select name="dosageForm" class="form-select">
                                <option value="">-- Select --</option>
                                <c:forEach var="f" items="${['Tablet','Capsule','Syrup','Injection','Cream','Drops','Inhaler','Patch','Powder']}">
                                    <option ${medicine.dosageForm == f ? 'selected' : ''}>${f}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Strength</label>
                            <input type="text" name="strength" class="form-control" value="${medicine.strength}">
                        </div>
                        <div class="form-group">
                            <label>Stock Quantity</label>
                            <input type="number" name="stockQuantity" class="form-control" min="0" value="${medicine.stockQuantity}">
                        </div>
                        <div class="form-group">
                            <label>Expiry Date</label>
                            <input type="date" name="expiryDate" class="form-control" value="${medicine.expiryDate}" min="<%= today %>">
                        </div>
                        <div class="form-group">
                            <label>Price per Unit (₹)</label>
                            <input type="number" name="price" class="form-control" step="0.01" value="${medicine.price}">
                        </div>
                        <div class="form-group">
                            <label>Units per Pack/Strip</label>
                            <input type="number" name="unitsPerPack" class="form-control" min="1" value="${medicine.unitsPerPack != null ? medicine.unitsPerPack : 1}">
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">e.g. 10 tablets per strip.</span>
                        </div>
                        <div class="form-group">
                            <label>Price per Pack/Strip (₹)</label>
                            <input type="number" name="pricePerPack" class="form-control" step="0.01" value="${medicine.pricePerPack}">
                            <span class="muted" style="font-size:0.8rem;margin-top:0.25rem;">Used for billing calculations.</span>
                        </div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label>Description</label>
                            <textarea name="description" class="form-control" rows="3">${medicine.description}</textarea>
                        </div>
                    </div>
                    <div style="border-top:1px solid var(--border);padding-top:1.5rem;margin-top:1.5rem;display:flex;justify-content:flex-end;gap:1rem;">
                        <a href="${pageContext.request.contextPath}/medical/medicines" class="btn btn-outline">Cancel</a>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
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
