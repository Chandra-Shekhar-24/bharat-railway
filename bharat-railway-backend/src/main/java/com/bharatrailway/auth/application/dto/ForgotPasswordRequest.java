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
 * Forgot password request DTO.
 * Accepts email and preferred reset channel (email or sms).
 */

package com.bharatrailway.auth.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class ForgotPasswordRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Reset channel is required")
    @Pattern(regexp = "^(email|sms)$", message = "Channel must be email or sms")
    private String channel;

    public ForgotPasswordRequest() {
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }
}