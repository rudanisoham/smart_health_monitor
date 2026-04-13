package com.smarthealth.repository.jpa;

import com.smarthealth.model.TimeSlot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface TimeSlotRepository extends JpaRepository<TimeSlot, Long> {
    List<TimeSlot> findByDoctorIdAndSlotDate(Long doctorId, LocalDate slotDate);
    List<TimeSlot> findByDoctorIdAndSlotDateAndIsBookedFalse(Long doctorId, LocalDate slotDate);
}
