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
 * JPA Entity mapped to fare_schema.cancellation_charges.
 */

package com.bharatrailway.fare.domain;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "fare_schema", name = "cancellation_charges")
public class CancellationCharge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "charge_id")
    private Integer chargeId;

    @Column(name = "hours_before_departure_min", nullable = false)
    private Integer hoursBeforeDepartureMin;

    @Column(name = "hours_before_departure_max", nullable = false)
    private Integer hoursBeforeDepartureMax;

    @Column(name = "cancellation_type", length = 20, nullable = false)
    private String cancellationType;

    @Column(name = "coach_class", length = 3, nullable = false)
    private String coachClass;

    @Column(name = "charge_type", length = 20, nullable = false)
    private String chargeType;

    @Column(name = "charge_value", precision = 6, scale = 2, nullable = false)
    private BigDecimal chargeValue;

    @Column(name = "minimum_charge", precision = 6, scale = 2, nullable = false)
    private BigDecimal minimumCharge;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    public CancellationCharge() {
    }

    public Integer getChargeId() {
        return chargeId;
    }

    public void setChargeId(Integer chargeId) {
        this.chargeId = chargeId;
    }

    public Integer getHoursBeforeDepartureMin() {
        return hoursBeforeDepartureMin;
    }

    public void setHoursBeforeDepartureMin(Integer hoursBeforeDepartureMin) {
        this.hoursBeforeDepartureMin = hoursBeforeDepartureMin;
    }

    public Integer getHoursBeforeDepartureMax() {
        return hoursBeforeDepartureMax;
    }

    public void setHoursBeforeDepartureMax(Integer hoursBeforeDepartureMax) {
        this.hoursBeforeDepartureMax = hoursBeforeDepartureMax;
    }

    public String getCancellationType() {
        return cancellationType;
    }

    public void setCancellationType(String cancellationType) {
        this.cancellationType = cancellationType;
    }

    public String getCoachClass() {
        return coachClass;
    }

    public void setCoachClass(String coachClass) {
        this.coachClass = coachClass;
    }

    public String getChargeType() {
        return chargeType;
    }

    public void setChargeType(String chargeType) {
        this.chargeType = chargeType;
    }

    public BigDecimal getChargeValue() {
        return chargeValue;
    }

    public void setChargeValue(BigDecimal chargeValue) {
        this.chargeValue = chargeValue;
    }

    public BigDecimal getMinimumCharge() {
        return minimumCharge;
    }

    public void setMinimumCharge(BigDecimal minimumCharge) {
        this.minimumCharge = minimumCharge;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}