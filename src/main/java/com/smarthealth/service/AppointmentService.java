package com.smarthealth.service;

import com.smarthealth.model.Appointment;
import com.smarthealth.model.Doctor;
import com.smarthealth.repository.jpa.AppointmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    // Average minutes per appointment slot
    private static final int SLOT_MINUTES = 20;

    /** Patient books — goes to AWAITING_ASSIGNMENT queue for reception */
    public Appointment book(Appointment appointment) {
        appointment.setStatus("AWAITING_ASSIGNMENT");
        return appointmentRepository.save(appointment);
    }

    /**
     * Reception assigns doctor + scheduled time.
     * Auto-generates token number and estimated arrival time.
     */
    public Appointment assignByReception(Long id, Doctor doctor, LocalDateTime scheduledAt) {
        Appointment appt = appointmentRepository.findById(id).orElse(null);
        if (appt == null) return null;

        appt.setDoctor(doctor);
        appt.setScheduledAt(scheduledAt);
        appt.setStatus("PENDING");
        appt.setAssignedByReception(true);

        // Generate token: max existing token for that doctor on that day + 1
        LocalDateTime dayStart = scheduledAt.toLocalDate().atStartOfDay();
        LocalDateTime dayEnd   = scheduledAt.toLocalDate().atTime(LocalTime.MAX);
        Integer maxToken = appointmentRepository.maxTokenByDoctorAndDate(doctor.getId(), dayStart, dayEnd);
        int token = (maxToken != null ? maxToken : 0) + 1;
        appt.setTokenNumber(token);

        // Estimated time = scheduledAt + (token - 1) * SLOT_MINUTES
        // (first patient at exact scheduledAt, each subsequent one SLOT_MINUTES later)
        LocalDateTime estimated = scheduledAt.plusMinutes((long)(token - 1) * SLOT_MINUTES);
        appt.setEstimatedTime(estimated);

        return appointmentRepository.save(appt);
    }

    public void cancel(Long id) {
        appointmentRepository.findById(id).ifPresent(a -> {
            a.setStatus("CANCELLED");
            appointmentRepository.save(a);
        });
    }

    public void confirm(Long id) {
        appointmentRepository.findById(id).ifPresent(a -> {
            a.setStatus("CONFIRMED");
            appointmentRepository.save(a);
        });
    }

    public void complete(Long id) {
        appointmentRepository.findById(id).ifPresent(a -> {
            a.setStatus("COMPLETED");
            appointmentRepository.save(a);
        });
    }

    public Optional<Appointment> findById(Long id) {
        return appointmentRepository.findById(id);
    }

    public List<Appointment> findByDoctorId(Long doctorId) {
        return appointmentRepository.findByDoctorIdOrderByScheduledAtDesc(doctorId);
    }

    public List<Appointment> findByPatientId(Long patientId) {
        return appointmentRepository.findByPatientIdOrderByScheduledAtDesc(patientId);
    }

    public List<Appointment> findAll() {
        return appointmentRepository.findAll();
    }

    public List<Appointment> findAwaitingAssignment() {
        return appointmentRepository.findByStatusOrderByCreatedAtDesc("AWAITING_ASSIGNMENT");
    }

    /** Doctor's schedule for a specific date */
    public List<Appointment> findByDoctorIdAndDate(Long doctorId, LocalDate date) {
        return appointmentRepository.findByDoctorIdAndDate(
                doctorId, date.atStartOfDay(), date.atTime(LocalTime.MAX));
    }

    /** Today's appointment count for a doctor */
    public long countTodayByDoctorId(Long doctorId) {
        LocalDate today = LocalDate.now();
        return appointmentRepository.countByDoctorIdAndDate(
                doctorId, today.atStartOfDay(), today.atTime(LocalTime.MAX));
    }

    public long countByDoctorId(Long doctorId) {
        return appointmentRepository.countByDoctorId(doctorId);
    }

    public long countByPatientId(Long patientId) {
        return appointmentRepository.countByPatientId(patientId);
    }

    public long count() {
        return appointmentRepository.count();
    }

    public long countAwaitingAssignment() {
        return appointmentRepository.countByStatus("AWAITING_ASSIGNMENT");
    }

    public boolean isTimeSlotOccupied(Long doctorId, LocalDateTime scheduledAt) {
        return appointmentRepository.existsByDoctorIdAndScheduledAtAndStatusNot(doctorId, scheduledAt, "CANCELLED");
    }
}
