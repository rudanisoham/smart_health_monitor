package com.smarthealth.repository.jpa;

import com.smarthealth.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorId(Long doctorId);
    List<Appointment> findByPatientId(Long patientId);
    List<Appointment> findByStatus(String status);
    List<Appointment> findByDoctorIdOrderByScheduledAtDesc(Long doctorId);
    List<Appointment> findByPatientIdOrderByScheduledAtDesc(Long patientId);
    long countByDoctorId(Long doctorId);
    long countByPatientId(Long patientId);
}
