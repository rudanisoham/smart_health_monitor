package com.smarthealth.model;

import jakarta.persistence.*;

@Entity
@Table(name = "beds")
public class Bed {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @Column(nullable = false)
    private String bedNumber;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BedType type; // NORMAL, ICU

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BedStatus status; // AVAILABLE, OCCUPIED, MAINTENANCE

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @Column(name = "assigned_at")
    private java.time.LocalDateTime assignedAt;

    @Column(nullable = false)
    private Double dailyCharge = 500.0; // Default charge

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
    
    public String getBedNumber() { return bedNumber; }
    public void setBedNumber(String bedNumber) { this.bedNumber = bedNumber; }
    
    public BedType getType() { return type; }
    public void setType(BedType type) { this.type = type; }
    
    public BedStatus getStatus() { return status; }
    public void setStatus(BedStatus status) { this.status = status; }
    
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public java.time.LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(java.time.LocalDateTime assignedAt) { this.assignedAt = assignedAt; }

    public Double getDailyCharge() { return dailyCharge; }
    public void setDailyCharge(Double dailyCharge) { this.dailyCharge = dailyCharge; }

    public enum BedType {
        NORMAL, ICU
    }

    public enum BedStatus {
        AVAILABLE, OCCUPIED, MAINTENANCE
    }
}
