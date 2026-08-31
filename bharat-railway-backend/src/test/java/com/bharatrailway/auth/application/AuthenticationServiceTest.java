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
 * Unit tests for AuthenticationService.
 * Verifies 5-failed-attempt lockout logic sets accountLockedUntil
 * and throws LockedException.
 */

package com.bharatrailway.auth.application;

import java.time.OffsetDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import static org.mockito.ArgumentMatchers.any;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.bharatrailway.auth.application.dto.LoginRequest;
import com.bharatrailway.auth.domain.LoginHistory;
import com.bharatrailway.auth.infrastructure.LoginHistoryRepository;
import com.bharatrailway.auth.infrastructure.UserSessionRepository;
import com.bharatrailway.identity.domain.User;
import com.bharatrailway.identity.infrastructure.UserRepository;

@ExtendWith(MockitoExtension.class)
class AuthenticationServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserSessionRepository userSessionRepository;

    @Mock
    private LoginHistoryRepository loginHistoryRepository;

    @Mock
    private BCryptPasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private AuthenticationService authenticationService;

    private User user;
    private LoginRequest request;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUserId(1);
        user.setUsername("testuser");
        user.setPasswordHash("$2a$10$hashedpassword");
        user.setStatus((short) 1);
        user.setFailedLoginAttempts((short) 0);
        user.setAccountLockedUntil(null);

        request = new LoginRequest();
        request.setUsername("testuser");
        request.setPassword("password");
    }

    @Test
    void shouldThrowLockedExceptionAfter5FailedAttempts() {
        user.setFailedLoginAttempts((short) 5);
        user.setAccountLockedUntil(OffsetDateTime.now().plusMinutes(30));

        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(user));

        assertThrows(LockedException.class,
                () -> authenticationService.login(request, "127.0.0.1", "JUnit"));
    }

    @Test
    void shouldSetAccountLockedUntilWhenMaxAttemptsReached() {
        User lockedUser = new User();
        lockedUser.setUserId(1);
        lockedUser.setUsername("testuser");
        lockedUser.setPasswordHash("hash");
        lockedUser.setStatus((short) 1);
        lockedUser.setFailedLoginAttempts((short) 4);
        lockedUser.setAccountLockedUntil(null);

        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(lockedUser));
        when(passwordEncoder.matches("password", "hash")).thenReturn(false);
        when(userRepository.findById(1)).thenReturn(Optional.of(lockedUser));
        when(loginHistoryRepository.save(any(LoginHistory.class))).thenReturn(null);

        authenticationService.incrementFailedAttempts(lockedUser);

        assertNotNull(lockedUser.getAccountLockedUntil());
        assertTrue(lockedUser.getAccountLockedUntil().isAfter(OffsetDateTime.now()));
    }

    @Test
    void shouldThrowBadCredentialsWhenPasswordInvalid() {
        when(userRepository.findByUsername("testuser")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("password", "$2a$10$hashedpassword")).thenReturn(false);
        when(userRepository.findById(1)).thenReturn(Optional.of(user));
        when(loginHistoryRepository.save(any(LoginHistory.class))).thenReturn(null);

        assertThrows(BadCredentialsException.class,
                () -> authenticationService.login(request, "127.0.0.1", "JUnit"));
    }
}