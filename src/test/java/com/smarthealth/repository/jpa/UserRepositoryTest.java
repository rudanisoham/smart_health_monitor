package com.smarthealth.repository.jpa;

import com.smarthealth.config.TestConfig;
import com.smarthealth.model.Role;
import com.smarthealth.model.User;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringJUnitConfig(TestConfig.class)
@Transactional
public class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    void shouldSaveAndFindUserByEmail() {
        User user = new User();
        user.setEmail("repo@test.com");
        user.setFullName("Repo Test");
        user.setPassword("secret");
        user.setRole(Role.PATIENT);
        user.setActive(true);

        userRepository.save(user);

        Optional<User> found = userRepository.findByEmail("repo@test.com");
        assertTrue(found.isPresent());
        assertEquals("Repo Test", found.get().getFullName());
    }

    @Test
    void shouldReturnEmptyForNonExistentEmail() {
        Optional<User> found = userRepository.findByEmail("non@existent.com");
        assertFalse(found.isPresent());
    }

    @Test
    void shouldCheckIfEmailExists() {
        User user = new User();
        user.setEmail("exists@test.com");
        user.setFullName("Exists Test");
        user.setPassword("secret");
        user.setRole(Role.PATIENT);
        userRepository.save(user);

        assertTrue(userRepository.existsByEmail("exists@test.com"));
        assertFalse(userRepository.existsByEmail("missing@test.com"));
    }
}
