package com.smarthealth.repository.jpa;

import com.smarthealth.model.SiteContent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SiteContentRepository extends JpaRepository<SiteContent, Long> {
    
    // As there will only be one config usually
    Optional<SiteContent> findFirstByOrderByIdAsc();
}
