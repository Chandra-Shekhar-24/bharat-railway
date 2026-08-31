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

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "train_master_schema", name = "trains")
public class Train {

    @Id
    @Column(name = "train_number", length = 5, nullable = false)
    private String trainNumber;

    @Column(name = "train_name", length = 100, nullable = false)
    private String trainName;

    @Column(name = "train_type", length = 30, nullable = false)
    private String trainType;

    @Column(name = "category", length = 20, nullable = false)
    private String category;

    @Column(name = "origin_station_code", length = 5, nullable = false)
    private String originStationCode;

    @Column(name = "destination_station_code", length = 5, nullable = false)
    private String destinationStationCode;

    @Column(name = "total_distance", precision = 7, scale = 2, nullable = false)
    private BigDecimal totalDistance;

    @Column(name = "average_speed", precision = 5, scale = 2)
    private BigDecimal averageSpeed;

    @Column(name = "maximum_speed", precision = 5, scale = 2)
    private BigDecimal maximumSpeed;

    @Column(name = "total_coaches", nullable = false)
    private Short totalCoaches;

    @Column(name = "pantry_car", nullable = false)
    private Boolean pantryCar;

    @Column(name = "wifi_available", nullable = false)
    private Boolean wifiAvailable;

    @Column(name = "train_status", length = 20, nullable = false)
    private String trainStatus;

    @Column(name = "introduction_date")
    private LocalDate introductionDate;

    @Column(name = "is_special_train", nullable = false)
    private Boolean isSpecialTrain;

    @Column(name = "fare_multiplier", precision = 4, scale = 2, nullable = false)
    private BigDecimal fareMultiplier;

    @Column(name = "tatkal_available", nullable = false)
    private Boolean tatkalAvailable;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    public Train() {
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