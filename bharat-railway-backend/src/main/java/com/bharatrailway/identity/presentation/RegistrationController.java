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
 * Registration API controller.
 * POST /api/v1/auth/register - creates new user.
 * Returns 201 Created with empty body on success.
 * No session generation - client must call login separately.
 */

package com.bharatrailway.identity.presentation;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.identity.application.UserRegistrationService;
import com.bharatrailway.identity.application.dto.RegistrationRequest;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/auth")
public class RegistrationController {

    private final UserRegistrationService userRegistrationService;

    public RegistrationController(UserRegistrationService userRegistrationService) {
        this.userRegistrationService = userRegistrationService;
    }

    @PostMapping("/register")
    public ResponseEntity<Void> register(@Valid @RequestBody RegistrationRequest request) {
        userRegistrationService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
}