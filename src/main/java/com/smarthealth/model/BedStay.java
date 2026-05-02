package com.smarthealth.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bed_stays")
public class BedStay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(nullable = false)
    private String bedNumber;

    @Column(nullable = false)
    private LocalDateTime assignedAt;

    @Column
    private LocalDateTime releasedAt;

    @Column(nullable = false)
    private Double dailyCharge;

    @Column
    private Double finalBill;

    @Column(nullable = false)
    private boolean settled = false;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public String getBedNumber() { return bedNumber; }
    public void setBedNumber(String bedNumber) { this.bedNumber = bedNumber; }

    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }

    public LocalDateTime getReleasedAt() { return releasedAt; }
    public void setReleasedAt(LocalDateTime releasedAt) { this.releasedAt = releasedAt; }

    public Double getDailyCharge() { return dailyCharge; }
    public void setDailyCharge(Double dailyCharge) { this.dailyCharge = dailyCharge; }

    public Double getFinalBill() { return finalBill; }
    public void setFinalBill(Double finalBill) { this.finalBill = finalBill; }

    public boolean isSettled() { return settled; }
    public void setSettled(boolean settled) { this.settled = settled; }
}
