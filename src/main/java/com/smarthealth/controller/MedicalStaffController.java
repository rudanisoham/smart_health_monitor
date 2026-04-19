package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/medical")
public class MedicalStaffController {

    @Autowired private PatientService patientService;
    @Autowired private UserService userService;
    @Autowired private MedicineService medicineService;
    @Autowired private MedicalReportService medicalReportService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private HealthMetricService healthMetricService;
    @Autowired private NotificationService notificationService;
    @Autowired private SystemLogService logService;
    @Autowired private DoctorService doctorService;

    private User getSessionUser(HttpSession session) {
        return (User) session.getAttribute("sessionUser");
    }

    // ── Dashboard ─────────────────────────────────────────────────────────
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("totalPatients", patientService.count());
        model.addAttribute("totalMedicines", medicineService.count());
        model.addAttribute("totalReports", medicalReportService.count());
        model.addAttribute("pendingReports", medicalReportService.findPending().size());
        model.addAttribute("recentReports", medicalReportService.findAll().stream().limit(5).toList());
        return "medical/dashboard";
    }

    // ── Patient Search ────────────────────────────────────────────────────
    @GetMapping("/patients")
    public String patientSearch(@RequestParam(required = false) String query,
                                @RequestParam(required = false) String searchType,
                                Model model) {
        List<Patient> results = patientService.findAll(); // always show all by default

        if (query != null && !query.isBlank()) {
            if ("id".equals(searchType)) {
                try {
                    Long pid = Long.parseLong(query.trim());
                    Patient found = patientService.findById(pid).orElse(null);
                    results = found != null ? java.util.List.of(found) : java.util.List.of();
                } catch (NumberFormatException ignored) {
                    results = java.util.List.of();
                }
            } else if ("email".equals(searchType)) {
                User u = userService.findByEmail(query.trim()).orElse(null);
                if (u != null) {
                    Patient p = patientService.findByUserId(u.getId());
                    results = p != null ? java.util.List.of(p) : java.util.List.of();
                } else {
                    results = java.util.List.of();
                }
            } else {
                // name search
                final String lq = query.toLowerCase();
                results = patientService.findAll().stream()
                        .filter(p -> p.getUser().getFullName().toLowerCase().contains(lq))
                        .toList();
            }
        }

        model.addAttribute("patients", results);
        model.addAttribute("query", query);
        model.addAttribute("searchType", searchType);
        return "medical/patient-search";
    }

    @GetMapping("/patients/{id}")
    public String patientDetails(@PathVariable Long id, Model model) {
        Patient patient = patientService.findById(id).orElse(null);
        if (patient == null) return "redirect:/medical/patients";
        model.addAttribute("patient", patient);
        model.addAttribute("prescriptions", prescriptionService.findByPatientId(id));
        model.addAttribute("appointments", appointmentService.findByPatientId(id));
        model.addAttribute("metrics", healthMetricService.findByPatientId(id));
        model.addAttribute("reports", medicalReportService.findByPatientId(id));
        model.addAttribute("latestMetric", healthMetricService.findLatestByPatientId(id));
        return "medical/patient-details";
    }

    // ── Medicine Management ───────────────────────────────────────────────
    @GetMapping("/medicines")
    public String medicineList(@RequestParam(required = false) String q, Model model) {
        model.addAttribute("medicines", q != null && !q.isBlank() ? medicineService.search(q) : medicineService.findAll());
        model.addAttribute("q", q);
        return "medical/medicine-list";
    }

    @GetMapping("/medicines/add")
    public String addMedicineForm() {
        return "medical/add-medicine";
    }

    @PostMapping("/medicines/add")
    public String saveMedicine(@RequestParam String name,
                               @RequestParam(required = false) String category,
                               @RequestParam(required = false) String dosageForm,
                               @RequestParam(required = false) String strength,
                               @RequestParam(required = false) Integer stockQuantity,
                               @RequestParam(required = false) String expiryDate,
                               @RequestParam(required = false) Double price,
                               @RequestParam(required = false) Integer unitsPerPack,
                               @RequestParam(required = false) Double pricePerPack,
                               @RequestParam(required = false) String description,
                               HttpSession session, RedirectAttributes ra) {
        if (dosageForm != null && medicineService.isDuplicate(name, dosageForm)) {
            ra.addFlashAttribute("error", "Medicine '" + name + "' with form '" + dosageForm + "' already exists.");
            return "redirect:/medical/medicines/add";
        }
        Medicine m = new Medicine();
        m.setName(name.trim());
        m.setCategory(category);
        m.setDosageForm(dosageForm);
        m.setStrength(strength);
        m.setStockQuantity(stockQuantity != null ? stockQuantity : 0);
        m.setPrice(price);
        m.setUnitsPerPack(unitsPerPack != null ? unitsPerPack : 1);
        m.setPricePerPack(pricePerPack);
        m.setDescription(description);
        if (expiryDate != null && !expiryDate.isBlank()) {
            try { m.setExpiryDate(LocalDate.parse(expiryDate)); } catch (Exception ignored) {}
        }
        User u = getSessionUser(session);
        m.setCreatedBy(u != null ? u.getFullName() : "Medical Staff");
        medicineService.save(m);
        logService.info("Medicine added: " + name, u != null ? u.getFullName() : "Medical Staff");
        ra.addFlashAttribute("success", "Medicine '" + name + "' added successfully.");
        return "redirect:/medical/medicines";
    }

    @GetMapping("/medicines/{id}/edit")
    public String editMedicineForm(@PathVariable Long id, Model model, RedirectAttributes ra) {
        Medicine m = medicineService.findById(id).orElse(null);
        if (m == null) { ra.addFlashAttribute("error", "Medicine not found."); return "redirect:/medical/medicines"; }
        model.addAttribute("medicine", m);
        return "medical/edit-medicine";
    }

    @PostMapping("/medicines/{id}/edit")
    public String updateMedicine(@PathVariable Long id,
                                 @RequestParam String name,
                                 @RequestParam(required = false) String category,
                                 @RequestParam(required = false) String dosageForm,
                                 @RequestParam(required = false) String strength,
                                 @RequestParam(required = false) Integer stockQuantity,
                                 @RequestParam(required = false) String expiryDate,
                                 @RequestParam(required = false) Double price,
                                 @RequestParam(required = false) Integer unitsPerPack,
                                 @RequestParam(required = false) Double pricePerPack,
                                 @RequestParam(required = false) String description,
                                 HttpSession session, RedirectAttributes ra) {
        Medicine m = medicineService.findById(id).orElse(null);
        if (m == null) { ra.addFlashAttribute("error", "Medicine not found."); return "redirect:/medical/medicines"; }
        m.setName(name.trim());
        m.setCategory(category);
        m.setDosageForm(dosageForm);
        m.setStrength(strength);
        if (stockQuantity != null) m.setStockQuantity(stockQuantity);
        if (price != null) m.setPrice(price);
        if (unitsPerPack != null) m.setUnitsPerPack(unitsPerPack);
        if (pricePerPack != null) m.setPricePerPack(pricePerPack);
        m.setDescription(description);
        if (expiryDate != null && !expiryDate.isBlank()) {
            try { m.setExpiryDate(LocalDate.parse(expiryDate)); } catch (Exception ignored) {}
        }
        medicineService.save(m);
        User u = getSessionUser(session);
        logService.info("Medicine updated: " + name, u != null ? u.getFullName() : "Medical Staff");
        ra.addFlashAttribute("success", "Medicine updated.");
        return "redirect:/medical/medicines";
    }

    @PostMapping("/medicines/{id}/delete")
    public String deleteMedicine(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        medicineService.deactivate(id);
        User u = getSessionUser(session);
        logService.warn("Medicine deactivated ID=" + id, u != null ? u.getFullName() : "Medical Staff");
        ra.addFlashAttribute("success", "Medicine removed from inventory.");
        return "redirect:/medical/medicines";
    }

    /** JSON endpoint for doctor prescription autocomplete */
    @GetMapping("/medicines/search")
    @ResponseBody
    public List<Medicine> searchMedicinesJson(@RequestParam String q) {
        return medicineService.search(q);
    }

    // ── Report Management ─────────────────────────────────────────────────
    @GetMapping("/reports")
    public String reportList(Model model) {
        model.addAttribute("reports", medicalReportService.findAll());
        return "medical/report-list";
    }

    @GetMapping("/reports/upload")
    public String uploadReportForm(Model model) {
        model.addAttribute("patients", patientService.findAll());
        return "medical/upload-report";
    }

    @PostMapping("/reports/upload")
    public String uploadReport(@RequestParam Long patientId,
                               @RequestParam String title,
                               @RequestParam(required = false) String type,
                               @RequestParam(required = false) String description,
                               @RequestParam(required = false) String results,
                               @RequestParam(required = false) MultipartFile reportFile,
                               HttpSession session, RedirectAttributes ra) {
        Patient patient = patientService.findById(patientId).orElse(null);
        if (patient == null) { ra.addFlashAttribute("error", "Patient not found."); return "redirect:/medical/reports/upload"; }

        MedicalReport report = new MedicalReport();
        report.setPatient(patient);
        report.setTitle(title);
        report.setDescription(description);
        report.setResults(results);
        report.setStatus(MedicalReport.ReportStatus.PENDING);
        User u = getSessionUser(session);
        report.setUploadedBy(u != null ? u.getFullName() : "Medical Staff");

        if (type != null && !type.isBlank()) {
            try { report.setType(MedicalReport.ReportType.valueOf(type)); } catch (Exception ignored) {}
        }

        if (reportFile != null && !reportFile.isEmpty()) {
            try {
                String uploadDir = session.getServletContext().getRealPath("/") + "uploads/reports/";
                new File(uploadDir).mkdirs();
                String fileName = UUID.randomUUID() + "_" + reportFile.getOriginalFilename();
                Path path = Paths.get(uploadDir + fileName);
                Files.write(path, reportFile.getBytes());
                report.setFilePath("/uploads/reports/" + fileName);
            } catch (Exception e) {
                ra.addFlashAttribute("error", "File upload failed: " + e.getMessage());
                return "redirect:/medical/reports/upload";
            }
        }

        medicalReportService.save(report);

        notificationService.send(patient.getUser().getId(), "PATIENT",
                "New Medical Report",
                "A new report '" + title + "' has been uploaded for you. Please check your reports section.",
                "INFO");

        logService.info("Report uploaded for patient #" + patientId + ": " + title,
                u != null ? u.getFullName() : "Medical Staff");
        ra.addFlashAttribute("success", "Report uploaded and patient notified.");
        return "redirect:/medical/reports";
    }

    @GetMapping("/prescriptions/{id}")
    public String prescriptionDetail(@PathVariable Long id, Model model, RedirectAttributes ra) {
        Prescription rx = prescriptionService.findById(id).orElse(null);
        if (rx == null) { ra.addFlashAttribute("error", "Prescription not found."); return "redirect:/medical/patients"; }
        model.addAttribute("prescription", rx);

        java.util.List<com.smarthealth.model.Medicine> allMeds = medicineService.findAll();
        model.addAttribute("allMedicines", allMeds);

        // Build bill line items
        java.util.List<java.util.Map<String, Object>> billItems = new java.util.ArrayList<>();
        java.util.List<java.util.Map<String, Object>> externalItems = new java.util.ArrayList<>();
        double grandTotal = 0.0;

        for (com.smarthealth.model.PrescribedMedicine pm : rx.getPrescribedMedicinesList()) {
            com.smarthealth.model.Medicine inv = null;
            for (com.smarthealth.model.Medicine m : allMeds) {
                if (m.getName().equalsIgnoreCase(pm.getMedicineName()) ||
                    pm.getMedicineName().toLowerCase().contains(m.getName().toLowerCase())) {
                    inv = m; break;
                }
            }

            if (inv != null) {
                // Parse timing: count doses per day from patterns like "1-0-1", "1-1-1", "Morning-Night", "TDS", "BD"
                int dosesPerDay = parseDosesPerDay(pm.getTiming());
                // Parse duration: extract number of days
                int days = parseDays(pm.getDuration());
                int totalUnitsNeeded = dosesPerDay * days;
                int unitsPerPack = inv.getUnitsPerPack() != null && inv.getUnitsPerPack() > 0 ? inv.getUnitsPerPack() : 1;
                int packsNeeded = (int) Math.ceil((double) totalUnitsNeeded / unitsPerPack);

                // Price: prefer pricePerPack, else price * unitsPerPack
                double packPrice = 0.0;
                if (inv.getPricePerPack() != null) {
                    packPrice = inv.getPricePerPack();
                } else if (inv.getPrice() != null) {
                    packPrice = inv.getPrice() * unitsPerPack;
                }
                double subtotal = packsNeeded * packPrice;
                grandTotal += subtotal;

                java.util.Map<String, Object> item = new java.util.LinkedHashMap<>();
                item.put("name", pm.getMedicineName());
                item.put("dosage", pm.getDosage());
                item.put("timing", pm.getTiming());
                item.put("duration", pm.getDuration());
                item.put("dosesPerDay", dosesPerDay);
                item.put("days", days);
                item.put("totalUnits", totalUnitsNeeded);
                item.put("unitsPerPack", unitsPerPack);
                item.put("packsNeeded", packsNeeded);
                item.put("packPrice", String.format("%.2f", packPrice));
                item.put("subtotal", String.format("%.2f", subtotal));
                item.put("form", inv.getDosageForm() != null ? inv.getDosageForm() : "");
                billItems.add(item);
            } else {
                java.util.Map<String, Object> ext = new java.util.LinkedHashMap<>();
                ext.put("name", pm.getMedicineName());
                ext.put("dosage", pm.getDosage());
                ext.put("timing", pm.getTiming());
                ext.put("duration", pm.getDuration());
                externalItems.add(ext);
            }
        }

        model.addAttribute("billItems", billItems);
        model.addAttribute("externalItems", externalItems);
        model.addAttribute("grandTotal", String.format("%.2f", grandTotal));
        model.addAttribute("availableCount", billItems.size());
        model.addAttribute("externalCount", externalItems.size());
        return "medical/prescription-detail";
    }

    /** Parse doses per day from timing string like "1-0-1"=2, "1-1-1"=3, "BD"=2, "TDS"=3, "OD"=1 */
    private int parseDosesPerDay(String timing) {
        if (timing == null || timing.isBlank()) return 1;
        String t = timing.trim().toUpperCase();
        if (t.equals("OD") || t.equals("ONCE DAILY") || t.equals("1-0-0") || t.equals("0-0-1")) return 1;
        if (t.equals("BD") || t.equals("BID") || t.equals("TWICE DAILY") || t.equals("1-0-1")) return 2;
        if (t.equals("TDS") || t.equals("TID") || t.equals("THRICE DAILY") || t.equals("1-1-1")) return 3;
        if (t.equals("QID") || t.equals("FOUR TIMES") || t.equals("1-1-1-1")) return 4;
        // Pattern like "1-0-1" — count non-zero parts
        if (t.matches("[0-9]-[0-9]-[0-9](-[0-9])?")) {
            int count = 0;
            for (String part : t.split("-")) { if (!part.equals("0")) count++; }
            return count > 0 ? count : 1;
        }
        // Count dashes + 1 as rough estimate for "Morning-Afternoon-Night"
        long dashes = timing.chars().filter(c -> c == '-').count();
        if (dashes > 0) return (int) dashes + 1;
        return 1;
    }

    /** Parse number of days from duration string like "5 days", "1 week", "10" */
    private int parseDays(String duration) {
        if (duration == null || duration.isBlank()) return 1;
        String d = duration.trim().toLowerCase();
        try {
            // "5 days", "5days", "5 day"
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d+)\\s*day").matcher(d);
            if (m.find()) return Integer.parseInt(m.group(1));
            // "2 weeks"
            m = java.util.regex.Pattern.compile("(\\d+)\\s*week").matcher(d);
            if (m.find()) return Integer.parseInt(m.group(1)) * 7;
            // "1 month"
            m = java.util.regex.Pattern.compile("(\\d+)\\s*month").matcher(d);
            if (m.find()) return Integer.parseInt(m.group(1)) * 30;
            // plain number
            m = java.util.regex.Pattern.compile("(\\d+)").matcher(d);
            if (m.find()) return Integer.parseInt(m.group(1));
        } catch (Exception ignored) {}
        return 1;
    }

    @GetMapping("/reports/{id}")
    public String viewReport(@PathVariable Long id, Model model, RedirectAttributes ra) {
        MedicalReport report = medicalReportService.findById(id).orElse(null);
        if (report == null) { ra.addFlashAttribute("error", "Report not found."); return "redirect:/medical/reports"; }
        model.addAttribute("report", report);
        return "medical/report-view";
    }

    // ── Profile / Settings ────────────────────────────────────────────────
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        model.addAttribute("user", getSessionUser(session));
        return "medical/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam(required = false) String phone,
                                HttpSession session, RedirectAttributes ra) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/auth/medical/login";
        user.setFullName(fullName);
        user.setPhone(phone);
        userService.update(user);
        session.setAttribute("sessionUser", userService.findById(user.getId()).orElse(user));
        ra.addFlashAttribute("success", "Profile updated.");
        return "redirect:/medical/profile";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session, Model model) {
        model.addAttribute("user", getSessionUser(session));
        return "medical/settings";
    }

    @PostMapping("/settings/update")
    public String updateSettings(@RequestParam(required = false) String currentPassword,
                                 @RequestParam(required = false) String newPassword,
                                 HttpSession session, RedirectAttributes ra) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/auth/medical/login";
        if (newPassword != null && !newPassword.isBlank()) {
            if (userService.checkPassword(currentPassword, user.getPassword())) {
                userService.updatePassword(user.getId(), newPassword);
                ra.addFlashAttribute("success", "Password updated.");
            } else {
                ra.addFlashAttribute("error", "Current password is incorrect.");
            }
        }
        return "redirect:/medical/settings";
    }
}
