package com.smarthealth.service;

import com.smarthealth.config.EnvConfig;
import com.smarthealth.model.Patient;
import com.smarthealth.model.Payment;
import com.smarthealth.repository.jpa.BedRepository;
import com.smarthealth.repository.jpa.PaymentRepository;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class PaymentService {

    @Autowired private PaymentRepository paymentRepository;
    @Autowired private BedRepository bedRepository;
    @Autowired private EmailService emailService;

    public Payment save(Payment payment) {
        return paymentRepository.save(payment);
    }

    private RazorpayClient getClient() throws RazorpayException {
        String keyId = EnvConfig.get("RAZORPAY_KEY_ID");
        String keySecret = EnvConfig.get("RAZORPAY_KEY_SECRET");
        
        if (keyId == null || keyId.trim().isEmpty() || keySecret == null || keySecret.trim().isEmpty()) {
            System.err.println("[Razorpay] ERROR: Key ID or Secret is MISSING from environment (.env)");
            throw new RazorpayException("Razorpay credentials are not configured in .env file.");
        }

        // Diagnostic log (masked for security)
        String maskedId = keyId.length() > 8 ? keyId.substring(0, 8) + "..." : "invalid-id";
        System.out.println("[Razorpay] Initializing with Key ID: " + maskedId);
        
        return new RazorpayClient(keyId, keySecret);
    }

    public Payment createRazorpayOrder(Patient patient, double amount, String type, String description) throws RazorpayException {
        RazorpayClient client = getClient();
        
        JSONObject orderRequest = new JSONObject();
        orderRequest.put("amount", (int)(amount * 100)); // amount in paise
        orderRequest.put("currency", "INR");
        orderRequest.put("receipt", "txn_" + System.currentTimeMillis());
        
        Order order = client.orders.create(orderRequest);
        
        Payment payment = new Payment();
        payment.setPatient(patient);
        payment.setAmount(amount);
        payment.setType(type);
        payment.setMethod("RAZORPAY");
        payment.setStatus("PENDING");
        payment.setRazorpayOrderId(order.get("id"));
        payment.setDescription(description);
        
        return paymentRepository.save(payment);
    }

    public Payment verifyAndCompletePayment(String orderId, String paymentId, String signature) {
        // In a real app, you'd verify the signature here using Razorpay SDK
        Payment payment = paymentRepository.findByRazorpayOrderId(orderId);
        if (payment != null) {
            payment.setRazorpayPaymentId(paymentId);
            payment.setStatus("COMPLETED");
            payment = paymentRepository.save(payment);
            
            // Send email invoice asynchronously (fire-and-forget for now, though it's sync here)
            try {
                emailService.sendPaymentInvoiceEmail(payment.getPatient().getUser().getEmail(), payment.getPatient().getUser().getFullName(), payment);
            } catch (Exception e) {
                System.err.println("Failed to send invoice email: " + e.getMessage());
            }
            return payment;
        }
        return null;
    }

    public Payment recordCashPayment(Patient patient, double amount, String type, String description) {
        Payment payment = new Payment();
        payment.setPatient(patient);
        payment.setAmount(amount);
        payment.setType(type);
        payment.setMethod("CASH");
        payment.setStatus("COMPLETED");
        payment.setDescription(description);
        
        payment = paymentRepository.save(payment);
        try {
            emailService.sendPaymentInvoiceEmail(patient.getUser().getEmail(), patient.getUser().getFullName(), payment);
        } catch (Exception e) {
            System.err.println("Failed to send invoice email: " + e.getMessage());
        }
        return payment;
    }

    public Payment recordRefund(Patient patient, double amount, String description) {
        Payment payment = new Payment();
        payment.setPatient(patient);
        payment.setAmount(-Math.abs(amount)); // Force negative for refund
        payment.setType("BED");
        payment.setMethod("CASH");
        payment.setStatus("COMPLETED");
        payment.setDescription("REFUND: " + description);
        
        payment = paymentRepository.save(payment);
        try {
            emailService.sendPaymentInvoiceEmail(patient.getUser().getEmail(), patient.getUser().getFullName(), payment);
        } catch (Exception e) {
            System.err.println("Failed to send invoice email: " + e.getMessage());
        }
        return payment;
    }

    public double getTotalPaidForBed(Long patientId) {
        return paymentRepository.findByPatientId(patientId).stream()
                .filter(p -> "BED".equals(p.getType()) && "COMPLETED".equals(p.getStatus()))
                .mapToDouble(Payment::getAmount)
                .sum();
    }

    public Payment payPendingInCash(Long paymentId) {
        Payment p = paymentRepository.findById(paymentId).orElse(null);
        if (p != null && "PENDING".equals(p.getStatus())) {
            p.setMethod("CASH");
            p.setStatus("COMPLETED");
            p = paymentRepository.save(p);
            try {
                emailService.sendPaymentInvoiceEmail(p.getPatient().getUser().getEmail(), p.getPatient().getUser().getFullName(), p);
            } catch (Exception e) {}
        }
        return p;
    }

    @Autowired private com.smarthealth.service.LabService labService;
    @Autowired private com.smarthealth.repository.jpa.BedStayRepository bedStayRepository;

    public java.util.Map<String, Object> getBillingSummary(Long patientId) {
        java.util.Map<String, Object> summary = new java.util.HashMap<>();
        
        // 1. Bed Charges
        double historicalBedCost = bedStayRepository.findByPatientId(patientId).stream()
                .filter(s -> s.getReleasedAt() != null)
                .mapToDouble(s -> s.getFinalBill() != null ? s.getFinalBill() : 0.0)
                .sum();
        
        double currentBedCost = 0.0;
        com.smarthealth.model.Bed currentBed = bedRepository.findByPatientId(patientId).stream().findFirst().orElse(null);
        if (currentBed != null) {
            currentBedCost = calculateCurrentStayCost(currentBed);
            summary.put("currentBed", currentBed);
        }
        double totalBedCost = historicalBedCost + currentBedCost;
        
        // 2. Lab Charges
        List<com.smarthealth.model.LabRequest> labRequests = labService.findRequestsByPatient(patientId);
        double totalLabCost = labRequests.stream()
                .mapToDouble(r -> r.getLabTest().getPrice())
                .sum();
        
        // 3. Payments
        double totalPaid = paymentRepository.findByPatientId(patientId).stream()
                .filter(p -> "COMPLETED".equals(p.getStatus()))
                .mapToDouble(com.smarthealth.model.Payment::getAmount)
                .sum();
        
        double grandTotal = totalBedCost + totalLabCost;
        double balance = grandTotal - totalPaid;
        
        summary.put("totalBedCost", totalBedCost);
        summary.put("totalLabCost", totalLabCost);
        summary.put("labRequests", labRequests);
        summary.put("grandTotal", grandTotal);
        summary.put("totalPaid", totalPaid);
        summary.put("balance", balance);
        summary.put("payments", paymentRepository.findByPatientId(patientId));
        
        return summary;
    }

    private double calculateCurrentStayCost(com.smarthealth.model.Bed bed) {
        if (bed.getAssignedAt() == null) return 0;
        java.time.Duration duration = java.time.Duration.between(bed.getAssignedAt(), java.time.LocalDateTime.now());
        long minutes = Math.max(0, duration.toMinutes());
        long days = (minutes / 1440) + 1;
        return days * (bed.getDailyCharge() != null ? bed.getDailyCharge() : 500.0);
    }

    public List<Payment> findByPatientId(Long patientId) {
        return paymentRepository.findByPatientId(patientId);
    }
}
