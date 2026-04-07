package com.smarthealth.repository.jpa;

import com.smarthealth.model.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    List<Doctor> findByIsApprovedFalse();
    List<Doctor> findByIsApprovedTrue();
    List<Doctor> findByDepartmentId(Long departmentId);
    List<Doctor> findByStatus(String status);
}
