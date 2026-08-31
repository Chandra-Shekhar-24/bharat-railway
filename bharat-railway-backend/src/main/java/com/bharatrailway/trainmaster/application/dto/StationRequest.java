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
 * Station request DTO for creating/updating stations.
 */

package com.bharatrailway.trainmaster.application.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class StationRequest {

    @NotBlank(message = "Station code is required")
    @Size(min = 2, max = 5, message = "Station code must be 2-5 characters")
    private String stationCode;

    @NotBlank(message = "Station name is required")
    @Size(max = 100, message = "Station name must not exceed 100 characters")
    private String stationName;

    @NotBlank(message = "City is required")
    @Size(max = 50, message = "City must not exceed 50 characters")
    private String city;

    @NotBlank(message = "State is required")
    @Size(max = 30, message = "State must not exceed 30 characters")
    private String state;

    @NotBlank(message = "Zone is required")
    @Size(max = 50, message = "Zone must not exceed 50 characters")
    private String zone;

    @NotBlank(message = "Division is required")
    @Size(max = 30, message = "Division must not exceed 30 characters")
    private String division;

    @NotBlank(message = "Station category is required")
    @Pattern(regexp = "^(A1|A|B|C|D|E|F)$", message = "Invalid station category")
    private String stationCategory;

    @NotBlank(message = "Station type is required")
    @Pattern(regexp = "^(Terminal|Junction|Central|Halt)$", message = "Invalid station type")
    private String stationType;

    private Short numberOfPlatforms = 1;

    @Size(max = 6, message = "Pincode must be 6 digits")
    private String pincode;

    private String stationStatus = "Active";

    private Boolean isHillStation = false;

    private Boolean isInternational = false;

    private Short openingYear;

    public StationRequest() {
    }

    public String getStationCode() {
        return stationCode;
    }

    public void setStationCode(String stationCode) {
        this.stationCode = stationCode;
    }

    public String getStationName() {
        return stationName;
    }

    public void setStationName(String stationName) {
        this.stationName = stationName;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZone() {
        return zone;
    }

    public void setZone(String zone) {
        this.zone = zone;
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
    }

    public String getStationCategory() {
        return stationCategory;
    }

    public void setStationCategory(String stationCategory) {
        this.stationCategory = stationCategory;
    }

    public String getStationType() {
        return stationType;
    }

    public void setStationType(String stationType) {
        this.stationType = stationType;
    }

    public Short getNumberOfPlatforms() {
        return numberOfPlatforms;
    }

    public void setNumberOfPlatforms(Short numberOfPlatforms) {
        this.numberOfPlatforms = numberOfPlatforms;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getStationStatus() {
        return stationStatus;
    }

    public void setStationStatus(String stationStatus) {
        this.stationStatus = stationStatus;
    }

    public Boolean getIsHillStation() {
        return isHillStation;
    }

    public void setIsHillStation(Boolean isHillStation) {
        this.isHillStation = isHillStation;
    }

    public Boolean getIsInternational() {
        return isInternational;
    }

    public void setIsInternational(Boolean isInternational) {
        this.isInternational = isInternational;
    }

    public Short getOpeningYear() {
        return openingYear;
    }

    public void setOpeningYear(Short openingYear) {
        this.openingYear = openingYear;
    }
}