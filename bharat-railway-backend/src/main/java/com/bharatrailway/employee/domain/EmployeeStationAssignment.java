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
 * JPA Entity mapped to employee_schema.employee_station_assignments.
 */

package com.bharatrailway.employee.domain;

import java.time.OffsetDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "employee_schema", name = "employee_station_assignments")
public class EmployeeStationAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "assignment_id")
    private Integer assignmentId;

    @Column(name = "employee_id", nullable = false)
    private Integer employeeId;

    @Column(name = "station_code", length = 5, nullable = false)
    private String stationCode;

    @Column(name = "is_primary_station", nullable = false)
    private Boolean isPrimaryStation;

    @Column(name = "assigned_at", nullable = false, updatable = false)
    private OffsetDateTime assignedAt;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    public EmployeeStationAssignment() {
    }

    public Integer getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Integer assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        this.employeeId = employeeId;
    }

    public String getStationCode() {
        return stationCode;
    }

    public void setStationCode(String stationCode) {
        this.stationCode = stationCode;
    }

    public Boolean getIsPrimaryStation() {
        return isPrimaryStation;
    }

    public void setIsPrimaryStation(Boolean isPrimaryStation) {
        this.isPrimaryStation = isPrimaryStation;
    }

    public OffsetDateTime getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(OffsetDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}