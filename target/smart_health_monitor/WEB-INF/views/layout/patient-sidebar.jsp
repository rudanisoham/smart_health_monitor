<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<aside class="admin-sidebar">
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">SH</div>
        <div class="sidebar-logo-text sidebar-text">
            <div>Smart Health</div>
            <span class="text-xs text-muted">Patient Portal</span>
        </div>
    </div>

    <div class="sidebar-section-label sidebar-text">Navigation</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/patient/dashboard"
           class="sidebar-link <%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M4 19V5"></path>
                    <path d="M4 19h16"></path>
                    <path d="M8 17V9"></path>
                    <path d="M12 17V7"></path>
                    <path d="M16 17v-5"></path>
                </svg>
            </span>
            <span class="sidebar-text">Dashboard</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/health"
           class="sidebar-link <%= "health".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M4.5 12.75 9 8.25l3 3 4.5-4.5"></path>
                    <path d="M21 12a9 9 0 1 1-9-9"></path>
                </svg>
            </span>
            <span class="sidebar-text">Health data</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/analytics"
           class="sidebar-link <%= "analytics".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M4 19V5"></path>
                    <path d="M4 19h16"></path>
                    <path d="M8 17V9"></path>
                    <path d="M12 17V7"></path>
                    <path d="M16 17v-3"></path>
                </svg>
            </span>
            <span class="sidebar-text">Analytics</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/ai"
           class="sidebar-link <%= "ai".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12 3v3"></path>
                    <path d="M12 18v3"></path>
                    <path d="M4.22 4.22 5.64 5.64"></path>
                    <path d="M18.36 18.36 19.78 19.78"></path>
                    <path d="M3 12h3"></path>
                    <path d="M18 12h3"></path>
                    <circle cx="12" cy="12" r="4"></circle>
                </svg>
            </span>
            <span class="sidebar-text">AI checker</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/appointments"
           class="sidebar-link <%= "appointments".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M7 3v4"></path>
                    <path d="M17 3v4"></path>
                    <path d="M3 9h18"></path>
                    <path d="M5 21h14a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Appointments</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/prescriptions"
           class="sidebar-link <%= "prescriptions".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M7 3h10v6H7z"></path>
                    <path d="M7 9l-2 4h14l-2-4"></path>
                    <path d="M7 13v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-5"></path>
                </svg>
            </span>
            <span class="sidebar-text">Prescriptions</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/reports"
           class="sidebar-link <%= "reports".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M7 3h10v6H7z"></path>
                    <path d="M7 9h10v12H7z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Reports</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/notifications"
           class="sidebar-link <%= "notifications".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
            </span>
            <span class="sidebar-text">Notifications</span>
        </a>

        <a href="<%= request.getContextPath() %>/patient/profile"
           class="sidebar-link <%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <path d="M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Profile</span>
        </a>
    </nav>

    <div class="sidebar-section-label sidebar-text">Session</div>
    <div class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/auth/patient/login" class="sidebar-link">
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
        <div class="mt-1">Track health, appointments &amp; alerts.</div>
    </div>
</aside>

