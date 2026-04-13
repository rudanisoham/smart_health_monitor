package com.smarthealth.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "medical_reports")
public class MedicalReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String results;

    @Column
    private String filePath;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getResults() { return results; }
    public void setResults(String results) { this.results = results; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Enumerated(EnumType.STRING)
    @Column(name = "report_type")
    private ReportType type;

    @Enumerated(EnumType.STRING)
    @Column(name = "report_status")
    private ReportStatus status;

    @Column(columnDefinition = "TEXT")
    private String doctorComments;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "prescription_id")
    private Prescription prescription;

    public ReportType getType() { return type; }
    public void setType(ReportType type) { this.type = type; }

    public ReportStatus getStatus() { return status; }
    public void setStatus(ReportStatus status) { this.status = status; }

    public String getDoctorComments() { return doctorComments; }
    public void setDoctorComments(String doctorComments) { this.doctorComments = doctorComments; }

    public Prescription getPrescription() { return prescription; }
    public void setPrescription(Prescription prescription) { this.prescription = prescription; }

    public enum ReportType {
        BLOOD_TEST, X_RAY, MRI, ECG, CT_SCAN, URINE_TEST, OTHER
    }

    public enum ReportStatus {
        NORMAL, ABNORMAL, PENDING, REVIEWED
    }
}
