/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-09-01
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Passenger request DTO for booking passengers.
 */

package com.bharatrailway.booking.application.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class PassengerRequest {

    @NotBlank(message = "Full name is required")
    @Size(max = 100, message = "Full name must not exceed 100 characters")
    private String fullName;

    @NotNull(message = "Age is required")
    @Min(value = 1, message = "Age must be positive")
    @Max(value = 119, message = "Age must be less than 120")
    private Short age;

    @NotBlank(message = "Gender is required")
    @Pattern(regexp = "^[MFON]$", message = "Gender must be M, F, O, or N")
    private String gender;

    @Pattern(regexp = "^(LOWER|MIDDLE|UPPER|SIDE_LOWER|SIDE_UPPER|NO_PREF)?$", 
             message = "Invalid berth preference")
    private String berthPreference;

    public PassengerRequest() {
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Short getAge() {
        return age;
    }

    public void setAge(Short age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBerthPreference() {
        return berthPreference;
    }

    public void setBerthPreference(String berthPreference) {
        this.berthPreference = berthPreference;
    }
}