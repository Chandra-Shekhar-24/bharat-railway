/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Hitanshu Dhakrey
 * Assisted by: Chandra Shekhar Bansal (Infrastructure), DeepSeek (AI Scribe)
 * Date: 2026-06-19
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * JPA Entity mapped to auth_schema.login_history.
 * Immutable audit log for every login attempt.
 * Status: 0=failure, 1=success. failure_reason is NULL for success.
 */

package com.bharatrailway.auth.domain;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "auth_schema", name = "login_history")
public class LoginHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "log_id")
    private Long logId;

    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @Column(name = "ip_address", length = 45, nullable = false)
    private String ipAddress;

    @Column(name = "user_agent", columnDefinition = "TEXT", nullable = false)
    private String userAgent;

    @Column(name = "geo_location", length = 255)
    private String geoLocation;

    @Column(name = "login_method", length = 50, nullable = false)
    private String loginMethod;

    @Column(name = "login_time", nullable = false, updatable = false)
    private OffsetDateTime loginTime;

    @Column(name = "status", nullable = false)
    private Short status;

    @Column(name = "failure_reason", length = 100)
    private String failureReason;

    // --- Constructors ---

    public LoginHistory() {
    }

    // --- Getters and Setters ---

    public Long getLogId() {
        return logId;
    }

    public void setLogId(Long logId) {
        this.logId = logId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getGeoLocation() {
        return geoLocation;
    }

    public void setGeoLocation(String geoLocation) {
        this.geoLocation = geoLocation;
    }

    public String getLoginMethod() {
        return loginMethod;
    }

    public void setLoginMethod(String loginMethod) {
        this.loginMethod = loginMethod;
    }

    public OffsetDateTime getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(OffsetDateTime loginTime) {
        this.loginTime = loginTime;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public String getFailureReason() {
        return failureReason;
    }

    public void setFailureReason(String failureReason) {
        this.failureReason = failureReason;
    }
}