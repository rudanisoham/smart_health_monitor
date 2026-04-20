<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "health");
    request.setAttribute("pageTitle", "Health Data");
    request.setAttribute("pageSubtitle", "Track your vitals and review your health history");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Health Data · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .vitals-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
        /* ── Vitals KPI cards — light theme ── */
        .vital-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
            box-shadow: 0 1px 6px rgba(0,0,0,0.06);
        }
        .vital-card .label {
            font-size: 0.78rem;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.4rem;
            font-weight: 600;
        }
        .vital-card .val {
            font-size: 2rem;
            font-weight: 700;
            color: #2563eb;
            line-height: 1;
        }
        .vital-card .val span {
            font-size: 0.95rem;
            font-weight: 400;
            color: #94a3b8;
            margin-left: 0.2rem;
        }
        .vital-card .empty-val {
            font-size: 1.5rem;
            color: #cbd5e1;
        }
        /* ── Add Health Reading card — light theme ── */
        .add-form-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 6px rgba(0,0,0,0.06);
        }
        .add-form-card .section-title  { color: #1e293b !important; }
        .add-form-card .section-subtitle { color: #64748b !important; }
        .add-form-card .history-badge  { background: rgba(59,130,246,0.1); color: #2563eb; }
        .add-form-card label           { color: #374151 !important; font-weight: 500; }
        .add-form-card .muted          { color: #94a3b8 !important; }
        .add-form-card .text-xs        { color: #94a3b8 !important; }
        .add-form-card .form-control   {
            background: #f8fafc !important;
            border: 1.5px solid #e2e8f0 !important;
            color: #1e293b !important;
            border-radius: 8px;
        }
        .add-form-card .form-control::placeholder { color: #cbd5e1 !important; }
        .add-form-card .form-control:focus {
            border-color: #3b82f6 !important;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.12) !important;
            outline: none !important;
        }
        .form-2col { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-3col { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; }
        .history-badge { display: inline-flex; align-items: center; gap: 0.4rem; background: rgba(59,130,246,0.12); color: #60a5fa; border-radius: 6px; padding: 0.2rem 0.7rem; font-size: 0.78rem; font-weight: 600; }
        .status-ok { color: #34d399; }
        .status-warn { color: #fbbf24; }
        .status-bad { color: #f87171; }
        @media (max-width: 768px) { .vitals-grid { grid-template-columns: 1fr 1fr; } .form-2col, .form-3col { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">

            <c:if test="${not empty success}">
                <div style="padding:0.75rem 1rem;background:rgba(52,211,153,0.15);border:1px solid #34d399;border-radius:8px;color:#10b981;margin-bottom:1rem;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="padding:0.75rem 1rem;background:rgba(248,113,113,0.15);border:1px solid #f87171;border-radius:8px;color:#f87171;margin-bottom:1rem;">${error}</div>
            </c:if>

            <!-- ── Latest Vitals Cards ─────────────────────────────── -->
            <div class="vitals-grid">
                <div class="vital-card">
                    <div class="label">❤ Heart Rate</div>
                    <c:choose>
                        <c:when test="${not empty latestMetric and latestMetric.heartRate != null}">
                            <div class="val">${latestMetric.heartRate}<span>bpm</span></div>
                        </c:when>
                        <c:otherwise><div class="empty-val">—<span style="font-size:0.85rem;"> bpm</span></div></c:otherwise>
                    </c:choose>
                </div>
                <div class="vital-card">
                    <div class="label">🩺 Blood Pressure</div>
                    <c:choose>
                        <c:when test="${not empty latestMetric and latestMetric.bloodPressureSys != null}">
                            <div class="val" style="font-size:1.6rem;">${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia}<span>mmHg</span></div>
                        </c:when>
                        <c:otherwise><div class="empty-val">—<span style="font-size:0.85rem;"> mmHg</span></div></c:otherwise>
                    </c:choose>
                </div>
                <div class="vital-card">
                    <div class="label">💧 SpO2</div>
                    <c:choose>
                        <c:when test="${not empty latestMetric and latestMetric.spo2 != null}">
                            <div class="val">${latestMetric.spo2}<span>%</span></div>
                        </c:when>
                        <c:otherwise><div class="empty-val">—<span style="font-size:0.85rem;"> %</span></div></c:otherwise>
                    </c:choose>
                </div>
                <div class="vital-card" style="background: #f0f9ff; border-color: #bae6fd; box-shadow: 0 4px 12px rgba(59, 130, 246, 0.05);">
                    <div class="label" style="color: #0369a1; font-weight: 800;">🤖 AI Insight</div>
                    <div style="font-size: 0.88rem; color: #1e293b; line-height: 1.5; margin-top: 0.6rem; font-weight: 600;">
                        <c:choose>
                            <c:when test="${not empty aiInsight}">
                                "${aiInsight}"
                            </c:when>
                            <c:otherwise>
                                <span style="color: #64748b; font-weight: 400;">Add a health reading to get your first AI analysis.</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- ── Add New Reading Form ───────────────────────────── -->
            <div class="add-form-card">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1rem;">
                    <div>
                        <div class="section-title">➕ Add Health Reading</div>
                        <div class="section-subtitle mt-1">Record your latest vitals — saved permanently to your health history</div>
                    </div>
                    <span class="history-badge">📊 ${not empty metrics ? metrics.size() : 0} readings saved</span>
                </div>

                <form id="healthForm" action="${pageContext.request.contextPath}/patient/health/add" method="post" data-validate-metrics>
                    <input type="hidden" id="latitude" name="latitude">
                    <input type="hidden" id="longitude" name="longitude">
                    <div class="form-3col">
                        <div class="form-group">
                            <label for="heartRate">Heart Rate <span class="muted">(bpm)</span></label>
                            <input id="heartRate" name="heartRate" class="form-control" type="number" min="30" max="250" placeholder="e.g. 72">
                        </div>
                        <div class="form-group">
                            <label for="bloodPressureSys">BP Systolic <span class="muted">(mmHg)</span></label>
                            <input id="bloodPressureSys" name="bloodPressureSys" class="form-control" type="number" min="60" max="250" placeholder="e.g. 120">
                        </div>
                        <div class="form-group">
                            <label for="bloodPressureDia">BP Diastolic <span class="muted">(mmHg)</span></label>
                            <input id="bloodPressureDia" name="bloodPressureDia" class="form-control" type="number" min="40" max="150" placeholder="e.g. 80">
                        </div>
                        <div class="form-group">
                            <label for="spo2">SpO2 <span class="muted">(%)</span></label>
                            <input id="spo2" name="spo2" class="form-control" type="number" step="0.1" min="80" max="100" placeholder="e.g. 98.5">
                        </div>
                        <div class="form-group">
                            <label for="temperature">Temperature <span class="muted">(°C)</span></label>
                            <input id="temperature" name="temperature" class="form-control" type="number" step="0.1" min="35" max="42" placeholder="e.g. 37.0">
                        </div>
                        <div class="form-group">
                            <label for="weight">Weight <span class="muted">(kg)</span></label>
                            <input id="weight" name="weight" class="form-control" type="number" step="0.1" min="1" max="300" placeholder="e.g. 70.5">
                        </div>
                    </div>
                    <div style="display:flex;justify-content:flex-end;align-items:center;gap:0.75rem;margin-top:0.75rem;">
                        <span class="text-xs text-muted">Fill at least one field · Data is saved permanently</span>
                        <button class="btn btn-primary" type="submit">💾 Save Reading</button>
                    </div>
                </form>
                <script>
                    function fetchLocation() {
                        if (navigator.geolocation) {
                            navigator.geolocation.getCurrentPosition(function(pos) {
                                document.getElementById('latitude').value = pos.coords.latitude;
                                document.getElementById('longitude').value = pos.coords.longitude;
                            }, function(err) {
                                console.warn('Geolocation error:', err.message);
                            }, {
                                enableHighAccuracy: true,
                                timeout: 5000,
                                maximumAge: 0
                            });
                        }
                    }
                    // Fetch on load
                    fetchLocation();
                </script>
            </div>

            <!-- ── Readings History Table ─────────────────────────── -->
            <div class="card">
                <div class="card-header">
                    <div>
                        <div class="section-title">📋 Readings History</div>
                        <div class="section-subtitle">All your saved vitals — newest first</div>
                    </div>
                    <span class="chip-neutral">${not empty metrics ? metrics.size() : 0} records</span>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Date & Time</th>
                            <th>Heart Rate</th>
                            <th>Blood Pressure</th>
                            <th>SpO2</th>
                            <th>Temperature</th>
                            <th>Weight</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty metrics}">
                                <c:set var="rowNum" value="1"/>
                                <c:forEach var="m" items="${metrics}">
                                    <tr>
                                        <td class="muted">${rowNum}</td>
                                        <td style="white-space:nowrap;">${m.timestamp.toString().replace('T',' ').substring(0,16)}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.heartRate != null}">
                                                    <c:set var="hrClass" value="status-ok"/>
                                                    <c:if test="${m.heartRate > 100 or m.heartRate < 60}"><c:set var="hrClass" value="status-warn"/></c:if>
                                                    <c:if test="${m.heartRate > 120}"><c:set var="hrClass" value="status-bad"/></c:if>
                                                    <span class="${hrClass}">${m.heartRate} bpm</span>
                                                </c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.bloodPressureSys != null}">
                                                    <c:set var="bpClass" value="status-ok"/>
                                                    <c:if test="${m.bloodPressureSys > 130 or m.bloodPressureSys < 90}"><c:set var="bpClass" value="status-warn"/></c:if>
                                                    <c:if test="${m.bloodPressureSys > 150}"><c:set var="bpClass" value="status-bad"/></c:if>
                                                    <span class="${bpClass}">${m.bloodPressureSys}/${m.bloodPressureDia} mmHg</span>
                                                </c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.spo2 != null}">
                                                    <c:set var="spo2Class" value="status-ok"/>
                                                    <c:if test="${m.spo2 < 95}"><c:set var="spo2Class" value="status-warn"/></c:if>
                                                    <c:if test="${m.spo2 < 90}"><c:set var="spo2Class" value="status-bad"/></c:if>
                                                    <span class="${spo2Class}">${m.spo2}%</span>
                                                </c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.temperature != null}">
                                                    <c:set var="tmpClass" value="status-ok"/>
                                                    <c:if test="${m.temperature > 37.5}"><c:set var="tmpClass" value="status-warn"/></c:if>
                                                    <c:if test="${m.temperature > 38.5}"><c:set var="tmpClass" value="status-bad"/></c:if>
                                                    <span class="${tmpClass}">${m.temperature}°C</span>
                                                </c:when>
                                                <c:otherwise><span class="muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${m.weight != null ? m.weight.toString().concat(' kg') : '—'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.riskLevel == 'HIGH'}"><span class="chip-danger">⚠ HIGH RISK</span></c:when>
                                                <c:when test="${m.riskLevel == 'MEDIUM'}"><span class="chip-warning">⚠ MEDIUM RISK</span></c:when>
                                                <c:when test="${m.riskLevel == 'LOW'}"><span class="chip">✓ LOW RISK</span></c:when>
                                                <c:otherwise><span class="muted">N/A</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <c:set var="rowNum" value="${rowNum + 1}"/>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" style="text-align:center;padding:3rem;" class="muted">
                                        <div style="font-size:2rem;margin-bottom:0.5rem;">📭</div>
                                        No readings yet — add your first one above!
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
