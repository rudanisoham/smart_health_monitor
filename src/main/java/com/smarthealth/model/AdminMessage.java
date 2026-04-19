package com.smarthealth.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "admin_messages")
public class AdminMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String subject;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String body;

    @Column(nullable = false)
    private String targetRole; // PATIENT, DOCTOR, ALL

    // Filter criteria stored as JSON-like strings
    @Column
    private String filterBloodGroup;

    @Column
    private String filterGender;

    @Column
    private String filterDepartment;

    @Column
    private String filterSpecialty;

    @Column
    private String deliveryMethod; // EMAIL, IN_APP, BOTH

    @Column(nullable = false)
    private Integer recipientCount = 0;

    @Column(nullable = false)
    private String status; // SENT, FAILED, PARTIAL

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sent_by")
    private User sentBy;

    @Column(name = "sent_at", nullable = false)
    private LocalDateTime sentAt;

    @PrePersist
    protected void onCreate() {
        sentAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }
    public String getTargetRole() { return targetRole; }
    public void setTargetRole(String targetRole) { this.targetRole = targetRole; }
    public String getFilterBloodGroup() { return filterBloodGroup; }
    public void setFilterBloodGroup(String filterBloodGroup) { this.filterBloodGroup = filterBloodGroup; }
    public String getFilterGender() { return filterGender; }
    public void setFilterGender(String filterGender) { this.filterGender = filterGender; }
    public String getFilterDepartment() { return filterDepartment; }
    public void setFilterDepartment(String filterDepartment) { this.filterDepartment = filterDepartment; }
    public String getFilterSpecialty() { return filterSpecialty; }
    public void setFilterSpecialty(String filterSpecialty) { this.filterSpecialty = filterSpecialty; }
    public String getDeliveryMethod() { return deliveryMethod; }
    public void setDeliveryMethod(String deliveryMethod) { this.deliveryMethod = deliveryMethod; }
    public Integer getRecipientCount() { return recipientCount; }
    public void setRecipientCount(Integer recipientCount) { this.recipientCount = recipientCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public User getSentBy() { return sentBy; }
    public void setSentBy(User sentBy) { this.sentBy = sentBy; }
    public LocalDateTime getSentAt() { return sentAt; }
    public void setSentAt(LocalDateTime sentAt) { this.sentAt = sentAt; }
}
