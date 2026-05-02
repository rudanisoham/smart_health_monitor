package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.service.*;
import com.smarthealth.repository.jpa.BedRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/reception")
public class ReceptionController {

    @Autowired private AppointmentService appointmentService;
    @Autowired private DoctorService doctorService;
    @Autowired private PatientService patientService;
    @Autowired private DepartmentService departmentService;
    @Autowired private BedService bedService;
    @Autowired private NotificationService notificationService;
    @Autowired private EmailService emailService;
    @Autowired private SystemLogService logService;
    @Autowired private UserService userService;
    @Autowired private PaymentService paymentService;
    @Autowired private BedRepository bedRepository;
    @Autowired private com.smarthealth.repository.jpa.BedStayRepository bedStayRepository;

    @GetMapping("/patient/{id}/billing")
    public String patientBilling(@PathVariable Long id, Model model, RedirectAttributes ra) {
        Patient patient = patientService.findById(id).orElse(null);
        if (patient == null) {
            ra.addFlashAttribute("error", "Patient not found.");
            return "redirect:/reception/patients";
        }

        java.util.Map<String, Object> summary = paymentService.getBillingSummary(id);
        model.addAllAttributes(summary);
        model.addAttribute("patient", patient);
        
        return "reception/patient-billing";
    }

    @PostMapping("/patient/{id}/pay-cash")
    public String recordCashPayment(@PathVariable Long id, @RequestParam Double amount, 
                                    @RequestParam String description, RedirectAttributes ra) {
        Patient patient = patientService.findById(id).orElse(null);
        if (patient == null) return "redirect:/reception/patients";
        
        paymentService.recordCashPayment(patient, amount, "MANUAL_SETTLEMENT", description);
        ra.addFlashAttribute("success", "Cash payment of ₹" + amount + " recorded for " + patient.getUser().getFullName());
        return "redirect:/reception/patient/" + id + "/billing";
    }

    @PostMapping("/patient/{id}/settle")
    public String settleStay(@PathVariable Long id, @RequestParam Long stayId, RedirectAttributes ra) {
        com.smarthealth.model.BedStay stay = bedStayRepository.findById(stayId).orElse(null);
        if (stay != null) {
            stay.setSettled(true);
            bedStayRepository.save(stay);
            ra.addFlashAttribute("success", "Stay history settled and archived.");
        }
        return "redirect:/reception/patient/" + id + "/billing";
    }

    @PostMapping("/patient/{id}/refund")
    public String refundPayment(@PathVariable Long id, @RequestParam Double amount, 
                                @RequestParam String description, RedirectAttributes ra) {
        Patient patient = patientService.findById(id).orElse(null);
        if (patient == null) return "redirect:/reception/patients";
        
        paymentService.recordRefund(patient, amount, description);
        ra.addFlashAttribute("success", "Refund of ₹" + amount + " processed for " + patient.getUser().getFullName());
        return "redirect:/reception/patient/" + id + "/billing";
    }

    @PostMapping("/payments/{paymentId}/pay-cash")
    public String completePendingPayment(@PathVariable Long paymentId, @RequestParam Long patientId, RedirectAttributes ra) {
        paymentService.payPendingInCash(paymentId);
        ra.addFlashAttribute("success", "Payment record #" + paymentId + " marked as COMPLETED (CASH).");
        return "redirect:/reception/patient/" + patientId + "/billing";
    }

    @GetMapping("/patients/search")
    public String searchPatients(@RequestParam(required = false) String query, Model model) {
        java.util.List<Patient> patients;
        if (query != null && !query.isBlank()) {
            patients = patientService.findAll().stream()
                .filter(p -> p.getUser().getFullName().toLowerCase().contains(query.toLowerCase()) || 
                             p.getUser().getEmail().toLowerCase().contains(query.toLowerCase()))
                .toList();
        } else {
            patients = patientService.findAll();
        }
        
        java.util.Map<Long, com.smarthealth.model.Bed> bedMap = new java.util.HashMap<>();
        for (Patient p : patients) {
            List<com.smarthealth.model.Bed> beds = bedRepository.findByPatientId(p.getId());
            if (!beds.isEmpty()) {
                bedMap.put(p.getId(), beds.get(0));
            }
        }
        
        model.addAttribute("patients", patients);
        model.addAttribute("bedMap", bedMap);
        model.addAttribute("searchQuery", query);
        return "reception/patients";
    }

