package com.smarthealth.service;

import com.smarthealth.model.ContactMessage;
import com.smarthealth.repository.jpa.ContactMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ContactMessageService {

    @Autowired
    private ContactMessageRepository repository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public ContactMessage save(ContactMessage message) {
        message.setStatus("PENDING");
        ContactMessage saved = repository.save(message);
        try {
            emailService.sendContactConfirmation(saved.getEmail(), saved.getFullName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return saved;
    }

    public List<ContactMessage> findAll() {
        return repository.findAllByOrderByCreatedAtDesc();
    }

    public List<ContactMessage> findPending() {
        return repository.findByStatusOrderByCreatedAtDesc("PENDING");
    }

    public Optional<ContactMessage> findById(Long id) {
        return repository.findById(id);
    }

    @Transactional
    public void reply(Long id, String replyText) {
        repository.findById(id).ifPresent(msg -> {
            msg.setAdminReply(replyText);
            msg.setStatus("REPLIED");
            msg.setRepliedAt(LocalDateTime.now());
            repository.save(msg);
            
            try {
                emailService.sendAdminReply(
                    msg.getEmail(), 
                    msg.getFullName(), 
                    msg.getMessage(), 
                    replyText
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    @Transactional
    public void delete(Long id) {
        repository.deleteById(id);
    }
}
