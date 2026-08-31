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
 * Spring Data JPA repository for train_master_schema.routes.
 */

package com.bharatrailway.trainmaster.domain;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "train_master_schema", name = "stations")
public class Station {

    @Id
    @Column(name = "station_code", length = 5, nullable = false)
    private String stationCode;

    @Column(name = "station_name", length = 100, nullable = false)
    private String stationName;

    @Column(name = "city", length = 50, nullable = false)
    private String city;

    @Column(name = "state", length = 30, nullable = false)
    private String state;

    @Column(name = "zone", length = 50, nullable = false)
    private String zone;

    @Column(name = "division", length = 30, nullable = false)
    private String division;

    @Column(name = "station_category", length = 5, nullable = false)
    private String stationCategory;

    @Column(name = "station_type", length = 20, nullable = false)
    private String stationType;

    @Column(name = "number_of_platforms", nullable = false)
    private Short numberOfPlatforms;

    @Column(name = "pincode", length = 6)
    private String pincode;

    @Column(name = "station_status", length = 20, nullable = false)
    private String stationStatus;

    @Column(name = "is_hill_station", nullable = false)
    private Boolean isHillStation;

    @Column(name = "is_international", nullable = false)
    private Boolean isInternational;

    @Column(name = "opening_year")
    private Short openingYear;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    public Station() {
    }

    // Getters and Setters
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

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}