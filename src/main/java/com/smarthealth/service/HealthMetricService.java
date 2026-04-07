package com.smarthealth.service;

import com.smarthealth.model.mongo.HealthMetric;
import com.smarthealth.repository.mongo.HealthMetricRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HealthMetricService {

    @Autowired
    private HealthMetricRepository healthMetricRepository;

    public HealthMetric save(HealthMetric metric) {
        return healthMetricRepository.save(metric);
    }

    public List<HealthMetric> findByPatientId(Long patientId) {
        return healthMetricRepository.findByPatientIdOrderByTimestampDesc(patientId);
    }

    public HealthMetric findLatestByPatientId(Long patientId) {
        return healthMetricRepository.findTopByPatientIdOrderByTimestampDesc(patientId);
    }
}
