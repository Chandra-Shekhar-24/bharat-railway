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
 * JPA Entity mapped to fare_schema.convenience_fee_config.
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
@Table(schema = "fare_schema", name = "convenience_fee_config")
public class ConvenienceFeeConfig {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "config_id")
    private Integer configId;

    @Column(name = "booking_channel", length = 20, nullable = false)
    private String bookingChannel;

    @Column(name = "coach_class", length = 3)
    private String coachClass;

    @Column(name = "fee_amount", precision = 6, scale = 2, nullable = false)
    private BigDecimal feeAmount;

    @Column(name = "gst_on_fee", precision = 5, scale = 2, nullable = false)
    private BigDecimal gstOnFee;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    public ConvenienceFeeConfig() {
    }

    public Integer getConfigId() {
        return configId;
    }

    public void setConfigId(Integer configId) {
        this.configId = configId;
    }

    public String getBookingChannel() {
        return bookingChannel;
    }

    public void setBookingChannel(String bookingChannel) {
        this.bookingChannel = bookingChannel;
    }

    public String getCoachClass() {
        return coachClass;
    }

    public void setCoachClass(String coachClass) {
        this.coachClass = coachClass;
    }

    public BigDecimal getFeeAmount() {
        return feeAmount;
    }

    public void setFeeAmount(BigDecimal feeAmount) {
        this.feeAmount = feeAmount;
    }

    public BigDecimal getGstOnFee() {
        return gstOnFee;
    }

    public void setGstOnFee(BigDecimal gstOnFee) {
        this.gstOnFee = gstOnFee;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}