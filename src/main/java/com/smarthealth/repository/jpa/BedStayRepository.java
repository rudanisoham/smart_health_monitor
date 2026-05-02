package com.smarthealth.repository.jpa;

import com.smarthealth.model.BedStay;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BedStayRepository extends JpaRepository<BedStay, Long> {
    List<BedStay> findByPatientId(Long patientId);
    List<BedStay> findByPatientIdOrderByAssignedAtDesc(Long patientId);
    
    // Find the most recent active (not released) stay for a patient
    Optional<BedStay> findFirstByPatientIdAndReleasedAtIsNull(Long patientId);
    
    // Find the most recent released but not settled stay
    Optional<BedStay> findFirstByPatientIdAndReleasedAtIsNotNullAndSettledFalseOrderByReleasedAtDesc(Long patientId);
}
