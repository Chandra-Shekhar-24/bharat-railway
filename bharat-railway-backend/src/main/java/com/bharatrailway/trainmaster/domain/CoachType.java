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
import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "train_master_schema", name = "coach_types")
public class CoachType {

    @Id
    @Column(name = "coach_code", length = 3, nullable = false)
    private String coachCode;

    @Column(name = "coach_name", length = 50, nullable = false)
    private String coachName;

    @Column(name = "comfort_level", length = 20, nullable = false)
    private String comfortLevel;

    @Column(name = "has_ac", nullable = false)
    private Boolean hasAc;

    @Column(name = "berth_type", length = 20, nullable = false)
    private String berthType;

    @Column(name = "seats_per_coach", nullable = false)
    private Short seatsPerCoach;

    @Column(name = "has_side_berths", nullable = false)
    private Boolean hasSideBerths;

    @Column(name = "bedding_provided", nullable = false)
    private Boolean beddingProvided;

    @Column(name = "food_included", nullable = false)
    private Boolean foodIncluded;

    @Column(name = "base_fare_multiplier", precision = 4, scale = 2, nullable = false)
    private BigDecimal baseFareMultiplier;

    @Column(name = "rac_allowed", nullable = false)
    private Boolean racAllowed;

    @Column(name = "tatkal_allowed", nullable = false)
    private Boolean tatkalAllowed;

    @Column(name = "max_passengers_per_pnr", nullable = false)
    private Short maxPassengersPerPnr;

    @Column(name = "is_unreserved", nullable = false)
    private Boolean isUnreserved;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    public CoachType() {
    }

    public String getCoachCode() {
        return coachCode;
    }

    public void setCoachCode(String coachCode) {
        this.coachCode = coachCode;
    }

    public String getCoachName() {
        return coachName;
    }

    public void setCoachName(String coachName) {
        this.coachName = coachName;
    }

    public String getComfortLevel() {
        return comfortLevel;
    }

    public void setComfortLevel(String comfortLevel) {
        this.comfortLevel = comfortLevel;
    }

    public Boolean getHasAc() {
        return hasAc;
    }

    public void setHasAc(Boolean hasAc) {
        this.hasAc = hasAc;
    }

    public String getBerthType() {
        return berthType;
    }

    public void setBerthType(String berthType) {
        this.berthType = berthType;
    }

    public Short getSeatsPerCoach() {
        return seatsPerCoach;
    }

    public void setSeatsPerCoach(Short seatsPerCoach) {
        this.seatsPerCoach = seatsPerCoach;
    }

    public Boolean getHasSideBerths() {
        return hasSideBerths;
    }

    public void setHasSideBerths(Boolean hasSideBerths) {
        this.hasSideBerths = hasSideBerths;
    }

    public Boolean getBeddingProvided() {
        return beddingProvided;
    }

    public void setBeddingProvided(Boolean beddingProvided) {
        this.beddingProvided = beddingProvided;
    }

    public Boolean getFoodIncluded() {
        return foodIncluded;
    }

    public void setFoodIncluded(Boolean foodIncluded) {
        this.foodIncluded = foodIncluded;
    }

    public BigDecimal getBaseFareMultiplier() {
        return baseFareMultiplier;
    }

    public void setBaseFareMultiplier(BigDecimal baseFareMultiplier) {
        this.baseFareMultiplier = baseFareMultiplier;
    }

    public Boolean getRacAllowed() {
        return racAllowed;
    }

    public void setRacAllowed(Boolean racAllowed) {
        this.racAllowed = racAllowed;
    }

    public Boolean getTatkalAllowed() {
        return tatkalAllowed;
    }

    public void setTatkalAllowed(Boolean tatkalAllowed) {
        this.tatkalAllowed = tatkalAllowed;
    }

    public Short getMaxPassengersPerPnr() {
        return maxPassengersPerPnr;
    }

    public void setMaxPassengersPerPnr(Short maxPassengersPerPnr) {
        this.maxPassengersPerPnr = maxPassengersPerPnr;
    }

    public Boolean getIsUnreserved() {
        return isUnreserved;
    }

    public void setIsUnreserved(Boolean isUnreserved) {
        this.isUnreserved = isUnreserved;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}