    // ── Dashboard ─────────────────────────────────────────────────────────
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model) {
        model.addAttribute("pendingQueue", appointmentService.findAwaitingAssignment());
        model.addAttribute("pendingCount", appointmentService.countAwaitingAssignment());
        model.addAttribute("totalAppointments", appointmentService.count());
        
        long todayCount = doctorService.findAll().stream()
                .mapToLong(d -> appointmentService.countTodayByDoctorId(d.getId()))
                .sum();
        model.addAttribute("todayAppointments", todayCount);
        
        model.addAttribute("departments", departmentService.findAll());
        model.addAttribute("totalPatients", patientService.count());
        return "reception/dashboard";
    }

    // ── Appointment Queue ─────────────────────────────────────────────────
    @GetMapping("/appointments")
    public String appointments(Model model) {
        model.addAttribute("pendingQueue", appointmentService.findAwaitingAssignment());
        model.addAttribute("allAppointments", appointmentService.findAll());
        model.addAttribute("doctors", doctorService.findApproved().stream()
                .filter(d -> "ACTIVE".equals(d.getStatus())).toList());
        model.addAttribute("departments", departmentService.findAll());
        model.addAttribute("specialties", doctorService.findDistinctSpecialties());
        return "reception/appointments";
    }

    /** Show assign form for a specific appointment */
    @GetMapping("/appointments/{id}/assign")
    public String showAssignForm(@PathVariable Long id, Model model, RedirectAttributes ra) {
        Appointment appt = appointmentService.findById(id).orElse(null);
        if (appt == null) {
            ra.addFlashAttribute("error", "Appointment not found.");
            return "redirect:/reception/appointments";
        }
        model.addAttribute("appointment", appt);
        List<Doctor> activeDoctors = doctorService.findApproved().stream()
                .filter(d -> "ACTIVE".equals(d.getStatus())).toList();
        model.addAttribute("doctors", activeDoctors);
        model.addAttribute("departments", departmentService.findAll());
        model.addAttribute("specialties", doctorService.findDistinctSpecialties());

        // Pre-load schedule for each doctor on the patient's preferred date (or today)
        java.time.LocalDate targetDate = appt.getPreferredDate() != null
                ? appt.getPreferredDate()
                : java.time.LocalDate.now();
        model.addAttribute("targetDate", targetDate.toString());

        java.util.Map<Long, java.util.List<Appointment>> scheduleMap = new java.util.HashMap<>();
        for (com.smarthealth.model.Doctor doc : activeDoctors) {
            scheduleMap.put(doc.getId(), appointmentService.findByDoctorIdAndDate(doc.getId(), targetDate));
        }
        model.addAttribute("scheduleMap", scheduleMap);
        return "reception/assign-appointment";
    }

    /** Reception assigns doctor + date/time */
    @PostMapping("/appointments/{id}/assign")
    public String assignAppointment(@PathVariable Long id,
                                    @RequestParam Long doctorId,
                                    @RequestParam String scheduledAt,
                                    HttpSession session,
                                    RedirectAttributes ra) {
        Appointment appt = appointmentService.findById(id).orElse(null);
        if (appt == null) {
            ra.addFlashAttribute("error", "Appointment not found.");
            return "redirect:/reception/appointments";
        }

        com.smarthealth.model.Doctor doctor = doctorService.findById(doctorId).orElse(null);
        if (doctor == null) {
            ra.addFlashAttribute("error", "Selected doctor not found.");
            return "redirect:/reception/appointments/" + id + "/assign";
        }

        java.time.LocalDateTime dt;
        try {
            String s = scheduledAt.length() == 16 ? scheduledAt + ":00" : scheduledAt;
            dt = java.time.LocalDateTime.parse(s);
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Invalid date/time format.");
            return "redirect:/reception/appointments/" + id + "/assign";
        }

        Appointment saved = appointmentService.assignByReception(id, doctor, dt);

        // Notify patient
        notificationService.send(appt.getPatient().getUser().getId(), "PATIENT",
                "Appointment Assigned — Token #" + saved.getTokenNumber(),
                "Your appointment has been assigned to Dr. " + doctor.getUser().getFullName() +
                " on " + dt.toString().replace("T", " ").substring(0, 16) +
                ". Your token number is #" + saved.getTokenNumber() +
                ". Estimated time: " + saved.getEstimatedTime().toString().replace("T", " ").substring(0, 16) + ".",
                "INFO");

        // Notify doctor
        notificationService.send(doctor.getUser().getId(), "DOCTOR",
                "New Appointment Assigned",
                "Patient " + appt.getPatient().getUser().getFullName() +
                " assigned to you on " + dt.toString().replace("T", " ").substring(0, 16) +
                " (Token #" + saved.getTokenNumber() + ").",
                "INFO");

        // Email patient
        try {
            String subject = "Appointment Assigned & Confirmed";
            String body = "Dear " + saved.getPatient().getUser().getFullName() + ",\n\n" +
                          "Your appointment request has been processed.\n" +
                          "Doctor: Dr. " + saved.getDoctor().getUser().getFullName() + "\n" +
                          "Scheduled Date & Time: " + saved.getScheduledAt().toString().replace("T", " ") + "\n" +
                          "Token Number: #" + saved.getTokenNumber() + "\n\n" +
                          "Please login to the portal for more details.\n\n" +
                          "Regards,\nSmart Health Monitor Team";
            emailService.sendEmail(saved.getPatient().getUser().getEmail(), subject, body);
        } catch (Exception e) {
            logService.warn("Failed to send assignment email to: " + appt.getPatient().getUser().getEmail(), "Reception");
        }

        User rec = (User) session.getAttribute("sessionUser");
        logService.info("Appointment #" + id + " assigned to Dr. " + doctor.getUser().getFullName() +
                " Token #" + saved.getTokenNumber(), rec != null ? rec.getFullName() : "Reception");

        ra.addFlashAttribute("success", "Appointment assigned to Dr. " + doctor.getUser().getFullName() +
                " on " + dt.toString().replace("T", " ").substring(0, 16) +
                ". Token #" + saved.getTokenNumber() + " — Estimated time: " +
                saved.getEstimatedTime().toString().replace("T", " ").substring(0, 16) +
                ". Patient notified via email.");
        return "redirect:/reception/appointments";
    }

    @PostMapping("/appointments/{id}/cancel")
    public String cancelAppointment(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        appointmentService.cancel(id);
        User rec = (User) session.getAttribute("sessionUser");
        logService.warn("Appointment #" + id + " cancelled by reception", rec != null ? rec.getFullName() : "Reception");
        ra.addFlashAttribute("success", "Appointment cancelled.");
        return "redirect:/reception/appointments";
    }

    @PostMapping("/appointments/{id}/notify-unavailable")
    public String notifyUnavailable(@PathVariable Long id,
                                    @RequestParam String availableFrom,
                                    @RequestParam(required = false) String message,
                                    HttpSession session,
                                    RedirectAttributes ra) {
        Appointment appt = appointmentService.findById(id).orElse(null);
        if (appt == null) {
            ra.addFlashAttribute("error", "Appointment not found.");
            return "redirect:/reception/appointments";
        }

        String doctorName = appt.getDoctor() != null ? "Dr. " + appt.getDoctor().getUser().getFullName() : "The selected doctor";
        
        // 1. Send Notification
        String notifMsg = doctorName + " is currently unavailable on your requested date. " +
                         "They will be available again from: " + availableFrom + ". " +
                         (message != null ? message : "Please update your request with a new date or select another doctor.");
        
        notificationService.send(appt.getPatient().getUser().getId(), "PATIENT",
                "Doctor Unavailable - Action Required", notifMsg, "WARNING");

        // 2. Send Email
        try {
            String subject = "Update Required: Your Appointment with " + doctorName;
            String body = "Dear " + appt.getPatient().getUser().getFullName() + ",\n\n" +
                          "Regarding your appointment request with " + doctorName + ",\n\n" +
                          "Our reception has noted that the doctor is currently unavailable on your requested date.\n\n" +
                          "Next Available From: " + availableFrom + "\n" +
                          "Notes: " + (message != null && !message.isBlank() ? message : "N/A") + "\n\n" +
                          "Please login to the Smart Health Monitor portal to update your appointment date or choose a different doctor.\n\n" +
                          "You can modify your request in the 'Your Appointments' section.\n\n" +
                          "Regards,\nReception Team\nSmart Health Monitor";
            emailService.sendEmail(appt.getPatient().getUser().getEmail(), subject, body);
        } catch (Exception e) {}

        logService.info("Patient #" + appt.getPatient().getId() + " notified of doctor unavailability for appt #" + id, "Reception");
        
        ra.addFlashAttribute("success", "Patient has been notified via email and portal notification.");
        return "redirect:/reception/appointments";
    }


    // ── Bed Management ────────────────────────────────────────────────────
    /** Main view: Department selection cards */
    @GetMapping("/beds")
    public String beds(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        
        // Get current charges for UI context (first found for each type)
        java.util.List<com.smarthealth.model.Bed> allBeds = bedRepository.findAll();
        double normalCharge = allBeds.stream()
                .filter(b -> b.getType() == com.smarthealth.model.Bed.BedType.NORMAL)
                .findFirst().map(b -> b.getDailyCharge()).orElse(500.0);
        double icuCharge = allBeds.stream()
                .filter(b -> b.getType() == com.smarthealth.model.Bed.BedType.ICU)
                .findFirst().map(b -> b.getDailyCharge()).orElse(1500.0);
        
        model.addAttribute("normalCharge", normalCharge);
        model.addAttribute("icuCharge", icuCharge);
        
        return "reception/beds";
    }

    @PostMapping("/beds/update-charges")
    public String updateBedCharges(@RequestParam Double normalCharge, @RequestParam Double icuCharge, RedirectAttributes ra) {
        bedService.updateBedCharges(com.smarthealth.model.Bed.BedType.NORMAL, normalCharge);
        bedService.updateBedCharges(com.smarthealth.model.Bed.BedType.ICU, icuCharge);
        ra.addFlashAttribute("success", "Bed daily charges updated successfully for all beds.");
        return "redirect:/reception/beds";
    }

    /** Detail view: Beds within a specific department */
    @GetMapping("/beds/department/{id}")
    public String departmentBeds(@PathVariable Long id, Model model, RedirectAttributes ra) {
        Department dept = departmentService.findById(id).orElse(null);
        if (dept == null) {
            ra.addFlashAttribute("error", "Department not found.");
            return "redirect:/reception/beds";
        }
        
        java.util.List<Patient> allPatients = patientService.findAll();
        java.util.Map<Long, com.smarthealth.model.Bed> bedMap = new java.util.HashMap<>();
        for (Patient p : allPatients) {
            List<com.smarthealth.model.Bed> pBeds = bedRepository.findByPatientId(p.getId());
            if (!pBeds.isEmpty()) {
                bedMap.put(p.getId(), pBeds.get(0));
            }
        }

        model.addAttribute("department", dept);
        model.addAttribute("beds", bedService.findByDepartmentId(id));
        model.addAttribute("patients", allPatients);
        model.addAttribute("bedMap", bedMap);
        return "reception/beds-department";
    }

    @PostMapping("/beds/{bedId}/assign")
    public String assignBed(@PathVariable Long bedId,
                            @RequestParam Long patientId,
                            @RequestParam(required = false) Long redirectDeptId,
                            HttpSession session,
                            RedirectAttributes ra) {
        Patient patient = patientService.findById(patientId).orElse(null);
        if (patient == null) { ra.addFlashAttribute("error", "Patient not found."); return "redirect:/reception/beds"; }

        boolean ok = bedService.assignBed(bedId, patient);
        if (!ok) {
            ra.addFlashAttribute("error", "Bed is not available.");
            return redirectDeptId != null ? "redirect:/reception/beds/department/" + redirectDeptId : "redirect:/reception/beds";
        }

        com.smarthealth.model.Bed bed = bedService.findById(bedId).orElse(null);
        String deptName = bed != null ? bed.getDepartment().getName() : "department";
        Long deptId = bed != null ? bed.getDepartment().getId() : null;

        notificationService.send(patient.getUser().getId(), "PATIENT",
                "Bed Assigned",
                "You have been assigned bed " + (bed != null ? bed.getBedNumber() : "") + " in " + deptName + ".",
                "INFO");

        User rec = (User) session.getAttribute("sessionUser");
        logService.info("Bed " + (bed != null ? bed.getBedNumber() : bedId) + " assigned to patient #" + patientId,
                rec != null ? rec.getFullName() : "Reception");
        ra.addFlashAttribute("success", "Bed assigned to " + patient.getUser().getFullName() + " in " + deptName + ".");
        
        return (redirectDeptId != null || deptId != null) 
                ? "redirect:/reception/beds/department/" + (redirectDeptId != null ? redirectDeptId : deptId)
                : "redirect:/reception/beds";
    }

    @PostMapping("/beds/{bedId}/release")
    public String releaseBed(@PathVariable Long bedId,
                             @RequestParam(required = false) Long redirectDeptId,
                             HttpSession session,
                             RedirectAttributes ra) {
        com.smarthealth.model.Bed bed = bedService.findById(bedId).orElse(null);
        String info = bed != null ? bed.getBedNumber() : String.valueOf(bedId);
        Long deptId = (bed != null && bed.getDepartment() != null) ? bed.getDepartment().getId() : null;

        boolean ok = bedService.releaseBed(bedId);
        if (!ok) {
            ra.addFlashAttribute("error", "Bed could not be released (already available or not found).");
            return "redirect:/reception/beds";
        }

        User rec = (User) session.getAttribute("sessionUser");
        logService.info("Bed " + info + " released", rec != null ? rec.getFullName() : "Reception");
        ra.addFlashAttribute("success", "Bed " + info + " released successfully.");
        
        return (redirectDeptId != null || deptId != null)
                ? "redirect:/reception/beds/department/" + (redirectDeptId != null ? redirectDeptId : deptId)
                : "redirect:/reception/beds";
    }

    // ── Patients ──────────────────────────────────────────────────────────
    @GetMapping("/patients")
    public String patients(Model model) {
        model.addAttribute("patients", patientService.findAll());
        model.addAttribute("departments", departmentService.findAll());
        return "reception/patients";
    }

    // ── Profile / Settings ────────────────────────────────────────────────
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        model.addAttribute("user", session.getAttribute("sessionUser"));
        return "reception/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam(required = false) String phone,
                                HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return "redirect:/auth/reception/login";
        user.setFullName(fullName);
        user.setPhone(phone);
        userService.update(user);
        session.setAttribute("sessionUser", userService.findById(user.getId()).orElse(user));
        ra.addFlashAttribute("success", "Profile updated.");
        return "redirect:/reception/profile";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session, Model model) {
        model.addAttribute("user", session.getAttribute("sessionUser"));
        return "reception/settings";
    }

    @PostMapping("/settings/update")
    public String updateSettings(@RequestParam(required = false) String currentPassword,
                                 @RequestParam(required = false) String newPassword,
                                 HttpSession session, RedirectAttributes ra) {
        User user = (User) session.getAttribute("sessionUser");
        if (user == null) return "redirect:/auth/reception/login";
        if (newPassword != null && !newPassword.isBlank()) {
            if (userService.checkPassword(currentPassword, user.getPassword())) {
                userService.updatePassword(user.getId(), newPassword);
                ra.addFlashAttribute("success", "Password updated.");
            } else {
                ra.addFlashAttribute("error", "Current password is incorrect.");
            }
        }
        return "redirect:/reception/settings";
    }

    // ── API ───────────────────────────────────────────────────────────────
    @GetMapping("/api/maxToken")
    @ResponseBody
    public java.util.Map<String, Object> getMaxTokenByDate(@RequestParam Long doctorId, @RequestParam String date) {
        java.util.Map<String, Object> map = new java.util.HashMap<>();
        map.put("maxToken", appointmentService.findMaxTokenForDoctor(doctorId, java.time.LocalDate.parse(date)));
        return map;
    }
}
