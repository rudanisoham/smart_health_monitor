package com.smarthealth.controller;

import com.smarthealth.model.Doctor;
import com.smarthealth.model.Patient;
import com.smarthealth.model.Role;
import com.smarthealth.model.User;
import com.smarthealth.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired private UserService userService;
    @Autowired private DoctorService doctorService;
    @Autowired private PatientService patientService;
    @Autowired private SystemLogService logService;
    @Autowired private DepartmentService departmentService;

    // ── GET login pages ──────────────────────────────────────────────────
    @GetMapping("/admin/login")
    public String adminLogin() { return "auth/admin-login"; }

    @GetMapping("/doctor/login")
    public String doctorLogin() { return "auth/doctor-login"; }

    @GetMapping("/patient/login")
    public String patientLogin() { return "auth/patient-login"; }

    @GetMapping("/patient/register")
    public String patientRegister(Model model) { return "auth/patient-register"; }

    @GetMapping("/doctor/register")
    public String doctorRegister(Model model) {
        model.addAttribute("departments", departmentService.findAll());
        return "auth/doctor-register";
    }

    // ── POST login ────────────────────────────────────────────────────────
    @PostMapping("/login")
    public String processLogin(@RequestParam String email,
                               @RequestParam String password,
                               @RequestParam String roleStr,
                               @RequestParam(required = false) Double latitude,
                               @RequestParam(required = false) Double longitude,
                               HttpSession session,
                               RedirectAttributes ra) {
        User user = userService.login(email, password);
        if (user == null) {
            ra.addFlashAttribute("error", "Invalid email or password.");
            return "redirect:/auth/" + roleStr.toLowerCase() + "/login";
        }
        if (!user.getRole().name().equalsIgnoreCase(roleStr)) {
            ra.addFlashAttribute("error", "You don't have access as " + roleStr + ".");
            return "redirect:/auth/" + roleStr.toLowerCase() + "/login";
        }
        session.setAttribute("sessionUser", user);
        if (latitude != null && longitude != null) {
            session.setAttribute("loginLatitude", latitude);
            session.setAttribute("loginLongitude", longitude);
        }
        logService.info("User logged in: " + user.getEmail(), user.getFullName());
        switch (user.getRole()) {
            case ADMIN:   return "redirect:/admin/dashboard";
            case DOCTOR:  return "redirect:/doctor/dashboard";
            case PATIENT: return "redirect:/patient/dashboard";
            default:      return "redirect:/";
        }
    }

    // ── POST patient register ────────────────────────────────────────────
    @PostMapping("/patient/register")
    public String registerPatient(@RequestParam String fullName,
                                  @RequestParam String email,
                                  @RequestParam String password,
                                  @RequestParam(required = false) String phone,
                                  @RequestParam(required = false) String gender,
                                  @RequestParam(required = false) String bloodGroup,
                                  RedirectAttributes ra) {
        if (userService.existsByEmail(email)) {
            ra.addFlashAttribute("error", "Email already registered.");
            return "redirect:/auth/patient/register";
        }
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(Role.PATIENT);
        user.setPhone(phone);
        User saved = userService.register(user);

        Patient patient = new Patient();
        patient.setUser(saved);
        patient.setGender(gender);
        patient.setBloodGroup(bloodGroup);
        patient.setPhone(phone);
        patientService.save(patient);

        logService.info("New patient registered: " + email, fullName);
        ra.addFlashAttribute("success", "Registration successful! Please login.");
        return "redirect:/auth/patient/login";
    }

    // ── POST doctor register ─────────────────────────────────────────────
    @PostMapping("/doctor/register")
    public String registerDoctor(@RequestParam String fullName,
                                 @RequestParam String email,
                                 @RequestParam String password,
                                 @RequestParam String specialty,
                                 @RequestParam String licenseNumber,
                                 @RequestParam(required = false) String phone,
                                 @RequestParam(required = false) Integer experience,
                                 @RequestParam(required = false) Long departmentId,
                                 RedirectAttributes ra) {
        if (userService.existsByEmail(email)) {
            ra.addFlashAttribute("error", "Email already registered.");
            return "redirect:/auth/doctor/register";
        }
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(Role.DOCTOR);
        user.setPhone(phone);
        User saved = userService.register(user);

        Doctor doctor = new Doctor();
        doctor.setUser(saved);
        doctor.setSpecialty(specialty);
        doctor.setLicenseNumber(licenseNumber);
        doctor.setPhone(phone);
        doctor.setExperience(experience);
        if (departmentId != null) {
            departmentService.findById(departmentId).ifPresent(doctor::setDepartment);
        }
        doctor.setApproved(false);
        doctorService.save(doctor);

        logService.info("New doctor registration request: " + email, fullName);
        ra.addFlashAttribute("success", "Registration submitted! Await admin approval.");
        return "redirect:/auth/doctor/login";
    }

    // ── Logout ────────────────────────────────────────────────────────────
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        User user = (User) session.getAttribute("sessionUser");
        if (user != null) logService.info("User logged out: " + user.getEmail(), user.getFullName());
        session.invalidate();
        return "redirect:/";
    }
}
