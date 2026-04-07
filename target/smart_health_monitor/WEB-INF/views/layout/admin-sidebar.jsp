<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="admin-sidebar">
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">SH</div>
        <div class="sidebar-logo-text sidebar-text">
            <div>Smart Health</div>
            <span class="text-xs text-muted">Admin Console</span>
        </div>
    </div>

    <div class="sidebar-section-label sidebar-text">Navigation</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/admin/dashboard"
           class="sidebar-link <%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M3 10.5 12 3l9 7.5"></path>
                    <path d="M5 10v11h14V10"></path>
                </svg>
            </span>
            <span class="sidebar-text">Dashboard</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/doctors"
           class="sidebar-link <%= "doctors".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <path d="M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Doctors</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/patients"
           class="sidebar-link <%= "patients".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <path d="M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Patients</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/departments"
           class="sidebar-link <%= "departments".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M3 21h18"></path>
                    <path d="M6 21V7a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v14"></path>
                    <path d="M10 9h4"></path>
                    <path d="M10 13h4"></path>
                    <path d="M10 17h4"></path>
                </svg>
            </span>
            <span class="sidebar-text">Departments</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/reports"
           class="sidebar-link <%= "reports".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M4 19V5"></path>
                    <path d="M4 19h16"></path>
                    <path d="M8 17V9"></path>
                    <path d="M12 17V7"></path>
                    <path d="M16 17v-5"></path>
                </svg>
            </span>
            <span class="sidebar-text">Reports &amp; Analytics</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/logs"
           class="sidebar-link <%= "logs".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M6 4h12"></path>
                    <path d="M6 8h12"></path>
                    <path d="M6 12h12"></path>
                    <path d="M6 16h12"></path>
                    <path d="M6 20h12"></path>
                </svg>
            </span>
            <span class="sidebar-text">System Logs</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/settings"
           class="sidebar-link <%= "settings".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12 15.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"></path>
                    <path d="M19.4 15a7.9 7.9 0 0 0 .1-1l2-1.5-2-3.5-2.4 1a8 8 0 0 0-1.7-1L15 4h-6l-.4 2.5a8 8 0 0 0-1.7 1l-2.4-1-2 3.5L4.6 14a7.9 7.9 0 0 0 .1 1l-2 1.5 2 3.5 2.4-1a8 8 0 0 0 1.7 1L9 20h6l.4-2.5a8 8 0 0 0 1.7-1l2.4 1 2-3.5-2-1.5z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Settings</span>
        </a>
    </nav>

    <div class="sidebar-section-label sidebar-text">Session</div>
    <div class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/auth/logout" class="sidebar-link">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M10 16l-4-4 4-4"></path>
                    <path d="M6 12h9"></path>
                    <path d="M14 3h6v18h-6"></path>
                </svg>
            </span>
            <span class="sidebar-text">Sign out</span>
        </a>
    </div>

    <div class="sidebar-footer sidebar-text">
        <div><strong>SmartHealthMonitor</strong></div>
        <div class="mt-1">Optimized for hospital operations &amp; insights.</div>
    </div>
</aside>

