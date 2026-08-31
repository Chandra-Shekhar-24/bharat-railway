/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-08-31
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Train coach composition request DTO.
 */

package com.bharatrailway.trainmaster.application.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class TrainCoachCompositionRequest {

    @NotBlank(message = "Train number is required")
    @Size(max = 5, message = "Train number must not exceed 5 characters")
    private String trainNumber;

    @NotBlank(message = "Coach class is required")
    @Size(max = 3, message = "Coach class must not exceed 3 characters")
    private String coachClass;

    @NotNull(message = "Number of coaches is required")
    @Min(value = 1, message = "Number of coaches must be at least 1")
    private Short numberOfCoaches;

    private String coachNumbers;

    private Short coachPositionFromEngine = 1;

    private Boolean hasDisabledAccess = false;

    private LocalDate effectiveFrom = LocalDate.now();

    private LocalDate effectiveTo;

    public TrainCoachCompositionRequest() {
    }

    public String getTrainNumber() {
        return trainNumber;
    }

    public void setTrainNumber(String trainNumber) {
        this.trainNumber = trainNumber;
    }

    public String getCoachClass() {
        return coachClass;
    }

    public void setCoachClass(String coachClass) {
        this.coachClass = coachClass;
    }

    public Short getNumberOfCoaches() {
        return numberOfCoaches;
    }

    public void setNumberOfCoaches(Short numberOfCoaches) {
        this.numberOfCoaches = numberOfCoaches;
    }

    public String getCoachNumbers() {
        return coachNumbers;
    }

    public void setCoachNumbers(String coachNumbers) {
        this.coachNumbers = coachNumbers;
    }

    public Short getCoachPositionFromEngine() {
        return coachPositionFromEngine;
    }

    public void setCoachPositionFromEngine(Short coachPositionFromEngine) {
        this.coachPositionFromEngine = coachPositionFromEngine;
    }

    public Boolean getHasDisabledAccess() {
        return hasDisabledAccess;
    }

    public void setHasDisabledAccess(Boolean hasDisabledAccess) {
        this.hasDisabledAccess = hasDisabledAccess;
    }

    public LocalDate getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(LocalDate effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }

    public LocalDate getEffectiveTo() {
        return effectiveTo;
    }

    public void setEffectiveTo(LocalDate effectiveTo) {
        this.effectiveTo = effectiveTo;
    }
}