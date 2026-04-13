package com.smarthealth.service;

import com.smarthealth.model.Bed;
import com.smarthealth.model.Department;
import com.smarthealth.model.Patient;
import com.smarthealth.repository.jpa.BedRepository;
import com.smarthealth.repository.jpa.DepartmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BedService {

    @Autowired private BedRepository bedRepository;
    @Autowired private DepartmentRepository departmentRepository;

    public List<Bed> findByDepartmentId(Long deptId) {
        return bedRepository.findByDepartmentId(deptId);
    }

    public List<Bed> findAvailableByDepartmentId(Long deptId) {
        return bedRepository.findByDepartmentId(deptId).stream()
                .filter(b -> b.getStatus() == Bed.BedStatus.AVAILABLE)
                .toList();
    }

    public Optional<Bed> findById(Long id) {
        return bedRepository.findById(id);
    }

    public Bed save(Bed bed) {
        return bedRepository.save(bed);
    }

    /** Assign a specific bed to a patient and sync department counters */
    public boolean assignBed(Long bedId, Patient patient) {
        Bed bed = bedRepository.findById(bedId).orElse(null);
        if (bed == null || bed.getStatus() != Bed.BedStatus.AVAILABLE) return false;

        bed.setPatient(patient);
        bed.setStatus(Bed.BedStatus.OCCUPIED);
        bedRepository.save(bed);

        // Sync department counters
        Department dept = bed.getDepartment();
        dept.setOccupiedBeds(dept.getOccupiedBeds() + 1);
        dept.setAvailableBeds(Math.max(0, dept.getAvailableBeds() - 1));
        dept.setCurrOccupancy(dept.getCurrOccupancy() + 1);
        departmentRepository.save(dept);
        return true;
    }

    /** Release a bed and sync department counters */
    public boolean releaseBed(Long bedId) {
        Bed bed = bedRepository.findById(bedId).orElse(null);
        if (bed == null || bed.getStatus() != Bed.BedStatus.OCCUPIED) return false;

        bed.setPatient(null);
        bed.setStatus(Bed.BedStatus.AVAILABLE);
        bedRepository.save(bed);

        Department dept = bed.getDepartment();
        if (dept.getOccupiedBeds() > 0) dept.setOccupiedBeds(dept.getOccupiedBeds() - 1);
        dept.setAvailableBeds(dept.getAvailableBeds() + 1);
        if (dept.getCurrOccupancy() > 0) dept.setCurrOccupancy(dept.getCurrOccupancy() - 1);
        departmentRepository.save(dept);
        return true;
    }

    /** Auto-create beds for a department based on totalBeds and icuBeds */
    public void initBedsForDepartment(Department dept) {
        int existing = bedRepository.findByDepartmentId(dept.getId()).size();
        if (existing > 0) return; // already initialized

        int total = dept.getTotalBeds() != null ? dept.getTotalBeds() : 0;
        int icu = dept.getIcuBeds() != null ? dept.getIcuBeds() : 0;
        int normal = total - icu;

        for (int i = 1; i <= normal; i++) {
            Bed b = new Bed();
            b.setDepartment(dept);
            b.setBedNumber(dept.getCode() + "-N" + String.format("%02d", i));
            b.setType(Bed.BedType.NORMAL);
            b.setStatus(Bed.BedStatus.AVAILABLE);
            bedRepository.save(b);
        }
        for (int i = 1; i <= icu; i++) {
            Bed b = new Bed();
            b.setDepartment(dept);
            b.setBedNumber(dept.getCode() + "-ICU" + String.format("%02d", i));
            b.setType(Bed.BedType.ICU);
            b.setStatus(Bed.BedStatus.AVAILABLE);
            bedRepository.save(b);
        }

        // Sync available beds count
        dept.setAvailableBeds(total);
        dept.setOccupiedBeds(0);
        departmentRepository.save(dept);
    }

    /**
     * Re-sync bed records when admin edits totalBeds / icuBeds.
     * Adds missing beds, removes excess AVAILABLE beds (never removes OCCUPIED).
     */
    public void syncBedsForDepartment(Department dept) {
        int targetTotal = dept.getTotalBeds() != null ? dept.getTotalBeds() : 0;
        int targetIcu   = dept.getIcuBeds()   != null ? dept.getIcuBeds()   : 0;
        int targetNormal = targetTotal - targetIcu;

        List<Bed> existing = bedRepository.findByDepartmentId(dept.getId());
        long existingNormal = existing.stream().filter(b -> b.getType() == Bed.BedType.NORMAL).count();
        long existingIcu    = existing.stream().filter(b -> b.getType() == Bed.BedType.ICU).count();

        // Add missing NORMAL beds
        for (long i = existingNormal + 1; i <= targetNormal; i++) {
            Bed b = new Bed();
            b.setDepartment(dept);
            b.setBedNumber(dept.getCode() + "-N" + String.format("%02d", i));
            b.setType(Bed.BedType.NORMAL);
            b.setStatus(Bed.BedStatus.AVAILABLE);
            bedRepository.save(b);
        }
        // Remove excess AVAILABLE NORMAL beds
        if (existingNormal > targetNormal) {
            existing.stream()
                .filter(b -> b.getType() == Bed.BedType.NORMAL && b.getStatus() == Bed.BedStatus.AVAILABLE)
                .skip(0)
                .limit(existingNormal - targetNormal)
                .forEach(bedRepository::delete);
        }

        // Add missing ICU beds
        for (long i = existingIcu + 1; i <= targetIcu; i++) {
            Bed b = new Bed();
            b.setDepartment(dept);
            b.setBedNumber(dept.getCode() + "-ICU" + String.format("%02d", i));
            b.setType(Bed.BedType.ICU);
            b.setStatus(Bed.BedStatus.AVAILABLE);
            bedRepository.save(b);
        }
        // Remove excess AVAILABLE ICU beds
        if (existingIcu > targetIcu) {
            existing.stream()
                .filter(b -> b.getType() == Bed.BedType.ICU && b.getStatus() == Bed.BedStatus.AVAILABLE)
                .skip(0)
                .limit(existingIcu - targetIcu)
                .forEach(bedRepository::delete);
        }

        // Recalculate available count from actual DB records
        long occupied = bedRepository.findByDepartmentId(dept.getId()).stream()
                .filter(b -> b.getStatus() == Bed.BedStatus.OCCUPIED).count();
        long total = bedRepository.findByDepartmentId(dept.getId()).size();
        dept.setOccupiedBeds((int) occupied);
        dept.setAvailableBeds((int) (total - occupied));
        dept.setTotalBeds((int) total);
        departmentRepository.save(dept);
    }

    public long countAvailableInDepartment(Long deptId) {
        return bedRepository.findByDepartmentId(deptId).stream()
                .filter(b -> b.getStatus() == Bed.BedStatus.AVAILABLE).count();
    }
}
