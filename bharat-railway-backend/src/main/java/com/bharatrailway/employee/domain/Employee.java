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
 * JPA Entity mapped to employee_schema.employees.
 */

package com.bharatrailway.employee.domain;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "employee_schema", name = "employees")
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "employee_id")
    private Integer employeeId;

    @Column(name = "employee_code", length = 20, nullable = false, unique = true)
    private String employeeCode;

    @Column(name = "first_name", length = 50, nullable = false)
    private String firstName;

    @Column(name = "last_name", length = 50, nullable = false)
    private String lastName;

    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;

    @Column(name = "mobile_number", length = 15, nullable = false)
    private String mobileNumber;

    @Column(name = "designation", length = 100, nullable = false)
    private String designation;

    @Column(name = "department", length = 30, nullable = false)
    private String department;

    @Column(name = "zone", length = 50, nullable = false)
    private String zone;

    @Column(name = "division", length = 50, nullable = false)
    private String division;

    @Column(name = "reporting_manager_id")
    private Integer reportingManagerId;

    @Column(name = "joining_date", nullable = false)
    private LocalDate joiningDate;

    @Column(name = "employment_status", length = 20, nullable = false)
    private String employmentStatus;

    @Column(name = "admin_access_status", length = 20, nullable = false)
    private String adminAccessStatus;

    @Column(name = "max_fare_change_percent", precision = 5, scale = 2, nullable = false)
    private BigDecimal maxFareChangePercent;

    @Column(name = "max_refund_approval", precision = 10, scale = 2, nullable = false)
    private BigDecimal maxRefundApproval;

    @Column(name = "last_login_at")
    private OffsetDateTime lastLoginAt;

    @Column(name = "last_login_ip", length = 45)
    private String lastLoginIp;

    @Column(name = "login_attempts_failed", nullable = false)
    private Short loginAttemptsFailed;

    @Column(name = "is_mfa_enabled", nullable = false)
    private Boolean isMfaEnabled;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    public Employee() {
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeCode() {
        return employeeCode;
    }

    public void setEmployeeCode(String employeeCode) {
        this.employeeCode = employeeCode;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
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

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getZone() {
        return zone;
    }

    public void setZone(String zone) {
        this.zone = zone;
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
    }

    public Integer getReportingManagerId() {
        return reportingManagerId;
    }

    public void setReportingManagerId(Integer reportingManagerId) {
        this.reportingManagerId = reportingManagerId;
    }

    public LocalDate getJoiningDate() {
        return joiningDate;
    }

    public void setJoiningDate(LocalDate joiningDate) {
        this.joiningDate = joiningDate;
    }

    public String getEmploymentStatus() {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus) {
        this.employmentStatus = employmentStatus;
    }

    public String getAdminAccessStatus() {
        return adminAccessStatus;
    }

    public void setAdminAccessStatus(String adminAccessStatus) {
        this.adminAccessStatus = adminAccessStatus;
    }

    public BigDecimal getMaxFareChangePercent() {
        return maxFareChangePercent;
    }

    public void setMaxFareChangePercent(BigDecimal maxFareChangePercent) {
        this.maxFareChangePercent = maxFareChangePercent;
    }

    public BigDecimal getMaxRefundApproval() {
        return maxRefundApproval;
    }

    public void setMaxRefundApproval(BigDecimal maxRefundApproval) {
        this.maxRefundApproval = maxRefundApproval;
    }

    public OffsetDateTime getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(OffsetDateTime lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public String getLastLoginIp() {
        return lastLoginIp;
    }

    public void setLastLoginIp(String lastLoginIp) {
        this.lastLoginIp = lastLoginIp;
    }

    public Short getLoginAttemptsFailed() {
        return loginAttemptsFailed;
    }

    public void setLoginAttemptsFailed(Short loginAttemptsFailed) {
        this.loginAttemptsFailed = loginAttemptsFailed;
    }

    public Boolean getIsMfaEnabled() {
        return isMfaEnabled;
    }

    public void setIsMfaEnabled(Boolean isMfaEnabled) {
        this.isMfaEnabled = isMfaEnabled;
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