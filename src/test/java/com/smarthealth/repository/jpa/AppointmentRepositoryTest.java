package com.smarthealth.repository.jpa;

import com.smarthealth.config.TestConfig;
import com.smarthealth.model.Appointment;
import com.smarthealth.model.Doctor;
import com.smarthealth.model.Patient;
import com.smarthealth.model.Role;
import com.smarthealth.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@SpringJUnitConfig(TestConfig.class)
@Transactional
public class AppointmentRepositoryTest {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PatientRepository patientRepository;

    private Doctor testDoctor;
    private Patient testPatient;

    @BeforeEach
    void setUp() {
        User u1 = new User(); u1.setEmail("doc@test.com"); u1.setRole(Role.DOCTOR); u1.setPassword("p");
        userRepository.save(u1);
        testDoctor = new Doctor(); testDoctor.setUser(u1); testDoctor.setLicenseNumber("123");
        doctorRepository.save(testDoctor);

        User u2 = new User(); u2.setEmail("pat@test.com"); u2.setRole(Role.PATIENT); u2.setPassword("p");
        userRepository.save(u2);
        testPatient = new Patient(); testPatient.setUser(u2);
        patientRepository.save(testPatient);
    }

    @Test
    void shouldFindMaxTokenNumber() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startOfDay = now.toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = now.toLocalDate().atTime(23, 59, 59);

        // First appointment
        Appointment a1 = new Appointment();
        a1.setDoctor(testDoctor);
        a1.setPatient(testPatient);
        a1.setScheduledAt(now);
        a1.setTokenNumber(1);
        a1.setStatus("PENDING");
        appointmentRepository.save(a1);

        // Second appointment
        Appointment a2 = new Appointment();
        a2.setDoctor(testDoctor);
        a2.setPatient(testPatient);
        a2.setScheduledAt(now.plusHours(1));
        a2.setTokenNumber(2);
        a2.setStatus("PENDING");
        appointmentRepository.save(a2);

        Integer maxToken = appointmentRepository.maxTokenByDoctorAndDate(testDoctor.getId(), startOfDay, endOfDay);
        assertEquals(2, maxToken);
    }

    @Test
    void shouldReturnNullMaxTokenIfNoAppointments() {
        LocalDateTime now = LocalDateTime.now();
        Integer maxToken = appointmentRepository.maxTokenByDoctorAndDate(testDoctor.getId(), now.toLocalDate().atStartOfDay(), now.toLocalDate().atTime(23, 59, 59));
        assertNull(maxToken);
    }
}
