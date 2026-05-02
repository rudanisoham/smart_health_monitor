<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "beds");
    request.setAttribute("pageTitle", "Department Beds");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${department.name} Beds · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .bed-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }
        .bed-card {
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 1.5rem;
            transition: all 0.2s;
            background: white;
            position: relative;
        }
        .bed-card:hover {
            border-color: #3b82f6;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .bed-status-badge {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
        }
        .bed-number {
            font-size: 1.5rem;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 0.25rem;
        }
        .bed-type {
            font-size: 0.85rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/reception-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/reception-header.jsp" %>
        <div class="admin-content">

            <div style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                    <a href="<%= request.getContextPath() %>/reception/beds" class="btn btn-outline btn-sm" style="margin-bottom: 1rem; border-radius: 8px;">← Back to Departments</a>
                    <h2 style="font-size: 1.75rem; font-weight: 800; color: #1e293b; margin: 0;">${department.name}</h2>
                    <p class="muted">${department.availableBeds} available · ${department.occupiedBeds} occupied</p>
                </div>
            </div>

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1.5rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1.5rem;">${error}</div>
            </c:if>

            <div class="bed-grid">
                <c:forEach var="bed" items="${beds}">
                    <div class="bed-card">
                        <div class="bed-status-badge">
                            <c:choose>
                                <c:when test="${bed.status == 'AVAILABLE'}"><span class="chip">Available</span></c:when>
                                <c:when test="${bed.status == 'OCCUPIED'}"><span class="chip-danger">Occupied</span></c:when>
                                <c:otherwise><span class="chip-warning">${bed.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="bed-number">#${bed.bedNumber}</div>
                        <div class="bed-type">${bed.type} Bed</div>

                        <div style="margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid #f1f5f9;">
                            <c:choose>
                                <c:when test="${bed.status == 'OCCUPIED'}">
                                    <div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:1.25rem;">
                                        <div style="width:32px; height:32px; background:var(--primary); border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:700; color:white; font-size:0.8rem;">
                                            ${bed.patient.user.fullName.substring(0,1)}
                                        </div>
                                        <div style="flex:1;">
                                            <div style="font-size:0.9rem; font-weight:700; color:#1e293b;">${bed.patient.user.fullName}</div>
                                            <div class="muted" style="font-size:0.75rem; display:flex; justify-content:space-between;">
                                                <span>Stay Duration</span>
                                                <span style="color:var(--primary); font-weight:600;">Since ${bed.assignedAt.toString().substring(0,10)}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem;">
                                        <a href="${pageContext.request.contextPath}/reception/patient/${bed.patient.id}/billing" class="btn btn-outline btn-sm" style="font-size:0.7rem; padding:0.4rem;">View Billing</a>
                                        <form action="<%= request.getContextPath() %>/reception/beds/${bed.id}/release" method="post">
                                            <input type="hidden" name="redirectDeptId" value="${department.id}">
                                            <button class="btn btn-sm" type="submit" onclick="return confirm('Release bed ${bed.bedNumber}?')" 
                                                    style="width:100%; font-size:0.7rem; background:#fee2e2; color:#ef4444; border:1px solid #fecaca;">Release</button>
                                        </form>
                                    </div>
                                </c:when>
                                <c:when test="${bed.status == 'AVAILABLE'}">
                                    <div style="margin-bottom:1.25rem;">
                                        <p class="muted" style="font-size:0.85rem;">Ready for new assignment</p>
                                    </div>
                                    <button class="btn btn-primary btn-sm w-full" style="justify-content:center;" onclick="showAssignModal(${bed.id}, '${bed.bedNumber}')">Assign Patient</button>
                                </c:when>
                                <c:otherwise>
                                    <p class="muted">Under Maintenance</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty beds}">
                <div class="card" style="padding:4rem 2rem; text-align:center;">
                    <div style="font-size:3rem; margin-bottom:1rem; opacity:0.3;">🛏️</div>
                    <h3 class="muted">No beds found in this department</h3>
                    <p class="muted mt-1">Beds can be added by administrators in the Department Settings.</p>
                </div>
            </c:if>

        </div>
        <%@ include file="/WEB-INF/views/layout/reception-footer.jsp" %>
    </main>
</div>

<!-- Assign Patient Modal -->
<div id="assignModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:1000;align-items:center;justify-content:center;">
    <div style="background:white;border-radius:1.5rem;padding:2rem;width:100%;max-width:440px;box-shadow:0 25px 50px -12px rgba(0,0,0,0.25);">
        <div style="font-size:1.5rem;font-weight:800;margin-bottom:0.5rem;color:#1e293b;">Assign Patient</div>
        <div id="modalBedLabel" style="color:#64748b;font-weight:600;font-size:0.95rem;margin-bottom:2rem;"></div>
        
        <form id="assignForm" method="post">
            <input type="hidden" name="redirectDeptId" value="${department.id}">
            
            <style>
                .searchable-dropdown { position: relative; }
                .dropdown-list {
                    position: absolute; top: calc(100% + 5px); left: 0; right: 0;
                    background: white; border: 1px solid #e2e8f0;
                    border-radius: 16px; max-height: 250px; overflow-y: auto; z-index: 2000;
                    box-shadow: 0 15px 40px -10px rgba(0,0,0,0.12), 0 10px 20px -10px rgba(0,0,0,0.08);
                    display: none; transition: all 0.2s;
                }
                .dropdown-item {
                    padding: 0.9rem 1.25rem; cursor: pointer;
                    transition: all 0.2s; border-bottom: 1px solid #f8fafc;
                }
                .dropdown-item:last-child { border-bottom: none; }
                .dropdown-item:hover { background: #f1f5f9; }
                .dropdown-item-title { font-weight: 700; color: #1e293b; font-size: 0.95rem; line-height: 1.4; }
                .dropdown-item-subtitle { color: #64748b; font-size: 0.8rem; margin-top: 0.15rem; }
                .form-control { border-radius: 12px !important; }
            </style>

                <div class="form-group">
                    <label for="patientSearch">Search Patient</label>
                    <div class="searchable-dropdown">
                        <input type="text" id="patientSearch" class="form-control" 
                               placeholder="Search by name or email..." 
                               autocomplete="off"
                               onfocus="togglePatientDropdown(true)" 
                               oninput="filterPatientDropdown()">
                        <input type="hidden" id="patientId" name="patientId" required>
                        <input type="hidden" id="isTransfer" value="false">
                        <div id="patientDropdownList" class="dropdown-list">
                            <c:forEach var="p" items="${patients}">
                                <c:set var="currBed" value="${bedMap[p.id]}" />
                                <div class="dropdown-item patient-opt" 
                                     data-id="${p.id}"
                                     data-name="${p.user.fullName}"
                                     data-search="${p.user.fullName} ${p.user.email} ${p.id}"
                                     data-hastransfer="${not empty currBed ? 'true' : 'false'}"
                                     onclick="selectPatient('${p.id}', '${p.user.fullName}', '${p.user.email}', ${not empty currBed ? 'true' : 'false'})">
                                    <div class="dropdown-item-title">${p.user.fullName}</div>
                                    <div class="dropdown-item-subtitle">${p.user.email} • ID #${p.id}</div>
                                    <c:if test="${not empty currBed}">
                                        <div style="margin-top:0.25rem; font-size:0.75rem; font-weight:700; color:#f59e0b; background:#fef3c7; display:inline-block; padding:0.1rem 0.4rem; border-radius:4px;">
                                            Currently in Bed: ${currBed.bedNumber} (${currBed.type})
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <div id="transferWarning" style="display:none; margin-top:1rem; padding:0.75rem; background:#fffbeb; border:1px solid #fde68a; border-radius:8px; color:#d97706; font-size:0.85rem; font-weight:600;">
                    ⚠️ This patient already has an active bed. Assigning them will automatically finalize their current stay bill and transfer them to this new bed.
                </div>
                
                <div style="display:flex; gap:1rem; margin-top:2rem;">
                    <button type="submit" id="btnConfirmAssign" class="btn btn-primary" style="flex:1; justify-content:center;">Confirm Assignment</button>
                    <button type="button" class="btn btn-outline" style="flex:1; justify-content:center;" onclick="closeModal()">Cancel</button>
                </div>
        </form>
    </div>
</div>

<script>
function togglePatientDropdown(show) {
    const list = document.getElementById('patientDropdownList');
    if (show) {
        list.style.display = 'block';
        filterPatientDropdown();
    } else {
        setTimeout(() => { list.style.display = 'none'; }, 200);
    }
}

function filterPatientDropdown() {
    const query = document.getElementById('patientSearch').value.toLowerCase();
    const items = document.querySelectorAll('.patient-opt');
    items.forEach(item => {
        const searchTerms = item.getAttribute('data-search').toLowerCase();
        item.style.display = searchTerms.includes(query) ? 'block' : 'none';
    });
}

function selectPatient(id, name, email, isTransfer) {
    document.getElementById('patientId').value = id;
    document.getElementById('patientSearch').value = name;
    
    if (isTransfer) {
        document.getElementById('transferWarning').style.display = 'block';
        document.getElementById('btnConfirmAssign').textContent = 'Confirm Transfer';
    } else {
        document.getElementById('transferWarning').style.display = 'none';
        document.getElementById('btnConfirmAssign').textContent = 'Confirm Assignment';
    }
    
    togglePatientDropdown(false);
}

document.addEventListener('click', function(e) {
    if (!e.target.closest('.searchable-dropdown')) {
        const list = document.getElementById('patientDropdownList');
        if (list) list.style.display = 'none';
    }
});

function showAssignModal(bedId, bedNumber) {
    document.getElementById('assignModal').style.display = 'flex';
    document.getElementById('modalBedLabel').textContent = 'Assigning Bed #' + bedNumber;
    document.getElementById('assignForm').action = '<%= request.getContextPath() %>/reception/beds/' + bedId + '/assign';
    
    // Reset selection
    document.getElementById('patientId').value = '';
    document.getElementById('patientSearch').value = '';
    document.getElementById('transferWarning').style.display = 'none';
    document.getElementById('btnConfirmAssign').textContent = 'Confirm Assignment';
}

function closeModal() {
    document.getElementById('assignModal').style.display = 'none';
}
</script>
<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
