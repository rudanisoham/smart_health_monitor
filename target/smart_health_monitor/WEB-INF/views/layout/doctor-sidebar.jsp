<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="admin-sidebar">
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">SH</div>
        <div class="sidebar-logo-text sidebar-text">
            <div>Smart Health</div>
            <span class="text-xs text-muted">Doctor Console</span>
        </div>
    </div>

    <div class="sidebar-section-label sidebar-text">Navigation</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/doctor/dashboard"
           class="sidebar-link <%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M4 19V5"/><path d="M4 19h16"/><path d="M8 17V9"/><path d="M12 17V7"/><path d="M16 17v-5"/></svg></span>
            <span class="sidebar-text">Dashboard</span>
        </a>

        <a href="<%= request.getContextPath() %>/doctor/patients"
           class="sidebar-link <%= "patients".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></span>
            <span class="sidebar-text">Patients</span>
        </a>

        <a href="<%= request.getContextPath() %>/doctor/appointments"
           class="sidebar-link <%= "appointments".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M7 3v4"/><path d="M17 3v4"/><path d="M3 9h18"/><path d="M5 21h14a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2z"/></svg></span>
            <span class="sidebar-text">Appointments</span>
        </a>

        <a href="<%= request.getContextPath() %>/doctor/prescriptions"
           class="sidebar-link <%= "prescriptions".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/></svg></span>
            <span class="sidebar-text">Prescriptions</span>
        </a>

        <a href="<%= request.getContextPath() %>/doctor/alerts"
           class="sidebar-link <%= "alerts".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M12 9v4"/><path d="M12 17h.01"/><path d="M10 3h4l8 16H2L10 3z"/></svg></span>
            <span class="sidebar-text">Alerts</span>
        </a>

        <a href="<%= request.getContextPath() %>/doctor/profile"
           class="sidebar-link <%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></span>
            <span class="sidebar-text">Profile</span>
        </a>

        <a href="<%= request.getContextPath() %>/doctor/settings"
           class="sidebar-link <%= "settings".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg></span>
            <span class="sidebar-text">Settings</span>
        </a>
    </nav>

    <div class="sidebar-section-label sidebar-text">Session</div>
    <div class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/auth/logout" class="sidebar-link">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M10 16l-4-4 4-4"/><path d="M6 12h9"/><path d="M14 3h6v18h-6"/></svg></span>
            <span class="sidebar-text">Sign out</span>
        </a>
    </div>

    <div class="sidebar-footer sidebar-text">
        <div><strong>SmartHealthMonitor</strong></div>
        <div class="mt-1">Clinical workflows · Alerts · Prescriptions.</div>
    </div>
</aside>
