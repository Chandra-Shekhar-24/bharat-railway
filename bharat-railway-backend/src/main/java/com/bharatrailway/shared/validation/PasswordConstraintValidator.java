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
 * Jakarta ConstraintValidator implementation for @ValidPassword.
 * Policy: Minimum 8 characters, at least 1 uppercase letter, 1 lowercase letter,
 * 1 number, and 1 special character.
 */

package com.bharatrailway.shared.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class PasswordConstraintValidator implements ConstraintValidator<ValidPassword, String> {

    private static final String SPECIAL_CHARS = "@$!%*?&#^()_\\-+=<>{}|:;',./~`";
    private static final String PASSWORD_PATTERN =
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[" + SPECIAL_CHARS + "])[A-Za-z\\d" + SPECIAL_CHARS + "]{8,}$";

    @Override
    public boolean isValid(String password, ConstraintValidatorContext context) {
        if (password == null || password.isBlank()) {
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate("Password must not be empty")
                    .addConstraintViolation();
            return false;
        }

        return password.matches(PASSWORD_PATTERN);
    }
}