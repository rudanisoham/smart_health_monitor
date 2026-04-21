package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.model.mongo.HealthMetric;
import com.smarthealth.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/patient")
public class PatientController {

    @Autowired private PatientService patientService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private HealthMetricService healthMetricService;
    @Autowired private NotificationService notificationService;
    @Autowired private DoctorService doctorService;
    @Autowired private UserService userService;
    @Autowired private MedicalReportService medicalReportService;
    @Autowired private SystemLogService systemLogService;
    @Autowired private DoctorReviewService reviewService;
    @Autowired private EmailService emailService;

    @Autowired private AIService aiService;

    private Patient getSessionPatient(HttpSession session) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return null;
        return patientService.findByUserId(user.getId());
    }

    // -- Doctor Profiles & Reviews --

    @GetMapping("/doctor/{id}/profile")
    public String doctorProfile(@PathVariable Long id, HttpSession session, Model model) {
        Doctor doctor = doctorService.findById(id).orElse(null);
        if (doctor == null) return "redirect:/patient/appointments";
        
        model.addAttribute("doctor", doctor);
        model.addAttribute("reviews", reviewService.findByDoctorId(id));
        model.addAttribute("reviewCount", reviewService.getReviewCount(id));
        model.addAttribute("avgRating", reviewService.getAverageRating(id));
        
        return "patient/doctor-profile"; // Needs a jsp page!
    }

    @GetMapping("/reviews/new")
    public String writeReviewForm(@RequestParam Long appointmentId, HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";
        
        Appointment appt = appointmentService.findById(appointmentId).orElse(null);
        if (appt == null || !appt.getPatient().getId().equals(patient.getId()) || !"COMPLETED".equals(appt.getStatus())) {
            return "redirect:/patient/appointments";
        }
        
        model.addAttribute("appointment", appt);
        return "patient/write-review";
    }

    @PostMapping("/reviews/submit")
    public String submitReview(@RequestParam Long appointmentId,
                               @RequestParam Integer rating,
                               @RequestParam String comment,
                               HttpSession session, RedirectAttributes ra) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";

        Appointment appt = appointmentService.findById(appointmentId).orElse(null);
        if (appt == null || !appt.getPatient().getId().equals(patient.getId())) {
            ra.addFlashAttribute("error", "Invalid appointment.");
            return "redirect:/patient/appointments";
        }
        
        DoctorReview review = new DoctorReview();
        review.setAppointment(appt);
        review.setDoctor(appt.getDoctor());
        review.setPatient(patient);
        review.setRating(rating);
        review.setComment(comment);
        
        reviewService.save(review);
        
        ra.addFlashAttribute("success", "Thank you! Your review for Dr. " + appt.getDoctor().getUser().getFullName() + " has been submitted.");
        return "redirect:/patient/doctor/" + appt.getDoctor().getId() + "/profile";
    }
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            model.addAttribute("appointments", appointmentService.findByPatientId(patient.getId()));
            model.addAttribute("prescriptions", prescriptionService.findByPatientId(patient.getId()));
            HealthMetric latest = healthMetricService.findLatestByPatientId(patient.getId());
            model.addAttribute("latestMetric", latest);
            model.addAttribute("unreadCount", notificationService.countUnread(patient.getUser().getId()));
            
            // AI Hint for dashboard
            if (latest != null) {
                model.addAttribute("aiInsight", aiService.getQuickInsight(latest));
            }
        }
        return "patient/dashboard";
    }

    @GetMapping("/health")
    public String health(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            model.addAttribute("metrics", healthMetricService.findByPatientId(patient.getId()));
            HealthMetric latest = healthMetricService.findLatestByPatientId(patient.getId());
            model.addAttribute("latestMetric", latest);
            
            // AI Analysis for health page
            if (latest != null) {
                model.addAttribute("aiInsight", aiService.getQuickInsight(latest));
            }
        }
        return "patient/health";
    }

    @PostMapping("/health/add")
    public String addMetric(@RequestParam(required = false) Integer heartRate,
                            @RequestParam(required = false) Integer bloodPressureSys,
                            @RequestParam(required = false) Integer bloodPressureDia,
                            @RequestParam(required = false) Double spo2,
                            @RequestParam(required = false) Double temperature,
                            @RequestParam(required = false) Double weight,
                            @RequestParam(required = false) Double latitude,
                            @RequestParam(required = false) Double longitude,
                            HttpSession session, RedirectAttributes ra) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";
        HealthMetric m = new HealthMetric();
        m.setPatientId(patient.getId());
        m.setHeartRate(heartRate); m.setBloodPressureSys(bloodPressureSys);
        m.setBloodPressureDia(bloodPressureDia); m.setSpo2(spo2);
        m.setTemperature(temperature); m.setWeight(weight);
        m.setLatitude(latitude); m.setLongitude(longitude);
        
        // Calculate Risk Level
        m.setRiskLevel(calculateRiskLevel(m));
        
        healthMetricService.save(m);
        
        // Use session coordinates as fallback if request coordinates are null
        Double lat = latitude != null ? latitude : (Double) session.getAttribute("loginLatitude");
        Double lng = longitude != null ? longitude : (Double) session.getAttribute("loginLongitude");

        // Emergency Alert System for HIGH risk
        if ("HIGH".equals(m.getRiskLevel())) {
            String alertTitle = "🚨 EMERGENCY: High Risk Patient";
            String displayLocation = (lat != null && lng != null) 
                    ? "Coordinates (" + lat + ", " + lng + ")" 
                    : (patient.getAddress() != null && !patient.getAddress().isBlank() ? patient.getAddress() : "Unknown");

            String alertMsg = "Patient " + (patient.getUser() != null ? patient.getUser().getFullName() : "Unknown") + " has critical vitals! " +
                               "Location: " + displayLocation + ". " +
                               "Please review immediately.";
            
            // 1. Notify all approved doctors
            for (Doctor d : doctorService.findApproved()) {
                notificationService.send(d.getUser().getId(), "DOCTOR", alertTitle, alertMsg, "DANGER");
            }

            // 2. Alert Emergency Contact (Email)
            if (patient.getEmergencyEmail() != null && !patient.getEmergencyEmail().isBlank()) {
                String vitals = "HR=" + heartRate + ", BP=" + bloodPressureSys + "/" + bloodPressureDia + ", SpO2=" + spo2;
                
                String locationLink;
                if (lat != null && lng != null) {
                    locationLink = "https://www.google.com/maps?q=" + lat + "," + lng;
                } else if (patient.getAddress() != null && !patient.getAddress().isBlank()) {
                    try {
                        locationLink = "https://www.google.com/maps?q=" + java.net.URLEncoder.encode(patient.getAddress(), "UTF-8");
                    } catch (java.io.UnsupportedEncodingException e) {
                        locationLink = "https://www.google.com/maps?q=" + patient.getAddress();
                    }
                } else {
                    locationLink = "Unknown";
                }
                
                emailService.sendEmergencyAlert(patient.getEmergencyEmail(), 
                    patient.getUser().getFullName(), vitals, locationLink);
                
                systemLogService.log("EMERGENCY EMAIL SENT", "To: " + patient.getEmergencyEmail(), "CRITICAL");
                notificationService.send(patient.getUser().getId(), "PATIENT", "Emergency Email Sent", 
                    "We have sent an emergency alert email to " + patient.getEmergencyEmail() + " with your health data and location.", "SUCCESS");
            } else {
                systemLogService.log("EMERGENCY ALERT FAILURE", "No emergency email found for patient: " + patient.getId(), "ERROR");
            }
            
            ra.addFlashAttribute("error", "⚠️ CRITICAL STATUS DETECTED: Emergency contacts and medical staff have been notified.");
        } else {
            ra.addFlashAttribute("success", "Health reading saved. Risk Level: " + m.getRiskLevel());
        }

        return "redirect:/patient/health";
    }

    private String calculateRiskLevel(HealthMetric m) {
        int score = 0;
        if (m.getHeartRate() != null) {
            if (m.getHeartRate() > 120 || m.getHeartRate() < 50) score += 3;
            else if (m.getHeartRate() > 100 || m.getHeartRate() < 60) score += 1;
        }
        if (m.getBloodPressureSys() != null) {
            if (m.getBloodPressureSys() > 160 || m.getBloodPressureSys() < 90) score += 3;
            else if (m.getBloodPressureSys() > 140 || m.getBloodPressureSys() < 100) score += 1;
        }
        if (m.getSpo2() != null) {
            if (m.getSpo2() < 90) score += 3;
            else if (m.getSpo2() < 95) score += 1;
        }
        if (m.getTemperature() != null) {
            if (m.getTemperature() > 39.0 || m.getTemperature() < 35.0) score += 3;
            else if (m.getTemperature() > 38.0 || m.getTemperature() < 36.0) score += 1;
        }
        if (score >= 3) return "HIGH";
        if (score >= 1) return "MEDIUM";
        return "LOW";
    }

    @GetMapping("/analytics")
    public String analytics(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            List<HealthMetric> metrics = healthMetricService.findByPatientId(patient.getId());
            model.addAttribute("metrics", metrics);
            HealthMetric latest = healthMetricService.findLatestByPatientId(patient.getId());
            model.addAttribute("latestMetric", latest);
            
            // AI Health Insight for analytics
            if (latest != null) {
                model.addAttribute("aiInsight", aiService.getQuickInsight(latest));
            }
        }
        return "patient/analytics";
    }

    @Autowired private com.smarthealth.repository.mongo.AILogRepository aiLogRepository;

    @GetMapping("/ai")
    public String ai(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            HealthMetric latest = healthMetricService.findLatestByPatientId(patient.getId());
            model.addAttribute("latestMetric", latest);
            
            if (latest != null) {
                model.addAttribute("aiInsight", aiService.getQuickInsight(latest));
            }

            // Fetch AI history
            model.addAttribute("aiLogs", aiLogRepository.findByPatientIdOrderByTimestampDesc(patient.getId()));
        }
        return "patient/ai-checker";
    }

    @GetMapping("/appointments")
    public String appointments(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            model.addAttribute("appointments", appointmentService.findByPatientId(patient.getId()));
            
            List<Doctor> doctors = doctorService.findApproved();
            model.addAttribute("doctors", doctors);
            
            Map<Long, Double> ratings = new java.util.HashMap<>();
            for (Doctor d : doctors) {
                Double avg = reviewService.getAverageRating(d.getId());
                ratings.put(d.getId(), avg != null ? avg : 0.0);
            }
            model.addAttribute("ratings", ratings);
        }
        return "patient/appointments";
    }

    @PostMapping("/appointments/book")
    public String bookAppointment(@RequestParam(required = false) Long doctorId,
                                  @RequestParam(required = false) String preferredDateNote,
                                  @RequestParam(required = false) String preferredDate,
                                  @RequestParam(required = false) String notes,
                                  HttpSession session, RedirectAttributes ra) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";

        Appointment appt = new Appointment();
        appt.setPatient(patient);
        appt.setPreferredDateNote(preferredDateNote);
        appt.setNotes(notes);
        if (doctorId != null) {
            doctorService.findById(doctorId).ifPresent(appt::setDoctor);
        }
        if (preferredDate != null && !preferredDate.isBlank()) {
            try { appt.setPreferredDate(java.time.LocalDate.parse(preferredDate)); } catch (Exception ignored) {}
        }
        appointmentService.book(appt);

        notificationService.send(patient.getUser().getId(), "PATIENT",
                "Appointment Request Submitted",
                "Your appointment request has been received. Our reception team will assign a doctor and confirm your schedule shortly.",
                "INFO");

        ra.addFlashAttribute("success", "Appointment request submitted! Reception will finalize the doctor and confirm your schedule.");
        return "redirect:/patient/appointments";
    }

    @PostMapping("/appointments/{id}/update")
    public String updateAppointment(@PathVariable Long id,
                                    @RequestParam(required = false) Long doctorId,
                                    @RequestParam(required = false) String preferredDate,
                                    @RequestParam(required = false) String preferredDateNote,
                                    @RequestParam(required = false) String notes,
                                    HttpSession session, RedirectAttributes ra) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";

        Appointment appt = appointmentService.findById(id).orElse(null);
        if (appt == null || !appt.getPatient().getId().equals(patient.getId())) {
            ra.addFlashAttribute("error", "Appointment not found.");
            return "redirect:/patient/appointments";
        }

        if (!"AWAITING_ASSIGNMENT".equals(appt.getStatus())) {
            ra.addFlashAttribute("error", "Only pending appointments can be updated.");
            return "redirect:/patient/appointments";
        }

        if (doctorId != null) {
            doctorService.findById(doctorId).ifPresent(appt::setDoctor);
        } else {
            appt.setDoctor(null);
        }
        
        if (preferredDate != null && !preferredDate.isBlank()) {
            try { appt.setPreferredDate(java.time.LocalDate.parse(preferredDate)); } catch (Exception ignored) {}
        }
        
        appt.setPreferredDateNote(preferredDateNote);
        appt.setNotes(notes);
        
        appointmentService.save(appt);
        
        ra.addFlashAttribute("success", "Appointment request updated successfully.");

        return "redirect:/patient/appointments";
    }


    @PostMapping("/appointments/{id}/cancel")
    public String cancelAppointment(@PathVariable Long id, RedirectAttributes ra) {
        appointmentService.cancel(id);
        ra.addFlashAttribute("success", "Appointment cancelled.");
        return "redirect:/patient/appointments";
    }

    @GetMapping("/prescriptions")
    public String prescriptions(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            model.addAttribute("prescriptions", prescriptionService.findByPatientId(patient.getId()));
        }
        return "patient/prescriptions";
    }

    @GetMapping("/prescriptions/{id}")
    public String prescriptionDetail(@PathVariable Long id, HttpSession session, Model model,
                                     org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";
        Prescription rx = prescriptionService.findById(id).orElse(null);
        if (rx == null || !rx.getPatient().getId().equals(patient.getId())) {
            ra.addFlashAttribute("error", "Prescription not found.");
            return "redirect:/patient/prescriptions";
        }
        model.addAttribute("prescription", rx);
        return "patient/prescription-detail";
    }

    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            model.addAttribute("patient", patient);
            model.addAttribute("reports", medicalReportService.findByPatientId(patient.getId()));
        }
        return "patient/reports";
    }

    @GetMapping("/reports/{id}")
    public String reportDetails(@PathVariable Long id, HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";
        
        MedicalReport report = medicalReportService.findById(id).orElse(null);
        if (report != null && report.getPatient().getId().equals(patient.getId())) {
            model.addAttribute("report", report);
        }
        return "patient/report-details";
    }

    @PostMapping("/reports/add")
    public String addReport(@RequestParam String title,
                            @RequestParam String type,
                            @RequestParam(required = false) String description,
                            @RequestParam String results,
                            @RequestParam(required = false) MultipartFile reportFile,
                            HttpSession session, RedirectAttributes ra) {
        Patient patient = getSessionPatient(session);
        if (patient == null) return "redirect:/auth/patient/login";
        
        try {
            MedicalReport report = new MedicalReport();
            report.setPatient(patient);
            report.setTitle(title);
            try {
                report.setType(MedicalReport.ReportType.valueOf(type));
            } catch (Exception e) {
                report.setType(MedicalReport.ReportType.OTHER);
            }
            report.setStatus(MedicalReport.ReportStatus.PENDING);
            report.setDescription(description);
            report.setResults(results);

            if (reportFile != null && !reportFile.isEmpty()) {
                String uploadDir = session.getServletContext().getRealPath("/") + "uploads/reports/";
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String fileName = UUID.randomUUID().toString() + "_" + reportFile.getOriginalFilename();
                Path path = Paths.get(uploadDir + fileName);
                Files.write(path, reportFile.getBytes());
                report.setFilePath("/uploads/reports/" + fileName);
            }
            
            medicalReportService.save(report);
            ra.addFlashAttribute("success", "Medical report added successfully.");
        } catch (IOException e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "Failed to upload file: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "Error saving report: " + e.getMessage());
        }
        
        return "redirect:/patient/reports";
    }

    @GetMapping("/notifications")
    public String notifications(HttpSession session, Model model) {
        User user = (User) session.getAttribute("sessionUser");
        if (user != null) {
            model.addAttribute("notifications", notificationService.findByRecipientId(user.getId()));
            model.addAttribute("unreadCount", notificationService.countUnread(user.getId()));
        }
        return "patient/notifications";
    }

    @PostMapping("/notifications/mark-read")
    public String markAllRead(HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user != null) notificationService.markAllRead(user.getId());
        ra.addFlashAttribute("success", "All notifications read.");
        return "redirect:/patient/notifications";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Patient patient = getSessionPatient(session);
        model.addAttribute("patient", patient);
        return "patient/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String address,
                                @RequestParam(required = false) String bloodGroup,
                                @RequestParam(required = false) String gender,
                                @RequestParam(required = false) String emergencyEmail,
                                HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return "redirect:/auth/patient/login";
        user.setFullName(fullName); user.setPhone(phone);
        userService.update(user);
        Patient patient = getSessionPatient(session);
        if (patient != null) {
            patient.setPhone(phone); patient.setAddress(address);
            patient.setBloodGroup(bloodGroup); patient.setEmergencyEmail(emergencyEmail);
            patient.setGender(gender);
            patientService.update(patient);
        }
        session.setAttribute("sessionUser", userService.findById(user.getId()).orElse(user));
        ra.addFlashAttribute("success", "Profile updated.");
        return "redirect:/patient/profile";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session, Model model) {
        model.addAttribute("user", session.getAttribute("sessionUser"));
        return "patient/settings";
    }

    @PostMapping("/settings/update")
    public String updateSettings(@RequestParam(required = false) String currentPassword,
                                 @RequestParam(required = false) String newPassword,
                                 HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return "redirect:/auth/patient/login";
        if (newPassword != null && !newPassword.isBlank()) {
            if (userService.checkPassword(currentPassword, user.getPassword())) {
                userService.updatePassword(user.getId(), newPassword);
                ra.addFlashAttribute("success", "Password updated.");
            } else {
                ra.addFlashAttribute("error", "Current password is wrong.");
            }
        }
        return "redirect:/patient/settings";
    }
}

