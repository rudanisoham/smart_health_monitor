<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "prescriptions");
    request.setAttribute("pageTitle", "Prescriptions");
    request.setAttribute("pageSubtitle", "Manage and issue patient prescriptions");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Prescriptions · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        /* Medicine Searchable Dropdown */
        .med-picker { position: relative; }
        .med-picker-input {
            width: 100%; padding: 0.8rem 1.25rem; font-size: 0.95rem;
            background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;
            color: var(--text-main); font-family: inherit; font-weight: 500;
            transition: all 0.2s; cursor: text;
        }
        .med-picker-input:focus {
            outline: none; border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--primary-light); background: white;
        }
        .med-dropdown {
            display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0;
            background: #ffffff !important; border: 1px solid #e2e8f0; border-radius: 10px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.12); z-index: 999;
            max-height: 220px; overflow-y: auto;
        }
        .med-dropdown.open { display: block; }
        .med-option {
            padding: 0.65rem 1rem; cursor: pointer; font-size: 0.9rem;
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid #f1f5f9; transition: background 0.15s;
            background: #ffffff !important; color: #0f172a !important;
        }
        .med-option:last-child { border-bottom: none; }
        .med-option:hover, .med-option.highlighted { background: #eff6ff !important; color: #0f172a !important; }
        .med-option-name { font-weight: 600; color: #0f172a; }
        .med-option-meta { font-size: 0.78rem; color: #64748b; margin-top: 0.1rem; }
        .med-option-badge {
            font-size: 0.72rem; padding: 0.2rem 0.5rem; border-radius: 4px;
            background: #eff6ff; color: #1d4ed8; font-weight: 700; white-space: nowrap;
        }
        .med-option-badge.low { background: #fef2f2; color: #ef4444; }
        .med-no-results { padding: 0.75rem 1rem; color: #64748b; font-size: 0.875rem; text-align: center; background: #ffffff; }
        .med-custom-hint {
            padding: 0.6rem 1rem; font-size: 0.82rem; color: #1d4ed8;
            background: #eff6ff; border-top: 1px solid #bfdbfe; cursor: pointer;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .med-custom-hint:hover { background: #dbeafe; }

        /* Patient Searchable Picker */
        .pat-picker { position: relative; }
        .pat-picker-input {
            width: 100%; padding: 0.8rem 1.25rem; font-size: 0.95rem;
            background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;
            color: #0f172a; font-family: inherit; font-weight: 500;
            transition: all 0.2s; cursor: text;
        }
        .pat-picker-input:focus {
            outline: none; border-color: #1d4ed8;
            box-shadow: 0 0 0 4px rgba(29,78,216,0.12); background: white;
        }
        .pat-dropdown {
            display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0;
            background: #ffffff; border: 1px solid #e2e8f0; border-radius: 10px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.12); z-index: 1000;
            max-height: 240px; overflow-y: auto;
        }
        .pat-dropdown.open { display: block; }
        .pat-option {
            padding: 0.7rem 1rem; cursor: pointer;
            border-bottom: 1px solid #f1f5f9; transition: background 0.15s;
            background: #ffffff; color: #0f172a;
        }
        .pat-option:last-child { border-bottom: none; }
        .pat-option:hover, .pat-option.highlighted { background: #eff6ff; }
        .pat-option-name { font-weight: 600; font-size: 0.9rem; color: #0f172a; }
        .pat-option-meta { font-size: 0.78rem; color: #64748b; margin-top: 0.1rem; }
        .pat-selected-badge {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.4rem 0.75rem; background: #eff6ff; border: 1px solid #bfdbfe;
            border-radius: 6px; font-size: 0.875rem; color: #1d4ed8; font-weight: 600;
            margin-top: 0.5rem;
        }
        .pat-no-results { padding: 0.75rem 1rem; color: #64748b; font-size: 0.875rem; text-align: center; }

        /* Medicine row layout */
        .med-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 32px;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            align-items: start;
        }
        .med-row:first-child .remove-btn { display: none; }
        .remove-btn {
            width: 32px; height: 38px; padding: 0; border-radius: 6px;
            background: white; border: 1px solid #fca5a5; color: #ef4444;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 1rem; transition: 0.2s; flex-shrink: 0;
        }
        .remove-btn:hover { background: #fef2f2; }
        .med-row-header {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 32px;
            gap: 0.5rem; margin-bottom: 0.25rem;
        }
        .med-row-header span {
            font-size: 0.75rem; font-weight: 700; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 0.05em; padding: 0 0.25rem;
        }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <div class="grid grid-2">
                <%-- Issue New Prescription Form --%>
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Issue Prescription</div>
                            <div class="section-subtitle">Add a new record for a patient</div>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/doctor/prescriptions/add" method="post" class="mt-3" id="prescriptionForm">
                        <div class="form-group">
                            <label for="patientSearch">Select Patient</label>
                            <!-- Hidden input that actually submits the patient ID -->
                            <input type="hidden" id="patientId" name="patientId" required>
                            <div class="pat-picker">
                                <input type="text" id="patientSearch" class="pat-picker-input"
                                       placeholder="Search by name or email..."
                                       autocomplete="off">
                                <div class="pat-dropdown" id="patDropdown"></div>
                            </div>
                            <div id="patSelectedBadge" style="display:none;" class="pat-selected-badge">
                                <span id="patSelectedName"></span>
                                <span style="cursor:pointer;font-size:1rem;color:#64748b;" onclick="clearPatient()" title="Clear">×</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="diagnosis">Diagnosis</label>
                            <input type="text" id="diagnosis" name="diagnosis" class="form-control" placeholder="e.g. Acute Bronchitis" required>
                        </div>

                        <!-- Medicines Structured List with Searchable Dropdown -->
                        <div class="form-group">
                            <label>Medicines (Structured List)</label>
                            <div style="padding:0.6rem 0.875rem;background:#eff6ff;border-radius:8px;border-left:3px solid #3b82f6;font-size:0.82rem;color:#1d4ed8;margin-bottom:0.75rem;">
                                Search and select from the medicine inventory, or type a custom name.
                            </div>

                            <!-- Column headers -->
                            <div class="med-row-header">
                                <span>Medicine Name</span>
                                <span>Dosage</span>
                                <span>Timing</span>
                                <span>Duration</span>
                                <span></span>
                            </div>

                            <div id="medicine-list">
                                <!-- First row (built by JS on load) -->
                            </div>

                            <button type="button" class="btn btn-outline btn-sm" style="margin-top:0.5rem;" onclick="addMedicineRow()">
                                + Add Medicine
                            </button>
                        </div>

                        <div class="form-group mt-3">
                            <label for="instructions">Special Instructions (Optional)</label>
                            <textarea id="instructions" name="instructions" class="form-control" rows="2" placeholder="Take with food, avoid alcohol, etc."></textarea>
                        </div>
                        <div class="form-group mt-3">
                            <label for="notes">Doctor Notes (Optional)</label>
                            <textarea id="notes" name="notes" class="form-control" rows="2" placeholder="Private notes or observations"></textarea>
                        </div>
                        <div class="form-group mt-3">
                            <label for="validUntil">Valid Until (Optional)</label>
                            <input id="validUntil" name="validUntil" class="form-control" type="date" min="<%= java.time.LocalDate.now() %>">
                            <span class="muted" style="font-size:0.75rem;">Set an expiration date for this prescription.</span>
                        </div>
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Save &amp; Issue Prescription</button>
                        </div>
                    </form>
                </div>

                <%-- Prescription History --%>
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="section-title">Recent Prescriptions</div>
                            <div class="section-subtitle">Last prescriptions issued by you</div>
                        </div>
                    </div>
                    <div class="table-container mt-2">
                        <table>
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Patient</th>
                                <th>Diagnosis</th>
                                <th>Expiry</th>
                                <th class="text-right">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty prescriptions}">
                                    <c:forEach var="p" items="${prescriptions}">
                                        <tr>
                                            <td style="white-space:nowrap;">${p.createdAt.toString().substring(0,10)}</td>
                                            <td><strong>${p.patient.user.fullName}</strong></td>
                                            <td>${p.diagnosis}</td>
                                            <td class="muted">${p.validUntil != null ? p.validUntil.toString() : 'Ongoing'}</td>
                                            <td class="text-right">
                                                <a href="${pageContext.request.contextPath}/doctor/prescriptions/${p.id}" class="btn btn-outline btn-sm">Details</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="muted text-center" style="padding:2rem;">No prescriptions issued yet.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
<script>
// ── Patient list from server (string concat — no JSP EL in template literals) ──
const PATIENTS = [
    <c:forEach var="pt" items="${patients}" varStatus="vs">
    { id: ${pt.id}, name: '<c:out value="${pt.user.fullName}"/>', email: '<c:out value="${pt.user.email}"/>' }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
];

// ── Patient picker logic ─────────────────────────────────────────────────
(function() {
    const searchEl  = document.getElementById('patientSearch');
    const hiddenEl  = document.getElementById('patientId');
    const dropdown  = document.getElementById('patDropdown');
    const badge     = document.getElementById('patSelectedBadge');
    const badgeName = document.getElementById('patSelectedName');
    let hiIdx = -1;

    function renderPat(q) {
        dropdown.innerHTML = '';
        hiIdx = -1;
        const lq = q.trim().toLowerCase();
        const list = lq.length === 0
            ? PATIENTS.slice(0, 15)
            : PATIENTS.filter(p =>
                p.name.toLowerCase().includes(lq) ||
                p.email.toLowerCase().includes(lq)
              );

        if (list.length === 0) {
            dropdown.innerHTML = '<div class="pat-no-results">No patients found</div>';
        } else {
            list.forEach(function(p, i) {
                const opt = document.createElement('div');
                opt.className = 'pat-option';
                opt.innerHTML = '<div class="pat-option-name">' + p.name + '</div>'
                              + '<div class="pat-option-meta">' + p.email + ' · ID #' + p.id + '</div>';
                opt.addEventListener('mousedown', function(e) {
                    e.preventDefault();
                    selectPatient(p);
                });
                dropdown.appendChild(opt);
            });
        }
    }

    function selectPatient(p) {
        hiddenEl.value = p.id;
        searchEl.value = '';
        searchEl.placeholder = p.name + ' (' + p.email + ')';
        badgeName.textContent = p.name + ' — ' + p.email;
        badge.style.display = 'inline-flex';
        dropdown.classList.remove('open');
    }

    window.clearPatient = function() {
        hiddenEl.value = '';
        searchEl.placeholder = 'Search by name or email...';
        badge.style.display = 'none';
        badgeName.textContent = '';
    };

    searchEl.addEventListener('focus', function() {
        renderPat(searchEl.value);
        dropdown.classList.add('open');
    });
    searchEl.addEventListener('input', function() {
        renderPat(searchEl.value);
        dropdown.classList.add('open');
    });
    searchEl.addEventListener('blur', function() {
        setTimeout(function() { dropdown.classList.remove('open'); }, 160);
    });
    searchEl.addEventListener('keydown', function(e) {
        const opts = dropdown.querySelectorAll('.pat-option');
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            hiIdx = Math.min(hiIdx + 1, opts.length - 1);
            opts.forEach(function(o, i) { o.classList.toggle('highlighted', i === hiIdx); });
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            hiIdx = Math.max(hiIdx - 1, 0);
            opts.forEach(function(o, i) { o.classList.toggle('highlighted', i === hiIdx); });
        } else if (e.key === 'Enter' && hiIdx >= 0) {
            e.preventDefault();
            opts[hiIdx].dispatchEvent(new MouseEvent('mousedown'));
        } else if (e.key === 'Escape') {
            dropdown.classList.remove('open');
        }
    });
    document.addEventListener('click', function(e) {
        if (!searchEl.closest('.pat-picker').contains(e.target)) dropdown.classList.remove('open');
    });
})();

// ── Medicine inventory from server ──────────────────────────────────────
const MEDICINES = [
    <c:forEach var="m" items="${medicines}" varStatus="vs">
    {
        id: ${m.id},
        name: '<c:out value="${m.name}"/>',
        category: '<c:out value="${m.category}"/>',
        dosageForm: '<c:out value="${m.dosageForm}"/>',
        strength: '<c:out value="${m.strength}"/>',
        stock: ${m.stockQuantity}
    }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
];

// ── Build a medicine row ─────────────────────────────────────────────────
function buildMedicineRow(isFirst) {
    const row = document.createElement('div');
    row.className = 'med-row';

    // Hidden actual name input (submitted to server)
    const hiddenName = document.createElement('input');
    hiddenName.type = 'hidden';
    hiddenName.name = 'medicineName[]';

    // Picker wrapper
    const pickerWrap = document.createElement('div');
    pickerWrap.className = 'med-picker';

    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.className = 'med-picker-input';
    searchInput.placeholder = 'Search or type medicine name...';
    searchInput.autocomplete = 'off';
    searchInput.required = true;

    const dropdown = document.createElement('div');
    dropdown.className = 'med-dropdown';

    pickerWrap.appendChild(searchInput);
    pickerWrap.appendChild(dropdown);
    pickerWrap.appendChild(hiddenName);

    // Dosage, Timing, Duration inputs
    const dosageInput   = makeInput('dosage[]',   'Dosage (e.g. 500mg)');
    const timingInput   = makeInput('timing[]',   'Timing (e.g. 1-0-1)');
    const durationInput = makeInput('duration[]', 'Duration (e.g. 5 days)');

    // Remove button
    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'remove-btn';
    removeBtn.innerHTML = '&times;';
    removeBtn.title = 'Remove';
    removeBtn.onclick = () => row.remove();
    if (isFirst) removeBtn.style.display = 'none';

    row.appendChild(pickerWrap);
    row.appendChild(dosageInput);
    row.appendChild(timingInput);
    row.appendChild(durationInput);
    row.appendChild(removeBtn);

    // ── Search logic ──────────────────────────────────────────────────
    let highlightIndex = -1;

    function renderDropdown(query) {
        dropdown.innerHTML = '';
        highlightIndex = -1;

        const q = query.trim().toLowerCase();
        const filtered = q.length === 0
            ? MEDICINES.slice(0, 20)
            : MEDICINES.filter(m =>
                m.name.toLowerCase().includes(q) ||
                m.category.toLowerCase().includes(q) ||
                m.dosageForm.toLowerCase().includes(q)
              );

        if (filtered.length === 0) {
            dropdown.innerHTML = '<div class="med-no-results">No medicines found in inventory</div>';
        } else {
            filtered.forEach((med, idx) => {
                const opt = document.createElement('div');
                opt.className = 'med-option';
                opt.dataset.idx = idx;
                const stockClass = med.stock <= 10 ? 'low' : '';
                opt.innerHTML = '<div>'
                    + '<div class="med-option-name" style="font-weight:600;color:#0f172a;">' + med.name + '</div>'
                    + '<div class="med-option-meta" style="font-size:0.78rem;color:#64748b;margin-top:0.1rem;">'
                    + med.dosageForm + (med.strength ? ' · ' + med.strength : '') + (med.category ? ' · ' + med.category : '')
                    + '</div></div>'
                    + '<span class="med-option-badge ' + stockClass + '">Stock: ' + med.stock + '</span>';
                opt.addEventListener('mousedown', (e) => {
                    e.preventDefault();
                    selectMedicine(med, searchInput, hiddenName, dosageInput, dropdown);
                });
                dropdown.appendChild(opt);
            });
        }

        // "Use custom" hint at bottom
        if (q.length > 0) {
            const hint = document.createElement('div');
            hint.className = 'med-custom-hint';
            hint.innerHTML = '<span>✏️</span> Use "<strong>' + query + '</strong>" as custom medicine';
            hint.addEventListener('mousedown', (e) => {
                e.preventDefault();
                searchInput.value = query;
                hiddenName.value = query;
                dropdown.classList.remove('open');
            });
            dropdown.appendChild(hint);
        }
    }

    function selectMedicine(med, searchEl, hiddenEl, dosageEl, ddEl) {
        searchEl.value = med.name + (med.strength ? ' ' + med.strength : '');
        hiddenEl.value = med.name + (med.strength ? ' ' + med.strength : '');
        // Auto-fill dosage with strength if dosage is empty
        if (!dosageEl.value && med.strength) dosageEl.value = med.strength;
        ddEl.classList.remove('open');
    }

    searchInput.addEventListener('focus', () => {
        renderDropdown(searchInput.value);
        dropdown.classList.add('open');
    });

    searchInput.addEventListener('input', () => {
        hiddenName.value = searchInput.value; // allow custom typing
        renderDropdown(searchInput.value);
        dropdown.classList.add('open');
    });

    searchInput.addEventListener('blur', () => {
        // Small delay so mousedown on option fires first
        setTimeout(() => {
            dropdown.classList.remove('open');
            // If nothing selected from list, use typed value as custom
            if (!hiddenName.value) hiddenName.value = searchInput.value;
        }, 150);
    });

    // Keyboard navigation
    searchInput.addEventListener('keydown', (e) => {
        const opts = dropdown.querySelectorAll('.med-option');
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            highlightIndex = Math.min(highlightIndex + 1, opts.length - 1);
            opts.forEach((o, i) => o.classList.toggle('highlighted', i === highlightIndex));
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            highlightIndex = Math.max(highlightIndex - 1, 0);
            opts.forEach((o, i) => o.classList.toggle('highlighted', i === highlightIndex));
        } else if (e.key === 'Enter' && highlightIndex >= 0) {
            e.preventDefault();
            opts[highlightIndex].dispatchEvent(new MouseEvent('mousedown'));
        } else if (e.key === 'Escape') {
            dropdown.classList.remove('open');
        }
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!pickerWrap.contains(e.target)) dropdown.classList.remove('open');
    }, { capture: true });

    return row;
}

function makeInput(name, placeholder) {
    const inp = document.createElement('input');
    inp.type = 'text';
    inp.name = name;
    inp.className = 'form-control';
    inp.placeholder = placeholder;
    inp.required = true;
    return inp;
}

function addMedicineRow() {
    const list = document.getElementById('medicine-list');
    list.appendChild(buildMedicineRow(false));
}

// Init first row on page load
document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('medicine-list').appendChild(buildMedicineRow(true));
});
</script>
</body>
</html>
