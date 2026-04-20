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

                        <!-- ── AI Trend Report Panel ──────────────────────── -->
                        <div class="card" style="background: #ffffff; border: 1px solid #f1f5f9; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-radius: 20px;">
                            <div class="card-header" style="border-bottom: 1px dashed #e2e8f0; padding-bottom: 1rem; margin-bottom: 1.5rem;">
                                <div style="display: flex; align-items: center; gap: 0.75rem;">
                                    <div style="width: 40px; height: 40px; border-radius: 10px; background: #f0f9ff; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">📊</div>
                                    <h3 class="card-title" style="margin: 0; font-size: 1.15rem; font-weight: 800; color: #1e293b;">AI Trend Intelligence</h3>
                                </div>
                                <span class="chip" style="background:#f0fdf4; color:#16a34a; font-weight:700;">LIVE</span>
                            </div>

                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${not empty aiInsight}">
                                        <div style="font-size: 1.05rem; line-height: 1.7; color: #334155; padding: 1.5rem; background: #f8fafc; border-radius: 16px; border: 1px solid #f1f5f9; font-weight: 500;">
                                            "${aiInsight}"
                                        </div>
                                        <div class="mt-4" style="display:flex; gap: 0.75rem; flex-direction: column;">
                                            <div style="display:flex; align-items:center; gap: 0.5rem; font-size: 0.85rem; color: #64748b;">
                                                <span style="font-size: 1rem;">✅</span>
                                                <span>Personalized based on your historical data.</span>
                                            </div>
                                            <div style="display:flex; align-items:center; gap: 0.5rem; font-size: 0.85rem; color: #64748b;">
                                                <span style="font-size: 1rem;">⚡</span>
                                                <span>Updated every time you add a reading.</span>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="muted" style="padding:2rem; text-align:center; background:#f8fafc; border-radius:12px;">
                                            <span style="font-size:2rem;display:block;margin-bottom:0.5rem;">🔍</span>
                                            Not enough data for AI analysis.
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="mt-4" style="background:#fefce8; border-radius:12px; padding:1rem; font-size:0.8rem; color:#854d0e; border: 1px solid #fef08a;">
                                    ℹ This report is generated by AI. It provides general wellness info and is <u>not</u> a medical diagnosis.
                                </div>
                                <div class="mt-3">
                                    <a href="${pageContext.request.contextPath}/patient/ai" class="btn btn-primary" style="width: 100%; justify-content: center; height: 48px; border-radius: 14px;">🤖 Run AI Checker</a>
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
