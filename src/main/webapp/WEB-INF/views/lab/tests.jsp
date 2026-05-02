<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "tests");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab Test Catalog · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body class="admin-body">
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/lab-sidebar.jsp" %>
    
    <main class="admin-main">
        <header class="admin-header">
            <div class="header-left">
                <button class="sidebar-toggle" id="mobileToggle">
                    <span class="sidebar-toggle-icon"></span>
                </button>
                <div class="page-title">Lab Test Catalog <span>Hospital Inventory</span></div>
            </div>
            <div class="header-right">
                <button class="btn btn-primary" onclick="openAddTestModal()">
                    <svg class="nav-icon" style="width:18px;height:18px;" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                    Add New Test
                </button>
                <div class="header-avatar">${sessionScope.sessionUser.fullName.substring(0,1)}</div>
            </div>
        </header>

        <div class="admin-content">
            <c:if test="${not empty success}">
                <div class="chip" style="margin-bottom: 1.5rem; width: 100%; padding: 1rem; border-radius: 12px;">
                    <svg class="nav-icon" style="width:20px;height:20px;margin-right:0.5rem;" viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                    ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="chip-danger" style="margin-bottom: 1.5rem; width: 100%; padding: 1rem; border-radius: 12px;">
                    ${error}
                </div>
            </c:if>

            <div class="card" style="padding: 0; overflow: hidden;">
                <div class="table-container" style="border: none; margin-top: 0;">
                    <table>
                        <thead>
                            <tr>
                                <th>Test ID</th>
                                <th>Test Name</th>
                                <th>Description</th>
                                <th>Price (₹)</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${labTests}">
                                <tr>
                                    <td><span class="badge-soft">#${t.id}</span></td>
                                    <td><strong>${t.name}</strong></td>
                                    <td><span class="text-muted" style="font-size: 0.9rem;">${t.description}</span></td>
                                    <td><span style="font-weight: 700; color: var(--primary);">₹${t.price}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.active}"><span class="chip">Active</span></c:when>
                                            <c:otherwise><span class="chip-neutral">Inactive</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty labTests}">
                                <tr><td colspan="5" style="text-align:center;padding:4rem;">
                                    <div style="font-size: 3rem; opacity: 0.2; margin-bottom: 1rem;">🧪</div>
                                    <div class="text-muted">No tests defined in the catalog yet.</div>
                                </td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <footer class="admin-footer">
            Smart Health Hospital Management System &copy; 2026
        </footer>
    </main>
</div>

<!-- Add Test Modal -->
<div id="addTestModal" style="display:none; position:fixed; inset:0; background:rgba(15,23,42,0.6); backdrop-filter:blur(4px); z-index:100; align-items:center; justify-content:center;">
    <div class="card" style="width:100%; max-width:500px; padding:2.5rem; animation: modalSlide 0.3s ease-out;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem;">
            <h3 class="section-title">Add New Lab Test</h3>
            <button class="btn-icon" onclick="closeAddTestModal()">&times;</button>
        </div>
        
        <form action="${pageContext.request.contextPath}/lab/tests/add" method="post" class="form-grid">
            <div class="form-group">
                <label>Test Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Blood Sugar (Fasting)" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" class="form-control" rows="3" placeholder="Brief details about the test..."></textarea>
            </div>
            <div class="form-group">
                <label>Service Price (₹)</label>
                <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
            </div>
            
            <div style="display:flex; gap:1rem; margin-top:1rem;">
                <button type="submit" class="btn btn-primary w-full">Create Test Entry</button>
                <button type="button" class="btn btn-outline w-full" onclick="closeAddTestModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<style>
@keyframes modalSlide {
    from { transform: translateY(20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}
</style>

<script>
    function openAddTestModal() { document.getElementById('addTestModal').style.display = 'flex'; }
    function closeAddTestModal() { document.getElementById('addTestModal').style.display = 'none'; }
    
    // Close modal on escape key
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') closeAddTestModal();
    });
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
