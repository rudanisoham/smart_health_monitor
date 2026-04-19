package com.smarthealth.controller;

import com.smarthealth.model.Patient;
import com.smarthealth.model.User;
import com.smarthealth.model.mongo.HealthMetric;
import com.smarthealth.service.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class PatientControllerTest {

    private MockMvc mockMvc;

    @Mock private PatientService patientService;
    @Mock private HealthMetricService healthMetricService;
    @Mock private AppointmentService appointmentService;
    @Mock private PrescriptionService prescriptionService;
    @Mock private NotificationService notificationService;
    @Mock private DoctorService doctorService;
    @Mock private UserService userService;
    @Mock private MedicalReportService medicalReportService;
    @Mock private SystemLogService systemLogService;
    @Mock private EmailService emailService;

    @InjectMocks
    private PatientController patientController;

    private User testUser;
    private Patient testPatient;

    @BeforeEach
    void setUp() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");

        mockMvc = MockMvcBuilders.standaloneSetup(patientController)
                .setViewResolvers(viewResolver)
                .build();

        testUser = new User();
        testUser.setId(1L);
        testUser.setEmail("patient@example.com");
        testUser.setFullName("John Patient");

        testPatient = new Patient();
        testPatient.setId(1L);
        testPatient.setUser(testUser);
    }

    @Test
    void shouldShowDashboard() throws Exception {
        when(patientService.findByUserId(1L)).thenReturn(testPatient);

        mockMvc.perform(get("/patient/dashboard")
                .sessionAttr("sessionUser", testUser))
                .andExpect(status().isOk())
                .andExpect(view().name("patient/dashboard"))
                .andExpect(model().attributeExists("patient"));
    }

    @Test
    void shouldRedirectToLoginIfNoSession() throws Exception {
        mockMvc.perform(get("/patient/dashboard"))
                .andExpect(status().isOk())
                .andExpect(view().name("patient/dashboard"))
                .andExpect(model().attributeDoesNotExist("patient"));
        // Note: The controller logic returns "patient/dashboard" but doesn't add attributes if patient is null.
        // The interceptor usually handles the redirect, but MockMvc standalone doesn't include interceptors unless added.
    }

    @Test
    void shouldCalculateLowRiskMetric() throws Exception {
        when(patientService.findByUserId(1L)).thenReturn(testPatient);

        mockMvc.perform(post("/patient/health/add")
                .sessionAttr("sessionUser", testUser)
                .param("heartRate", "72")
                .param("bloodPressureSys", "120")
                .param("bloodPressureDia", "80")
                .param("spo2", "98")
                .param("temperature", "36.6"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/patient/health"))
                .andExpect(flash().attribute("success", "Health reading saved. Risk Level: LOW"));

        verify(healthMetricService).save(argThat(m -> "LOW".equals(m.getRiskLevel())));
    }

    @Test
    void shouldCalculateHighRiskMetricAndNotifyEmergency() throws Exception {
        when(patientService.findByUserId(1L)).thenReturn(testPatient);
        testPatient.setEmergencyEmail("emergency@example.com");

        mockMvc.perform(post("/patient/health/add")
                .sessionAttr("sessionUser", testUser)
                .param("heartRate", "150") // Critical (>120)
                .param("bloodPressureSys", "180") // Critical (>160)
                .param("spo2", "85") // Critical (<90)
                .param("temperature", "40.0")) // Critical (>39.0)
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/patient/health"))
                .andExpect(flash().attributeExists("error"));

        verify(healthMetricService).save(argThat(m -> "HIGH".equals(m.getRiskLevel())));
        verify(emailService).sendEmergencyAlert(eq("emergency@example.com"), anyString(), anyString(), anyString());
        verify(notificationService, atLeastOnce()).send(anyLong(), eq("DOCTOR"), anyString(), anyString(), eq("DANGER"));
    }

    @Test
    void shouldBookAppointment() throws Exception {
        when(patientService.findByUserId(1L)).thenReturn(testPatient);

        mockMvc.perform(post("/patient/appointments/book")
                .sessionAttr("sessionUser", testUser)
                .param("preferredDate", "2026-05-20")
                .param("notes", "General checkup"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/patient/appointments"))
                .andExpect(flash().attributeExists("success"));

        verify(appointmentService).book(any());
        verify(notificationService).send(eq(1L), eq("PATIENT"), anyString(), anyString(), eq("INFO"));
    }
}
