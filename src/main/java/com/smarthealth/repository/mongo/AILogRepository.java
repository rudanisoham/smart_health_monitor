package com.smarthealth.repository.mongo;

import com.smarthealth.model.mongo.AILog;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface AILogRepository extends MongoRepository<AILog, String> {
    List<AILog> findByPatientIdOrderByTimestampDesc(Long patientId);
}
