package com.smarthealth.service;

import com.smarthealth.model.LabRequest;
import com.smarthealth.model.LabTest;
import com.smarthealth.repository.jpa.LabRequestRepository;
import com.smarthealth.repository.jpa.LabTestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class LabService {

    @Autowired private LabTestRepository labTestRepository;
    @Autowired private LabRequestRepository labRequestRepository;

    public List<LabTest> findAllActiveTests() {
        return labTestRepository.findByIsActiveTrue();
    }

    public List<LabTest> findAllTests() {
        return labTestRepository.findAll();
    }

    public Optional<LabTest> findTestById(Long id) {
        return labTestRepository.findById(id);
    }

    public LabTest saveTest(LabTest test) {
        return labTestRepository.save(test);
    }

    public LabRequest saveRequest(LabRequest request) {
        return labRequestRepository.save(request);
    }

    public Optional<LabRequest> findRequestById(Long id) {
        return labRequestRepository.findById(id);
    }

    public List<LabRequest> findRequestsByPatient(Long patientId) {
        return labRequestRepository.findByPatientIdOrderByRequestedAtDesc(patientId);
    }

    public List<LabRequest> findRequestsByDoctor(Long doctorId) {
        return labRequestRepository.findByDoctorIdOrderByRequestedAtDesc(doctorId);
    }

    public List<LabRequest> findActiveRequestsByDoctor(Long doctorId) {
        return labRequestRepository.findByDoctorIdAndStatusInOrderByRequestedAtDesc(doctorId, java.util.Arrays.asList("PENDING", "IN_PROGRESS"));
    }

    public List<LabRequest> findActiveRequests() {
        return labRequestRepository.findByStatusInOrderByRequestedAtDesc(java.util.Arrays.asList("PENDING", "IN_PROGRESS"));
    }

    public List<LabRequest> findHistoryRequests() {
        return labRequestRepository.findByStatusInOrderByRequestedAtDesc(java.util.Arrays.asList("COMPLETED"));
    }

    public List<LabRequest> findByGroupId(String groupId) {
        return labRequestRepository.findByGroupId(groupId);
    }
}
