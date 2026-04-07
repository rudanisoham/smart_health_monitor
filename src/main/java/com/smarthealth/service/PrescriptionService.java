package com.smarthealth.service;

import com.smarthealth.model.Prescription;
import com.smarthealth.repository.jpa.PrescriptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class PrescriptionService {

    @Autowired
    private PrescriptionRepository prescriptionRepository;

    public Prescription save(Prescription prescription) {
        return prescriptionRepository.save(prescription);
    }

    public Optional<Prescription> findById(Long id) {
        return prescriptionRepository.findById(id);
    }

    public List<Prescription> findByDoctorId(Long doctorId) {
        return prescriptionRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId);
    }

    public List<Prescription> findByPatientId(Long patientId) {
        return prescriptionRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
    }

    public List<Prescription> findAll() {
        return prescriptionRepository.findAll();
    }

    public void delete(Long id) {
        prescriptionRepository.deleteById(id);
    }
}
