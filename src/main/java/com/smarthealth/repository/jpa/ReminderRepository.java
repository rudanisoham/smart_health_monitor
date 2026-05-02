package com.smarthealth.repository.jpa;

import com.smarthealth.model.Patient;
import com.smarthealth.model.Reminder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalTime;
import java.util.List;

@Repository
public interface ReminderRepository extends JpaRepository<Reminder, Long> {
    List<Reminder> findByPatientAndIsActive(Patient patient, Boolean isActive);
    List<Reminder> findByIsActiveAndReminderTimeBetween(Boolean isActive, LocalTime start, LocalTime end);
}
