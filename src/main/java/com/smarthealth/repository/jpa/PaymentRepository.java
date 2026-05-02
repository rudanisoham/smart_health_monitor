package com.smarthealth.repository.jpa;

import com.smarthealth.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByPatientId(Long patientId);
    List<Payment> findByStatus(String status);
    Payment findByRazorpayOrderId(String orderId);
}
