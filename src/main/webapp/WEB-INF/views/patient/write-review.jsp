<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "appointments");
    request.setAttribute("pageTitle", "Write a Review");
    request.setAttribute("pageSubtitle", "Rate your appointment with Dr. " + ((com.smarthealth.model.Appointment)request.getAttribute("appointment")).getDoctor().getUser().getFullName());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Write Review · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .star-rating-input {
            display: flex; flex-direction: row-reverse; justify-content: flex-end; font-size: 2.5rem;
        }
        .star-rating-input input { display: none; }
        .star-rating-input label { color: #cbd5e1; cursor: pointer; transition: color 0.2s; }
        .star-rating-input label:hover,
        .star-rating-input label:hover ~ label,
        .star-rating-input input:checked ~ label { color: #f59e0b; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            
            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline btn-sm" style="margin-bottom:1.5rem;">← Cancel</a>

            <div class="card" style="max-width:600px; margin:0 auto; padding:2rem;">
                <h2 style="font-size:1.5rem; margin-bottom:0.5rem; font-weight:700;">Rate your experience</h2>
                <p class="muted" style="margin-bottom:1.5rem;">Appointment on ${appointment.scheduledAt.toString().substring(0,10)} with <strong>Dr. ${appointment.doctor.user.fullName}</strong></p>

                <form action="${pageContext.request.contextPath}/patient/reviews/submit" method="post">
                    <input type="hidden" name="appointmentId" value="${appointment.id}">
                    
                    <div class="form-group" style="margin-bottom:1.5rem;">
                        <label>Select Rating <span style="color:#ef4444;">*</span></label>
                        <div class="star-rating-input mt-1">
                            <input type="radio" id="star5" name="rating" value="5" required/><label for="star5" title="5 stars">★</label>
                            <input type="radio" id="star4" name="rating" value="4"/><label for="star4" title="4 stars">★</label>
                            <input type="radio" id="star3" name="rating" value="3"/><label for="star3" title="3 stars">★</label>
                            <input type="radio" id="star2" name="rating" value="2"/><label for="star2" title="2 stars">★</label>
                            <input type="radio" id="star1" name="rating" value="1"/><label for="star1" title="1 star">★</label>
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom:1.5rem;">
                        <label for="comment">Write your review <span style="color:#ef4444;">*</span></label>
                        <textarea id="comment" name="comment" class="form-control" rows="4" required placeholder="How was the consultation? Did the doctor explain things clearly?"></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-full" style="padding:0.75rem;">Submit Review</button>
                </form>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
