<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="admin-header">
    <div class="header-left">
        <button type="button" class="sidebar-toggle" data-sidebar-toggle aria-label="Toggle sidebar">
            <span class="sidebar-toggle-icon"></span>
        </button>
        <div>
            <div class="page-title">
                <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Patient Portal" %>
            </div>
            <div class="page-title">
                <span>
                    <%= request.getAttribute("pageSubtitle") != null ? request.getAttribute("pageSubtitle") : "Smart Health Monitor" %>
                </span>
            </div>
        </div>
    </div>
    <div class="header-right">
        <div class="header-pill">
            <span>●</span>
            <span>Signed in</span>
        </div>
        <div class="header-avatar" title="Patient">
            <span>P</span>
        </div>
    </div>
</header>

