package com.smarthealth.controller;

import com.smarthealth.model.*;
import com.smarthealth.service.DepartmentService;
import com.smarthealth.repository.jpa.BedRepository;
import com.smarthealth.repository.jpa.PatientRepository;
import com.smarthealth.repository.jpa.DoctorRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/department")
public class DepartmentController {

    @Autowired private DepartmentService departmentService;
    @Autowired private BedRepository bedRepository;
    @Autowired private PatientRepository patientRepository;
    @Autowired private DoctorRepository doctorRepository;

    @GetMapping("/{id}/dashboard")
    public String dashboard(@PathVariable Long id, Model model) {
        Department department = departmentService.findById(id).orElse(null);
        if (department == null) return "redirect:/";

        model.addAttribute("department", department);
        model.addAttribute("beds", bedRepository.findByDepartmentId(id));
        model.addAttribute("patients", patientRepository.findByDepartmentId(id));
        model.addAttribute("doctors", doctorRepository.findByDepartmentId(id));

        return "department/dashboard";
    }

    @GetMapping("/{id}/beds")
    public String bedManagement(@PathVariable Long id, Model model) {
        Department department = departmentService.findById(id).orElse(null);
        if (department == null) return "redirect:/";

        model.addAttribute("department", department);
        model.addAttribute("beds", bedRepository.findByDepartmentId(id));
        model.addAttribute("patients", patientRepository.findByDepartmentId(id));

        return "department/bed-management";
    }

    @PostMapping("/beds/assign")
    public String assignBed(@RequestParam Long bedId, @RequestParam Long patientId, @RequestParam Long departmentId, RedirectAttributes ra) {
        Bed bed = bedRepository.findById(bedId).orElse(null);
        Patient patient = patientRepository.findById(patientId).orElse(null);
        Department department = departmentService.findById(departmentId).orElse(null);

        if (bed != null && patient != null && department != null && bed.getStatus() == Bed.BedStatus.AVAILABLE) {
            bed.setPatient(patient);
            bed.setStatus(Bed.BedStatus.OCCUPIED);
            bedRepository.save(bed);

            department.setAvailableBeds(department.getAvailableBeds() > 0 ? department.getAvailableBeds() - 1 : 0);
            department.setOccupiedBeds(department.getOccupiedBeds() + 1);
            departmentService.save(department);

            ra.addFlashAttribute("success", "Bed assigned to patient.");
        } else {
            ra.addFlashAttribute("error", "Cannot assign bed. Invalid selection or bed occupied.");
        }
        return "redirect:/department/" + departmentId + "/beds";
    }

    @PostMapping("/beds/release")
    public String releaseBed(@RequestParam Long bedId, @RequestParam Long departmentId, RedirectAttributes ra) {
        Bed bed = bedRepository.findById(bedId).orElse(null);
        Department department = departmentService.findById(departmentId).orElse(null);

        if (bed != null && department != null && bed.getStatus() == Bed.BedStatus.OCCUPIED) {
            bed.setPatient(null);
            bed.setStatus(Bed.BedStatus.AVAILABLE);
            bedRepository.save(bed);

            department.setAvailableBeds(department.getAvailableBeds() + 1);
            department.setOccupiedBeds(department.getOccupiedBeds() > 0 ? department.getOccupiedBeds() - 1 : 0);
            departmentService.save(department);

            ra.addFlashAttribute("success", "Bed released.");
        } else {
            ra.addFlashAttribute("error", "Cannot release bed. Invalid selection.");
        }
        return "redirect:/department/" + departmentId + "/beds";
    }
}
