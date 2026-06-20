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
 * Application service for user registration.
 * Validates uniqueness of username, email, mobile before creation.
 * Hashes password using BCrypt. Sets default account state.
 * Throws ResourceAlreadyExistsException on duplicate fields.
 */

package com.bharatrailway.identity.application;

import java.time.OffsetDateTime;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.identity.application.dto.RegistrationRequest;
import com.bharatrailway.identity.domain.User;
import com.bharatrailway.identity.infrastructure.UserRepository;
import com.bharatrailway.shared.exception.ResourceAlreadyExistsException;

@Service
public class UserRegistrationService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public UserRegistrationService(UserRepository userRepository,
                                   BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void register(RegistrationRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new ResourceAlreadyExistsException("User", "username", request.getUsername());
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ResourceAlreadyExistsException("User", "email", request.getEmail());
        }
        if (userRepository.existsByMobileNumber(request.getMobileNumber())) {
            throw new ResourceAlreadyExistsException("User", "mobile number", request.getMobileNumber());
        }

        User user = new User();
        user.setFullName(request.getFullName());
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setMobileNumber(request.getMobileNumber());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setDateOfBirth(request.getDateOfBirth());
        user.setGender(request.getGender().charAt(0));
        user.setStatus((short) 1);
        user.setFailedLoginAttempts((short) 0);
        user.setIsEmailVerified(false);
        user.setIsMobileVerified(false);
        user.setCreatedAt(OffsetDateTime.now());
        user.setUpdatedAt(OffsetDateTime.now());

        userRepository.save(user);
    }
}