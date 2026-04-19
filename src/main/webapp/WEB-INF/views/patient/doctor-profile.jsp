<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Doctor Profile");
    request.setAttribute("pageSubtitle", "Dr. " + request.getAttribute("doctor") != null ? ((com.smarthealth.model.Doctor)request.getAttribute("doctor")).getUser().getFullName() : "Profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Profile · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .star-rating { color: #f59e0b; font-size: 1.25rem; letter-spacing: 2px; }
        .review-card { padding: 1rem; border: 1px solid var(--border-color); border-radius: 8px; margin-bottom: 1rem; }
        .doctor-hero { display: flex; gap: 2rem; align-items: center; padding: 2rem; background: #eff6ff; border-radius: 12px; margin-bottom: 2rem; }
        .doc-avatar { width: 100px; height: 100px; border-radius: 50%; background: #3b82f6; color: white; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: bold; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline btn-sm" style="margin-bottom:1.5rem;">← Back to Appointments</a>

            <div class="doctor-hero">
                <div class="doc-avatar">
                    Dr
                </div>
                <div>
                    <h2 style="font-size:2rem; font-weight:700; color:#1e293b; margin-bottom:0.25rem;">Dr. ${doctor.user.fullName}</h2>
                    <div style="font-size:1.1rem; color:#475569; margin-bottom:0.75rem;">
                        <c:if test="${not empty doctor.specialty}"><strong>${doctor.specialty}</strong></c:if>
                        <c:if test="${not empty doctor.department}"> · ${doctor.department.name}</c:if>
                    </div>
                    <div style="display:flex; gap:1rem; align-items:center;">
                        <span class="star-rating">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${not empty avgRating and avgRating >= i}">★</c:when>
                                    <c:otherwise>☆</c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                        <span class="muted" style="font-size:0.9rem; font-weight:600;">
                            ${not empty avgRating ? String.format("%.1f", avgRating) : 'New'} / 5.0
                        </span>
                        <span class="muted" style="font-size:0.9rem;">(${reviewCount != null ? reviewCount : 0} reviews)</span>
                    </div>
                </div>
            </div>

            <div class="grid grid-2">
                <div class="card">
                    <div class="section-title">About the Doctor</div>
                    <div class="mt-3" style="line-height:1.6; color:#475569;">
                        <c:choose>
                            <c:when test="${not empty doctor.bio}">${doctor.bio}</c:when>
                            <c:otherwise>This doctor's profile biography is currently empty.</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="card">
                    <div class="section-title">Patient Reviews</div>
                    <div class="mt-3">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="rev" items="${reviews}">
                                    <div class="review-card">
                                        <div style="display:flex; justify-content:space-between; margin-bottom:0.5rem; align-items:center;">
                                            <div style="font-weight:600;">${rev.patient.user.fullName}</div>
                                            <div class="star-rating" style="font-size:1rem;">
                                                <c:forEach begin="1" end="5" var="i">
                                                    ${rev.rating >= i ? '★' : '☆'}
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div style="font-size:0.9rem; color:#475569; margin-bottom:0.5rem;">
                                            ${rev.comment}
                                        </div>
                                        <div class="muted" style="font-size:0.75rem;">
                                            Reviewed on: ${rev.createdAt.toString().substring(0,10)}
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="muted" style="padding:1.5rem; text-align:center;">No reviews yet. Be the first to review!</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
