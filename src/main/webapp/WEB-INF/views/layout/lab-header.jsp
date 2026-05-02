<header class="admin-header">
    <div class="header-left">
        <button type="button" class="sidebar-toggle" data-sidebar-toggle aria-label="Toggle sidebar">
            <span class="sidebar-toggle-icon"></span>
        </button>
        <div>
            <div class="page-title">
                <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Lab Portal" %>
            </div>
            <div class="page-title">
                <span>
                    <%= request.getAttribute("pageSubtitle") != null ? request.getAttribute("pageSubtitle") : "Laboratory Diagnostics" %>
                </span>
            </div>
        </div>
    </div>

    <div class="header-right">
        <div class="header-pill" style="background: #e0f2fe; color: #0369a1;">
            <span>●</span>
            <span>Lab Active</span>
        </div>

        <div class="header-avatar" style="background: linear-gradient(135deg, #0369a1, #075985); color: white;">
            <span>${sessionScope.sessionUser.fullName.substring(0,1)}</span>
        </div>
    </div>
</header>
