<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "medicines");
    request.setAttribute("pageTitle", "Medicine Inventory");
    request.setAttribute("pageSubtitle", "Manage all medicines and stock levels");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medicine Inventory · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <form action="${pageContext.request.contextPath}/medical/medicines" method="get" style="display:flex;gap:0.75rem;align-items:center;flex:1;">
                        <div class="search-bar" style="max-width:350px;">
                            <svg class="search-icon" viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                            <input type="text" name="q" value="${q}" placeholder="Search by name or category...">
                        </div>
                        <button type="submit" class="btn btn-outline btn-sm">Search</button>
                        <c:if test="${not empty q}"><a href="${pageContext.request.contextPath}/medical/medicines" class="btn btn-outline btn-sm">Clear</a></c:if>
                    </form>
                    <a href="${pageContext.request.contextPath}/medical/medicines/add" class="btn btn-primary">+ Add Medicine</a>
                </div>

                <div class="table-container mt-3">
                    <table>
                        <thead>
                            <tr><th>Name</th><th>Category</th><th>Form</th><th>Strength</th><th>Stock</th><th>Expiry</th><th>Price</th><th class="text-right">Actions</th></tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty medicines}">
                                <c:forEach var="m" items="${medicines}">
                                    <tr>
                                        <td><strong>${m.name}</strong></td>
                                        <td><span class="chip-neutral" style="font-size:0.75rem;">${m.category != null ? m.category : '—'}</span></td>
                                        <td>${m.dosageForm != null ? m.dosageForm : '—'}</td>
                                        <td>${m.strength != null ? m.strength : '—'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.stockQuantity <= 10}"><span class="chip-danger">${m.stockQuantity} ⚠</span></c:when>
                                                <c:when test="${m.stockQuantity <= 50}"><span class="chip-warning">${m.stockQuantity}</span></c:when>
                                                <c:otherwise><span class="chip">${m.stockQuantity}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="muted" style="font-size:0.85rem;">
                                            <c:choose>
                                                <c:when test="${m.expiryDate != null}">${m.expiryDate}</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${m.price != null ? '₹'.concat(m.price.toString()) : '—'}</td>
                                        <td class="text-right">
                                            <div style="display:flex;gap:0.5rem;justify-content:flex-end;">
                                                <a href="${pageContext.request.contextPath}/medical/medicines/${m.id}/edit" class="btn btn-outline btn-sm" style="border-color:#3b82f6;color:#3b82f6;">Edit</a>
                                                <form action="${pageContext.request.contextPath}/medical/medicines/${m.id}/delete" method="post" style="display:inline;">
                                                    <button type="submit" class="btn btn-outline btn-sm" style="border-color:#ef4444;color:#ef4444;" onclick="return confirm('Remove ${m.name} from inventory?')">Remove</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="8" class="muted" style="text-align:center;padding:2.5rem;">
                                    <div style="font-size:2rem;margin-bottom:0.5rem;">💊</div>
                                    No medicines found. <a href="${pageContext.request.contextPath}/medical/medicines/add">Add the first one</a>.
                                </td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%@ include file="/WEB-INF/views/layout/medical-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
