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
 * Spring Data JPA repository for employee_schema.employee_station_assignments.
 */

package com.bharatrailway.employee.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.employee.domain.EmployeeStationAssignment;

@Repository
public interface EmployeeStationAssignmentRepository extends JpaRepository<EmployeeStationAssignment, Integer> {

    List<EmployeeStationAssignment> findByEmployeeId(Integer employeeId);

    List<EmployeeStationAssignment> findByStationCode(String stationCode);

    List<EmployeeStationAssignment> findByEmployeeIdAndIsActiveTrue(Integer employeeId);
}