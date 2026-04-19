package com.smarthealth.repository.jpa;

import com.smarthealth.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    Patient findByUserId(Long userId);
    List<Patient> findByDepartmentId(Long departmentId);
    List<Patient> findByBloodGroup(String bloodGroup);
    List<Patient> findByGender(String gender);
    List<Patient> findByBloodGroupAndGender(String bloodGroup, String gender);
    List<Patient> findByBloodGroupAndDepartmentId(String bloodGroup, Long departmentId);
    List<Patient> findByGenderAndDepartmentId(String gender, Long departmentId);
    List<Patient> findByBloodGroupAndGenderAndDepartmentId(String bloodGroup, String gender, Long departmentId);
}
