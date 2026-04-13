package com.smarthealth.repository.jpa;

import com.smarthealth.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    Patient findByUserId(Long userId);
    java.util.List<Patient> findByDepartmentId(Long departmentId);
}
