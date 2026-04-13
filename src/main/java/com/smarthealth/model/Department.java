package com.smarthealth.model;

import jakarta.persistence.*;

@Entity
@Table(name = "departments")
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String code;

    @Column(nullable = false)
    private Integer targetCapacity;
    
    @Column(nullable = false)
    private Integer currOccupancy;

    @Column(nullable = false)
    private String status; // ACTIVE, INACTIVE

    private String headName;
    private String physicalLocation;
    private String emergencyPhone;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(nullable = false, columnDefinition="int default 0")
    private Integer totalBeds = 0;
    
    @Column(nullable = false, columnDefinition="int default 0")
    private Integer availableBeds = 0;
    
    @Column(nullable = false, columnDefinition="int default 0")
    private Integer occupiedBeds = 0;
    
    @Column(nullable = false, columnDefinition="int default 0")
    private Integer icuBeds = 0;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public Integer getTargetCapacity() { return targetCapacity; }
    public void setTargetCapacity(Integer targetCapacity) { this.targetCapacity = targetCapacity; }
    public Integer getCurrOccupancy() { return currOccupancy; }
    public void setCurrOccupancy(Integer currOccupancy) { this.currOccupancy = currOccupancy; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getHeadName() { return headName; }
    public void setHeadName(String headName) { this.headName = headName; }
    public String getPhysicalLocation() { return physicalLocation; }
    public void setPhysicalLocation(String physicalLocation) { this.physicalLocation = physicalLocation; }
    public String getEmergencyPhone() { return emergencyPhone; }
    public void setEmergencyPhone(String emergencyPhone) { this.emergencyPhone = emergencyPhone; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Integer getTotalBeds() { return totalBeds; }
    public void setTotalBeds(Integer totalBeds) { this.totalBeds = totalBeds; }
    public Integer getAvailableBeds() { return availableBeds; }
    public void setAvailableBeds(Integer availableBeds) { this.availableBeds = availableBeds; }
    public Integer getOccupiedBeds() { return occupiedBeds; }
    public void setOccupiedBeds(Integer occupiedBeds) { this.occupiedBeds = occupiedBeds; }
    public Integer getIcuBeds() { return icuBeds; }
    public void setIcuBeds(Integer icuBeds) { this.icuBeds = icuBeds; }
}
