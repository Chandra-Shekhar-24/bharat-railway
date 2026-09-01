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
 * Application service for Employee domain.
 * Handles employee CRUD, roles, and station assignments.
 */

package com.bharatrailway.employee.application.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.employee.domain.Employee;
import com.bharatrailway.employee.domain.EmployeeRole;
import com.bharatrailway.employee.domain.EmployeeStationAssignment;
import com.bharatrailway.employee.infrastructure.EmployeeRepository;
import com.bharatrailway.employee.infrastructure.EmployeeRoleRepository;
import com.bharatrailway.employee.infrastructure.EmployeeStationAssignmentRepository;

@Service
public class EmployeeService {

    private final EmployeeRepository employeeRepository;
    private final EmployeeRoleRepository employeeRoleRepository;
    private final EmployeeStationAssignmentRepository assignmentRepository;

    public EmployeeService(EmployeeRepository employeeRepository,
                           EmployeeRoleRepository employeeRoleRepository,
                           EmployeeStationAssignmentRepository assignmentRepository) {
        this.employeeRepository = employeeRepository;
        this.employeeRoleRepository = employeeRoleRepository;
        this.assignmentRepository = assignmentRepository;
    }

    // Employee operations
    @Transactional
    public Employee createEmployee(Employee employee) {
        employee.setCreatedAt(OffsetDateTime.now());
        employee.setUpdatedAt(OffsetDateTime.now());
        if (employee.getEmploymentStatus() == null) employee.setEmploymentStatus("ACTIVE");
        if (employee.getAdminAccessStatus() == null) employee.setAdminAccessStatus("ACTIVE");
        if (employee.getLoginAttemptsFailed() == null) employee.setLoginAttemptsFailed((short) 0);
        if (employee.getIsMfaEnabled() == null) employee.setIsMfaEnabled(false);
        return employeeRepository.save(employee);
    }

    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    public Employee getEmployeeById(Integer id) {
        return employeeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Employee not found: " + id));
    }

    public Employee getEmployeeByCode(String code) {
        return employeeRepository.findByEmployeeCode(code)
                .orElseThrow(() -> new RuntimeException("Employee not found with code: " + code));
    }

    public List<Employee> getEmployeesByDepartment(String department) {
        return employeeRepository.findByDepartment(department);
    }

    // Role operations
    @Transactional
    public EmployeeRole createRole(EmployeeRole role) {
        role.setCreatedAt(OffsetDateTime.now());
        if (role.getIsActive() == null) role.setIsActive(true);
        if (role.getIsSystemRole() == null) role.setIsSystemRole(false);
        if (role.getIsStationScoped() == null) role.setIsStationScoped(false);
        return employeeRoleRepository.save(role);
    }

    public List<EmployeeRole> getAllRoles() {
        return employeeRoleRepository.findAll();
    }

    public EmployeeRole getRoleByCode(String code) {
        return employeeRoleRepository.findByRoleCode(code)
                .orElseThrow(() -> new RuntimeException("Role not found: " + code));
    }

    // Station assignment operations
    @Transactional
    public EmployeeStationAssignment assignStation(Integer employeeId, String stationCode,
                                                    Boolean isPrimary) {
        EmployeeStationAssignment assignment = new EmployeeStationAssignment();
        assignment.setEmployeeId(employeeId);
        assignment.setStationCode(stationCode);
        assignment.setIsPrimaryStation(isPrimary != null ? isPrimary : false);
        assignment.setAssignedAt(OffsetDateTime.now());
        assignment.setIsActive(true);
        return assignmentRepository.save(assignment);
    }

    public List<EmployeeStationAssignment> getAssignmentsByEmployee(Integer employeeId) {
        return assignmentRepository.findByEmployeeIdAndIsActiveTrue(employeeId);
    }

    public List<EmployeeStationAssignment> getAssignmentsByStation(String stationCode) {
        return assignmentRepository.findByStationCode(stationCode);
    }
}