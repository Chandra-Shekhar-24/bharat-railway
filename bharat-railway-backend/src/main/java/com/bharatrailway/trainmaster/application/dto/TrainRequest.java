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
 * Train request DTO for creating/updating trains.
 */

package com.bharatrailway.trainmaster.application.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class TrainRequest {

    @NotBlank(message = "Train number is required")
    @Size(min = 3, max = 5, message = "Train number must be 3-5 digits")
    private String trainNumber;

    @NotBlank(message = "Train name is required")
    @Size(max = 100, message = "Train name must not exceed 100 characters")
    private String trainName;

    @NotBlank(message = "Train type is required")
    @Pattern(regexp = "^(Rajdhani|Shatabdi|Duronto|Garib Rath|Sampark Kranti|Express|Mail|Passenger|Superfast|MEMU|DEMU|Vande Bharat|Tejas|Humsafar)$",
            message = "Invalid train type")
    private String trainType;

    @NotBlank(message = "Category is required")
    @Pattern(regexp = "^(Superfast|Express|Mail|Passenger)$", message = "Invalid category")
    private String category;

    @NotBlank(message = "Origin station code is required")
    @Size(max = 5, message = "Origin station code must not exceed 5 characters")
    private String originStationCode;

    @NotBlank(message = "Destination station code is required")
    @Size(max = 5, message = "Destination station code must not exceed 5 characters")
    private String destinationStationCode;

    @NotNull(message = "Total distance is required")
    @DecimalMin(value = "0.01", message = "Total distance must be greater than 0")
    private BigDecimal totalDistance;

    private BigDecimal averageSpeed;

    private BigDecimal maximumSpeed;

    private Short totalCoaches = 0;

    private Boolean pantryCar = false;

    private Boolean wifiAvailable = false;

    private String trainStatus = "Active";

    private LocalDate introductionDate;

    private Boolean isSpecialTrain = false;

    private BigDecimal fareMultiplier = BigDecimal.ONE;

    private Boolean tatkalAvailable = true;

    public TrainRequest() {
    }

    public String getTrainNumber() {
        return trainNumber;
    }

    public void setTrainNumber(String trainNumber) {
        this.trainNumber = trainNumber;
    }

    public String getTrainName() {
        return trainName;
    }

    public void setTrainName(String trainName) {
        this.trainName = trainName;
    }

    public String getTrainType() {
        return trainType;
    }

    public void setTrainType(String trainType) {
        this.trainType = trainType;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getOriginStationCode() {
        return originStationCode;
    }

    public void setOriginStationCode(String originStationCode) {
        this.originStationCode = originStationCode;
    }

    public String getDestinationStationCode() {
        return destinationStationCode;
    }

    public void setDestinationStationCode(String destinationStationCode) {
        this.destinationStationCode = destinationStationCode;
    }

    public BigDecimal getTotalDistance() {
        return totalDistance;
    }

    public void setTotalDistance(BigDecimal totalDistance) {
        this.totalDistance = totalDistance;
    }

    public BigDecimal getAverageSpeed() {
        return averageSpeed;
    }

    public void setAverageSpeed(BigDecimal averageSpeed) {
        this.averageSpeed = averageSpeed;
    }

    public BigDecimal getMaximumSpeed() {
        return maximumSpeed;
    }

    public void setMaximumSpeed(BigDecimal maximumSpeed) {
        this.maximumSpeed = maximumSpeed;
    }

    public Short getTotalCoaches() {
        return totalCoaches;
    }

    public void setTotalCoaches(Short totalCoaches) {
        this.totalCoaches = totalCoaches;
    }

    public Boolean getPantryCar() {
        return pantryCar;
    }

    public void setPantryCar(Boolean pantryCar) {
        this.pantryCar = pantryCar;
    }

    public Boolean getWifiAvailable() {
        return wifiAvailable;
    }

    public void setWifiAvailable(Boolean wifiAvailable) {
        this.wifiAvailable = wifiAvailable;
    }

    public String getTrainStatus() {
        return trainStatus;
    }

    public void setTrainStatus(String trainStatus) {
        this.trainStatus = trainStatus;
    }

    public LocalDate getIntroductionDate() {
        return introductionDate;
    }

    public void setIntroductionDate(LocalDate introductionDate) {
        this.introductionDate = introductionDate;
    }

    public Boolean getIsSpecialTrain() {
        return isSpecialTrain;
    }

    public void setIsSpecialTrain(Boolean isSpecialTrain) {
        this.isSpecialTrain = isSpecialTrain;
    }

    public BigDecimal getFareMultiplier() {
        return fareMultiplier;
    }

    public void setFareMultiplier(BigDecimal fareMultiplier) {
        this.fareMultiplier = fareMultiplier;
    }

    public Boolean getTatkalAvailable() {
        return tatkalAvailable;
    }

    public void setTatkalAvailable(Boolean tatkalAvailable) {
        this.tatkalAvailable = tatkalAvailable;
    }
}