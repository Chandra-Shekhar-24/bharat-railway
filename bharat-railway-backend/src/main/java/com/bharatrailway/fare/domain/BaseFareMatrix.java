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
 * JPA Entity mapped to fare_schema.base_fare_matrix.
 */

package com.bharatrailway.fare.domain;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "fare_schema", name = "base_fare_matrix")
public class BaseFareMatrix {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fare_id")
    private Integer fareId;

    @Column(name = "train_type", length = 20, nullable = false)
    private String trainType;

    @Column(name = "coach_class", length = 3, nullable = false)
    private String coachClass;

    @Column(name = "distance_from_km", nullable = false)
    private Integer distanceFromKm;

    @Column(name = "distance_to_km", nullable = false)
    private Integer distanceToKm;

    @Column(name = "base_fare", precision = 8, scale = 2, nullable = false)
    private BigDecimal baseFare;

    @Column(name = "minimum_fare", precision = 8, scale = 2, nullable = false)
    private BigDecimal minimumFare;

    @Column(name = "per_km_rate_beyond", precision = 6, scale = 2, nullable = false)
    private BigDecimal perKmRateBeyond;

    @Column(name = "effective_from", nullable = false)
    private LocalDate effectiveFrom;

    @Column(name = "effective_to")
    private LocalDate effectiveTo;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    public BaseFareMatrix() {
    }

    public Integer getFareId() {
        return fareId;
    }

    public void setFareId(Integer fareId) {
        this.fareId = fareId;
    }

    public String getTrainType() {
        return trainType;
    }

    public void setTrainType(String trainType) {
        this.trainType = trainType;
    }

    public String getCoachClass() {
        return coachClass;
    }

    public void setCoachClass(String coachClass) {
        this.coachClass = coachClass;
    }

    public Integer getDistanceFromKm() {
        return distanceFromKm;
    }

    public void setDistanceFromKm(Integer distanceFromKm) {
        this.distanceFromKm = distanceFromKm;
    }

    public Integer getDistanceToKm() {
        return distanceToKm;
    }

    public void setDistanceToKm(Integer distanceToKm) {
        this.distanceToKm = distanceToKm;
    }

    public BigDecimal getBaseFare() {
        return baseFare;
    }

    public void setBaseFare(BigDecimal baseFare) {
        this.baseFare = baseFare;
    }

    public BigDecimal getMinimumFare() {
        return minimumFare;
    }

    public void setMinimumFare(BigDecimal minimumFare) {
        this.minimumFare = minimumFare;
    }

    public BigDecimal getPerKmRateBeyond() {
        return perKmRateBeyond;
    }

    public void setPerKmRateBeyond(BigDecimal perKmRateBeyond) {
        this.perKmRateBeyond = perKmRateBeyond;
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

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}