package com.smarthealth.repository.jpa;

import com.smarthealth.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DepartmentRepository extends JpaRepository<Department, Long> {
    boolean existsByCode(String code);
}
