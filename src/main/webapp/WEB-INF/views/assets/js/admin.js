document.addEventListener("DOMContentLoaded", function () {
  const body = document.body;

  function applyTheme(mode) {
    if (!body) return;
    body.classList.remove("theme-dark", "theme-light");
    if (mode === "light") {
      body.classList.add("theme-light");
    } else {
      body.classList.add("theme-dark");
    }
    try {
      localStorage.setItem("adminTheme", mode === "light" ? "light" : "dark");
    } catch (e) {
      // ignore
    }
  }

  // Initial theme from storage or default to dark
  try {
    const storedTheme = localStorage.getItem("adminTheme");
    if (storedTheme === "light") {
      applyTheme("light");
    } else {
      applyTheme("dark");
    }
  } catch (e) {
    applyTheme("dark");
  }

  // Theme controls (e.g. on settings page)
  const themeControls = document.querySelectorAll("[data-theme-mode]");
  themeControls.forEach((el) => {
    el.addEventListener("click", () => {
      const mode = el.getAttribute("data-theme-mode");
      applyTheme(mode === "light" ? "light" : "dark");
    });
  });

  const sidebar = document.querySelector(".admin-sidebar");
  const appRoot = document.querySelector(".admin-app");
  const toggleButtons = document.querySelectorAll("[data-sidebar-toggle]");

  if (sidebar && appRoot && toggleButtons.length) {
    toggleButtons.forEach((btn) => {
      btn.addEventListener("click", () => {
        const isCollapsed = sidebar.classList.toggle("collapsed");
        appRoot.classList.toggle("sidebar-collapsed", isCollapsed);
        try {
          localStorage.setItem("adminSidebarCollapsed", isCollapsed ? "1" : "0");
        } catch (e) {
          // ignore storage issues
        }
      });
    });

    try {
      const stored = localStorage.getItem("adminSidebarCollapsed");
      if (stored === "1") {
        sidebar.classList.add("collapsed");
        appRoot.classList.add("sidebar-collapsed");
      }
    } catch (e) {
      // ignore storage issues
    }
  }

  // Simple tab-like behaviour for settings sections
  const settingsTabs = document.querySelectorAll("[data-settings-tab]");
  const settingsPanels = document.querySelectorAll("[data-settings-panel]");

  if (settingsTabs.length && settingsPanels.length) {
    settingsTabs.forEach((tab) => {
      tab.addEventListener("click", () => {
        const target = tab.getAttribute("data-settings-tab");
        settingsTabs.forEach((t) => t.classList.remove("filter-chip", "active"));
        tab.classList.add("filter-chip", "active");

        settingsPanels.forEach((panel) => {
          if (panel.getAttribute("data-settings-panel") === target) {
            panel.style.display = "block";
          } else {
            panel.style.display = "none";
          }
        });
      });
    });
  }
});

