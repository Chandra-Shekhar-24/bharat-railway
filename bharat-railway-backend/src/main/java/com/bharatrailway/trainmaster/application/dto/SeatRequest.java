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
 * Seat request DTO for creating seats.
 */

package com.bharatrailway.trainmaster.application.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class SeatRequest {

    @NotBlank(message = "Train number is required")
    @Size(max = 5, message = "Train number must not exceed 5 characters")
    private String trainNumber;

    @NotBlank(message = "Coach class is required")
    @Size(max = 3, message = "Coach class must not exceed 3 characters")
    private String coachClass;

    @NotBlank(message = "Seat number is required")
    @Size(max = 10, message = "Seat number must not exceed 10 characters")
    private String seatNumber;

    @Pattern(regexp = "^(LOWER|MIDDLE|UPPER|SIDE_LOWER|SIDE_UPPER|WINDOW|AISLE)?$", 
             message = "Invalid berth type")
    private String berthType;

    private Boolean isActive = true;

    public SeatRequest() {
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

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getBerthType() {
        return berthType;
    }

    public void setBerthType(String berthType) {
        this.berthType = berthType;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}