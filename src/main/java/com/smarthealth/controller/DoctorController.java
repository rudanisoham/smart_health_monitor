package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.service.*;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

    @Autowired private DoctorService doctorService;
    @Autowired private PatientService patientService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private NotificationService notificationService;
    @Autowired private UserService userService;
    @Autowired private HealthMetricService healthMetricService;
    @Autowired private MedicalReportService medicalReportService;
    @Autowired private EmailService emailService;
    @Autowired private MedicineService medicineService;

    private Doctor getSessionDoctor(HttpSession session) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return null;
        return doctorService.findAll().stream()
                .filter(d -> d.getUser().getId().equals(user.getId()))
                .findFirst().orElse(null);
    }

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor != null) {
            model.addAttribute("doctor", doctor);
            model.addAttribute("appointments", appointmentService.findByDoctorId(doctor.getId()));
            model.addAttribute("appointmentCount", appointmentService.countByDoctorId(doctor.getId()));
            model.addAttribute("todayCount", appointmentService.countTodayByDoctorId(doctor.getId()));
            model.addAttribute("unreadCount", notificationService.countUnread(doctor.getUser().getId()));
        }
        return "doctor/dashboard";
    }

    @GetMapping("/patients")
    public String patients(HttpSession session, Model model) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor != null) {
            model.addAttribute("doctor", doctor);
            model.addAttribute("appointments", appointmentService.findByDoctorId(doctor.getId()));
        }
        return "doctor/patient-list";
    }

    @GetMapping("/appointments")
    public String appointments(HttpSession session, Model model) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor != null) {
            model.addAttribute("doctor", doctor);
            model.addAttribute("appointments", appointmentService.findByDoctorId(doctor.getId()));
        }
        return "doctor/appointments";
    }

    @PostMapping("/appointments/{id}/complete")
    public String completeAppointment(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor == null || !doctor.isApproved()) { ra.addFlashAttribute("error", "Action denied. Account not approved."); return "redirect:/doctor/dashboard"; }
        appointmentService.complete(id);
        
        appointmentService.findById(id).ifPresent(appt -> {
            try {
                String reviewLink = "http://localhost:8080" + session.getServletContext().getContextPath() + "/patient/reviews/new?appointmentId=" + id;
                String body = "Dear " + appt.getPatient().getUser().getFullName() + ",\n\n" +
                              "We hope your recent appointment with Dr. " + doctor.getUser().getFullName() + " went well.\n\n" +
                              "Please take a moment to review your experience by clicking the link below:\n" +
                              reviewLink + "\n\n" +
                              "Your feedback helps us improve our healthcare services!\n\n" +
                              "Stay Healthy,\nSmart Health Monitor Team";
                emailService.sendEmail(appt.getPatient().getUser().getEmail(), "How was your appointment? Leave a Review!", body);
            } catch (Exception e) {}
        });

        ra.addFlashAttribute("success", "Appointment marked as completed and review invitation sent.");
        return "redirect:/doctor/appointments";
    }

    @PostMapping("/appointments/{id}/confirm")
    public String confirmAppointment(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor == null || !doctor.isApproved()) { ra.addFlashAttribute("error", "Action denied. Account not approved."); return "redirect:/doctor/dashboard"; }
        appointmentService.confirm(id);
        
        // Send email notification to patient
        appointmentService.findById(id).ifPresent(a -> {
            emailService.sendAppointmentConfirmation(a.getPatient().getUser().getEmail(), 
                a.getPatient().getUser().getFullName(), doctor.getUser().getFullName(), a.getScheduledAt().toString());
        });
        
        ra.addFlashAttribute("success", "Appointment confirmed and notification sent to patient.");
        return "redirect:/doctor/appointments";
    }

    @PostMapping("/appointments/{id}/cancel")
    public String cancelAppointment(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor == null || !doctor.isApproved()) { ra.addFlashAttribute("error", "Action denied. Account not approved."); return "redirect:/doctor/dashboard"; }
        appointmentService.cancel(id);
        ra.addFlashAttribute("success", "Appointment cancelled.");
        return "redirect:/doctor/appointments";
    }

    @GetMapping("/prescriptions")
    public String prescriptions(HttpSession session, Model model) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor != null) {
            model.addAttribute("doctor", doctor);
            model.addAttribute("prescriptions", prescriptionService.findByDoctorId(doctor.getId()));
            model.addAttribute("patients", patientService.findAll());
            model.addAttribute("medicines", medicineService.findAll());
        }
        return "doctor/prescriptions";
    }

    @Autowired private PdfService pdfService;

    @PostMapping("/prescriptions/add")
    public String addPrescription(@RequestParam Long patientId,
                                  @RequestParam String diagnosis,
                                  @RequestParam(required = false) String medicines,
                                  @RequestParam(required = false) String instructions,
                                  @RequestParam(required = false) String notes,
                                  @RequestParam(value="medicineName[]", required=false) String[] medicineNames,
                                  @RequestParam(value="dosage[]", required=false) String[] dosages,
                                  @RequestParam(value="timing[]", required=false) String[] timings,
                                  @RequestParam(value="duration[]", required=false) String[] durations,
                                  @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate validUntil,
                                  HttpSession session, RedirectAttributes ra) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor == null) return "redirect:/auth/doctor/login";
        if (!doctor.isApproved()) {
            ra.addFlashAttribute("error", "You cannot issue prescriptions until your account is approved by admin.");
            return "redirect:/doctor/prescriptions";
        }
        Patient patient = patientService.findById(patientId).orElse(null);
        if (patient == null) { ra.addFlashAttribute("error", "Patient not found."); return "redirect:/doctor/prescriptions"; }

        Prescription p = new Prescription();
        p.setDoctor(doctor); p.setPatient(patient);
        p.setDiagnosis(diagnosis); 
        p.setMedicines(medicines != null ? medicines : "See structured list");
        p.setInstructions(instructions);
        p.setNotes(notes);
        p.setValidUntil(validUntil);
        
        java.util.List<PrescribedMedicine> structuredMedList = new java.util.ArrayList<>();
        if (medicineNames != null) {
            for (int i = 0; i < medicineNames.length; i++) {
                if(medicineNames[i] == null || medicineNames[i].trim().isEmpty()) continue;
                PrescribedMedicine pm = new PrescribedMedicine();
                pm.setPrescription(p);
                pm.setMedicineName(medicineNames[i]);
                pm.setDosage(dosages != null && dosages.length > i ? dosages[i] : "");
                pm.setTiming(timings != null && timings.length > i ? timings[i] : "");
                pm.setDuration(durations != null && durations.length > i ? durations[i] : "");
                structuredMedList.add(pm);
            }
        }
        p.setPrescribedMedicinesList(structuredMedList);
        
        prescriptionService.save(p);

        try {
            byte[] pdf = pdfService.generatePrescriptionPdf(p);
            if (patient.getUser().getEmail() != null) {
                emailService.sendPrescriptionPdf(patient.getUser().getEmail(), patient.getUser().getFullName(), doctor.getUser().getFullName(), pdf);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to generate or send pdf");
        }

        notificationService.send(patient.getUser().getId(), "PATIENT",
                "New Prescription", "Dr. " + doctor.getUser().getFullName() + " issued a prescription.", "INFO");
        ra.addFlashAttribute("success", "Prescription created and sent to patient's email.");
        return "redirect:/doctor/prescriptions";
    }

    @GetMapping("/alerts")
    public String alerts(HttpSession session, Model model) {
        User user = (User) session.getAttribute("sessionUser");
        if (user != null) {
            model.addAttribute("notifications", notificationService.findByRecipientId(user.getId()));
            model.addAttribute("unreadCount", notificationService.countUnread(user.getId()));
        }
        return "doctor/alerts";
    }

    @PostMapping("/alerts/mark-read")
    public String markAllRead(HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user != null) notificationService.markAllRead(user.getId());
        ra.addFlashAttribute("success", "All notifications marked as read.");
        return "redirect:/doctor/alerts";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor != null) {
            model.addAttribute("doctor", doctor);
            model.addAttribute("departments", null);
        }
        return "doctor/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String bio,
                                HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return "redirect:/auth/doctor/login";
        user.setFullName(fullName); user.setPhone(phone);
        userService.update(user);
        Doctor doctor = getSessionDoctor(session);
        if (doctor != null) { doctor.setBio(bio); doctorService.save(doctor); }
        session.setAttribute("sessionUser", userService.findById(user.getId()).orElse(user));
        ra.addFlashAttribute("success", "Profile updated.");
        return "redirect:/doctor/profile";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session, Model model) {
        model.addAttribute("user", session.getAttribute("sessionUser"));
        return "doctor/settings";
    }

    @PostMapping("/settings/update")
    public String updateSettings(@RequestParam(required = false) String currentPassword,
                                 @RequestParam(required = false) String newPassword,
                                 HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return "redirect:/auth/doctor/login";
        if (newPassword != null && !newPassword.isBlank()) {
            if (userService.checkPassword(currentPassword, user.getPassword())) {
                userService.updatePassword(user.getId(), newPassword);
                ra.addFlashAttribute("success", "Password updated.");
            } else {
                ra.addFlashAttribute("error", "Current password wrong.");
            }
        }
        return "redirect:/doctor/settings";
    }

    @GetMapping("/patient/{id}")
    public String patientDetail(@PathVariable Long id, Model model) {
        model.addAttribute("patient", patientService.findById(id).orElse(null));
        model.addAttribute("prescriptions", prescriptionService.findByPatientId(id));
        model.addAttribute("appointments", appointmentService.findByPatientId(id));
        model.addAttribute("metrics", healthMetricService.findByPatientId(id));
        model.addAttribute("reports", medicalReportService.findByPatientId(id));
        return "doctor/patient-details";
    }

    @GetMapping("/reports/{id}")
    public String viewReport(@PathVariable Long id, HttpSession session, Model model) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor == null) return "redirect:/auth/doctor/login";
        
        MedicalReport report = medicalReportService.findById(id).orElse(null);
        if (report != null) {
            model.addAttribute("report", report);
            model.addAttribute("patient", report.getPatient());
            model.addAttribute("doctor", doctor);
        }
        return "doctor/report-view";
    }

    @PostMapping("/reports/{id}/review")
    public String reviewReport(@PathVariable Long id,
                               @RequestParam String status,
                               @RequestParam(required = false) String doctorComments,
                               HttpSession session, RedirectAttributes ra) {
        Doctor doctor = getSessionDoctor(session);
        if (doctor == null) return "redirect:/auth/doctor/login";
        
        MedicalReport report = medicalReportService.findById(id).orElse(null);
        if (report != null) {
            try {
                report.setStatus(MedicalReport.ReportStatus.valueOf(status));
            } catch (Exception e) {}
            report.setDoctorComments(doctorComments);
            medicalReportService.save(report);
            
            // Notify patient via email
            if (report.getPatient().getUser().getEmail() != null) {
                emailService.sendReportUpdate(report.getPatient().getUser().getEmail(), 
                    report.getPatient().getUser().getFullName(), report.getTitle(), report.getStatus().toString());
            }
            notificationService.send(report.getPatient().getUser().getId(), "PATIENT",
                "Report Updated", "Dr. " + doctor.getUser().getFullName() + " has reviewed your report: " + report.getTitle(), "INFO");
            
            ra.addFlashAttribute("success", "Review saved and patient notified.");
        } else {
            ra.addFlashAttribute("error", "Report not found.");
        }
        return "redirect:/doctor/reports/" + id;
    }

    @GetMapping("/diagnosis/add")
    public String addDiagnosis(HttpSession session, Model model) {
        model.addAttribute("patients", patientService.findAll());
        return "doctor/add-diagnosis";
    }

    /** JSON endpoint for medicine autocomplete in prescription form */
    @GetMapping("/medicines/search")
    @ResponseBody
    public java.util.List<com.smarthealth.model.Medicine> searchMedicines(@RequestParam String q) {
        return medicineService.search(q);
    }

    @GetMapping("/prescriptions/{id}")
    public String prescriptionDetail(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes ra) {
        Doctor doctor = getSessionDoctor(session);
        Prescription rx = prescriptionService.findById(id).orElse(null);
        if (rx == null) { ra.addFlashAttribute("error", "Prescription not found."); return "redirect:/doctor/prescriptions"; }
        model.addAttribute("prescription", rx);
        model.addAttribute("doctor", doctor);
        return "doctor/prescription-detail";
    }
}
