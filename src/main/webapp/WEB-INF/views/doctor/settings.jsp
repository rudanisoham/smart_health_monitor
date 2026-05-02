<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <% request.setAttribute("activePage", "settings" ); request.setAttribute("pageTitle", "Settings" );
            request.setAttribute("pageSubtitle", "Security preferences and account configurations" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Settings · Smart Health Monitor</title>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
            </head>

            <body>
                <div class="admin-app">
                    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
                        <main class="admin-main">
                            <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

                                <div class="admin-content">

                                    <c:if test="${not empty success}">
                                        <div
                                            style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">
                                            ${success}</div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div
                                            style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">
                                            ${error}</div>
                                    </c:if>

                                    <div class="grid grid-2">
                                        <%-- Security & Password --%>
                                            <div class="card">
                                                <div class="card-header">
                                                    <div>
                                                        <div class="section-title">Change Password</div>
                                                        <div class="section-subtitle">Keep your account secure</div>
                                                    </div>
                                                    <span class="chip-neutral">Security</span>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/doctor/settings/update"
                                                    method="post" class="mt-3">
                                                    <div class="form-group">
                                                        <label for="currentPassword">Current Password</label>
                                                        <input type="password" id="currentPassword"
                                                            name="currentPassword" class="form-control" required
                                                            placeholder="Enter current password">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="newPassword">New Password</label>
                                                        <input type="password" id="newPassword" name="newPassword"
                                                            class="form-control" required
                                                            placeholder="Enter new password">
                                                    </div>
                                                    <div class="mt-4">
                                                        <button type="submit" class="btn btn-primary">Update
                                                            Password</button>
                                                    </div>
                                                </form>
                                            </div>

                                            <div style="display: flex; flex-direction: column; gap: 1rem;">
                                                <%-- Availability Schedule --%>
                                                <div class="card">
                                                    <div class="card-header">
                                                        <div>
                                                            <div class="section-title">Availability Schedule</div>
                                                            <div class="section-subtitle">Select your active working days</div>
                                                        </div>
                                                        <span class="chip" style="background:rgba(59,130,246,0.1);color:#3b82f6;">Schedule</span>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/doctor/settings/availability" method="post" class="mt-3">
                                                        <div style="display: flex; flex-wrap: wrap; gap: 0.75rem;">
                                                            <c:set var="days" value="Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday" />
                                                            <c:forEach var="day" items="${days.split(',')}">
                                                                <label style="display: flex; align-items: center; gap: 0.5rem; background: rgba(255,255,255,0.03); padding: 0.5rem 1rem; border-radius: 8px; border: 1px solid rgba(255,255,255,0.06); cursor: pointer; min-width: 120px;">
                                                                    <input type="checkbox" name="days[]" value="${day}" 
                                                                        <c:if test="${doctor.availableDays.contains(day)}">checked</c:if>
                                                                    >
                                                                    <span style="font-size: 0.875rem;">${day}</span>
                                                                </label>
                                                            </c:forEach>
                                                        </div>
                                                        <div class="mt-4">
                                                            <button type="submit" class="btn btn-primary btn-sm">Save Schedule</button>
                                                        </div>
                                                    </form>
                                                </div>
                                                <%-- Help & Support --%>
                                                    <div class="card">
                                                        <div class="card-header">
                                                            <div>
                                                                <div class="section-title">Help & Support</div>
                                                                <div class="section-subtitle">Technical assistance and
                                                                    documentation</div>
                                                            </div>
                                                        </div>
                                                        <div class="mt-3">
                                                            <p class="muted" style="margin-bottom: 1rem;">Need help with
                                                                the portal or facing technical issues? Contact hospital
                                                                IT support.</p>
                                                            <a href="rudanisoham07@gmail.com" class="btn btn-outline"
                                                                style="width:100%;text-align:center;">✉ Email
                                                                Support</a>
                                                        </div>
                                                    </div>

                                                    <%-- Danger Zone --%>
                                                        <div class="card"
                                                            style="border-width:0; box-shadow: 0 0 0 1px rgba(239,68,68,0.2); background: rgba(239,68,68,0.02);">
                                                            <div class="card-header"
                                                                style="border-bottom-color: rgba(239,68,68,0.1);">
                                                                <div>
                                                                    <div class="section-title" style="color: #ef4444;">
                                                                        Danger Zone</div>
                                                                    <div class="section-subtitle text-xs"
                                                                        style="color: rgba(239,68,68,0.7);">Irreversible
                                                                        account actions</div>
                                                                </div>
                                                            </div>
                                                            <div class="mt-3">
                                                                <p class="text-xs"
                                                                    style="color:var(--text-muted); margin-bottom:1rem;">
                                                                    Suspending your account will instantly remove you
                                                                    from patient appointment bookings. This action
                                                                    cannot be undone by you. Admin approval will be
                                                                    required to reactivate.
                                                                </p>
                                                                <button class="btn btn-outline btn-sm"
                                                                    style="color:#ef4444;border-color:#ef4444;"
                                                                    onclick="alert('Please contact an administrator to suspend your clinical account.')">Suspend
                                                                    Account</button>
                                                            </div>
                                                        </div>
                                            </div>
                                    </div>

                                </div>

                                <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
                        </main>
                </div>
                <script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
            </body>

            </html>