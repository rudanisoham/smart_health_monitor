package com.smarthealth.repository.jpa;

import com.smarthealth.model.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    List<Doctor> findByIsApprovedFalse();
    List<Doctor> findByIsApprovedTrue();
    List<Doctor> findByDepartmentId(Long departmentId);
    List<Doctor> findByStatus(String status);
    List<Doctor> findBySpecialty(String specialty);
    List<Doctor> findBySpecialtyAndDepartmentId(String specialty, Long departmentId);

    @Query("SELECT DISTINCT d.specialty FROM Doctor d WHERE d.specialty IS NOT NULL ORDER BY d.specialty")
    List<String> findDistinctSpecialties();

    Doctor findByUserId(Long userId);

}
