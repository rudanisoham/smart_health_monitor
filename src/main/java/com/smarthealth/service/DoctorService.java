package com.smarthealth.service;

import com.smarthealth.model.Doctor;
import com.smarthealth.repository.jpa.DoctorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DoctorService {

    @Autowired
    private DoctorRepository doctorRepository;

    public Doctor save(Doctor doctor) {
        return doctorRepository.save(doctor);
    }

    public Optional<Doctor> findById(Long id) {
        return doctorRepository.findById(id);
    }

    public Doctor findByUserId(Long userId) {
        return doctorRepository.findByUserId(userId);
    }


    public List<Doctor> findAll() {
        return doctorRepository.findAll();
    }

    public List<Doctor> findPending() {
        return doctorRepository.findByIsApprovedFalse();
    }

    public List<Doctor> findApproved() {
        return doctorRepository.findByIsApprovedTrue();
    }

    public void approve(Long id) {
        doctorRepository.findById(id).ifPresent(d -> {
            d.setApproved(true);
            d.setStatus("ACTIVE");
            doctorRepository.save(d);
        });
    }

    public void reject(Long id) {
        doctorRepository.findById(id).ifPresent(d -> {
            doctorRepository.delete(d);
        });
    }

    public void toggleActive(Long id) {
        doctorRepository.findById(id).ifPresent(d -> {
            d.setStatus("ACTIVE".equals(d.getStatus()) ? "INACTIVE" : "ACTIVE");
            doctorRepository.save(d);
        });
    }

    public void delete(Long id) {
        doctorRepository.deleteById(id);
    }

    public long count() {
        return doctorRepository.count();
    }

    public long countActive() {
        return doctorRepository.findByStatus("ACTIVE").size();
    }

    // ── Filter methods for messaging ──────────────────────────────────
    public List<String> findDistinctSpecialties() {
        return doctorRepository.findDistinctSpecialties();
    }

    public List<Doctor> findFiltered(String specialty, Long departmentId) {
        boolean hasSpec = specialty != null && !specialty.isBlank();
        boolean hasDept = departmentId != null;

        if (hasSpec && hasDept) {
            return doctorRepository.findBySpecialtyAndDepartmentId(specialty, departmentId);
        } else if (hasSpec) {
            return doctorRepository.findBySpecialty(specialty);
        } else if (hasDept) {
            return doctorRepository.findByDepartmentId(departmentId);
        } else {
            return doctorRepository.findAll();
        }
    }
}

