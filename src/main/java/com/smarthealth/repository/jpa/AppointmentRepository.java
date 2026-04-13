package com.smarthealth.repository.jpa;

import com.smarthealth.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorId(Long doctorId);
    List<Appointment> findByPatientId(Long patientId);
    List<Appointment> findByStatus(String status);
    List<Appointment> findByDoctorIdOrderByScheduledAtDesc(Long doctorId);
    List<Appointment> findByPatientIdOrderByScheduledAtDesc(Long patientId);
    List<Appointment> findByStatusOrderByCreatedAtDesc(String status);
    long countByDoctorId(Long doctorId);
    long countByPatientId(Long patientId);
    long countByStatus(String status);
    boolean existsByDoctorIdAndScheduledAtAndStatusNot(Long doctorId, LocalDateTime scheduledAt, String status);

    /** Appointments for a doctor on a specific date range (for schedule view) */
    @Query("SELECT a FROM Appointment a WHERE a.doctor.id = :doctorId AND a.scheduledAt >= :start AND a.scheduledAt < :end AND a.status != 'CANCELLED' ORDER BY a.scheduledAt ASC")
    List<Appointment> findByDoctorIdAndDate(@Param("doctorId") Long doctorId,
                                             @Param("start") LocalDateTime start,
                                             @Param("end") LocalDateTime end);

    /** Count today's appointments for a doctor (for token numbering) */
    @Query("SELECT COUNT(a) FROM Appointment a WHERE a.doctor.id = :doctorId AND a.scheduledAt >= :start AND a.scheduledAt < :end AND a.status != 'CANCELLED'")
    long countByDoctorIdAndDate(@Param("doctorId") Long doctorId,
                                 @Param("start") LocalDateTime start,
                                 @Param("end") LocalDateTime end);

    /** Max token number for a doctor on a given date */
    @Query("SELECT COALESCE(MAX(a.tokenNumber), 0) FROM Appointment a WHERE a.doctor.id = :doctorId AND a.scheduledAt >= :start AND a.scheduledAt < :end")
    Integer maxTokenByDoctorAndDate(@Param("doctorId") Long doctorId,
                                     @Param("start") LocalDateTime start,
                                     @Param("end") LocalDateTime end);
}
