package com.smarthealth.service;

import com.smarthealth.model.mongo.Notification;
import com.smarthealth.repository.mongo.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    public Notification send(Long recipientId, String recipientRole, String title, String message, String type) {
        return notificationRepository.save(new Notification(recipientId, recipientRole, title, message, type));
    }

    public List<Notification> findByRecipientId(Long recipientId) {
        return notificationRepository.findByRecipientIdOrderByCreatedAtDesc(recipientId);
    }

    public List<Notification> findUnread(Long recipientId) {
        return notificationRepository.findByRecipientIdAndIsReadFalseOrderByCreatedAtDesc(recipientId);
    }

    public long countUnread(Long recipientId) {
        return notificationRepository.countByRecipientIdAndIsReadFalse(recipientId);
    }

    public void markRead(String id) {
        notificationRepository.findById(id).ifPresent(n -> {
            n.setRead(true);
            notificationRepository.save(n);
        });
    }

    public void markAllRead(Long recipientId) {
        List<Notification> unread = notificationRepository.findByRecipientIdAndIsReadFalseOrderByCreatedAtDesc(recipientId);
        for (Notification n : unread) { n.setRead(true); }
        notificationRepository.saveAll(unread);
    }
}
