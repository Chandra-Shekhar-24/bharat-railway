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
 * JPA Entity mapped to auth_schema.password_reset.
 * Time-bound password reset token. Token stored as bcrypt hash.
 * is_used flag prevents token reuse after successful reset.
 * FK to identity_schema.users with CASCADE delete.
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
@Table(schema = "auth_schema", name = "password_reset")
public class PasswordResetToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "reset_id")
    private Integer resetId;

    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @Column(name = "token", length = 255, nullable = false, unique = true)
    private String token;

    @Column(name = "request_ip", length = 45, nullable = false)
    private String requestIp;

    @Column(name = "reset_channel", length = 50, nullable = false)
    private String resetChannel;

    @Column(name = "is_used", nullable = false)
    private Boolean isUsed;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "expires_at", nullable = false)
    private OffsetDateTime expiresAt;

    // --- Constructors ---

    public PasswordResetToken() {
    }

    // --- Getters and Setters ---

    public Integer getResetId() {
        return resetId;
    }

    public void setResetId(Integer resetId) {
        this.resetId = resetId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getRequestIp() {
        return requestIp;
    }

    public void setRequestIp(String requestIp) {
        this.requestIp = requestIp;
    }

    public String getResetChannel() {
        return resetChannel;
    }

    public void setResetChannel(String resetChannel) {
        this.resetChannel = resetChannel;
    }

    public Boolean getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(Boolean isUsed) {
        this.isUsed = isUsed;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public OffsetDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(OffsetDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }
}