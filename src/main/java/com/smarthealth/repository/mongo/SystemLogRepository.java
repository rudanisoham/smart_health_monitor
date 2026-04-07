package com.smarthealth.repository.mongo;

import com.smarthealth.model.mongo.SystemLog;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface SystemLogRepository extends MongoRepository<SystemLog, String> {
    List<SystemLog> findTop50ByOrderByTimestampDesc();
    List<SystemLog> findByLevel(String level);
}
