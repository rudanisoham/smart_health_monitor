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

  // Theme controls
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
          // ignore
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
      // ignore
    }
  }

  // Settings Tabs
  const settingsTabs = document.querySelectorAll("[data-settings-tab]");
  const settingsPanels = document.querySelectorAll("[data-settings-panel]");

  if (settingsTabs.length && settingsPanels.length) {
    settingsTabs.forEach((tab) => {
      tab.addEventListener("click", () => {
        const target = tab.getAttribute("data-settings-tab");
        settingsTabs.forEach((t) => t.classList.remove("filter-chip", "active"));
        tab.classList.add("filter-chip", "active");

        settingsPanels.forEach((panel) => {
          panel.style.display = panel.getAttribute("data-settings-panel") === target ? "block" : "none";
        });
      });
    });
  }

  // ── Form Validation ─────────────────────────────
  const validatedForms = document.querySelectorAll("form");
  validatedForms.forEach((form) => {
    form.addEventListener("submit", function (e) {
      if (form.hasAttribute("data-no-auto-validate")) return;

      let isValid = true;
      let errorMsg = "";

      // 1. Generic 'required' check
      const requiredInputs = form.querySelectorAll("[required]");
      requiredInputs.forEach((input) => {
        if (!input.value || input.value.trim() === "") {
          isValid = false;
          input.classList.add("field-error");
          if(!errorMsg) errorMsg = "Please fill in all required fields.";
        } else {
          input.classList.remove("field-error");
        }
      });

      // 2. Health Metrics 'at least one' check
      if (form.hasAttribute("data-validate-metrics")) {
        const metricInputs = form.querySelectorAll("input[type='number']");
        let oneFilled = false;
        metricInputs.forEach((mi) => {
          if (mi.value && mi.value.trim() !== "") {
            oneFilled = true;
          }
        });
        if (!oneFilled) {
          isValid = false;
          errorMsg = "Please enter at least one health metric reading.";
        }
      }

      // 3. Password Confirmation Match
      const pw = form.querySelector("#password, #registerPassword, #newPassword");
      const cpw = form.querySelector("#confirmPassword, #confirmRegisterPassword");
      if (pw && cpw && pw.value !== cpw.value) {
        isValid = false;
        errorMsg = "Passwords do not match.";
        cpw.classList.add("field-error");
      }

      if (!isValid) {
        e.preventDefault();
        alert(errorMsg || "Invalid form data. Please check your inputs.");
      }
    });
  });
});
