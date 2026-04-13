package com.smarthealth.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column
    private String bloodGroup;

    @Column(columnDefinition = "TEXT")
    private String allergies;

    @Column
    private String emergencyEmail;

    @Column
    private LocalDate dateOfBirth;

    @Column
    private String gender;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Column
    private String phone;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }
    public String getEmergencyEmail() { return emergencyEmail; }
    public void setEmergencyEmail(String emergencyEmail) { this.emergencyEmail = emergencyEmail; }
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "department_id")
    private Department department;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "doctor_id")
    private Doctor assignedDoctor;

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }

    public Doctor getAssignedDoctor() { return assignedDoctor; }
    public void setAssignedDoctor(Doctor assignedDoctor) { this.assignedDoctor = assignedDoctor; }
}
