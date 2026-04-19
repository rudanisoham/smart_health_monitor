package com.smarthealth.service;

import com.smarthealth.model.AdminMessage;
import com.smarthealth.repository.jpa.AdminMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AdminMessageService {

    @Autowired
    private AdminMessageRepository adminMessageRepository;

    public AdminMessage save(AdminMessage message) {
        return adminMessageRepository.save(message);
    }

    public List<AdminMessage> findAll() {
        return adminMessageRepository.findAllByOrderBySentAtDesc();
    }

    public List<AdminMessage> findRecent() {
        return adminMessageRepository.findTop20ByOrderBySentAtDesc();
    }

    public Optional<AdminMessage> findById(Long id) {
        return adminMessageRepository.findById(id);
    }

    public void delete(Long id) {
        adminMessageRepository.deleteById(id);
    }

    public long count() {
        return adminMessageRepository.count();
    }
}
