package com.smarthealth.repository.mongo;

import com.smarthealth.model.mongo.HealthMetric;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface HealthMetricRepository extends MongoRepository<HealthMetric, String> {
    List<HealthMetric> findByPatientIdOrderByTimestampDesc(Long patientId);
    HealthMetric findTopByPatientIdOrderByTimestampDesc(Long patientId);
}
