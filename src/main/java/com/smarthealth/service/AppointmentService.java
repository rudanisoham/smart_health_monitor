package com.smarthealth.service;

import com.smarthealth.model.Appointment;
import com.smarthealth.repository.jpa.AppointmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    public Appointment book(Appointment appointment) {
        appointment.setStatus("PENDING");
        return appointmentRepository.save(appointment);
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

    public long countByDoctorId(Long doctorId) {
        return appointmentRepository.countByDoctorId(doctorId);
    }

    public long countByPatientId(Long patientId) {
        return appointmentRepository.countByPatientId(patientId);
    }

    public long count() {
        return appointmentRepository.count();
    }
}
