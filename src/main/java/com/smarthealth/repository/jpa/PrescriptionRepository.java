package com.smarthealth.repository.jpa;

import com.smarthealth.model.Prescription;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PrescriptionRepository extends JpaRepository<Prescription, Long> {
    List<Prescription> findByDoctorIdOrderByCreatedAtDesc(Long doctorId);
    List<Prescription> findByPatientIdOrderByCreatedAtDesc(Long patientId);
}
