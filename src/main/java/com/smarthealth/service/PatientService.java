package com.smarthealth.service;

import com.smarthealth.model.Patient;
import com.smarthealth.repository.jpa.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    public Patient save(Patient patient) {
        return patientRepository.save(patient);
    }

    public Optional<Patient> findById(Long id) {
        return patientRepository.findById(id);
    }

    public Patient findByUserId(Long userId) {
        return patientRepository.findByUserId(userId);
    }

    public List<Patient> findAll() {
        return patientRepository.findAll();
    }

    public Patient update(Patient patient) {
        return patientRepository.save(patient);
    }

    public void delete(Long id) {
        patientRepository.deleteById(id);
    }

    public long count() {
        return patientRepository.count();
    }
}
