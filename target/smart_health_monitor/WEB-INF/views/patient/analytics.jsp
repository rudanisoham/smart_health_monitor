<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "analytics");
    request.setAttribute("pageTitle", "Analytics");
    request.setAttribute("pageSubtitle", "Health trends and insights based on your real data");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Analytics · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .trend-up   { color: #f87171; }
        .trend-down { color: #34d399; }
        .trend-ok   { color: #60a5fa; }
        .progress-bar-wrap { background: rgba(255,255,255,0.08); border-radius: 99px; height: 8px; width: 100%; margin-top: 0.4rem; overflow: hidden; }
        .progress-bar-fill { height: 8px; border-radius: 99px; background: linear-gradient(90deg, #3b82f6, #06b6d4); transition: width 0.8s ease; }
        .progress-bar-fill.warn { background: linear-gradient(90deg, #f59e0b, #f97316); }
        .progress-bar-fill.danger { background: linear-gradient(90deg, #ef4444, #dc2626); }
        .insight-card { border-left: 3px solid #3b82f6; padding: 0.75rem 1rem; background: rgba(59,130,246,0.07); border-radius: 0 8px 8px 0; margin-bottom: 0.75rem; }
        .insight-card.warn { border-left-color: #f59e0b; background: rgba(245,158,11,0.07); }
        .insight-card.danger { border-left-color: #ef4444; background: rgba(239,68,68,0.07); }
        .mini-trend { display: flex; gap: 3px; align-items: flex-end; height: 32px; }
        .mini-bar { width: 6px; border-radius: 3px 3px 0 0; background: #3b82f6; min-height: 4px; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">

            <c:choose>
                <c:when test="${empty metrics}">
                    <!-- No Data State -->
                    <div class="card" style="text-align:center;padding:4rem 2rem;">
                        <div style="font-size:3rem;margin-bottom:1rem;">📊</div>
                        <div class="section-title">No Data to Analyze Yet</div>
                        <p class="section-subtitle mt-2">Start tracking your vitals on the Health Data page to see trends and AI insights here.</p>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/patient/health" class="btn btn-primary">➕ Add Health Data</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>

                    <!-- ── KPI Summary ──────────────────────────────────── -->
                    <div class="grid grid-4" style="margin-bottom:1.5rem;">
                        <div class="card">
                            <div class="card-title">Total Readings</div>
                            <div class="card-value">${metrics.size()}</div>
                            <div class="muted" style="font-size:0.8rem;">all time records</div>
                        </div>
                        <div class="card">
                            <div class="card-title">Latest Heart Rate</div>
                            <div class="card-value">
                                <c:choose>
                                    <c:when test="${not empty latestMetric and latestMetric.heartRate != null}">${latestMetric.heartRate} <span style="font-size:1rem;color:var(--text-muted)">bpm</span></c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-title">Latest SpO2</div>
                            <div class="card-value">
                                <c:choose>
                                    <c:when test="${not empty latestMetric and latestMetric.spo2 != null}">${latestMetric.spo2}<span style="font-size:1rem;color:var(--text-muted)">%</span></c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-title">Latest BP</div>
                            <div class="card-value" style="font-size:1.4rem;">
                                <c:choose>
                                    <c:when test="${not empty latestMetric and latestMetric.bloodPressureSys != null}">${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-2">

                        <!-- ── Real Biometrics Panel ───────────────────── -->
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">Current Biometrics</div>
                                    <div class="section-subtitle">Based on your latest reading</div>
                                </div>
                            </div>
                            <div class="mt-3">

                                <!-- Heart Rate -->
                                <c:if test="${not empty latestMetric and latestMetric.heartRate != null}">
                                    <div class="stat-item">
                                        <div class="stat-info" style="flex:1;">
                                            <div style="display:flex;justify-content:space-between;">
                                                <span class="stat-label">Heart Rate</span>
                                                <span class="stat-value">
                                                    <c:set var="hr" value="${latestMetric.heartRate}"/>
                                                    <c:choose>
                                                        <c:when test="${hr >= 60 and hr <= 100}"><span style="color:#34d399;">${hr} bpm ✓</span></c:when>
                                                        <c:when test="${hr > 100}"><span style="color:#f59e0b;">${hr} bpm ↑</span></c:when>
                                                        <c:otherwise><span style="color:#60a5fa;">${hr} bpm ↓</span></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="progress-bar-wrap">
                                                <c:set var="hrPct" value="${hr > 200 ? 100 : hr / 2}"/>
                                                <div class="progress-bar-fill ${hr > 100 ? 'warn' : ''}" style="width:${hrPct}%;"></div>
                                            </div>
                                            <div style="display:flex;justify-content:space-between;font-size:0.72rem;color:var(--text-muted);margin-top:0.25rem;"><span>30</span><span>Normal: 60–100</span><span>200+</span></div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Blood Pressure -->
                                <c:if test="${not empty latestMetric and latestMetric.bloodPressureSys != null}">
                                    <div class="stat-item">
                                        <div class="stat-info" style="flex:1;">
                                            <div style="display:flex;justify-content:space-between;">
                                                <span class="stat-label">Blood Pressure (Systolic)</span>
                                                <span class="stat-value">
                                                    <c:set var="bps" value="${latestMetric.bloodPressureSys}"/>
                                                    <c:choose>
                                                        <c:when test="${bps >= 90 and bps <= 120}"><span style="color:#34d399;">${bps} mmHg ✓</span></c:when>
                                                        <c:when test="${bps > 120}"><span style="color:#f59e0b;">${bps} mmHg ↑</span></c:when>
                                                        <c:otherwise><span style="color:#60a5fa;">${bps} mmHg ↓</span></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="progress-bar-wrap">
                                                <c:set var="bpPct" value="${bps > 180 ? 100 : (bps - 60) * 100 / 120}"/>
                                                <div class="progress-bar-fill ${bps > 130 ? 'warn' : ''} ${bps > 150 ? 'danger' : ''}" style="width:${bpPct}%;"></div>
                                            </div>
                                            <div style="display:flex;justify-content:space-between;font-size:0.72rem;color:var(--text-muted);margin-top:0.25rem;"><span>60</span><span>Normal: 90–120</span><span>180+</span></div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- SpO2 -->
                                <c:if test="${not empty latestMetric and latestMetric.spo2 != null}">
                                    <div class="stat-item">
                                        <div class="stat-info" style="flex:1;">
                                            <div style="display:flex;justify-content:space-between;">
                                                <span class="stat-label">Blood Oxygen (SpO2)</span>
                                                <span class="stat-value">
                                                    <c:set var="spo2" value="${latestMetric.spo2}"/>
                                                    <c:choose>
                                                        <c:when test="${spo2 >= 95}"><span style="color:#34d399;">${spo2}% ✓</span></c:when>
                                                        <c:when test="${spo2 >= 90}"><span style="color:#f59e0b;">${spo2}% ⚠</span></c:when>
                                                        <c:otherwise><span style="color:#f87171;">${spo2}% ✗</span></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="progress-bar-wrap">
                                                <div class="progress-bar-fill ${spo2 < 95 ? 'warn' : ''} ${spo2 < 90 ? 'danger' : ''}" style="width:${spo2}%;"></div>
                                            </div>
                                            <div style="display:flex;justify-content:space-between;font-size:0.72rem;color:var(--text-muted);margin-top:0.25rem;"><span>80%</span><span>Normal: 95–100%</span><span>100%</span></div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Temperature -->
                                <c:if test="${not empty latestMetric and latestMetric.temperature != null}">
                                    <div class="stat-item">
                                        <div class="stat-info" style="flex:1;">
                                            <div style="display:flex;justify-content:space-between;">
                                                <span class="stat-label">Body Temperature</span>
                                                <span class="stat-value">
                                                    <c:set var="tmp" value="${latestMetric.temperature}"/>
                                                    <c:choose>
                                                        <c:when test="${tmp >= 36.1 and tmp <= 37.2}"><span style="color:#34d399;">${tmp}°C ✓</span></c:when>
                                                        <c:when test="${tmp > 37.2}"><span style="color:#f59e0b;">${tmp}°C ↑ Fever</span></c:when>
                                                        <c:otherwise><span style="color:#60a5fa;">${tmp}°C ↓</span></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="progress-bar-wrap">
                                                <c:set var="tmpPct" value="${(tmp - 35) * 100 / 7}"/>
                                                <div class="progress-bar-fill ${tmp > 37.5 ? 'warn' : ''} ${tmp > 38.5 ? 'danger' : ''}" style="width:${tmpPct > 100 ? 100 : tmpPct}%;"></div>
                                            </div>
                                            <div style="display:flex;justify-content:space-between;font-size:0.72rem;color:var(--text-muted);margin-top:0.25rem;"><span>35°C</span><span>Normal: 36.1–37.2°C</span><span>42°C</span></div>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${latestMetric == null or (latestMetric.heartRate == null and latestMetric.bloodPressureSys == null and latestMetric.spo2 == null and latestMetric.temperature == null)}">
                                    <div class="muted" style="padding:1.5rem;text-align:center;">No vitals data available. <a href="${pageContext.request.contextPath}/patient/health">Add a reading</a></div>
                                </c:if>
                            </div>
                        </div>

                        <!-- ── AI Insights Panel ──────────────────────── -->
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <div class="section-title">🤖 AI Health Insights</div>
                                    <div class="section-subtitle">Rule-based analysis of your ${metrics.size()} readings</div>
                                </div>
                            </div>
                            <div class="mt-3">

                                <c:if test="${not empty latestMetric}">

                                    <%-- Heart Rate Insight --%>
                                    <c:if test="${latestMetric.heartRate != null}">
                                        <c:choose>
                                            <c:when test="${latestMetric.heartRate >= 60 and latestMetric.heartRate <= 100}">
                                                <div class="insight-card">
                                                    <strong>✅ Heart Rate is Normal</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Your resting heart rate of ${latestMetric.heartRate} bpm is within the healthy range (60–100 bpm). Keep maintaining a regular exercise routine.</div>
                                                </div>
                                            </c:when>
                                            <c:when test="${latestMetric.heartRate > 100}">
                                                <div class="insight-card warn">
                                                    <strong>⚠️ Elevated Heart Rate</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Your heart rate of ${latestMetric.heartRate} bpm is above normal. Consider rest, hydration, and consult your doctor if this persists.</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="insight-card">
                                                    <strong>ℹ️ Low Heart Rate</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Heart rate of ${latestMetric.heartRate} bpm is slightly below average. This may be normal for athletes. Monitor closely.</div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- BP Insight --%>
                                    <c:if test="${latestMetric.bloodPressureSys != null}">
                                        <c:choose>
                                            <c:when test="${latestMetric.bloodPressureSys > 140}">
                                                <div class="insight-card danger">
                                                    <strong>🚨 High Blood Pressure (Stage 2)</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">BP of ${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia} is dangerously high. Please consult your doctor immediately.</div>
                                                </div>
                                            </c:when>
                                            <c:when test="${latestMetric.bloodPressureSys > 120}">
                                                <div class="insight-card warn">
                                                    <strong>⚠️ Elevated Blood Pressure</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">BP of ${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia} is in the pre-hypertension range. Reduce salt intake and monitor regularly.</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="insight-card">
                                                    <strong>✅ Blood Pressure Normal</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Your BP of ${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia} mmHg is in the healthy range. Great job!</div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- SpO2 Insight --%>
                                    <c:if test="${latestMetric.spo2 != null}">
                                        <c:choose>
                                            <c:when test="${latestMetric.spo2 < 90}">
                                                <div class="insight-card danger">
                                                    <strong>🚨 Critical SpO2 Level</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">SpO2 of ${latestMetric.spo2}% is critically low. Seek emergency care immediately.</div>
                                                </div>
                                            </c:when>
                                            <c:when test="${latestMetric.spo2 < 95}">
                                                <div class="insight-card warn">
                                                    <strong>⚠️ Low Blood Oxygen</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">SpO2 of ${latestMetric.spo2}% is below the normal threshold (95%). Rest and see your doctor if it doesn't improve.</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="insight-card">
                                                    <strong>✅ Blood Oxygen Normal</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">SpO2 of ${latestMetric.spo2}% is excellent. Your lungs are functioning well.</div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- Temperature Insight --%>
                                    <c:if test="${latestMetric.temperature != null}">
                                        <c:choose>
                                            <c:when test="${latestMetric.temperature > 38.5}">
                                                <div class="insight-card danger">
                                                    <strong>🚨 High Fever</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Temperature of ${latestMetric.temperature}°C indicates high fever. Rest, stay hydrated, and consult a doctor.</div>
                                                </div>
                                            </c:when>
                                            <c:when test="${latestMetric.temperature > 37.5}">
                                                <div class="insight-card warn">
                                                    <strong>⚠️ Mild Fever</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Temperature of ${latestMetric.temperature}°C is slightly elevated. Rest and monitor closely.</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="insight-card">
                                                    <strong>✅ Temperature Normal</strong>
                                                    <div class="muted" style="font-size:0.85rem;margin-top:0.25rem;">Body temperature of ${latestMetric.temperature}°C is within the healthy range.</div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                </c:if>

                                <c:if test="${empty latestMetric}">
                                    <div class="muted" style="padding:1.5rem;text-align:center;">No data available for analysis.</div>
                                </c:if>

                                <div class="mt-3" style="background:rgba(255,255,255,0.03);border-radius:8px;padding:0.75rem;font-size:0.78rem;color:var(--text-muted);">
                                    ⚕ <em>This is rule-based analysis only. Always consult a qualified doctor for medical advice.</em>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ── Trend Overview Table ─────────────────────── -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <div>
                                <div class="section-title">📈 All Readings Trend</div>
                                <div class="section-subtitle">Your complete health log — newest first</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/patient/health" class="btn btn-outline btn-sm">+ Add Reading</a>
                        </div>
                        <div class="table-container mt-2">
                            <table>
                                <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Heart Rate</th>
                                    <th>Blood Pressure</th>
                                    <th>SpO2</th>
                                    <th>Temperature</th>
                                    <th>Weight</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="m" items="${metrics}">
                                    <tr>
                                        <td>${m.timestamp.toString().replace('T',' ').substring(0,16)}</td>
                                        <td>${m.heartRate != null ? m.heartRate.toString().concat(' bpm') : '—'}</td>
                                        <td>${m.bloodPressureSys != null ? m.bloodPressureSys.toString().concat('/').concat(m.bloodPressureDia.toString()).concat(' mmHg') : '—'}</td>
                                        <td>${m.spo2 != null ? m.spo2.toString().concat('%') : '—'}</td>
                                        <td>${m.temperature != null ? m.temperature.toString().concat('°C') : '—'}</td>
                                        <td>${m.weight != null ? m.weight.toString().concat(' kg') : '—'}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </c:otherwise>
            </c:choose>

        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
</body>
</html>
