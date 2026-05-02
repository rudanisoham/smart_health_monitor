<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "beds");
    request.setAttribute("pageTitle", "Bed Management");
    request.setAttribute("pageSubtitle", "Select a department to manage bed assignments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bed Management · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .dept-card {
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #e2e8f0;
            position: relative;
            overflow: hidden;
        }
        .dept-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px -5px rgba(0,0,0,0.1);
            border-color: #3b82f6;
        }
        .dept-card::after {
            content: 'View Beds →';
            position: absolute;
            bottom: 1.25rem;
            right: 1.5rem;
            font-size: 0.8rem;
            font-weight: 700;
            color: #3b82f6;
            opacity: 0;
            transition: all 0.3s;
        }
        .dept-card:hover::after {
            opacity: 1;
            right: 1.25rem;
        }
        .dept-icon {
            width: 48px;
            height: 48px;
            background: #eff6ff;
            color: #3b82f6;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <%-- Bed Pricing Config --%>
            <div class="card" style="margin-bottom:2rem; border-left:4px solid var(--primary);">
                <div class="card-header" style="border-bottom:none; padding-bottom:0.5rem;">
                    <div>
                        <div class="section-title">Bed Pricing Configuration</div>
                        <div class="section-subtitle">Update daily charges for all hospital beds</div>
                    </div>
                </div>
                <form action="<%= request.getContextPath() %>/reception/beds/update-charges" method="post" style="padding:0 1.5rem 1.5rem 1.5rem;">
                    <div style="display:flex; gap:1.5rem; align-items:flex-end;">
                        <div class="form-group" style="margin:0; flex:1;">
                            <label style="font-size:0.75rem; font-weight:700; color:var(--text-muted); text-transform:uppercase;">Normal Bed (₹/Day)</label>
                            <input type="number" name="normalCharge" class="form-control" value="${normalCharge}" required min="0" step="0.01">
                        </div>
                        <div class="form-group" style="margin:0; flex:1;">
                            <label style="font-size:0.75rem; font-weight:700; color:var(--text-muted); text-transform:uppercase;">ICU Bed (₹/Day)</label>
                            <input type="number" name="icuCharge" class="form-control" value="${icuCharge}" required min="0" step="0.01">
                        </div>
                        <button type="submit" class="btn btn-primary" style="height:2.75rem; border-radius:12px; font-weight:700;">UPDATE RATES</button>
                    </div>
                    <p style="font-size:0.75rem; color:var(--text-muted); margin-top:0.75rem; font-style:italic;">
                        * Note: Changes will apply globally to all beds in all departments. Existing bills may be affected upon recalculation.
                    </p>
                </form>
            </div>

            <div class="grid grid-3">
                <c:forEach var="dept" items="${departments}">
                    <div class="card dept-card" onclick="location.href='<%= request.getContextPath() %>/reception/beds/department/${dept.id}'">
                        <div class="dept-icon">
                            <c:choose>
                                <c:when test="${dept.name.contains('Cardio')}">❤️</c:when>
                                <c:when test="${dept.name.contains('Neuro')}">🧠</c:when>
                                <c:when test="${dept.name.contains('Pediat')}">👶</c:when>
                                <c:when test="${dept.name.contains('Emerg')}">🚨</c:when>
                                <c:otherwise>🏥</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-title" style="font-size:1.1rem;">${dept.name}</div>
                        
                        <div style="display:flex;gap:0.5rem;margin-top:1rem;flex-wrap:wrap;">
                            <span class="chip">${dept.availableBeds} Free</span>
                            <span class="chip-danger">${dept.occupiedBeds} Occupied</span>
                        </div>

                        <div class="progress-container" style="margin-top:1.25rem; margin-bottom: 0.5rem;">
                            <c:set var="pct" value="${dept.totalBeds > 0 ? (dept.occupiedBeds * 100 / dept.totalBeds) : 0}"/>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill ${pct > 90 ? 'danger' : (pct > 70 ? 'warning' : 'success')}" style="width:${pct}%;"></div>
                            </div>
                            <div class="progress-label" style="margin-top:0.5rem;">
                                <span style="font-size:0.8rem; font-weight:600; color:#64748b;">${dept.occupiedBeds}/${dept.totalBeds} beds assigned</span>
                                <span style="font-size:0.85rem; font-weight:700; color:#1e293b;">${pct}%</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
