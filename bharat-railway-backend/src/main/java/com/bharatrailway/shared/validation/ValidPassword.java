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
 * Custom Jakarta constraint annotation for password policy validation.
 * Policy: Minimum 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special char.
 * Applied on String fields in request DTOs.
 */

package com.bharatrailway.shared.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

@Documented
@Constraint(validatedBy = PasswordConstraintValidator.class)
@Target(FIELD)
@Retention(RUNTIME)
public @interface ValidPassword {

    String message() default "Password must be at least 8 characters, "
            + "contain 1 uppercase, 1 lowercase, 1 number, and 1 special character";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}