package com.smarthealth.model.mongo;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Document(collection = "health_metrics")
public class HealthMetric {

    @Id
    private String id;
    private Long patientId;
    private Integer heartRate;
    private Integer bloodPressureSys;
    private Integer bloodPressureDia;
    private Double spo2;
    private Double temperature;
    private Double weight;
    private String riskLevel;
    private Double latitude;
    private Double longitude;
    private LocalDateTime timestamp;

    public HealthMetric() { this.timestamp = LocalDateTime.now(); }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }
    public Integer getHeartRate() { return heartRate; }
    public void setHeartRate(Integer heartRate) { this.heartRate = heartRate; }
    public Integer getBloodPressureSys() { return bloodPressureSys; }
    public void setBloodPressureSys(Integer bloodPressureSys) { this.bloodPressureSys = bloodPressureSys; }
    public Integer getBloodPressureDia() { return bloodPressureDia; }
    public void setBloodPressureDia(Integer bloodPressureDia) { this.bloodPressureDia = bloodPressureDia; }
    public Double getSpo2() { return spo2; }
    public void setSpo2(Double spo2) { this.spo2 = spo2; }
    public Double getTemperature() { return temperature; }
    public void setTemperature(Double temperature) { this.temperature = temperature; }
    public Double getWeight() { return weight; }
    public void setWeight(Double weight) { this.weight = weight; }
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
