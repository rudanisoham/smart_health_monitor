<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("activePage", "ai");
    request.setAttribute("pageTitle", "AI Health Assistant");
    request.setAttribute("pageSubtitle", "Get simple, friendly answers about your health problems");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Health Check · Smart Health Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/admin.css?v=3">
    <style>
        :root {
            --ai-primary: #3b82f6;
            --ai-bg-light: #f8fafc;
            --ai-card-shadow: 0 4px 24px rgba(0,0,0,0.06);
            --ai-text-dark: #1e293b;
            --ai-text-muted: #64748b;
        }

        .symptom-chip {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.5rem 1.1rem; border-radius: 99px;
            border: 1.5px solid #e2e8f0;
            background: #ffffff; color: var(--ai-text-muted);
            cursor: pointer; font-size: 0.88rem; transition: all 0.2s;
            user-select: none; font-weight: 500;
        }
        .symptom-chip:hover { border-color: var(--ai-primary); color: var(--ai-primary); background: var(--ai-bg-light); }
        .symptom-chip.active {
            border-color: var(--ai-primary); background: var(--ai-primary); color: #ffffff;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.25);
        }
        
        .chips-wrap { display: flex; flex-wrap: wrap; gap: 0.75rem; margin-top: 1rem; }
        .ai-result-box { border-radius: 16px; padding: 1.75rem; margin-top: 1.5rem; display: none; background: #ffffff; border: 1px solid #f1f5f9; box-shadow: var(--ai-card-shadow); }
        .ai-result-box.show { display: block; animation: fadeIn 0.4s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .risk-low    { border-left: 6px solid #22c55e; }
        .risk-medium { border-left: 6px solid #f59e0b; }
        .risk-high   { border-left: 6px solid #ef4444; }
        
        .risk-indicator { font-size: 2rem; margin-bottom: 0.5rem; }
        .risk-label  { font-size: 1.1rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; color: var(--ai-text-muted); }
        .result-subtitle { font-size: 0.95rem; color: var(--ai-text-muted); font-weight: 500; }
        .summary-text { font-size: 1.1rem; line-height: 1.7; margin-top: 1.25rem; color: var(--ai-text-dark); font-weight: 500; }
        
        .vitals-summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 1rem; margin-top: 1.5rem; }
        .vital-row { background: var(--ai-bg-light); border: 1px solid #f1f5f9; border-radius: 12px; padding: 0.85rem 1.1rem; display: flex; justify-content: space-between; align-items: center; }
        .vital-row .vname { font-size: 0.8rem; color: var(--ai-text-muted); font-weight: 700; }
        .vital-row .vval  { font-weight: 800; font-size: 1.1rem; color: var(--ai-text-dark); }
        
        .result-card { min-height: 520px; }
        .next-steps { margin-top: 1.75rem; padding-top: 1.5rem; border-top: 1px dashed #e2e8f0; }
        .section-title-sm { font-size: 0.95rem; font-weight: 800; color: var(--ai-text-dark); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 1rem; }
        .steps-list { list-style: none; padding: 0; margin: 0; }
        .steps-list li { display: flex; gap: 0.85rem; padding: 0.85rem 1rem; background: #f8fafc; border-radius: 12px; margin-bottom: 0.5rem; border: 1px solid #f1f5f9; font-size: 0.95rem; color: #334155; font-weight: 500; }
        .steps-list li .icon { font-size: 1.2rem; }
        
        .typing-indicator { display: flex; gap: 6px; justify-content: center; align-items: center; padding: 2.5rem; }
        .typing-indicator span { width: 10px; height: 10px; background: var(--ai-primary); border-radius: 50%; opacity: 0.3; animation: blink 1.4s infinite both; }
        .typing-indicator span:nth-child(2) { animation-delay: 0.2s; }
        .typing-indicator span:nth-child(3) { animation-delay: 0.4s; }
        @keyframes blink { 0%, 80%, 100% { opacity: 0.3; transform: scale(0.8); } 40% { opacity: 1; transform: scale(1.1); } }
        
        .history-list { display: flex; flex-direction: column; gap: 0.75rem; margin-top: 1rem; }
        .history-item { 
            padding: 1rem 1.25rem; background: #ffffff; border-radius: 14px; 
            cursor: pointer; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border: 1px solid #f1f5f9; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 1rem;
        }
        .history-item:hover { transform: translateX(6px); border-color: var(--ai-primary); box-shadow: 0 4px 16px rgba(0,0,0,0.06); }
        .history-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; background: var(--ai-bg-light); }
        
        .card { box-shadow: var(--ai-card-shadow) !important; border: 1px solid #f1f5f9 !important; border-radius: 20px !important; }
        .form-control { border-radius: 12px !important; background: var(--ai-bg-light) !important; border: 1.5px solid #e2e8f0 !important; font-weight: 500 !important; }
        .form-control:focus { border-color: var(--ai-primary) !important; background: #ffffff !important; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1) !important; }
        .btn-primary { background: var(--ai-primary) !important; border-radius: 14px !important; font-weight: 700 !important; padding: 0.9rem 2rem !important; transition: 0.3s !important; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3); }
    </style>
</head>
<body>
<div class="admin-app">
    <%@ include file="/WEB-INF/views/layout/patient-sidebar.jsp" %>
    <main class="admin-main">
        <%@ include file="/WEB-INF/views/layout/patient-header.jsp" %>

        <div class="admin-content">
            <div class="grid grid-2" style="align-items: stretch;">

                <!-- ── Left: Problem Input ─────────────────── -->
                <div class="card">
                    <div style="display:flex; align-items:center; gap:0.75rem; margin-bottom:0.5rem;">
                        <span style="font-size:1.75rem;">🩺</span>
                        <div class="section-title">Health Check-in</div>
                    </div>
                    <p class="section-subtitle">Describe how you feel in normal words, or select symptoms below.</p>

                    <!-- Details textarea (Primary Focus) -->
                    <div class="form-group mt-4">
                        <label for="aiNotes" style="font-size:0.9rem;font-weight:700;color:var(--ai-text-dark);">What is the problem?</label>
                        <textarea id="aiNotes" class="form-control" rows="6" 
                                  placeholder="E.g., 'My stomach has been hurting since morning and I feel like throwing up...'"></textarea>
                        <div class="muted mt-1" style="font-size:0.75rem;">Speak naturally, the AI understands normal language.</div>
                    </div>

                    <!-- Symptom Chips (Secondary) -->
                    <div class="mt-4">
                        <label style="font-size:0.75rem;color:var(--ai-text-muted);text-transform:uppercase;letter-spacing:0.1em;font-weight:800;">Quick Symptom Tags</label>
                        <div class="chips-wrap" id="symptomChips">
                            <span class="symptom-chip" data-val="chest_pain">💔 Chest Pain</span>
                            <span class="symptom-chip" data-val="breathing">🌬 Difficulty Breathing</span>
                            <span class="symptom-chip" data-val="dizziness">💫 Dizziness</span>
                            <span class="symptom-chip" data-val="headache">🤕 Headache</span>
                            <span class="symptom-chip" data-val="fever">🌡 Fever</span>
                            <span class="symptom-chip" data-val="fatigue">😴 Constant Tiredness</span>
                            <span class="symptom-chip" data-val="nausea">🤢 Nausea</span>
                        </div>
                    </div>

                    <div class="mt-4 pt-2">
                        <button class="btn btn-primary w-full" id="runAiBtn" onclick="runAiCheck()">✨ Analyze Health Problem</button>
                        <button class="btn btn-outline w-full mt-2" onclick="clearAll()" style="font-size:0.85rem; border:none; color:var(--ai-text-muted);">🔄 Click here to reset</button>
                    </div>

                    <input type="hidden" id="selectedSymptoms" value="">

                    <!-- Vitals Summary -->
                    <c:if test="${not empty latestMetric}">
                        <div style="margin-top:2rem; padding-top:1.5rem; border-top:1px dashed #e2e8f0;">
                            <label style="font-size:0.7rem;color:var(--ai-text-muted);text-transform:uppercase;letter-spacing:0.15em;font-weight:800;">Reference Health Data</label>
                            <div class="vitals-summary">
                                <c:if test="${latestMetric.heartRate != null}"><div class="vital-row"><span class="vname">Heart Rate</span><span class="vval">${latestMetric.heartRate} bpm</span></div></c:if>
                                <c:if test="${latestMetric.bloodPressureSys != null}"><div class="vital-row"><span class="vname">Blood Pressure</span><span class="vval">${latestMetric.bloodPressureSys}/${latestMetric.bloodPressureDia}</span></div></c:if>
                                <c:if test="${latestMetric.spo2 != null}"><div class="vital-row"><span class="vname">Oxygen (SpO2)</span><span class="vval">${latestMetric.spo2}%</span></div></c:if>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- ── Right: AI Analysis ────────────────────────── -->
                <div class="card result-card" style="display:flex; flex-direction:column;">
                    <div id="waitingState" style="text-align:center; padding:4rem 2rem;">
                         <div style="font-size:3rem; margin-bottom:1rem;">🤔</div>
                         <div class="muted" style="font-size:1.1rem; font-weight:500;">Ready to help. Describe your problem on the left and click analyze.</div>
                    </div>

                    <div id="aiResultBox" class="ai-result-box">
                        <div style="display:flex; align-items:center; gap:1.25rem;">
                            <div class="risk-indicator" id="riskIcon">✅</div>
                            <div>
                                <div class="risk-label" id="riskLabel">LOW RISK</div>
                                <div class="result-subtitle" id="resultSubtitle">Analysis Complete</div>
                            </div>
                        </div>

                        <div class="summary-text" id="summaryText"></div>

                        <div class="next-steps">
                            <div class="section-title-sm">Suggested Next Steps</div>
                            <ul class="steps-list" id="stepsList"></ul>
                        </div>
                    </div>

                    <!-- History Section -->
                    <c:if test="${not empty aiLogs}">
                        <div class="mt-4 pt-4" style="border-top:1px solid #f1f5f9;">
                            <div class="section-title-sm" style="display:flex; justify-content:space-between; align-items:center;">
                                <span>Recent History</span>
                                <span class="badge-soft" style="background:#f1f5f9; color:#64748b; font-size:0.7rem; border-radius:6px;">LATEST ${aiLogs.size()}</span>
                            </div>
                            <div class="history-list" style="margin-top: 1rem;">
                                <c:forEach var="log" items="${aiLogs}">
                                    <div class="history-item" onclick="displayLogResults('${log.id}')">
                                        <div class="history-icon" style="background:${log.aiResponse.riskLevel == 'HIGH' ? '#fef2f2' : log.aiResponse.riskLevel == 'MEDIUM' ? '#fffbeb' : '#f0fdf4'}">
                                            ${log.aiResponse.riskLevel == 'HIGH' ? '🔴' : log.aiResponse.riskLevel == 'MEDIUM' ? '🟡' : '🟢'}
                                        </div>
                                        <div style="flex:1;">
                                            <div style="font-size:0.85rem; font-weight:700; color:var(--ai-text-dark);">${log.symptoms.size() > 0 ? log.symptoms[0] : 'Note-only check'}</div>
                                            <div style="font-size:0.75rem; color:var(--ai-text-muted);">${log.timestamp.toString().replace('T',' ').substring(0,16)}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
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
        chip.addEventListener('click', () => chip.classList.toggle('active'));
    });

    function getSelectedSymptoms() {
        return Array.from(document.querySelectorAll('.symptom-chip.active')).map(c => c.dataset.val);
    }

    function clearAll() {
        chips.forEach(c => c.classList.remove('active'));
        document.getElementById('aiNotes').value = '';
        document.getElementById('waitingState').style.display = 'block';
        document.getElementById('aiResultBox').classList.remove('show');
    }

    async function runAiCheck() {
        const symptoms = getSelectedSymptoms();
        const notes = document.getElementById('aiNotes').value.trim();

        if (symptoms.length === 0 && notes.length < 10) {
            alert('Please describe your problem (at least 10 letters) or pick a symptom.');
            return;
        }

        const box     = document.getElementById('aiResultBox');
        const waiting = document.getElementById('waitingState');
        const runBtn  = document.getElementById('runAiBtn');

        waiting.style.display = 'block';
        waiting.innerHTML = `
            <div class="typing-indicator"><span></span><span></span><span></span></div>
            <div style="font-weight:700; color:var(--ai-text-dark);">AI is thinking...</div>
            <div style="font-size:0.85rem; color:var(--ai-text-muted); margin-top:0.5rem;">Analyzing your problem in plain language.</div>
        `;
        box.classList.remove('show');
        runBtn.disabled = true;
        runBtn.innerHTML = '✨ Processing...';

        try {
            const response = await fetch('${pageContext.request.contextPath}/patient/ai/check', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ symptoms, notes })
            });
            const data = await response.json();
            if (data.error) { alert('Error: ' + data.error); clearAll(); return; }
            displayResults(data);
        } catch (error) {
            alert('Failed to connect to AI. Please try again.');
        } finally {
            runBtn.disabled = false;
            runBtn.innerHTML = '✨ Analyze Health Problem';
        }
    }

    function displayResults(data) {
        const box = document.getElementById('aiResultBox');
        const waiting = document.getElementById('waitingState');
        const stepsList = document.getElementById('stepsList');
        
        let riskClass = 'risk-low'; let riskIcon = '🟢';
        if (data.riskLevel === 'HIGH') { riskClass = 'risk-high'; riskIcon = '🔴'; }
        else if (data.riskLevel === 'MEDIUM') { riskClass = 'risk-medium'; riskIcon = '🟡'; }

        document.getElementById('riskLabel').textContent = data.riskLevel + ' RISK';
        document.getElementById('riskIcon').textContent  = riskIcon;
        
        const summaryEl = document.getElementById('summaryText');
        summaryEl.textContent = '';
        let i = 0; const text = data.summary;
        function typeWriter() {
            if (i < text.length) { summaryEl.textContent += text.charAt(i); i++; setTimeout(typeWriter, 12); }
        }
        typeWriter();

        stepsList.innerHTML = '';
        if (data.recommendations) {
            data.recommendations.forEach(rec => {
                const li = document.createElement('li');
                li.innerHTML = '<span class="icon">👉</span><span>' + rec + '</span>';
                stepsList.appendChild(li);
            });
        }
        
        if (data.disclaimer) {
            const li = document.createElement('li');
            li.style.background = 'none'; li.style.border = 'none'; li.style.marginTop = '1rem';
            li.innerHTML = '<span style="font-size:0.8rem; color:var(--ai-text-muted); font-style:italic;">' + data.disclaimer + '</span>';
            stepsList.appendChild(li);
        }

        waiting.style.display = 'none';
        box.className = 'ai-result-box ' + riskClass + ' show';
    }
</script>
</body>
</html>
