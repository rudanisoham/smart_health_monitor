package com.smarthealth.model.mongo;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Document(collection = "ai_logs")
public class AILog {
    @Id
    private String id;
    private Long patientId;
    private LocalDateTime timestamp;
    private List<String> symptoms;
    private String notes;
    private Map<String, Object> aiResponse;

    public AILog() {
        this.timestamp = LocalDateTime.now();
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
    public List<String> getSymptoms() { return symptoms; }
    public void setSymptoms(List<String> symptoms) { this.symptoms = symptoms; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public Map<String, Object> getAiResponse() { return aiResponse; }
    public void setAiResponse(Map<String, Object> aiResponse) { this.aiResponse = aiResponse; }
}
