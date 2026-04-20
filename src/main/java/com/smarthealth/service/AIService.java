package com.smarthealth.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smarthealth.model.mongo.HealthMetric;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.*;

@Service
public class AIService {

    private final String MISTRAL_API_KEY = "";
    private final String MISTRAL_API_URL = "https://api.mistral.ai/v1/chat/completions";
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RestTemplate restTemplate = new RestTemplate();

    public Map<String, Object> analyzeSymptoms(List<String> symptoms, HealthMetric vitals, String notes) {
        String prompt = buildSymptomPrompt(symptoms, vitals, notes);
        String response = callMistral(prompt);
        return parseAIServiceResponse(response);
    }

    public String getQuickInsight(HealthMetric metric) {
        if (metric == null) return "No health data recorded yet. Add your first reading to get AI insights.";
        String prompt = "Give a 1-sentence health insight for a person with: " +
                "Heart Rate: " + metric.getHeartRate() + " bpm, " +
                "BP: " + metric.getBloodPressureSys() + "/" + metric.getBloodPressureDia() + ", " +
                "SpO2: " + metric.getSpo2() + "%, " +
                "Temp: " + metric.getTemperature() + "C.";
        
        try {
            String response = callMistral(prompt);
            JsonNode root = objectMapper.readTree(response);
            return root.path("choices").get(0).path("message").path("content").asText().trim();
        } catch (Exception e) {
            return "Vitals appear dynamic. Keep monitoring and stay hydrated.";
        }
    }

    private String buildSymptomPrompt(List<String> symptoms, HealthMetric vitals, String notes) {
        StringBuilder sb = new StringBuilder();
        sb.append("You are a friendly, caring medical assistant. Your goal is to explain things in SIMPLE, NON-TECHNICAL language that a regular person can easily understand. Avoid medical jargon.\n\n");
        sb.append("Patient Input:\n");
        if (symptoms != null && !symptoms.isEmpty()) {
            sb.append("- Selected Symptoms: ").append(String.join(", ", symptoms)).append("\n");
        }
        if (notes != null && !notes.isBlank()) {
            sb.append("- Problem Description: ").append(notes).append("\n");
        }
        if (vitals != null) {
            sb.append("- Latest Recorded Vitals: Heart Rate=").append(vitals.getHeartRate())
              .append("bpm, BP=").append(vitals.getBloodPressureSys()).append("/").append(vitals.getBloodPressureDia())
              .append(", SpO2=").append(vitals.getSpo2()).append("%, Temp=").append(vitals.getTemperature()).append("C\n");
        }
        sb.append("\nRespond ONLY with a JSON object. The 'summary' should be conversational and easy to read.\n");
        sb.append("Required JSON Format:\n");
        sb.append("{\n");
        sb.append("  \"riskLevel\": \"LOW\" | \"MEDIUM\" | \"HIGH\",\n");
        sb.append("  \"summary\": \"Conversational explanation of likely causes and findings in plain words\",\n");
        sb.append("  \"recommendations\": [\"Simple step 1\", \"Simple step 2\", ...],\n");
        sb.append("  \"disclaimer\": \"Always talk to your real doctor for a final diagnosis.\"\n");
        sb.append("}");
        return sb.toString();
    }

    private String callMistral(String prompt) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(MISTRAL_API_KEY);

            Map<String, Object> body = new HashMap<>();
            body.put("model", "mistral-small-latest");
            body.put("messages", Collections.singletonList(
                Map.of("role", "user", "content", prompt)
            ));

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(MISTRAL_API_URL, entity, String.class);
            return response.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private Map<String, Object> parseAIServiceResponse(String response) {
        Map<String, Object> result = new HashMap<>();
        try {
            JsonNode root = objectMapper.readTree(response);
            String content = root.path("choices").get(0).path("message").path("content").asText();
            
            // Extract JSON if AI wrapped it in markdown
            if (content.contains("```json")) {
                content = content.split("```json")[1].split("```")[0].trim();
            } else if (content.contains("```")) {
                content = content.split("```")[1].split("```")[0].trim();
            }

            return objectMapper.readValue(content, Map.class);
        } catch (Exception e) {
            result.put("riskLevel", "UNKNOWN");
            result.put("summary", "AI Analysis failed to process. Please consult a doctor manually.");
            result.put("recommendations", Arrays.asList("Check your internet connection", "Try again later", "Book an appointment if symptoms persist"));
            return result;
        }
    }
}
