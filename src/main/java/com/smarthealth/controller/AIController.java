package com.smarthealth.controller;

import com.smarthealth.model.mongo.HealthMetric;
import com.smarthealth.service.AIService;
import com.smarthealth.service.HealthMetricService;
import com.smarthealth.model.Patient;
import com.smarthealth.model.User;
import com.smarthealth.service.PatientService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/patient/ai")
public class AIController {

    @Autowired private AIService aiService;
    @Autowired private HealthMetricService healthMetricService;
    @Autowired private PatientService patientService;
    @Autowired private com.smarthealth.repository.mongo.AILogRepository aiLogRepository;

    @PostMapping("/check")
    public Map<String, Object> runCheck(@RequestBody Map<String, Object> request, HttpSession session) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return Map.of("error", "Unauthorized");

        Patient patient = patientService.findByUserId(user.getId());
        if (patient == null) return Map.of("error", "Patient profile not found");

        List<String> symptoms = (List<String>) request.get("symptoms");
        String notes = (String) request.get("notes");
        
        HealthMetric latest = healthMetricService.findLatestByPatientId(patient.getId());

        Map<String, Object> response = aiService.analyzeSymptoms(symptoms, latest, notes);

        // Logging
        try {
            com.smarthealth.model.mongo.AILog log = new com.smarthealth.model.mongo.AILog();
            log.setPatientId(patient.getId());
            log.setSymptoms(symptoms);
            log.setNotes(notes);
            log.setAiResponse(response);
            aiLogRepository.save(log);
        } catch (Exception e) {
            System.err.println("Failed to log AI interaction: " + e.getMessage());
        }

        return response;
    }
}
