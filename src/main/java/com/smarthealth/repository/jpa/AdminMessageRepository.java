package com.smarthealth.repository.jpa;

import com.smarthealth.model.AdminMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AdminMessageRepository extends JpaRepository<AdminMessage, Long> {
    List<AdminMessage> findAllByOrderBySentAtDesc();
    List<AdminMessage> findTop20ByOrderBySentAtDesc();
}
