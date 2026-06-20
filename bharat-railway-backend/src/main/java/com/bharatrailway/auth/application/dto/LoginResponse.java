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
 * Login response DTO.
 * Returns JWT access token and session UUID on successful authentication.
 */

package com.bharatrailway.auth.application.dto;

import java.util.UUID;

public class LoginResponse {

    private String accessToken;
    private String tokenType;
    private long expiresIn;
    private UUID sessionId;

    public LoginResponse() {
    }

    public LoginResponse(String accessToken, long expiresIn, UUID sessionId) {
        this.accessToken = accessToken;
        this.tokenType = "Bearer";
        this.expiresIn = expiresIn;
        this.sessionId = sessionId;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getTokenType() {
        return tokenType;
    }

    public long getExpiresIn() {
        return expiresIn;
    }

    public UUID getSessionId() {
        return sessionId;
    }
}