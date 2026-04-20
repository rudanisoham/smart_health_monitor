<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Appointments");
    request.setAttribute("pageSubtitle", "Manage and respond to all your patient appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointments · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .filter-bar { display:flex; gap:0.75rem; flex-wrap:wrap; align-items:center; }
        .filter-bar select, .filter-bar input[type=date], .filter-bar input[type=text] {
            padding:0.55rem 1rem; font-size:0.875rem; background:#f8fafc;
            border:1px solid #e2e8f0; border-radius:8px; color:#0f172a;
            font-family:inherit; transition:all 0.2s;
        }
        .filter-bar select:focus, .filter-bar input:focus {
            outline:none; border-color:#1d4ed8; box-shadow:0 0 0 3px rgba(29,78,216,0.1);
        }
        .sort-btn {
            padding:0.55rem 0.9rem; font-size:0.82rem; font-weight:600;
            background:white; border:1px solid #e2e8f0; border-radius:8px;
            cursor:pointer; color:#64748b; transition:0.2s;
        }
        .sort-btn.active { background:#eff6ff; border-color:#1d4ed8; color:#1d4ed8; }
        .sort-btn:hover { border-color:#1d4ed8; color:#1d4ed8; }
        #resultCount { font-size:0.82rem; color:#64748b; white-space:nowrap; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <%-- KPI Cards --%>
            <div class="grid grid-4" style="margin-bottom:1.5rem;">
                <div class="card">
                    <div class="card-title">Total</div>
                    <div class="card-value">${not empty appointments ? appointments.size() : 0}</div>
                </div>
                <div class="card">
                    <div class="card-title">Pending</div>
                    <div class="card-value" style="color:#fbbf24;">
                        <c:set var="p" value="0"/>
                        <c:forEach var="a" items="${appointments}"><c:if test="${a.status == 'PENDING'}"><c:set var="p" value="${p+1}"/></c:if></c:forEach>
                        ${p}
                    </div>
                </div>
                <div class="card">
                    <div class="card-title">Confirmed</div>
                    <div class="card-value" style="color:#34d399;">
                        <c:set var="cf" value="0"/>
                        <c:forEach var="a" items="${appointments}"><c:if test="${a.status == 'CONFIRMED'}"><c:set var="cf" value="${cf+1}"/></c:if></c:forEach>
                        ${cf}
                    </div>
                </div>
                <div class="card">
                    <div class="card-title">Completed</div>
                    <div class="card-value" style="color:#60a5fa;">
                        <c:set var="cp" value="0"/>
                        <c:forEach var="a" items="${appointments}"><c:if test="${a.status == 'COMPLETED'}"><c:set var="cp" value="${cp+1}"/></c:if></c:forEach>
                        ${cp}
                    </div>
                </div>
            </div>

            <div class="card">
                <%-- Filter & Search Bar --%>
                <div style="margin-bottom:1.25rem;">
                    <div class="filter-bar">
                        <!-- Search -->
                        <input type="text" id="searchInput" placeholder="Search patient name..." oninput="applyFilters()" style="min-width:200px;">

                        <!-- Status filter -->
                        <select id="statusFilter" onchange="applyFilters()">
                            <option value="">All Statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="CONFIRMED">Confirmed</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="CANCELLED">Cancelled</option>
                            <option value="AWAITING_ASSIGNMENT">Awaiting</option>
                        </select>

                        <!-- Date filter -->
                        <input type="date" id="dateFilter" onchange="applyFilters()" title="Filter by date">
                        <button class="sort-btn" onclick="clearDate()" title="Clear date filter" style="font-size:0.8rem;">✕ Date</button>

                        <!-- Sort -->
                        <button class="sort-btn" id="sortNewest" onclick="sortTable('newest')" title="Newest first">↓ Newest</button>
                        <button class="sort-btn" id="sortOldest" onclick="sortTable('oldest')" title="Oldest first">↑ Oldest</button>

                        <span id="resultCount"></span>
                    </div>
                </div>

                <div class="table-container">
                    <table id="apptTable">
                        <thead>
                        <tr>
                            <th>Date &amp; Time</th>
                            <th>Token</th>
                            <th>Patient</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody id="apptBody">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <c:forEach var="appt" items="${appointments}">
                                    <tr data-status="${appt.status}"
                                        data-date="${appt.scheduledAt != null ? appt.scheduledAt.toString().substring(0,10) : ''}"
                                        data-patient="${appt.patient.user.fullName}"
                                        data-ts="${appt.scheduledAt != null ? appt.scheduledAt.toString() : appt.createdAt.toString()}">
                                        <td style="white-space:nowrap;font-size:0.875rem;">
                                            <c:choose>
                                                <c:when test="${appt.scheduledAt != null}">${appt.scheduledAt.toString().replace('T',' ').substring(0,16)}</c:when>
                                                <c:otherwise><span class="muted">TBD</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${appt.tokenNumber != null}">
                                                <span style="background:#eff6ff;color:#1d4ed8;padding:0.2rem 0.5rem;border-radius:4px;font-size:0.8rem;font-weight:700;">#${appt.tokenNumber}</span>
                                            </c:if>
                                            <c:if test="${appt.tokenNumber == null}"><span class="muted">—</span></c:if>
                                        </td>
                                        <td>
                                            <strong>${appt.patient.user.fullName}</strong>
                                            <div class="muted" style="font-size:0.78rem;">${appt.patient.user.email}</div>
                                        </td>
                                        <td class="muted" style="max-width:160px;font-size:0.85rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                            ${appt.notes != null ? appt.notes : '—'}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${appt.status == 'AWAITING_ASSIGNMENT'}"><span class="chip-warning">⏳ Awaiting</span></c:when>
                                                <c:when test="${appt.status == 'PENDING'}"><span class="chip-warning">⏳ Pending</span></c:when>
                                                <c:when test="${appt.status == 'CONFIRMED'}"><span class="chip">✓ Confirmed</span></c:when>
                                                <c:when test="${appt.status == 'COMPLETED'}"><span class="chip-neutral">✅ Completed</span></c:when>
                                                <c:when test="${appt.status == 'CANCELLED'}"><span class="chip-danger">✗ Cancelled</span></c:when>
                                                <c:otherwise><span class="chip-neutral">${appt.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-right">
                                            <div style="display:flex;gap:0.4rem;justify-content:flex-end;flex-wrap:wrap;">
                                                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/doctor/patient/${appt.patient.id}">Patient</a>
                                                <c:if test="${appt.status == 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/doctor/appointments/${appt.id}/confirm" method="post" style="display:inline;">
                                                        <button class="btn btn-primary btn-sm" type="submit">Confirm</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${appt.status == 'CONFIRMED'}">
                                                    <form action="${pageContext.request.contextPath}/doctor/appointments/${appt.id}/complete" method="post" style="display:inline;">
                                                        <button class="btn btn-primary btn-sm" type="submit">Complete</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${appt.status == 'PENDING' or appt.status == 'CONFIRMED'}">
                                                    <form action="${pageContext.request.contextPath}/doctor/appointments/${appt.id}/cancel" method="post" style="display:inline;">
                                                        <button class="btn btn-outline btn-sm" style="border-color:#ef4444;color:#ef4444;" type="submit" onclick="return confirm('Cancel?')">Cancel</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr id="emptyRow">
                                    <td colspan="6" style="text-align:center;padding:2.5rem;" class="muted">
                                        <div style="font-size:2rem;margin-bottom:0.5rem;">📅</div>
                                        No appointments found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                <div id="noResults" style="display:none;text-align:center;padding:2rem;color:#64748b;">
                    <div style="font-size:1.5rem;margin-bottom:0.5rem;">🔍</div>
                    No appointments match your filters.
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
<script>
let currentSort = 'newest';

function applyFilters() {
    const search = document.getElementById('searchInput').value.toLowerCase();
    const status = document.getElementById('statusFilter').value;
    const date   = document.getElementById('dateFilter').value;
    const rows   = document.querySelectorAll('#apptBody tr[data-status]');
    let visible  = 0;

    rows.forEach(row => {
        const matchSearch = !search || row.dataset.patient.toLowerCase().includes(search) ||
                            (row.innerText || row.textContent).toLowerCase().includes(search);
        const matchStatus = !status || row.dataset.status === status;
        const matchDate   = !date   || row.dataset.date === date;
        const show = matchSearch && matchStatus && matchDate;
        row.style.display = show ? '' : 'none';
        if (show) visible++;
    });

    document.getElementById('resultCount').textContent = visible + ' result' + (visible !== 1 ? 's' : '');
    document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
}

function clearDate() {
    document.getElementById('dateFilter').value = '';
    applyFilters();
}

function sortTable(order) {
    currentSort = order;
    document.getElementById('sortNewest').classList.toggle('active', order === 'newest');
    document.getElementById('sortOldest').classList.toggle('active', order === 'oldest');

    const tbody = document.getElementById('apptBody');
    const rows  = Array.from(tbody.querySelectorAll('tr[data-status]'));
    rows.sort((a, b) => {
        const ta = a.dataset.ts || '';
        const tb = b.dataset.ts || '';
        return order === 'newest' ? tb.localeCompare(ta) : ta.localeCompare(tb);
    });
    rows.forEach(r => tbody.appendChild(r));
    applyFilters();
}

// Init: show result count and set default sort active
document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('sortNewest').classList.add('active');
    applyFilters();
});
</script>
</body>
</html>
