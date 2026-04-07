package com.smarthealth.service;

import com.smarthealth.model.mongo.SystemLog;
import com.smarthealth.repository.mongo.SystemLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SystemLogService {

    @Autowired
    private SystemLogRepository systemLogRepository;

    public void log(String action, String performedBy, String level) {
        systemLogRepository.save(new SystemLog(action, performedBy, level));
    }

    public void info(String action, String performedBy) {
        log(action, performedBy, "INFO");
    }

    public void warn(String action, String performedBy) {
        log(action, performedBy, "WARN");
    }

    public void error(String action, String performedBy) {
        log(action, performedBy, "ERROR");
    }

    public List<SystemLog> findRecent() {
        return systemLogRepository.findTop50ByOrderByTimestampDesc();
    }

    public List<SystemLog> findAll() {
        return systemLogRepository.findAll();
    }
}
