package com.smarthealth.service;

import com.smarthealth.repository.jpa.AppointmentRepository;
import com.smarthealth.repository.jpa.DoctorRepository;
import com.smarthealth.repository.jpa.PatientRepository;
import com.smarthealth.repository.jpa.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class DashboardService {

    @Autowired private UserRepository userRepository;
    @Autowired private DoctorRepository doctorRepository;
    @Autowired private PatientRepository patientRepository;
    @Autowired private AppointmentRepository appointmentRepository;

    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", userRepository.count());
        stats.put("totalDoctors", doctorRepository.count());
        stats.put("activeDoctors", doctorRepository.findByStatus("ACTIVE").size());
        stats.put("pendingDoctors", doctorRepository.findByIsApprovedFalse().size());
        stats.put("totalPatients", patientRepository.count());
        stats.put("totalAppointments", appointmentRepository.count());
        stats.put("awaitingAssignment", appointmentRepository.countByStatus("AWAITING_ASSIGNMENT"));
        return stats;
    }
}
