package com.smarthealth.controller;

import com.smarthealth.model.Role;
import com.smarthealth.model.User;
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

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class AuthControllerTest {

    private MockMvc mockMvc;

    @Mock private UserService userService;
    @Mock private DoctorService doctorService;
    @Mock private PatientService patientService;
    @Mock private SystemLogService logService;
    @Mock private DepartmentService departmentService;

    @InjectMocks
    private AuthController authController;

    private User testUser;

    @BeforeEach
    void setUp() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");

        mockMvc = MockMvcBuilders.standaloneSetup(authController)
                .setViewResolvers(viewResolver)
                .build();

        testUser = new User();
        testUser.setId(1L);
        testUser.setEmail("admin@smarthealth.com");
        testUser.setPassword("password");
        testUser.setRole(Role.ADMIN);
        testUser.setFullName("Admin User");
    }

    @Test
    void shouldReturnAdminLoginPage() throws Exception {
        mockMvc.perform(get("/auth/admin/login"))
                .andExpect(status().isOk())
                .andExpect(view().name("auth/admin-login"));
    }

    @Test
    void shouldLoginSuccessfullyAsAdmin() throws Exception {
        when(userService.login(anyString(), anyString())).thenReturn(testUser);

        mockMvc.perform(post("/auth/login")
                .param("email", "admin@smarthealth.com")
                .param("password", "password")
                .param("roleStr", "ADMIN"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/admin/dashboard"))
                .andExpect(request().sessionAttribute("sessionUser", testUser));

        verify(logService).info(contains("logged in"), anyString());
    }

    @Test
    void shouldFailLoginWithWrongRole() throws Exception {
        when(userService.login(anyString(), anyString())).thenReturn(testUser); // User is ADMIN

        mockMvc.perform(post("/auth/login")
                .param("email", "admin@smarthealth.com")
                .param("password", "password")
                .param("roleStr", "DOCTOR")) // Trying to login as DOCTOR
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/auth/doctor/login"))
                .andExpect(flash().attribute("error", containsString("don't have access as DOCTOR")));
    }

    @Test
    void shouldFailLoginWithInvalidCredentials() throws Exception {
        when(userService.login(anyString(), anyString())).thenReturn(null);

        mockMvc.perform(post("/auth/login")
                .param("email", "wrong@example.com")
                .param("password", "wrong")
                .param("roleStr", "PATIENT"))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/auth/patient/login"))
                .andExpect(flash().attribute("error", "Invalid email or password."));
    }

    @Test
    void shouldLogoutSuccessfully() throws Exception {
        mockMvc.perform(get("/auth/logout").sessionAttr("sessionUser", testUser))
                .andExpect(status().isFound())
                .andExpect(redirectedUrl("/"))
                .andExpect(request().sessionAttributeDoesNotExist("sessionUser"));

        verify(logService).info(contains("logged out"), anyString());
    }
}
