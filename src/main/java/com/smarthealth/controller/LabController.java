package com.smarthealth.controller;

import com.smarthealth.model.LabRequest;
import com.smarthealth.model.LabTest;
import com.smarthealth.model.Role;
import com.smarthealth.model.User;
import com.smarthealth.service.LabService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/lab")
public class LabController {

    @Autowired private LabService labService;

    private boolean checkAccess(HttpSession session) {
        User u = (User) session.getAttribute("sessionUser");
        return u != null && (u.getRole() == Role.LAB_STAFF || u.getRole() == Role.ADMIN);
    }

    @Autowired private com.smarthealth.service.PaymentService paymentService;
    @Autowired private com.smarthealth.service.EmailService emailService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!checkAccess(session)) return "redirect:/auth/login"; 
        
        java.util.List<LabRequest> allActive = labService.findActiveRequests();
        java.util.Map<String, java.util.List<LabRequest>> grouped = allActive.stream()
            .collect(java.util.stream.Collectors.groupingBy(
                r -> r.getGroupId() != null ? r.getGroupId() : "single-" + r.getId(),
                java.util.LinkedHashMap::new,
                java.util.stream.Collectors.toList()
            ));
            
        model.addAttribute("groupedRequests", grouped);
        return "lab/dashboard";
    }

    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        if (!checkAccess(session)) return "redirect:/auth/login";
        
        java.util.List<LabRequest> allHistory = labService.findHistoryRequests();
        java.util.Map<String, java.util.List<LabRequest>> grouped = allHistory.stream()
            .collect(java.util.stream.Collectors.groupingBy(
                r -> r.getGroupId() != null ? r.getGroupId() : "single-" + r.getId(),
                java.util.LinkedHashMap::new,
                java.util.stream.Collectors.toList()
            ));
            
        model.addAttribute("groupedHistory", grouped);
        return "lab/history";
    }

    @PostMapping("/requests/{id}/update")
    public String updateRequest(@PathVariable Long id,
                                @RequestParam String status,
                                @RequestParam(required = false) String resultNotes,
                                @RequestParam(required = false) org.springframework.web.multipart.MultipartFile resultFile,
                                HttpSession session, RedirectAttributes ra) {
        if (!checkAccess(session)) return "redirect:/auth/login";
        
        LabRequest req = labService.findRequestById(id).orElse(null);
        if (req != null) {
            String oldStatus = req.getStatus().name();
            req.setStatus(LabRequest.RequestStatus.valueOf(status));
            if (resultNotes != null && !resultNotes.isBlank()) {
                req.setResultNotes(resultNotes);
            }
            
            if (resultFile != null && !resultFile.isEmpty()) {
                try {
                    String uploadDir = session.getServletContext().getRealPath("/") + "uploads/lab_reports/";
                    java.io.File dir = new java.io.File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();

                    String fileName = java.util.UUID.randomUUID().toString() + "_" + resultFile.getOriginalFilename();
                    java.nio.file.Path path = java.nio.file.Paths.get(uploadDir + fileName);
                    java.nio.file.Files.write(path, resultFile.getBytes());
                    req.setResultFileUrl("/uploads/lab_reports/" + fileName);
                } catch (java.io.IOException e) {
                    ra.addFlashAttribute("error", "File upload failed: " + e.getMessage());
                    return "redirect:/lab/dashboard";
                }
            }

            if (req.getStatus() == LabRequest.RequestStatus.COMPLETED) {
                req.setCompletedAt(java.time.LocalDateTime.now());
            }
            
            labService.saveRequest(req);

            // Check for group status and billing
            if (req.getStatus() == LabRequest.RequestStatus.COMPLETED && req.getGroupId() != null) {
                java.util.List<LabRequest> group = labService.findByGroupId(req.getGroupId());
                boolean allDone = group.stream().allMatch(r -> r.getStatus() == LabRequest.RequestStatus.COMPLETED);
                
                if (allDone) {
                    // Generate ONE payment for the whole group
                    double totalAmount = group.stream().mapToDouble(r -> r.getLabTest().getPrice()).sum();
                    String testsList = group.stream().map(r -> r.getLabTest().getName()).collect(java.util.stream.Collectors.joining(", "));
                    
                    com.smarthealth.model.Payment payment = new com.smarthealth.model.Payment();
                    payment.setPatient(req.getPatient());
                    payment.setAmount(totalAmount);
                    payment.setType("LAB_GROUP");
                    payment.setMethod("PENDING");
                    payment.setStatus("PENDING");
                    payment.setDescription("Group Lab Diagnostics: " + testsList);
                    paymentService.save(payment);
                    
                    // Send Group Email
                    emailService.sendLabReportCompletedEmail(req.getPatient().getUser().getEmail(), 
                            req.getPatient().getUser().getFullName(), "Group Report: " + testsList);
                    emailService.sendPaymentInvoiceEmail(req.getPatient().getUser().getEmail(), 
                            req.getPatient().getUser().getFullName(), payment);
                    
                    ra.addFlashAttribute("success", "Group results completed. Consolidated billing and notifications sent.");
                } else {
                    ra.addFlashAttribute("success", "Individual report updated. Awaiting other tests in the group for final billing.");
                }
            } else if (req.getStatus() == LabRequest.RequestStatus.COMPLETED) {
                // Single request logic (no groupId)
                com.smarthealth.model.Payment payment = new com.smarthealth.model.Payment();
                payment.setPatient(req.getPatient());
                payment.setAmount(req.getLabTest().getPrice());
                payment.setType("LAB");
                payment.setMethod("PENDING");
                payment.setStatus("PENDING");
                payment.setDescription("Lab Diagnostic: " + req.getLabTest().getName());
                paymentService.save(payment);
                
                emailService.sendLabReportCompletedEmail(req.getPatient().getUser().getEmail(), 
                        req.getPatient().getUser().getFullName(), req.getLabTest().getName());
                emailService.sendPaymentInvoiceEmail(req.getPatient().getUser().getEmail(), 
                        req.getPatient().getUser().getFullName(), payment);
                ra.addFlashAttribute("success", "Lab report completed and billing generated.");
            } else if (req.getStatus() == LabRequest.RequestStatus.IN_PROGRESS && !"IN_PROGRESS".equals(oldStatus)) {
                emailService.sendLabRequestProcessingEmail(req.getPatient().getUser().getEmail(), 
                        req.getPatient().getUser().getFullName(), req.getLabTest().getName());
                ra.addFlashAttribute("success", "Request status updated to IN_PROGRESS.");
            }
        }
        return "COMPLETED".equals(status) ? "redirect:/lab/history" : "redirect:/lab/dashboard";
    }

    @PostMapping("/requests/group/{groupId}/update")
    public String updateGroupRequest(@PathVariable String groupId,
                                     @RequestParam String status,
                                     @RequestParam(required = false) String resultNotes,
                                     @RequestParam(required = false) org.springframework.web.multipart.MultipartFile resultFile,
                                     HttpSession session, RedirectAttributes ra) {
        if (!checkAccess(session)) return "redirect:/auth/login";
        
        java.util.List<LabRequest> group = labService.findByGroupId(groupId);
        if (group.isEmpty()) {
            ra.addFlashAttribute("error", "Group not found.");
            return "redirect:/lab/dashboard";
        }
        
        String fileUrl = null;
        if (resultFile != null && !resultFile.isEmpty()) {
            try {
                String uploadDir = session.getServletContext().getRealPath("/") + "uploads/lab_reports/";
                java.io.File dir = new java.io.File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String fileName = java.util.UUID.randomUUID().toString() + "_" + resultFile.getOriginalFilename();
                java.nio.file.Path path = java.nio.file.Paths.get(uploadDir + fileName);
                java.nio.file.Files.write(path, resultFile.getBytes());
                fileUrl = "/uploads/lab_reports/" + fileName;
            } catch (java.io.IOException e) {
                ra.addFlashAttribute("error", "File upload failed: " + e.getMessage());
                return "redirect:/lab/dashboard";
            }
        }
        
        LabRequest.RequestStatus newStatus = LabRequest.RequestStatus.valueOf(status);
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        
        for (LabRequest req : group) {
            req.setStatus(newStatus);
            if (resultNotes != null) req.setResultNotes(resultNotes);
            if (fileUrl != null) req.setResultFileUrl(fileUrl);
            if (newStatus == LabRequest.RequestStatus.COMPLETED) {
                req.setCompletedAt(now);
            }
            labService.saveRequest(req);
        }
        
        if (newStatus == LabRequest.RequestStatus.COMPLETED) {
            LabRequest first = group.get(0);
            double totalAmount = group.stream().mapToDouble(r -> r.getLabTest().getPrice()).sum();
            String testsList = group.stream().map(r -> r.getLabTest().getName()).collect(java.util.stream.Collectors.joining(", "));
            
            com.smarthealth.model.Payment payment = new com.smarthealth.model.Payment();
            payment.setPatient(first.getPatient());
            payment.setAmount(totalAmount);
            payment.setType("LAB_GROUP");
            payment.setMethod("PENDING");
            payment.setStatus("PENDING");
            payment.setDescription("Diagnostic Session: " + testsList);
            paymentService.save(payment);
            
            emailService.sendLabReportCompletedEmail(first.getPatient().getUser().getEmail(), 
                    first.getPatient().getUser().getFullName(), "Group Report: " + testsList);
            emailService.sendPaymentInvoiceEmail(first.getPatient().getUser().getEmail(), 
                    first.getPatient().getUser().getFullName(), payment);
            
            ra.addFlashAttribute("success", "Group report finalized. Billing and notifications sent.");
            return "redirect:/lab/history";
        }
        
        ra.addFlashAttribute("success", "Group status updated to " + status + ".");
        return "redirect:/lab/dashboard";
    }

    // ── Lab Test Catalog Management ───────────────────────────────────────

    @GetMapping("/tests")
    public String viewTests(HttpSession session, Model model) {
        if (!checkAccess(session)) return "redirect:/auth/login";
        model.addAttribute("labTests", labService.findAllTests());
        return "lab/tests";
    }

    @PostMapping("/tests/add")
    public String addTest(@RequestParam String name,
                          @RequestParam(required = false) String description,
                          @RequestParam Double price,
                          HttpSession session, RedirectAttributes ra) {
        if (!checkAccess(session)) return "redirect:/auth/login";
        
        LabTest test = new LabTest();
        test.setName(name);
        test.setDescription(description);
        test.setPrice(price);
        test.setActive(true);
        labService.saveTest(test);
        
        ra.addFlashAttribute("success", "Lab test '" + name + "' added successfully.");
        return "redirect:/lab/tests";
    }
}
