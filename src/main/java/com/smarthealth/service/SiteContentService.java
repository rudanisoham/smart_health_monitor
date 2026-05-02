package com.smarthealth.service;

import com.smarthealth.model.SiteContent;
import com.smarthealth.repository.jpa.SiteContentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class SiteContentService {

    @Autowired
    private SiteContentRepository repository;

    public SiteContent getSiteContent() {
        return repository.findFirstByOrderByIdAsc().orElseGet(() -> {
            SiteContent defaultContent = new SiteContent();
            defaultContent.setProjectTitle("Smart Health Monitor");
            defaultContent.setTagline("Advanced Health Tracking & Doctor Consultations");
            defaultContent.setAboutDescription("Smart Health Monitor is a comprehensive healthcare platform connecting patients with doctors effortlessly.");
            defaultContent.setContactEmail("support@smarthealth.com");
            defaultContent.setContactPhone("+1 234 567 8900");
            defaultContent.setAddress("123 Healthcare Ave, Medical District");
            return repository.save(defaultContent);
        });
    }

    public SiteContent save(SiteContent content) {
        return repository.save(content);
    }
}
