package com.smarthealth.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column
    private LocalDateTime scheduledAt;

    @Column(nullable = false)
    private String status = "AWAITING_ASSIGNMENT";

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "assigned_by_reception", columnDefinition = "TINYINT(1) DEFAULT 0")
    private Boolean assignedByReception = false;

    @Column(name = "preferred_date_note")
    private String preferredDateNote;

    /** Patient's preferred date (actual date picker value) */
    @Column(name = "preferred_date")
    private LocalDate preferredDate;

    /** Token number assigned by reception for queue management */
    @Column(name = "token_number")
    private Integer tokenNumber;

    /** Estimated time patient should arrive (set by reception) */
    @Column(name = "estimated_time")
    private LocalDateTime estimatedTime;

    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
    public LocalDateTime getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(LocalDateTime scheduledAt) { this.scheduledAt = scheduledAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public Boolean isAssignedByReception() { return assignedByReception != null && assignedByReception; }
    public void setAssignedByReception(Boolean v) { this.assignedByReception = v != null ? v : false; }
    public String getPreferredDateNote() { return preferredDateNote; }
    public void setPreferredDateNote(String preferredDateNote) { this.preferredDateNote = preferredDateNote; }
    public LocalDate getPreferredDate() { return preferredDate; }
    public void setPreferredDate(LocalDate preferredDate) { this.preferredDate = preferredDate; }
    public Integer getTokenNumber() { return tokenNumber; }
    public void setTokenNumber(Integer tokenNumber) { this.tokenNumber = tokenNumber; }
    public LocalDateTime getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(LocalDateTime estimatedTime) { this.estimatedTime = estimatedTime; }
}
