package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.service.*;
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
        model.addAttribute("doctors", doctorService.findApproved());
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
        model.addAttribute("doctors", doctorService.findApproved());

        // Pre-load schedule for each doctor on the patient's preferred date (or today)
        java.time.LocalDate targetDate = appt.getPreferredDate() != null
                ? appt.getPreferredDate()
                : java.time.LocalDate.now();
        model.addAttribute("targetDate", targetDate.toString());

        java.util.Map<Long, java.util.List<Appointment>> scheduleMap = new java.util.HashMap<>();
        for (com.smarthealth.model.Doctor doc : doctorService.findApproved()) {
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
    @GetMapping("/beds")
    public String beds(Model model) {
        List<Department> departments = departmentService.findAll();
        model.addAttribute("departments", departments);
        // Add beds per department
        java.util.Map<Long, java.util.List<com.smarthealth.model.Bed>> bedMap = new java.util.HashMap<>();
        for (Department d : departments) {
            bedMap.put(d.getId(), bedService.findByDepartmentId(d.getId()));
        }
        model.addAttribute("bedMap", bedMap);
        model.addAttribute("patients", patientService.findAll());
        return "reception/beds";
    }

    @PostMapping("/beds/{bedId}/assign")
    public String assignBed(@PathVariable Long bedId,
                            @RequestParam Long patientId,
                            HttpSession session,
                            RedirectAttributes ra) {
        Patient patient = patientService.findById(patientId).orElse(null);
        if (patient == null) { ra.addFlashAttribute("error", "Patient not found."); return "redirect:/reception/beds"; }

        boolean ok = bedService.assignBed(bedId, patient);
        if (!ok) {
            ra.addFlashAttribute("error", "Bed is not available.");
            return "redirect:/reception/beds";
        }

        com.smarthealth.model.Bed bed = bedService.findById(bedId).orElse(null);
        String deptName = bed != null ? bed.getDepartment().getName() : "department";

        notificationService.send(patient.getUser().getId(), "PATIENT",
                "Bed Assigned",
                "You have been assigned bed " + (bed != null ? bed.getBedNumber() : "") + " in " + deptName + ".",
                "INFO");

        User rec = (User) session.getAttribute("sessionUser");
        logService.info("Bed " + (bed != null ? bed.getBedNumber() : bedId) + " assigned to patient #" + patientId,
                rec != null ? rec.getFullName() : "Reception");
        ra.addFlashAttribute("success", "Bed assigned to " + patient.getUser().getFullName() + " in " + deptName + ".");
        return "redirect:/reception/beds";
    }

    @PostMapping("/beds/{bedId}/release")
    public String releaseBed(@PathVariable Long bedId,
                             HttpSession session,
                             RedirectAttributes ra) {
        com.smarthealth.model.Bed bed = bedService.findById(bedId).orElse(null);
        String info = bed != null ? bed.getBedNumber() : String.valueOf(bedId);

        boolean ok = bedService.releaseBed(bedId);
        if (!ok) {
            ra.addFlashAttribute("error", "Bed could not be released (already available or not found).");
            return "redirect:/reception/beds";
        }

        User rec = (User) session.getAttribute("sessionUser");
        logService.info("Bed " + info + " released", rec != null ? rec.getFullName() : "Reception");
        ra.addFlashAttribute("success", "Bed " + info + " released successfully.");
        return "redirect:/reception/beds";
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
        try {
            java.time.LocalDate ld = java.time.LocalDate.parse(date);
            Integer max = appointmentService.findMaxTokenForDoctor(doctorId, ld);
            java.time.LocalDateTime latest = appointmentService.findMaxScheduledTimeForDoctor(doctorId, ld);
            map.put("maxToken", max != null ? max : 0);
            map.put("latestTime", latest != null ? latest.toString() : null);
        } catch (Exception e) {
            map.put("maxToken", 0);
            map.put("latestTime", null);
        }
        return map;
    }
}
