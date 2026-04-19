<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "patients");
    request.setAttribute("pageTitle", "Patient Search");
    request.setAttribute("pageSubtitle", "Search by name, email or patient ID");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Search · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/medical-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/medical-header.jsp" %>
        <div class="admin-content">

            <!-- Search Form -->
            <div class="card" style="margin-bottom:1.5rem;">
                <div class="section-title">Search Patient</div>
                <div class="section-subtitle mt-1">Filter by name, email, or patient ID — all patients shown by default</div>
                <form action="${pageContext.request.contextPath}/medical/patients" method="get"
                      style="margin-top:1.25rem;display:flex;gap:1rem;flex-wrap:wrap;align-items:flex-end;">
                    <div class="form-group" style="min-width:160px;">
                        <label>Search Type</label>
                        <select name="searchType" class="form-select">
                            <option value="name"  ${searchType == 'name'  ? 'selected' : ''}>Name</option>
                            <option value="email" ${searchType == 'email' ? 'selected' : ''}>Email</option>
                            <option value="id"    ${searchType == 'id'    ? 'selected' : ''}>Patient ID</option>
                        </select>
                    </div>
                    <div class="form-group" style="flex:1;min-width:220px;">
                        <label>Search Query</label>
                        <input type="text" name="query" class="form-control"
                               value="${query}" placeholder="Type to filter patients...">
                    </div>
                    <div class="form-group" style="display:flex;gap:0.5rem;">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <c:if test="${not empty query}">
                            <a href="${pageContext.request.contextPath}/medical/patients" class="btn btn-outline">Clear</a>
                        </c:if>
                    </div>
                </form>
            </div>

            <!-- Patient Table — always visible -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">
                            <c:choose>
                                <c:when test="${not empty query}">Results for "${query}"</c:when>
                                <c:otherwise>All Patients</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="section-subtitle">${not empty patients ? patients.size() : 0} patient(s) found</div>
                    </div>
                </div>
                <div class="table-container mt-2">
                    <table id="patientTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Blood Group</th>
                                <th>Gender</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty patients}">
                                <c:forEach var="p" items="${patients}">
                                    <tr>
                                        <td class="muted" style="font-size:0.85rem;">#${p.id}</td>
                                        <td>
                                            <div style="display:flex;align-items:center;gap:0.75rem;">
                                                <div style="width:34px;height:34px;border-radius:50%;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-weight:700;color:var(--primary);font-size:0.9rem;flex-shrink:0;">
                                                    ${p.user.fullName.substring(0,1)}
                                                </div>
                                                <strong>${p.user.fullName}</strong>
                                            </div>
                                        </td>
                                        <td style="font-size:0.875rem;">${p.user.email}</td>
                                        <td class="muted" style="font-size:0.875rem;">${p.user.phone != null ? p.user.phone : '—'}</td>
                                        <td>
                                            <c:if test="${p.bloodGroup != null}">
                                                <span class="chip-danger" style="font-size:0.75rem;">${p.bloodGroup}</span>
                                            </c:if>
                                            <c:if test="${p.bloodGroup == null}"><span class="muted">—</span></c:if>
                                        </td>
                                        <td class="muted" style="font-size:0.875rem;">${p.gender != null ? p.gender : '—'}</td>
                                        <td class="text-right">
                                            <div style="display:flex;gap:0.5rem;justify-content:flex-end;flex-wrap:wrap;">
                                                <a href="${pageContext.request.contextPath}/medical/patients/${p.id}"
                                                   class="btn btn-primary btn-sm">View Profile</a>
                                                <a href="${pageContext.request.contextPath}/medical/patients/${p.id}#prescriptions"
                                                   class="btn btn-outline btn-sm" style="border-color:#3b82f6;color:#3b82f6;">Prescriptions</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="muted" style="text-align:center;padding:2.5rem;">
                                        <div style="font-size:2rem;margin-bottom:0.5rem;">🔍</div>
                                        No patients found<c:if test="${not empty query}"> for "<strong>${query}</strong>"</c:if>.
                                    </td>
                                </tr>
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
