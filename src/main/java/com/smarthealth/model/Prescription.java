package com.smarthealth.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "prescriptions")
public class Prescription {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @NotBlank(message = "Diagnosis is required")
    @Column(nullable = false)
    private String diagnosis;

    @NotBlank(message = "Medicines list is required")
    @Column(columnDefinition = "TEXT", nullable = false)
    private String medicines;

    @Column(columnDefinition = "TEXT")
    private String instructions;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @FutureOrPresent(message = "Expiry date cannot be in the past")
    @Column
    private LocalDate validUntil;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @OneToMany(mappedBy = "prescription", cascade = CascadeType.ALL, orphanRemoval = true)
    private java.util.List<PrescribedMedicine> prescribedMedicinesList = new java.util.ArrayList<>();

    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    public String getMedicines() { return medicines; }
    public void setMedicines(String medicines) { this.medicines = medicines; }
    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDate getValidUntil() { return validUntil; }
    public void setValidUntil(LocalDate validUntil) { this.validUntil = validUntil; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public java.util.List<PrescribedMedicine> getPrescribedMedicinesList() { return prescribedMedicinesList; }
    public void setPrescribedMedicinesList(java.util.List<PrescribedMedicine> prescribedMedicinesList) { this.prescribedMedicinesList = prescribedMedicinesList; }
}
