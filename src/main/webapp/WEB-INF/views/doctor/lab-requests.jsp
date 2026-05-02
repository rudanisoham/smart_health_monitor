<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "lab-requests");
    request.setAttribute("pageTitle", "Lab Requests");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab Requests · Doctor Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .request-card { border: 1px solid #e2e8f0; border-radius: 20px; padding: 2rem; background: white; margin-bottom: 1.5rem; display: flex; gap: 1.5rem; transition: all 0.2s; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .request-card:hover { border-color: #3b82f6; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); }
        .request-status { padding: 0.4rem 1rem; border-radius: 100px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; }
        .status-pending { background: #fef3c7; color: #d97706; }
        .status-inprogress { background: #e0e7ff; color: #4338ca; }
        .status-completed { background: #d1fae5; color: #059669; }

        /* Searchable Select Styles */
        .searchable-select { position: relative; }
        .search-results { position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #e2e8f0; border-radius: 12px; max-height: 200px; overflow-y: auto; z-index: 1100; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); display: none; margin-top: 5px; }
        .search-item { padding: 0.75rem 1rem; cursor: pointer; transition: background 0.2s; border-bottom: 1px solid #f1f5f9; }
        .search-item:hover { background: #f8fafc; }
        .search-item:last-child { border-bottom: none; }

        /* Test List Styles */
        .selected-test-item { display: flex; justify-content: space-between; align-items: center; background: #f8fafc; padding: 0.75rem 1rem; border-radius: 12px; margin-bottom: 0.5rem; border: 1px solid #e2e8f0; }
        .remove-test { color: #ef4444; cursor: pointer; font-size: 1.2rem; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/doctor-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/doctor-header.jsp" %>
        <div class="admin-content">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:2.5rem;">
                <div>
                    <h2 style="font-size:2rem; font-weight:800; color:#1e293b; margin:0;">Lab Requests</h2>
                    <p class="muted">Order diagnostics and monitor patient lab progress.</p>
                </div>
                <button class="btn btn-primary" onclick="showRequestModal()" style="padding: 0.75rem 1.5rem; border-radius: 12px; font-weight: 700;">
                    <i class="fas fa-plus-circle"></i> Create New Order
                </button>
            </div>

            <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

            <c:if test="${empty labRequests}">
                <div class="card" style="padding:5rem 2rem; text-align:center;">
                    <div style="font-size:4rem; margin-bottom:1.5rem; opacity:0.2;">🔬</div>
                    <h3 style="color:#64748b; font-weight:700;">No Active Requests</h3>
                    <p class="muted">Your prescribed diagnostic tests will be listed here.</p>
                </div>
            </c:if>

            <c:forEach var="req" items="${labRequests}">
                <div class="request-card">
                    <div style="flex:1;">
                        <div style="display:flex; justify-content:space-between; margin-bottom:0.75rem; align-items:center;">
                            <h3 style="font-size:1.2rem; font-weight:800; color:#1e293b; margin:0;">${req.labTest.name}</h3>
                            <span class="request-status ${req.status == 'PENDING' ? 'status-pending' : req.status == 'IN_PROGRESS' ? 'status-inprogress' : 'status-completed'}">
                                ${req.status}
                            </span>
                        </div>
                        <div style="display:flex; gap:2.5rem; font-size:0.9rem; color:#64748b; margin-bottom:1.25rem;">
                            <div style="display:flex; align-items:center; gap:0.5rem;"><i class="fas fa-user-circle"></i> <strong>Patient:</strong> ${req.patient.user.fullName}</div>
                            <div style="display:flex; align-items:center; gap:0.5rem;"><i class="fas fa-calendar-alt"></i> <strong>Ordered:</strong> ${req.requestedAt.toString().replace('T', ' ').substring(0,16)}</div>
                        </div>
                        <c:if test="${not empty req.doctorNotes}">
                            <div style="font-size:0.85rem; background:#f8fafc; padding:1rem; border-radius:12px; border:1px solid #e2e8f0; margin-bottom:0.75rem;">
                                <strong style="color:#475569;"><i class="fas fa-clipboard-list"></i> Clinical Instructions:</strong><br/>
                                <div style="margin-top:0.25rem;">${req.doctorNotes}</div>
                            </div>
                        </c:if>
                        <c:if test="${not empty req.resultFileUrl}">
                            <div style="margin-top: 1rem;">
                                <a href="<%= request.getContextPath() %>${req.resultFileUrl}" target="_blank" class="btn btn-outline btn-sm" style="border-radius:8px;">
                                    <i class="fas fa-file-download"></i> Download Report
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
        <%@ include file="/WEB-INF/views/layout/doctor-footer.jsp" %>
    </main>
</div>

<!-- Advanced Request Lab Modal -->
<div id="requestModal" style="display:none;position:fixed;inset:0;background:rgba(15,23,42,0.7);backdrop-filter:blur(4px);z-index:2000;align-items:center;justify-content:center;padding:1rem;">
    <div style="background:white;border-radius:2rem;padding:2.5rem;width:100%;max-width:550px;box-shadow:0 25px 50px -12px rgba(0,0,0,0.5);max-height:95vh;overflow-y:auto;">
        <h3 style="font-size:1.75rem;font-weight:900;margin-bottom:2rem;color:#1e293b;text-align:center;">New Diagnostic Order</h3>
        
        <form action="<%= request.getContextPath() %>/doctor/lab-requests/create" method="post" id="labOrderForm">
            <!-- Searchable Patient Select -->
            <div class="form-group searchable-select">
                <label style="font-weight:700; color:#334155;">Search Patient</label>
                <div style="position:relative;">
                    <i class="fas fa-search" style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:#94a3b8;"></i>
                    <input type="text" id="patientSearch" class="form-control" placeholder="Type name or email..." autocomplete="off" style="padding-left:2.5rem;">
                </div>
                <input type="hidden" name="patientId" id="selectedPatientId" required>
                <div id="patientResults" class="search-results">
                    <c:forEach var="p" items="${patients}">
                        <div class="search-item" data-id="${p.id}" data-name="${p.user.fullName}" data-info="${p.user.email}">
                            <div style="font-weight:700; color:#1e293b;">${p.user.fullName}</div>
                            <div style="font-size:0.75rem; color:#64748b;">${p.user.email}</div>
                        </div>
                    </c:forEach>
                </div>
                <div id="patientDisplay" style="display:none; margin-top:0.5rem; padding:0.75rem; background:#f0fdf4; border:1px solid #bbf7d0; border-radius:12px; color:#166534; font-size:0.9rem;">
                    Selected: <strong id="patientDisplayName"></strong>
                    <i class="fas fa-times-circle" style="float:right; cursor:pointer;" onclick="clearPatient()"></i>
                </div>
            </div>
            
            <!-- Dynamic Test Addition -->
            <div class="form-group mt-4">
                <label style="font-weight:700; color:#334155;">Select Lab Investigation</label>
                <div style="display:flex; gap:0.5rem;">
                    <select id="testSelect" class="form-control" style="flex:1;">
                        <option value="">-- Choose Test --</option>
                        <c:forEach var="t" items="${labTests}">
                            <option value="${t.id}" data-name="${t.name}" data-price="${t.price}">${t.name} (₹${t.price})</option>
                        </c:forEach>
                    </select>
                    <button type="button" class="btn btn-primary" onclick="addTestToList()" style="padding: 0.75rem 1rem;">
                        <i class="fas fa-plus"></i> Add
                    </button>
                </div>
            </div>

            <!-- Selected Tests List -->
            <div id="selectedTestsContainer" style="margin-top:1.5rem; display:none;">
                <label style="font-weight:700; color:#334155; font-size:0.85rem; text-transform:uppercase;">Selected Investigations</label>
                <div id="selectedTestsList" style="margin-top:0.5rem;"></div>
                <div id="totalCost" style="text-align:right; font-weight:800; color:#1e293b; margin-top:1rem; font-size:1.1rem; padding-top:1rem; border-top:1px dashed #e2e8f0;">
                    Total: ₹<span id="costValue">0</span>
                </div>
            </div>

            <div class="form-group mt-4">
                <label style="font-weight:700; color:#334155;">Clinical Notes (Optional)</label>
                <textarea name="doctorNotes" class="form-control" rows="3" placeholder="Provide clinical context or specific instructions..."></textarea>
            </div>
            
            <div style="display:flex; gap:1rem; margin-top:2.5rem;">
                <button type="submit" class="btn btn-primary" style="flex:1; justify-content:center; padding:1rem; border-radius:12px; font-weight:800;">
                    <i class="fas fa-check-circle"></i> Submit Order
                </button>
                <button type="button" class="btn btn-outline" style="flex:1; justify-content:center; padding:1rem; border-radius:12px; font-weight:800;" onclick="closeModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showRequestModal() { document.getElementById('requestModal').style.display = 'flex'; }
    function closeModal() { 
        document.getElementById('requestModal').style.display = 'none';
        // Reset form
        document.getElementById('labOrderForm').reset();
        clearPatient();
        document.getElementById('selectedTestsList').innerHTML = '';
        document.getElementById('selectedTestsContainer').style.display = 'none';
        costTotal = 0;
        updateCost();
    }

    // Patient Search Logic
    const pSearch = document.getElementById('patientSearch');
    const pResults = document.getElementById('patientResults');
    const pDisplay = document.getElementById('patientDisplay');
    const pSelectedId = document.getElementById('selectedPatientId');

    pSearch.addEventListener('input', function() {
        const query = this.value.toLowerCase();
        const items = pResults.getElementsByClassName('search-item');
        let hasVisible = false;
        
        for (let item of items) {
            const name = item.getAttribute('data-name').toLowerCase();
            const email = item.getAttribute('data-info').toLowerCase();
            if (name.includes(query) || email.includes(query)) {
                item.style.display = 'block';
                hasVisible = true;
            } else {
                item.style.display = 'none';
            }
        }
        pResults.style.display = hasVisible && query.length > 0 ? 'block' : 'none';
    });

    pSearch.addEventListener('focus', function() {
        if (this.value.length > 0) pResults.style.display = 'block';
    });

    document.addEventListener('click', function(e) {
        if (!pSearch.contains(e.target) && !pResults.contains(e.target)) {
            pResults.style.display = 'none';
        }
    });

    pResults.addEventListener('click', function(e) {
        const item = e.target.closest('.search-item');
        if (item) {
            pSelectedId.value = item.getAttribute('data-id');
            document.getElementById('patientDisplayName').textContent = item.getAttribute('data-name');
            pDisplay.style.display = 'block';
            pSearch.style.display = 'none';
            pResults.style.display = 'none';
        }
    });

    function clearPatient() {
        pSelectedId.value = '';
        pSearch.value = '';
        pSearch.style.display = 'block';
        pDisplay.style.display = 'none';
    }

    // Dynamic Test Logic
    let costTotal = 0;
    const selectedTests = new Set();

    function addTestToList() {
        const select = document.getElementById('testSelect');
        const option = select.options[select.selectedIndex];
        
        if (!option.value) return;
        if (selectedTests.has(option.value)) {
            alert('This test is already in the list.');
            return;
        }

        const id = option.value;
        const name = option.getAttribute('data-name');
        const price = parseFloat(option.getAttribute('data-price'));

        selectedTests.add(id);
        costTotal += price;
        updateCost();

        const list = document.getElementById('selectedTestsList');
        const item = document.createElement('div');
        item.className = 'selected-test-item';
        item.id = 'test-item-' + id;
        
        // Use standard string concatenation to avoid JSP EL interference with JS template literals
        item.innerHTML = '<div>' +
            '<strong style="color:#1e293b;">' + name + '</strong>' +
            '<div style="font-size:0.75rem; color:#64748b;">₹' + price.toFixed(2) + '</div>' +
            '<input type="hidden" name="labTestId" value="' + id + '">' +
            '</div>' +
            '<i class="fas fa-trash-alt remove-test" onclick="removeTest(\'' + id + '\', ' + price + ')"></i>';
            
        list.appendChild(item);
        document.getElementById('selectedTestsContainer').style.display = 'block';
        select.selectedIndex = 0;
    }

    function removeTest(id, price) {
        selectedTests.delete(id);
        costTotal -= price;
        updateCost();
        document.getElementById('test-item-' + id).remove();
        if (selectedTests.size === 0) {
            document.getElementById('selectedTestsContainer').style.display = 'none';
        }
    }

    function updateCost() {
        document.getElementById('costValue').textContent = costTotal.toFixed(2);
    }
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
