/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Hitanshu Dhakrey
 * Assisted by: Chandra Shekhar Bansal (Infrastructure), DeepSeek (AI Scribe)
 * Date: 2026-06-19
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Standardized JSON error response DTO.
 * Every exception maps to this single contract for consistent client handling.
 */

package com.bharatrailway.shared.exception;

import java.time.OffsetDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

public record ErrorResponse(
        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ssXXX")
        OffsetDateTime timestamp,
        int status,
        String error,
        String message,
        String path
) {}