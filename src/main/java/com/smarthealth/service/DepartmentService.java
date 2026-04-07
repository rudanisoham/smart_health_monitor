package com.smarthealth.service;

import com.smarthealth.model.Department;
import com.smarthealth.repository.jpa.DepartmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DepartmentService {

    @Autowired
    private DepartmentRepository departmentRepository;

    public Department save(Department department) {
        return departmentRepository.save(department);
    }

    public Optional<Department> findById(Long id) {
        return departmentRepository.findById(id);
    }

    public List<Department> findAll() {
        return departmentRepository.findAll();
    }

    public void delete(Long id) {
        departmentRepository.deleteById(id);
    }

    public long count() {
        return departmentRepository.count();
    }
}
