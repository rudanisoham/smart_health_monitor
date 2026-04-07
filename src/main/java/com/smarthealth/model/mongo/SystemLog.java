package com.smarthealth.model.mongo;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Document(collection = "system_logs")
public class SystemLog {

    @Id
    private String id;
    private String action;
    private String performedBy;
    private String level; // INFO, WARN, ERROR
    private LocalDateTime timestamp;

    public SystemLog() {}

    public SystemLog(String action, String performedBy, String level) {
        this.action = action;
        this.performedBy = performedBy;
        this.level = level;
        this.timestamp = LocalDateTime.now();
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public String getPerformedBy() { return performedBy; }
    public void setPerformedBy(String performedBy) { this.performedBy = performedBy; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
