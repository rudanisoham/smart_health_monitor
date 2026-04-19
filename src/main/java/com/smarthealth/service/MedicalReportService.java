package com.smarthealth.service;

import com.smarthealth.model.MedicalReport;
import com.smarthealth.repository.jpa.MedicalReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MedicalReportService {

    @Autowired
    private MedicalReportRepository medicalReportRepository;

    public List<MedicalReport> findByPatientId(Long patientId) {
        return medicalReportRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
    }

    public MedicalReport save(MedicalReport report) {
        return medicalReportRepository.save(report);
    }

    public Optional<MedicalReport> findById(Long id) {
        return medicalReportRepository.findById(id);
    }

    public void delete(Long id) {
        medicalReportRepository.deleteById(id);
    }

    public List<MedicalReport> findAll() {
        return medicalReportRepository.findAllByOrderByCreatedAtDesc();
    }

    public List<MedicalReport> findPending() {
        return medicalReportRepository.findByStatusOrderByCreatedAtDesc(MedicalReport.ReportStatus.PENDING);
    }

    public long count() {
        return medicalReportRepository.count();
    }
}
