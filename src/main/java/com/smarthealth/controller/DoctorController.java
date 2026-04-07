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
        ra.addFlashAttribute("success", "Appointment marked as completed.");
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
        }
        return "doctor/prescriptions";
    }

    @PostMapping("/prescriptions/add")
    public String addPrescription(@RequestParam Long patientId,
                                  @RequestParam String diagnosis,
                                  @RequestParam String medicines,
                                  @RequestParam(required = false) String instructions,
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
        p.setDiagnosis(diagnosis); p.setMedicines(medicines);
        p.setInstructions(instructions);
        p.setValidUntil(validUntil);
        prescriptionService.save(p);

        notificationService.send(patient.getUser().getId(), "PATIENT",
                "New Prescription", "Dr. " + doctor.getUser().getFullName() + " issued a prescription.", "INFO");
        ra.addFlashAttribute("success", "Prescription created.");
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

    @GetMapping("/diagnosis/add")
    public String addDiagnosis(HttpSession session, Model model) {
        model.addAttribute("patients", patientService.findAll());
        return "doctor/add-diagnosis";
    }
}
