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
import java.time.LocalTime;
import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "train_master_schema", name = "routes")
public class Route {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "route_id")
    private Integer routeId;

    @Column(name = "train_number", length = 5, nullable = false)
    private String trainNumber;

    @Column(name = "station_code", length = 5, nullable = false)
    private String stationCode;

    @Column(name = "sequence_number", nullable = false)
    private Integer sequenceNumber;

    @Column(name = "arrival_time")
    private LocalTime arrivalTime;

    @Column(name = "departure_time")
    private LocalTime departureTime;

    @Column(name = "halt_duration", nullable = false)
    private Short haltDuration;

    @Column(name = "distance_from_origin", precision = 7, scale = 2, nullable = false)
    private BigDecimal distanceFromOrigin;

    @Column(name = "day_number", nullable = false)
    private Short dayNumber;

    @Column(name = "platform_number", length = 10)
    private String platformNumber;

    @Column(name = "is_commercial_stop", nullable = false)
    private Boolean isCommercialStop;

    @Column(name = "is_technical_halt", nullable = false)
    private Boolean isTechnicalHalt;

    @Column(name = "is_originating_station", nullable = false)
    private Boolean isOriginatingStation;

    @Column(name = "is_terminating_station", nullable = false)
    private Boolean isTerminatingStation;

    @Column(name = "is_major_junction", nullable = false)
    private Boolean isMajorJunction;

    @Column(name = "booking_quota", nullable = false)
    private Integer bookingQuota;

    @Column(name = "waiting_list_quota", nullable = false)
    private Integer waitingListQuota;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    public Route() {
    }

    public Integer getRouteId() {
        return routeId;
    }

    public void setRouteId(Integer routeId) {
        this.routeId = routeId;
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

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}