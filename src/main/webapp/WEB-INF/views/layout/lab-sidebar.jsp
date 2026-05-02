<aside class="admin-sidebar">
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">LAB</div>
        <div class="sidebar-logo-text sidebar-text">
            <div>Smart Health</div>
            <span class="text-xs text-muted">Laboratory Portal</span>
        </div>
    </div>

    <div class="sidebar-section-label sidebar-text">Navigation</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/lab/dashboard"
           class="sidebar-link <%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon"><svg class="nav-icon" viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></span>
            <span class="sidebar-text">Lab Requests</span>
        </a>
        <a href="<%= request.getContextPath() %>/lab/tests"
           class="sidebar-link <%= "tests".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="3" y1="9" x2="21" y2="9"></line>
                    <line x1="9" y1="21" x2="9" y2="9"></line>
                </svg>
            </span>
            <span class="sidebar-text">Test Catalog</span>
        </a>
        <a href="<%= request.getContextPath() %>/lab/history"
           class="sidebar-link <%= "history".equals(request.getAttribute("activePage")) ? "active" : "" %>">
            <span class="icon">
                <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
            </span>
            <span class="sidebar-text">Report History</span>
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
        <div class="mt-1">Diagnostics & Lab Reports</div>
    </div>
</aside>
