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
 * Route request DTO for creating train route stops.
 */

package com.bharatrailway.trainmaster.application.dto;

import java.math.BigDecimal;
import java.time.LocalTime;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class RouteRequest {

    @NotBlank(message = "Train number is required")
    @Size(max = 5, message = "Train number must not exceed 5 characters")
    private String trainNumber;

    @NotBlank(message = "Station code is required")
    @Size(max = 5, message = "Station code must not exceed 5 characters")
    private String stationCode;

    @NotNull(message = "Sequence number is required")
    @Min(value = 1, message = "Sequence number must be positive")
    private Integer sequenceNumber;

    private LocalTime arrivalTime;

    private LocalTime departureTime;

    private Short haltDuration = 0;

    @NotNull(message = "Distance from origin is required")
    @DecimalMin(value = "0.0", message = "Distance must be non-negative")
    private BigDecimal distanceFromOrigin;

    private Short dayNumber = 1;

    private String platformNumber;

    private Boolean isCommercialStop = true;

    private Boolean isTechnicalHalt = false;

    private Boolean isOriginatingStation = false;

    private Boolean isTerminatingStation = false;

    private Boolean isMajorJunction = false;

    private Integer bookingQuota = 0;

    private Integer waitingListQuota = 0;

    public RouteRequest() {
    }

    public String getTrainNumber() {
        return trainNumber;
    }

    public void setTrainNumber(String trainNumber) {
        this.trainNumber = trainNumber;
    }

    public String getStationCode() {
        return stationCode;
    }

    public void setStationCode(String stationCode) {
        this.stationCode = stationCode;
    }

    public Integer getSequenceNumber() {
        return sequenceNumber;
    }

    public void setSequenceNumber(Integer sequenceNumber) {
        this.sequenceNumber = sequenceNumber;
    }

    public LocalTime getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(LocalTime arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public LocalTime getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(LocalTime departureTime) {
        this.departureTime = departureTime;
    }

    public Short getHaltDuration() {
        return haltDuration;
    }

    public void setHaltDuration(Short haltDuration) {
        this.haltDuration = haltDuration;
    }

    public BigDecimal getDistanceFromOrigin() {
        return distanceFromOrigin;
    }

    public void setDistanceFromOrigin(BigDecimal distanceFromOrigin) {
        this.distanceFromOrigin = distanceFromOrigin;
    }

    public Short getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(Short dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getPlatformNumber() {
        return platformNumber;
    }

    public void setPlatformNumber(String platformNumber) {
        this.platformNumber = platformNumber;
    }

    public Boolean getIsCommercialStop() {
        return isCommercialStop;
    }

    public void setIsCommercialStop(Boolean isCommercialStop) {
        this.isCommercialStop = isCommercialStop;
    }

    public Boolean getIsTechnicalHalt() {
        return isTechnicalHalt;
    }

    public void setIsTechnicalHalt(Boolean isTechnicalHalt) {
        this.isTechnicalHalt = isTechnicalHalt;
    }

    public Boolean getIsOriginatingStation() {
        return isOriginatingStation;
    }

    public void setIsOriginatingStation(Boolean isOriginatingStation) {
        this.isOriginatingStation = isOriginatingStation;
    }

    public Boolean getIsTerminatingStation() {
        return isTerminatingStation;
    }

    public void setIsTerminatingStation(Boolean isTerminatingStation) {
        this.isTerminatingStation = isTerminatingStation;
    }

    public Boolean getIsMajorJunction() {
        return isMajorJunction;
    }

    public void setIsMajorJunction(Boolean isMajorJunction) {
        this.isMajorJunction = isMajorJunction;
    }

    public Integer getBookingQuota() {
        return bookingQuota;
    }

    public void setBookingQuota(Integer bookingQuota) {
        this.bookingQuota = bookingQuota;
    }

    public Integer getWaitingListQuota() {
        return waitingListQuota;
    }

    public void setWaitingListQuota(Integer waitingListQuota) {
        this.waitingListQuota = waitingListQuota;
    }
}