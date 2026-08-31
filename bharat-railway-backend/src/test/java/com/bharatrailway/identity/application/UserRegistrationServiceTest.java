/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Hitanshu Dhakrey
 * Assisted by: Chandra Shekhar Bansal (Infrastructure), DeepSeek (AI Scribe)
 * Date: 2026-06-20
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Unit tests for UserRegistrationService.
 * Verifies duplicate detection for username, email, and mobile number.
 */

package com.bharatrailway.identity.application;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import static org.mockito.ArgumentMatchers.any;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.bharatrailway.identity.application.dto.RegistrationRequest;
import com.bharatrailway.identity.infrastructure.UserRepository;
import com.bharatrailway.shared.exception.ResourceAlreadyExistsException;

@ExtendWith(MockitoExtension.class)
class UserRegistrationServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private BCryptPasswordEncoder passwordEncoder;

    @InjectMocks
    private UserRegistrationService userRegistrationService;

    private RegistrationRequest validRequest() {
        RegistrationRequest request = new RegistrationRequest();
        request.setFullName("Test User");
        request.setUsername("newuser");
        request.setEmail("newuser@bharatrailway.com");
        request.setMobileNumber("+919876543210");
        request.setPassword("Test@1234");
        request.setDateOfBirth(LocalDate.of(1995, 6, 15));
        request.setGender("M");
        return request;
    }

    @Test
    void shouldRegisterSuccessfullyWhenNoDuplicates() {
        RegistrationRequest request = validRequest();
        when(userRepository.existsByUsername(request.getUsername())).thenReturn(false);
        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(userRepository.existsByMobileNumber(request.getMobileNumber())).thenReturn(false);
        when(passwordEncoder.encode(request.getPassword())).thenReturn("hashed");
        when(userRepository.save(any())).thenReturn(null);

        assertDoesNotThrow(() -> userRegistrationService.register(request));
    }

    @Test
    void shouldThrowExceptionWhenUsernameExists() {
        RegistrationRequest request = validRequest();
        when(userRepository.existsByUsername(request.getUsername())).thenReturn(true);

        assertThrows(ResourceAlreadyExistsException.class,
                () -> userRegistrationService.register(request));
    }

    @Test
    void shouldThrowExceptionWhenEmailExists() {
        RegistrationRequest request = validRequest();
        when(userRepository.existsByUsername(request.getUsername())).thenReturn(false);
        when(userRepository.existsByEmail(request.getEmail())).thenReturn(true);

        assertThrows(ResourceAlreadyExistsException.class,
                () -> userRegistrationService.register(request));
    }

    @Test
    void shouldThrowExceptionWhenMobileExists() {
        RegistrationRequest request = validRequest();
        when(userRepository.existsByUsername(request.getUsername())).thenReturn(false);
        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(userRepository.existsByMobileNumber(request.getMobileNumber())).thenReturn(true);

        assertThrows(ResourceAlreadyExistsException.class,
                () -> userRegistrationService.register(request));
    }
}