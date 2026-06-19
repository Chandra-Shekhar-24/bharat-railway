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
 * Custom runtime exception for duplicate resource conflicts.
 * Thrown when registration finds an existing email or mobile.
 * Caught by GlobalExceptionHandler -> HTTP 409 Conflict.
 */

package com.bharatrailway.shared.exception;

public class ResourceAlreadyExistsException extends RuntimeException {

    public ResourceAlreadyExistsException(String resource, String field, String value) {
        super(String.format("%s with %s '%s' already exists", resource, field, value));
    }
}