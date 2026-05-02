package com.smarthealth.repository.jpa;

import com.smarthealth.model.LabRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LabRequestRepository extends JpaRepository<LabRequest, Long> {
    List<LabRequest> findByPatientIdOrderByRequestedAtDesc(Long patientId);
    List<LabRequest> findByDoctorIdOrderByRequestedAtDesc(Long doctorId);
    List<LabRequest> findAllByOrderByRequestedAtDesc();
    
    // Status-based filters
    List<LabRequest> findByStatusInOrderByRequestedAtDesc(java.util.List<String> statuses);
    List<LabRequest> findByPatientIdAndStatusOrderByRequestedAtDesc(Long patientId, String status);
    List<LabRequest> findByDoctorIdAndStatusInOrderByRequestedAtDesc(Long doctorId, java.util.List<String> statuses);
    List<LabRequest> findByGroupId(String groupId);
}
