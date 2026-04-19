package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private DoctorService doctorService;
    @Autowired private PatientService patientService;
    @Autowired private DepartmentService departmentService;
    @Autowired private UserService userService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private SystemLogService logService;
    @Autowired private DashboardService dashboardService;
    @Autowired private BedService bedService;
    @Autowired private ContactMessageService contactService;
    @Autowired private AdminMessageService adminMessageService;
    @Autowired private NotificationService notificationService;
    @Autowired private EmailService emailService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private HealthMetricService healthMetricService;
    @Autowired private MedicalReportService medicalReportService;

    // ── Broadcast Messaging ───────────────────────────────────────────────

    @GetMapping("/messaging")
    public String messagingCenter(Model model) {
        model.addAttribute("messages", adminMessageService.findAll());
        model.addAttribute("departments", departmentService.findAll());
        model.addAttribute("specialties", doctorService.findDistinctSpecialties());
        return "admin/messaging";
    }

    @PostMapping("/messaging/send")
    public String sendBroadcast(@RequestParam String subject,
                                @RequestParam String body,
                                @RequestParam String targetRole,
                                @RequestParam(required = false) String filterBloodGroup,
                                @RequestParam(required = false) String filterGender,
                                @RequestParam(required = false) Long filterDepartment,
                                @RequestParam(required = false) String filterSpecialty,
                                @RequestParam String deliveryMethod,
                                HttpSession session, RedirectAttributes ra) {

        User admin = (User) session.getAttribute("sessionUser");
        if (admin == null) return "redirect:/auth/admin/login";

        AdminMessage msg = new AdminMessage();
        msg.setSubject(subject);
        msg.setBody(body);
        msg.setTargetRole(targetRole);
        msg.setFilterBloodGroup(filterBloodGroup);
        msg.setFilterGender(filterGender);
        if (filterDepartment != null) msg.setFilterDepartment(filterDepartment.toString());
        msg.setFilterSpecialty(filterSpecialty);
        msg.setDeliveryMethod(deliveryMethod);
        msg.setSentBy(admin);

        java.util.List<User> recipients = new java.util.ArrayList<>();

        // Fetch users based on selected target and filters
        if ("PATIENT".equals(targetRole) || "ALL".equals(targetRole)) {
            java.util.List<Patient> patients;
            if ("ALL".equals(targetRole)) {
                patients = patientService.findAll();
            } else {
                patients = patientService.findFiltered(filterBloodGroup, filterGender, filterDepartment);
            }
            for (Patient p : patients) recipients.add(p.getUser());
        }

        if ("DOCTOR".equals(targetRole) || "ALL".equals(targetRole)) {
            java.util.List<Doctor> doctors;
            if ("ALL".equals(targetRole)) {
                doctors = doctorService.findAll();
            } else {
                doctors = doctorService.findFiltered(filterSpecialty, filterDepartment);
            }
            for (Doctor d : doctors) recipients.add(d.getUser());
        }

        msg.setRecipientCount(recipients.size());

        if (recipients.isEmpty()) {
            ra.addFlashAttribute("error", "No users matched the selected criteria. Message not sent.");
            return "redirect:/admin/messaging";
        }

        int emailsSent = 0;
        int inAppSent = 0;

        java.util.List<String> emailsToNotify = new java.util.ArrayList<>();

        for (User user : recipients) {
            boolean wantEmail = "EMAIL".equals(deliveryMethod) || "BOTH".equals(deliveryMethod);
            boolean wantInApp = "IN_APP".equals(deliveryMethod) || "BOTH".equals(deliveryMethod);

            if (wantEmail && user.getEmail() != null && !user.getEmail().isBlank()) {
                emailsToNotify.add(user.getEmail());
            }

            if (wantInApp) {
                notificationService.send(user.getId(), user.getRole().name(), "📢 " + subject, body, "INFO");
                inAppSent++;
            }
        }

        if (!emailsToNotify.isEmpty()) {
            emailsSent = emailService.sendBroadcastEmail(emailsToNotify, subject, body);
        }

        msg.setStatus(emailsSent + inAppSent > 0 ? "SENT" : "FAILED");
        adminMessageService.save(msg);

        logService.info("Admin sent broadcast (" + targetRole + ") to " + recipients.size() + " users.", admin.getFullName());
        ra.addFlashAttribute("success", "Broadcast sent to " + recipients.size() + " matching users!");

        return "redirect:/admin/messaging";
    }

    // ── Feedback & Inquiries ──────────────────────────────────────────────
    @GetMapping("/feedback")
    public String listFeedback(Model model) {
        model.addAttribute("messages", contactService.findAll());
        model.addAttribute("pendingCount", contactService.findPending().size());
        return "admin/feedback-list";
    }

    @GetMapping("/feedback/{id}/view")
    public String viewFeedback(@PathVariable Long id, Model model, RedirectAttributes ra) {
        return contactService.findById(id).map(msg -> {
            model.addAttribute("message", msg);
            return "admin/feedback-reply";
        }).orElseGet(() -> {
            ra.addFlashAttribute("error", "Message not found.");
            return "redirect:/admin/feedback";
        });
    }

    @PostMapping("/feedback/{id}/reply")
    public String replyFeedback(@PathVariable Long id, @RequestParam String reply, 
                                 HttpSession session, RedirectAttributes ra) {
        contactService.reply(id, reply);
        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Admin replied to feedback ID: " + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Reply sent successfully.");
        return "redirect:/admin/feedback";
    }

    @Autowired private DoctorReviewService reviewService;

    @GetMapping("/feedback/{id}/delete")
    public String deleteFeedback(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        contactService.delete(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.warn("Admin deleted feedback ID: " + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Message deleted.");
        return "redirect:/admin/feedback";
    }

    // ── Reviews ───────────────────────────────────────────────────────────
    @GetMapping("/reviews")
    public String viewReviews(Model model) {
        model.addAttribute("reviews", reviewService.findAll());
        return "admin/reviews";
    }

    // ── Dashboard ─────────────────────────────────────────────────────────
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model, HttpSession session) {
        Map<String, Object> stats = dashboardService.getAdminStats();
        model.addAllAttributes(stats);
        model.addAttribute("recentLogs", logService.findRecent());
        return "admin/dashboard";
    }

    // ── Doctors ───────────────────────────────────────────────────────────
    @GetMapping("/doctors")
    public String doctors(Model model) {
        List<Doctor> doctors = doctorService.findAll();
        Map<Long, Double> ratings = new HashMap<>();
        for (Doctor d : doctors) {
            Double avg = reviewService.getAverageRating(d.getId());
            ratings.put(d.getId(), avg != null ? avg : 0.0);
        }
        model.addAttribute("doctors", doctors);
        model.addAttribute("ratings", ratings);
        model.addAttribute("pendingCount", doctorService.findPending().size());
        return "admin/manage-doctors";
    }

    @GetMapping("/doctors/add")
    public String addDoctorForm(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        return "admin/add-doctor";
    }

    @PostMapping("/doctors/add")
    public String saveDoctor(@RequestParam String fullName, @RequestParam String email,
                             @RequestParam String password, @RequestParam String specialty,
                             @RequestParam String licenseNumber,
                             @RequestParam(required = false) String phone,
                             @RequestParam(required = false) Integer experience,
                             @RequestParam(required = false) Long departmentId,
                             HttpSession session, RedirectAttributes ra) {
        if (userService.existsByEmail(email)) {
            ra.addFlashAttribute("error", "Email already exists.");
            return "redirect:/admin/doctors/add";
        }
        User user = new User();
        user.setFullName(fullName); user.setEmail(email);
        user.setPassword(password); user.setRole(Role.DOCTOR);
        user.setPhone(phone);
        User saved = userService.register(user);

        Doctor doctor = new Doctor();
        doctor.setUser(saved); doctor.setSpecialty(specialty);
        doctor.setLicenseNumber(licenseNumber); doctor.setPhone(phone);
        doctor.setExperience(experience); doctor.setApproved(true);
        doctor.setStatus("ACTIVE");
        if (departmentId != null) departmentService.findById(departmentId).ifPresent(doctor::setDepartment);
        doctorService.save(doctor);

        // Send welcome email with credentials
        emailService.sendWelcomeCredentials(email, fullName, "DOCTOR", password);

        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Admin added doctor: " + fullName, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Doctor added successfully. Credentials sent to " + email);
        return "redirect:/admin/doctors";
    }

    @GetMapping("/doctors/requests")
    public String pendingDoctors(Model model) {
        model.addAttribute("doctors", doctorService.findPending());
        return "admin/pending-doctors";
    }

    @PostMapping("/doctors/{id}/approve")
    public String approveDoctor(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        doctorService.approve(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Doctor approved, ID=" + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Doctor approved.");
        return "redirect:/admin/doctors/requests";
    }

    @PostMapping("/doctors/{id}/reject")
    public String rejectDoctor(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        doctorService.reject(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.warn("Doctor request rejected, ID=" + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Doctor request rejected.");
        return "redirect:/admin/doctors/requests";
    }

    @GetMapping("/doctors/{id}/delete")
    public String deleteDoctor(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        doctorService.delete(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.warn("Doctor deleted, ID=" + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Doctor deleted.");
        return "redirect:/admin/doctors";
    }

    @GetMapping("/doctors/{id}/toggle")
    public String toggleDoctor(@PathVariable Long id, RedirectAttributes ra) {
        doctorService.toggleActive(id);
        ra.addFlashAttribute("success", "Doctor status updated.");
        return "redirect:/admin/doctors";
    }

    @GetMapping("/doctors/{id}/view")
    public String viewDoctor(@PathVariable Long id, Model model) {
        model.addAttribute("doctor", doctorService.findById(id).orElse(null));
        model.addAttribute("departments", departmentService.findAll());
        return "admin/doctor-actions";
    }

    // ── Patients ──────────────────────────────────────────────────────────
    @GetMapping("/patients")
    public String patients(Model model) {
        model.addAttribute("patients", patientService.findAll());
        return "admin/manage-patients";
    }

    // ── Staff Management (Reception & Medical) ────────────────────────────
    @GetMapping("/receptionists")
    public String viewReceptionists(Model model) {
        model.addAttribute("staff", userService.findByRole(Role.RECEPTIONIST));
        model.addAttribute("roleTitle", "Receptionists");
        model.addAttribute("roleKey", "RECEPTIONIST");
        return "admin/manage-staff";
    }

    @GetMapping("/medical-staff")
    public String viewMedicalStaff(Model model) {
        model.addAttribute("staff", userService.findByRole(Role.MEDICAL_STAFF));
        model.addAttribute("roleTitle", "Medical Staff");
        model.addAttribute("roleKey", "MEDICAL_STAFF");
        return "admin/manage-staff";
    }

    @GetMapping("/staff/add")
    public String addStaffForm(@RequestParam String role, Model model) {
        model.addAttribute("role", role);
        return "admin/add-staff";
    }

    @PostMapping("/staff/add")
    public String saveStaff(@RequestParam String fullName, @RequestParam String email,
                            @RequestParam String password, @RequestParam String role,
                            @RequestParam(required = false) String phone,
                            HttpSession session, RedirectAttributes ra) {
        if (userService.existsByEmail(email)) {
            ra.addFlashAttribute("error", "Email already exists.");
            return "redirect:/admin/staff/add?role=" + role;
        }
        User user = new User();
        user.setFullName(fullName); user.setEmail(email);
        user.setPassword(password); user.setRole(Role.valueOf(role));
        user.setPhone(phone);
        userService.register(user);

        // Send welcome email with credentials
        emailService.sendWelcomeCredentials(email, fullName, role, password);

        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Admin added " + role + ": " + fullName, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", role + " added successfully. Credentials sent to " + email);
        return "redirect:/admin/" + (role.equals("RECEPTIONIST") ? "receptionists" : "medical-staff");
    }

    @GetMapping("/staff/{id}/delete")
    public String deleteStaff(@PathVariable Long id, @RequestParam String role, HttpSession session, RedirectAttributes ra) {
        userService.delete(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.warn(role + " deleted, ID=" + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "User deleted.");
        return "redirect:/admin/" + (role.equals("RECEPTIONIST") ? "receptionists" : "medical-staff");
    }


    @GetMapping("/patients/add")
    public String addPatientForm() { return "admin/add-patient"; }

    @PostMapping("/patients/add")
    public String savePatient(@RequestParam String fullName, @RequestParam String email,
                              @RequestParam String password,
                              @RequestParam(required = false) String phone,
                              @RequestParam(required = false) String gender,
                              @RequestParam(required = false) String bloodGroup,
                              HttpSession session, RedirectAttributes ra) {
        if (userService.existsByEmail(email)) {
            ra.addFlashAttribute("error", "Email already exists.");
            return "redirect:/admin/patients/add";
        }
        User user = new User();
        user.setFullName(fullName); user.setEmail(email);
        user.setPassword(password); user.setRole(Role.PATIENT);
        user.setPhone(phone);
        User saved = userService.register(user);

        Patient patient = new Patient();
        patient.setUser(saved); patient.setGender(gender);
        patient.setBloodGroup(bloodGroup); patient.setPhone(phone);
        patientService.save(patient);

        // Send welcome email with credentials
        emailService.sendWelcomeCredentials(email, fullName, "PATIENT", password);

        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Admin added patient: " + fullName, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Patient added successfully. Credentials sent to " + email);
        return "redirect:/admin/patients";
    }

    @GetMapping("/patients/{id}/delete")
    public String deletePatient(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        patientService.delete(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.warn("Patient deleted, ID=" + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Patient deleted.");
        return "redirect:/admin/patients";
    }

    @GetMapping("/patients/{id}/view")
    public String viewPatient(@PathVariable Long id, Model model) {
        model.addAttribute("patient", patientService.findById(id).orElse(null));
        model.addAttribute("prescriptions", prescriptionService.findByPatientId(id));
        model.addAttribute("appointments", appointmentService.findByPatientId(id));
        model.addAttribute("metrics", healthMetricService.findByPatientId(id));
        model.addAttribute("reports", medicalReportService.findByPatientId(id));
        return "admin/patient-actions";
    }


    // ── Departments ───────────────────────────────────────────────────────
    @GetMapping("/departments")
    public String departments(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        return "admin/departments";
    }

    @GetMapping("/departments/add")
    public String addDepartmentForm() { return "admin/add-department"; }

    @PostMapping("/departments/add")
    public String saveDepartment(@ModelAttribute Department department, HttpSession session, RedirectAttributes ra) {
        department.setStatus("ACTIVE");
        department.setCurrOccupancy(0);
        if (department.getTotalBeds() == null) department.setTotalBeds(0);
        if (department.getIcuBeds() == null) department.setIcuBeds(0);
        department.setAvailableBeds(department.getTotalBeds());
        department.setOccupiedBeds(0);
        Department saved = departmentService.save(department);
        // Auto-create individual bed records
        bedService.initBedsForDepartment(saved);
        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Department added: " + department.getName(), admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Department added with " + saved.getTotalBeds() + " beds.");
        return "redirect:/admin/departments";
    }

    @GetMapping("/departments/{id}/delete")
    public String deleteDepartment(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        departmentService.delete(id);
        User admin = (User) session.getAttribute("sessionUser");
        logService.warn("Department deleted, ID=" + id, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Department deleted.");
        return "redirect:/admin/departments";
    }

    @GetMapping("/departments/{id}/view")
    public String viewDepartment(@PathVariable Long id, Model model) {
        Department dept = departmentService.findById(id).orElse(null);
        model.addAttribute("department", dept);
        if (dept != null) {
            model.addAttribute("doctors", doctorService.findAll().stream()
                    .filter(d -> d.getDepartment() != null && d.getDepartment().getId().equals(id))
                    .toList());
            model.addAttribute("beds", bedService.findByDepartmentId(id));
        }
        return "admin/view-department";
    }

    @GetMapping("/departments/{id}/edit")
    public String editDepartmentForm(@PathVariable Long id, Model model, RedirectAttributes ra) {
        Department dept = departmentService.findById(id).orElse(null);
        if (dept == null) { ra.addFlashAttribute("error", "Department not found."); return "redirect:/admin/departments"; }
        model.addAttribute("department", dept);
        return "admin/edit-department";
    }

    @PostMapping("/departments/{id}/edit")
    public String updateDepartment(@PathVariable Long id,
                                   @RequestParam String name,
                                   @RequestParam String code,
                                   @RequestParam Integer targetCapacity,
                                   @RequestParam(required = false) String description,
                                   @RequestParam(required = false) String headName,
                                   @RequestParam(required = false) String physicalLocation,
                                   @RequestParam(required = false) String emergencyPhone,
                                   @RequestParam(required = false) String status,
                                   @RequestParam(required = false, defaultValue = "0") Integer totalBeds,
                                   @RequestParam(required = false, defaultValue = "0") Integer icuBeds,
                                   HttpSession session, RedirectAttributes ra) {
        Department dept = departmentService.findById(id).orElse(null);
        if (dept == null) { ra.addFlashAttribute("error", "Department not found."); return "redirect:/admin/departments"; }

        dept.setName(name);
        dept.setCode(code);
        dept.setTargetCapacity(targetCapacity);
        dept.setDescription(description);
        dept.setHeadName(headName);
        dept.setPhysicalLocation(physicalLocation);
        dept.setEmergencyPhone(emergencyPhone);
        if (status != null) dept.setStatus(status);

        // Update bed capacity if changed
        int oldTotal = dept.getTotalBeds() != null ? dept.getTotalBeds() : 0;
        int oldIcu   = dept.getIcuBeds()   != null ? dept.getIcuBeds()   : 0;
        int safeIcu  = Math.min(icuBeds, totalBeds);

        if (totalBeds != oldTotal || safeIcu != oldIcu) {
            dept.setTotalBeds(totalBeds);
            dept.setIcuBeds(safeIcu);
            // Recalculate available = total - occupied (keep occupied as-is)
            int occupied = dept.getOccupiedBeds() != null ? dept.getOccupiedBeds() : 0;
            dept.setAvailableBeds(Math.max(0, totalBeds - occupied));
            departmentService.save(dept);
            // Regenerate bed records to match new totals
            bedService.syncBedsForDepartment(dept);
        } else {
            departmentService.save(dept);
        }

        User admin = (User) session.getAttribute("sessionUser");
        logService.info("Department updated: " + name, admin != null ? admin.getFullName() : "Admin");
        ra.addFlashAttribute("success", "Department updated successfully.");
        return "redirect:/admin/departments/" + id + "/view";
    }

    // ── Reports / Logs / Settings ─────────────────────────────────────────
    @GetMapping("/reports")
    public String reports(Model model) {
        Map<String, Object> stats = dashboardService.getAdminStats();
        model.addAllAttributes(stats);
        model.addAttribute("appointments", appointmentService.findAll());
        return "admin/reports";
    }

    @GetMapping("/reports/{id}")
    public String viewReport(@PathVariable Long id, Model model) {
        model.addAttribute("report", medicalReportService.findById(id).orElse(null));
        return "admin/report-view";
    }


    @GetMapping("/logs")
    public String logs(Model model) {
        model.addAttribute("logs", logService.findRecent());
        return "admin/system-logs";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session, Model model) {
        User admin = (User) session.getAttribute("sessionUser");
        model.addAttribute("admin", admin);
        return "admin/settings";
    }

    @PostMapping("/settings/update")
    public String updateSettings(@RequestParam String fullName,
                                 @RequestParam(required = false) String phone,
                                 @RequestParam(required = false) String currentPassword,
                                 @RequestParam(required = false) String newPassword,
                                 HttpSession session, RedirectAttributes ra) {
        User admin = (User) session.getAttribute("sessionUser");
        if (admin == null) return "redirect:/auth/admin/login";
        admin.setFullName(fullName);
        admin.setPhone(phone);
        userService.update(admin);
        if (newPassword != null && !newPassword.isBlank()) {
            if (userService.checkPassword(currentPassword, admin.getPassword())) {
                userService.updatePassword(admin.getId(), newPassword);
                ra.addFlashAttribute("success", "Profile and password updated.");
            } else {
                ra.addFlashAttribute("error", "Current password is wrong.");
                return "redirect:/admin/settings";
            }
        } else {
            ra.addFlashAttribute("success", "Profile updated.");
        }
        session.setAttribute("sessionUser", userService.findById(admin.getId()).orElse(admin));
        return "redirect:/admin/settings";
    }
}
