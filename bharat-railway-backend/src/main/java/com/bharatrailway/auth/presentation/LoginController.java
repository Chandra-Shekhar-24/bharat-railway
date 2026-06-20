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
 * Login API controller.
 * POST /api/v1/auth/login - authenticates user, returns JWT and session UUID.
 * Extracts client IP and User-Agent for audit logging.
 */

package com.bharatrailway.auth.presentation;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.auth.application.AuthenticationService;
import com.bharatrailway.auth.application.dto.LoginRequest;
import com.bharatrailway.auth.application.dto.LoginResponse;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/auth")
public class LoginController {

    private final AuthenticationService authenticationService;

    public LoginController(AuthenticationService authenticationService) {
        this.authenticationService = authenticationService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request,
                                                HttpServletRequest httpRequest) {
        String ipAddress = httpRequest.getRemoteAddr();
        String userAgent = httpRequest.getHeader("User-Agent");
        if (userAgent == null) {
            userAgent = "Unknown";
        }

        LoginResponse response = authenticationService.login(request, ipAddress, userAgent);
        return ResponseEntity.ok(response);
    }
}