package com.smarthealth.service;

import com.smarthealth.model.Appointment;
import com.smarthealth.model.Doctor;
import com.smarthealth.model.Patient;
import com.smarthealth.repository.jpa.AppointmentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AppointmentServiceTest {

    @Mock
    private AppointmentRepository appointmentRepository;

    @InjectMocks
    private AppointmentService appointmentService;

    private Appointment testAppointment;
    private Doctor testDoctor;
    private Patient testPatient;

    @BeforeEach
    void setUp() {
        testPatient = new Patient();
        testPatient.setId(1L);

        testDoctor = new Doctor();
        testDoctor.setId(1L);

        testAppointment = new Appointment();
        testAppointment.setId(1L);
        testAppointment.setPatient(testPatient);
        testAppointment.setStatus("PENDING");
    }

    @Test
    void shouldBookAppointmentSuccessfully() {
        when(appointmentRepository.save(any(Appointment.class))).thenReturn(testAppointment);

        Appointment booked = appointmentService.book(testAppointment);

        assertNotNull(booked);
        assertEquals("AWAITING_ASSIGNMENT", booked.getStatus());
        verify(appointmentRepository).save(testAppointment);
    }

    @Test
    void shouldAssignDoctorAndGenerateTokenSuccessfully() {
        testAppointment.setStatus("AWAITING_ASSIGNMENT");
        LocalDateTime scheduledTime = LocalDateTime.now().plusDays(1);
        
        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(testAppointment));
        // Mock maxToken call: say there are 2 tokens already
        when(appointmentRepository.maxTokenByDoctorAndDate(anyLong(), any(), any())).thenReturn(2);
        when(appointmentRepository.save(any(Appointment.class))).thenReturn(testAppointment);

        Appointment assigned = appointmentService.assignByReception(1L, testDoctor, scheduledTime);

        assertNotNull(assigned);
        assertEquals(testDoctor, assigned.getDoctor());
        assertEquals("PENDING", assigned.getStatus());
        assertEquals(3, assigned.getTokenNumber());
        // Slot is 20 mins. For token 3, estimated = scheduled + (3-1)*20 = scheduled + 40 mins
        assertEquals(scheduledTime.plusMinutes(40), assigned.getEstimatedTime());
        verify(appointmentRepository).save(testAppointment);
    }

    @Test
    void shouldCancelAppointment() {
        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(testAppointment));

        appointmentService.cancel(1L);

        assertEquals("CANCELLED", testAppointment.getStatus());
        verify(appointmentRepository).save(testAppointment);
    }

    @Test
    void shouldConfirmAppointment() {
        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(testAppointment));

        appointmentService.confirm(1L);

        assertEquals("CONFIRMED", testAppointment.getStatus());
        verify(appointmentRepository).save(testAppointment);
    }

    @Test
    void shouldCompleteAppointment() {
        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(testAppointment));

        appointmentService.complete(1L);

        assertEquals("COMPLETED", testAppointment.getStatus());
        verify(appointmentRepository).save(testAppointment);
    }

    @Test
    void shouldCheckIfTimeSlotIsOccupied() {
        LocalDateTime time = LocalDateTime.now();
        when(appointmentRepository.existsByDoctorIdAndScheduledAtAndStatusNot(1L, time, "CANCELLED")).thenReturn(true);

        boolean occupied = appointmentService.isTimeSlotOccupied(1L, time);

        assertTrue(occupied);
    }
}
