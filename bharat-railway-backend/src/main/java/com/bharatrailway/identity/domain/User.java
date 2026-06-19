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
 * JPA Entity mapped to identity_schema.users.
 * Core passenger identity aggregate root. All user profile data,
 * account status, and lockout state managed here.
 * Zero knowledge of authentication/session logic.
 */

package com.bharatrailway.identity.domain;

import java.time.LocalDate;
import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "identity_schema", name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "full_name", length = 100, nullable = false)
    private String fullName;

    @Column(name = "username", length = 50, nullable = false, unique = true)
    private String username;

    @Column(name = "email", length = 255, nullable = false, unique = true)
    private String email;

    @Column(name = "mobile_number", length = 15, nullable = false, unique = true)
    private String mobileNumber;

    @Column(name = "password_hash", length = 255, nullable = false)
    private String passwordHash;

    @Column(name = "date_of_birth", nullable = false)
    private LocalDate dateOfBirth;

    @Column(name = "gender", length = 1, nullable = false)
    private Character gender;

    @Column(name = "status", nullable = false)
    private Short status;

    @Column(name = "failed_login_attempts", nullable = false)
    private Short failedLoginAttempts;

    @Column(name = "account_locked_until")
    private OffsetDateTime accountLockedUntil;

    @Column(name = "is_email_verified", nullable = false)
    private Boolean isEmailVerified;

    @Column(name = "is_mobile_verified", nullable = false)
    private Boolean isMobileVerified;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    // --- Constructors ---

    public User() {
    }

    // --- Getters and Setters ---

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Character getGender() {
        return gender;
    }

    public void setGender(Character gender) {
        this.gender = gender;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Short getFailedLoginAttempts() {
        return failedLoginAttempts;
    }

    public void setFailedLoginAttempts(Short failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts;
    }

    public OffsetDateTime getAccountLockedUntil() {
        return accountLockedUntil;
    }

    public void setAccountLockedUntil(OffsetDateTime accountLockedUntil) {
        this.accountLockedUntil = accountLockedUntil;
    }

    public Boolean getIsEmailVerified() {
        return isEmailVerified;
    }

    public void setIsEmailVerified(Boolean isEmailVerified) {
        this.isEmailVerified = isEmailVerified;
    }

    public Boolean getIsMobileVerified() {
        return isMobileVerified;
    }

    public void setIsMobileVerified(Boolean isMobileVerified) {
        this.isMobileVerified = isMobileVerified;
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