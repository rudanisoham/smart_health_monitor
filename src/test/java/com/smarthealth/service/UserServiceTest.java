package com.smarthealth.service;

import com.smarthealth.model.Role;
import com.smarthealth.model.User;
import com.smarthealth.repository.jpa.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User testUser;
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setId(1L);
        testUser.setEmail("test@smarthealth.com");
        testUser.setFullName("Test User");
        testUser.setRole(Role.PATIENT);
        testUser.setPassword("password123");
    }

    @Test
    void shouldRegisterUserSuccessfully() {
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        User savedUser = userService.register(testUser);

        assertNotNull(savedUser);
        assertTrue(encoder.matches("password123", savedUser.getPassword()));
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void shouldLoginSuccessfullyWithValidCredentials() {
        String rawPassword = "password123";
        testUser.setPassword(encoder.encode(rawPassword));
        
        when(userRepository.findByEmail(testUser.getEmail())).thenReturn(Optional.of(testUser));
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        User loggedInUser = userService.login(testUser.getEmail(), rawPassword);

        assertNotNull(loggedInUser);
        assertEquals(testUser.getEmail(), loggedInUser.getEmail());
        assertNotNull(loggedInUser.getLastLogin());
    }

    @Test
    void shouldFailLoginWithInvalidPassword() {
        String rawPassword = "wrongPassword";
        testUser.setPassword(encoder.encode("correctPassword"));
        
        when(userRepository.findByEmail(testUser.getEmail())).thenReturn(Optional.of(testUser));

        User loggedInUser = userService.login(testUser.getEmail(), rawPassword);

        assertNull(loggedInUser);
    }

    @Test
    void shouldFailLoginWithNonExistentEmail() {
        when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());

        User loggedInUser = userService.login("nonexistent@example.com", "password123");

        assertNull(loggedInUser);
    }

    @Test
    void shouldUpdatePasswordSuccessfully() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));
        
        userService.updatePassword(1L, "newPassword456");

        assertTrue(encoder.matches("newPassword456", testUser.getPassword()));
        verify(userRepository, times(1)).save(testUser);
    }

    @Test
    void shouldDeactivateUser() {
        testUser.setActive(true);
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));

        userService.deactivate(1L);

        assertFalse(testUser.isActive());
        verify(userRepository, times(1)).save(testUser);
    }
}
