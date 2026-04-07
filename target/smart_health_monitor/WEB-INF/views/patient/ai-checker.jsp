<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "ai");
    request.setAttribute("pageTitle", "AI Symptom Checker");
    request.setAttribute("pageSubtitle", "Get instant health insights based on your symptoms and vitals");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Symptom Checker · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        .symptom-chip {
            display: inline-flex; align-items: center; gap: 0.4rem;
            padding: 0.4rem 0.9rem; border-radius: 99px;
            border: 1.5px solid var(--border, #334155);
            background: transparent; color: var(--text-muted, #94a3b8);
            cursor: pointer; font-size: 0.82rem; transition: all 0.2s;
            user-select: none;
        }
        .symptom-chip.active {
            border-color: #3b82f6; background: rgba(59,130,246,0.15); color: #60a5fa;
        }
        .symptom-chip:hover { border-color: #60a5fa; color: #93c5fd; }
        .chips-wrap { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.75rem; }
        .ai-result-box { border-radius: 12px; padding: 1.25rem 1.5rem; margin-top: 1rem; display: none; }
        .ai-result-box.show { display: block; }
        .risk-low    { background: rgba(52,211,153,0.1); border: 1px solid #34d399; }
        .risk-medium { background: rgba(251,191,36,0.1); border: 1px solid #fbbf24; }
        .risk-high   { background: rgba(239,68,68,0.1);  border: 1px solid #ef4444; }
        .risk-label  { font-size: 1.4rem; font-weight: 700; }
        .vitals-summary { display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; margin-top: 1rem; }
        .vital-row { background: rgba(255,255,255,0.04); border-radius: 8px; padding: 0.6rem 1rem; display: flex; justify-content: space-between; align-items: center; }
        .vital-row .vname { font-size: 0.82rem; color: var(--text-muted); }
        .vital-row .vval  { font-weight: 600; font-size: 0.95rem; }
        .steps-list { list-style: none; padding: 0; margin: 0.75rem 0 0; }
        .steps-list li { display: flex; gap: 0.75rem; padding: 0.6rem 0; border-bottom: 1px solid rgba(255,255,255,0.06); font-size: 0.9rem; }
        .steps-list li:last-child { border-bottom: none; }
        .steps-list li .icon { font-size: 1.1rem; flex-shrink: 0; }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            <div class="grid grid-2">

                <!-- ── Left: Symptom Checker Input ─────────────────── -->
                <div class="card">
                    <div class="section-title">🩺 Describe Your Symptoms</div>
                    <p class="section-subtitle mt-1">Select all that apply, then click <strong>Run AI Check</strong></p>

                    <!-- Symptom Chips (clickable) -->
                    <div class="mt-3">
                        <label style="font-size:0.82rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;">Common Symptoms</label>
                        <div class="chips-wrap" id="symptomChips">
                            <span class="symptom-chip" data-val="chest_pain">💔 Chest Pain</span>
                            <span class="symptom-chip" data-val="breathing">🌬 Shortness of Breath</span>
                            <span class="symptom-chip" data-val="dizziness">💫 Dizziness</span>
                            <span class="symptom-chip" data-val="headache">🤕 Headache</span>
                            <span class="symptom-chip" data-val="fever">🌡 Fever</span>
                            <span class="symptom-chip" data-val="fatigue">😴 Fatigue</span>
                            <span class="symptom-chip" data-val="nausea">🤢 Nausea</span>
                            <span class="symptom-chip" data-val="palpitations">❤ Palpitations</span>
                            <span class="symptom-chip" data-val="sweating">💧 Excessive Sweating</span>
                            <span class="symptom-chip" data-val="swelling">🦵 Swelling</span>
                            <span class="symptom-chip" data-val="vision">👁 Blurred Vision</span>
                            <span class="symptom-chip" data-val="weakness">💪 Muscle Weakness</span>
                        </div>
                    </div>

                    <!-- Details textarea -->
                    <div class="form-group mt-3">
                        <label for="aiNotes">Additional Details <span class="muted">(optional)</span></label>
                        <textarea id="aiNotes" class="form-control" rows="4"
                                  placeholder="How long have you had these symptoms? Are they getting worse? Any known conditions?"></textarea>
                    </div>

                    <!-- Hidden field for selected symptoms -->
                    <input type="hidden" id="selectedSymptoms" value="">

                    <!-- Your Current Vitals (from DB) -->
                    <c:if test="${not empty latestMetric}">
                        <div style="margin-top:1rem;">
                            <label style="font-size:0.82rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;">Your Latest Vitals (used in analysis)</label>
                            <div class="vitals-summary">
                                <c:if test="${latestMetric.heartRate != null}">
                                    <div class="vital-row">
                                        <span class="vname">❤ Heart Rate</span>
                                        <span class="vval">${latestMetric.heartRate} bpm</span>
                                    </div>
                                </c:if>
                                <c:if test="${latestMetric.bloodPressureSys != null}">
                                    <div class="vital-row">
                                        <span class="vname">🩺 Blood Pressure</span>
                                        <span class="vval">${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia}</span>
                                    </div>
                                </c:if>
                                <c:if test="${latestMetric.spo2 != null}">
                                    <div class="vital-row">
                                        <span class="vname">💧 SpO2</span>
                                        <span class="vval">${latestMetric.spo2}%</span>
                                    </div>
                                </c:if>
                                <c:if test="${latestMetric.temperature != null}">
                                    <div class="vital-row">
                                        <span class="vname">🌡 Temperature</span>
                                        <span class="vval">${latestMetric.temperature}°C</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${empty latestMetric}">
                        <div class="mt-3" style="padding:0.75rem;background:rgba(251,191,36,0.08);border:1px solid #fbbf24;border-radius:8px;font-size:0.85rem;color:#fbbf24;">
                            ⚠ No vitals recorded. <a href="${pageContext.request.contextPath}/patient/health" style="color:#fbbf24;font-weight:600;">Add health data</a> for a more accurate analysis.
                        </div>
                    </c:if>

                    <div class="mt-4">
                        <button class="btn btn-primary" type="button" id="runAiBtn" onclick="runAiCheck()">
                            🤖 Run AI Check
                        </button>
                        <button class="btn btn-outline btn-sm" type="button" onclick="clearAll()" style="margin-left:0.75rem;">Clear</button>
                    </div>
                </div>

                <!-- ── Right: AI Results ──────────────────────────── -->
                <div class="card" id="resultPanel">
                    <div class="section-title">🤖 AI Prediction</div>
                    <p class="section-subtitle mt-1" id="resultSubtitle">Select symptoms and click Run AI Check to see your analysis.</p>

                    <!-- Waiting State -->
                    <div id="waitingState" class="mt-4" style="text-align:center;padding:2rem;">
                        <div style="font-size:3rem;margin-bottom:1rem;">🔬</div>
                        <div class="muted">Your AI health analysis will appear here.</div>
                        <c:if test="${not empty latestMetric}">
                            <div style="font-size:0.82rem;margin-top:0.5rem;color:#60a5fa;">
                                ✅ Your latest vitals will be automatically included in the analysis.
                            </div>
                        </c:if>
                    </div>

                    <!-- Result Box (shown after check) -->
                    <div id="aiResultBox" class="ai-result-box">
                        <div style="display:flex;align-items:center;gap:1rem;margin-bottom:1rem;">
                            <div id="riskIcon" style="font-size:2rem;">✅</div>
                            <div>
                                <div class="muted" style="font-size:0.8rem;">Estimated Risk Level</div>
                                <div class="risk-label" id="riskLabel">—</div>
                            </div>
                        </div>
                        <div style="border-top:1px solid rgba(255,255,255,0.08);padding-top:1rem;margin-top:0.5rem;">
                            <div class="section-title" style="font-size:0.95rem;">📋 Summary</div>
                            <p id="summaryText" style="font-size:0.9rem;color:var(--text-muted);margin-top:0.5rem;"></p>
                        </div>
                        <div style="border-top:1px solid rgba(255,255,255,0.08);padding-top:1rem;margin-top:0.75rem;">
                            <div class="section-title" style="font-size:0.95rem;">✅ Recommended Next Steps</div>
                            <ul class="steps-list" id="stepsList"></ul>
                        </div>
                        <div style="margin-top:1rem;">
                            <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-outline btn-sm">📅 Book an Appointment</a>
                        </div>
                    </div>

                    <div class="mt-4" style="background:rgba(255,255,255,0.03);border-radius:8px;padding:0.75rem;font-size:0.78rem;color:var(--text-muted);">
                        ⚕ <em>This AI checker uses rule-based logic. It does NOT replace professional medical diagnosis. Always consult a qualified doctor.</em>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/layout/patient-footer.jsp" %>
    </main>
</div>

<script src="<%= request.getContextPath() %>/assets/js/admin.js?v=3"></script>
<script>
    // ── Symptom chip toggle ──────────────────────────────────
    const chips = document.querySelectorAll('.symptom-chip');
    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            chip.classList.toggle('active');
        });
    });

    function getSelectedSymptoms() {
        return Array.from(document.querySelectorAll('.symptom-chip.active')).map(c => c.dataset.val);
    }

    function clearAll() {
        chips.forEach(c => c.classList.remove('active'));
        document.getElementById('aiNotes').value = '';
        document.getElementById('waitingState').style.display = 'block';
        document.getElementById('aiResultBox').classList.remove('show');
        document.getElementById('resultSubtitle').textContent = 'Select symptoms and click Run AI Check to see your analysis.';
    }

    // ── Live vitals from server ──────────────────────────────
    const vitals = {
        heartRate:        ${not empty latestMetric and latestMetric.heartRate != null ? latestMetric.heartRate : 'null'},
        bloodPressureSys: ${not empty latestMetric and latestMetric.bloodPressureSys != null ? latestMetric.bloodPressureSys : 'null'},
        spo2:             ${not empty latestMetric and latestMetric.spo2 != null ? latestMetric.spo2 : 'null'},
        temperature:      ${not empty latestMetric and latestMetric.temperature != null ? latestMetric.temperature : 'null'}
    };

    // ── Main AI Check Logic ──────────────────────────────────
    function runAiCheck() {
        const symptoms = getSelectedSymptoms();
        if (symptoms.length === 0) {
            alert('Please select at least one symptom before running the check.');
            return;
        }

        let riskScore = 0;
        let findings  = [];
        let steps     = [];

        // ── Symptom-based scoring ────────────────────────────
        if (symptoms.includes('chest_pain')) {
            riskScore += 40;
            findings.push('Chest pain is a serious symptom that may indicate cardiac issues.');
            steps.push({ icon: '🚨', text: 'Seek immediate medical attention if chest pain is severe or radiates to your arm or jaw.' });
        }
        if (symptoms.includes('breathing')) {
            riskScore += 30;
            findings.push('Shortness of breath can indicate respiratory or cardiac conditions.');
            steps.push({ icon: '🏥', text: 'If breathing difficulty is sudden or severe, call emergency services.' });
        }
        if (symptoms.includes('palpitations')) {
            riskScore += 20;
            findings.push('Heart palpitations detected — may be related to stress, caffeine, or arrhythmia.');
            steps.push({ icon: '📅', text: 'Book a cardiology appointment for an ECG evaluation.' });
        }
        if (symptoms.includes('dizziness')) {
            riskScore += 15;
            findings.push('Dizziness may indicate low blood pressure, dehydration, or inner ear issues.');
            steps.push({ icon: '💧', text: 'Stay hydrated and avoid sudden position changes.' });
        }
        if (symptoms.includes('headache')) {
            riskScore += 10;
            findings.push('Persistent headaches can be related to blood pressure or tension.');
        }
        if (symptoms.includes('fever')) {
            riskScore += 20;
            findings.push('Fever indicates an active infection or inflammatory response.');
            steps.push({ icon: '💊', text: 'Rest, take antipyretics, and see a doctor if fever exceeds 39°C.' });
        }
        if (symptoms.includes('fatigue')) {
            riskScore += 10;
            findings.push('Fatigue may be a sign of anaemia, thyroid issues, or poor sleep.');
        }
        if (symptoms.includes('nausea')) {
            riskScore += 10;
            findings.push('Nausea combined with chest pain is a red flag requiring immediate evaluation.');
            if (symptoms.includes('chest_pain')) riskScore += 20;
        }
        if (symptoms.includes('sweating')) {
            riskScore += 15;
            findings.push('Excessive sweating with chest pain can indicate myocardial infarction.');
            if (symptoms.includes('chest_pain')) riskScore += 15;
        }
        if (symptoms.includes('swelling')) {
            riskScore += 15;
            findings.push('Swelling in limbs may indicate heart failure, kidney, or venous issues.');
            steps.push({ icon: '🩺', text: 'Consult a doctor for evaluation of possible fluid retention.' });
        }
        if (symptoms.includes('vision')) {
            riskScore += 20;
            findings.push('Blurred vision combined with headache may indicate hypertensive urgency.');
        }
        if (symptoms.includes('weakness')) {
            riskScore += 15;
            findings.push('Sudden muscle weakness, especially one-sided, is a stroke warning sign.');
            steps.push({ icon: '🚑', text: 'Sudden weakness on one side? Call emergency immediately — possible stroke.' });
        }

        // ── Vitals-based scoring ─────────────────────────────
        if (vitals.heartRate !== null) {
            if (vitals.heartRate > 120) { riskScore += 20; findings.push('⚡ Your recorded heart rate (' + vitals.heartRate + ' bpm) is elevated.'); }
            else if (vitals.heartRate > 100) { riskScore += 10; findings.push('Your heart rate (' + vitals.heartRate + ' bpm) is slightly above normal.'); }
        }
        if (vitals.bloodPressureSys !== null) {
            if (vitals.bloodPressureSys > 140) { riskScore += 20; findings.push('⚡ Your recorded BP (' + vitals.bloodPressureSys + ' mmHg) is high.'); }
            else if (vitals.bloodPressureSys > 120) { riskScore += 10; findings.push('Your BP (' + vitals.bloodPressureSys + ' mmHg) is slightly elevated.'); }
        }
        if (vitals.spo2 !== null && vitals.spo2 < 95) {
            riskScore += 25;
            findings.push('⚡ Your SpO2 (' + vitals.spo2 + '%) is below normal — oxygen levels are low!');
            steps.push({ icon: '🫁', text: 'Low SpO2 detected. Rest and seek medical attention if breathing is difficult.' });
        }
        if (vitals.temperature !== null && vitals.temperature > 37.5) {
            riskScore += 15;
            findings.push('⚡ Your body temperature (' + vitals.temperature + '°C) indicates fever.');
        }

        riskScore = Math.min(riskScore, 100);

        // ── Default steps if none set ────────────────────────
        if (steps.length === 0) {
            steps.push({ icon: '📅', text: 'Monitor your symptoms over the next 24 hours.' });
            steps.push({ icon: '💊', text: 'Rest well, stay hydrated, and maintain a balanced diet.' });
        }
        steps.push({ icon: '👨‍⚕️', text: 'Schedule a follow-up with your doctor if symptoms persist or worsen.' });

        // ── Render result ────────────────────────────────────
        const box     = document.getElementById('aiResultBox');
        const waiting = document.getElementById('waitingState');

        let riskLabel, riskIcon, riskClass, summary;
        if (riskScore >= 60) {
            riskLabel = '🔴 High Risk'; riskIcon = '🚨'; riskClass = 'risk-high';
            summary = 'Based on your symptoms' + (vitals.heartRate ? ' and recorded vitals' : '') + ', your risk level appears HIGH. Several serious indicators are present. Please consult a doctor as soon as possible — do not ignore these symptoms.';
        } else if (riskScore >= 30) {
            riskLabel = '🟡 Medium Risk'; riskIcon = '⚠️'; riskClass = 'risk-medium';
            summary = 'Your combination of symptoms suggests a moderate health concern. While not immediately life-threatening, you should book an appointment with your doctor this week for proper evaluation.';
        } else {
            riskLabel = '🟢 Low Risk'; riskIcon = '✅'; riskClass = 'risk-low';
            summary = 'Your symptoms suggest a low-risk condition. Monitor your health, rest well, and stay hydrated. If symptoms worsen or new ones appear, please consult a doctor.';
        }

        document.getElementById('riskLabel').textContent = riskLabel;
        document.getElementById('riskIcon').textContent  = riskIcon;
        document.getElementById('summaryText').textContent = summary;
        document.getElementById('resultSubtitle').textContent = 'Analysis complete — ' + symptoms.length + ' symptom(s) checked.';

        // Build steps list
        const stepsList = document.getElementById('stepsList');
        stepsList.innerHTML = '';
        findings.slice(0, 3).forEach(f => {
            const li = document.createElement('li');
            li.innerHTML = '<span class="icon">🔍</span><span style="color:var(--text-muted);font-size:0.85rem;">' + f + '</span>';
            stepsList.appendChild(li);
        });
        steps.forEach(s => {
            const li = document.createElement('li');
            li.innerHTML = '<span class="icon">' + s.icon + '</span><span>' + s.text + '</span>';
            stepsList.appendChild(li);
        });

        box.className = 'ai-result-box ' + riskClass + ' show';
        waiting.style.display = 'none';
    }
</script>
</body>
</html>
