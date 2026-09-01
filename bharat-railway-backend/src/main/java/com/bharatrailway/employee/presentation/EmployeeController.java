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
 * REST controller for Employee domain.
 * Provides endpoints for employee CRUD, roles, and station assignments.
 */

package com.bharatrailway.employee.presentation;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.employee.application.service.EmployeeService;
import com.bharatrailway.employee.domain.Employee;
import com.bharatrailway.employee.domain.EmployeeRole;
import com.bharatrailway.employee.domain.EmployeeStationAssignment;

@RestController
@RequestMapping("/api/v1/employees")
public class EmployeeController {

    private final EmployeeService employeeService;

    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @PostMapping
    public ResponseEntity<Employee> createEmployee(@RequestBody Employee employee) {
        Employee created = employeeService.createEmployee(employee);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping
    public ResponseEntity<List<Employee>> getAllEmployees() {
        return ResponseEntity.ok(employeeService.getAllEmployees());
    }

    @GetMapping("/{employeeId}")
    public ResponseEntity<Employee> getEmployeeById(@PathVariable Integer employeeId) {
        return ResponseEntity.ok(employeeService.getEmployeeById(employeeId));
    }

    @GetMapping("/code/{employeeCode}")
    public ResponseEntity<Employee> getEmployeeByCode(@PathVariable String employeeCode) {
        return ResponseEntity.ok(employeeService.getEmployeeByCode(employeeCode));
    }

    @GetMapping("/department/{department}")
    public ResponseEntity<List<Employee>> getEmployeesByDepartment(@PathVariable String department) {
        return ResponseEntity.ok(employeeService.getEmployeesByDepartment(department));
    }

    @PostMapping("/roles")
    public ResponseEntity<EmployeeRole> createRole(@RequestBody EmployeeRole role) {
        EmployeeRole created = employeeService.createRole(role);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping("/roles")
    public ResponseEntity<List<EmployeeRole>> getAllRoles() {
        return ResponseEntity.ok(employeeService.getAllRoles());
    }

    @GetMapping("/roles/{roleCode}")
    public ResponseEntity<EmployeeRole> getRoleByCode(@PathVariable String roleCode) {
        return ResponseEntity.ok(employeeService.getRoleByCode(roleCode));
    }

    @PostMapping("/{employeeId}/assign-station")
    public ResponseEntity<EmployeeStationAssignment> assignStation(
            @PathVariable Integer employeeId,
            @RequestBody Map<String, Object> request) {
        String stationCode = (String) request.get("stationCode");
        Boolean isPrimary = (Boolean) request.get("isPrimary");

        EmployeeStationAssignment assignment = employeeService.assignStation(employeeId, stationCode, isPrimary);
        return ResponseEntity.status(HttpStatus.CREATED).body(assignment);
    }

    @GetMapping("/{employeeId}/assignments")
    public ResponseEntity<List<EmployeeStationAssignment>> getAssignmentsByEmployee(
            @PathVariable Integer employeeId) {
        return ResponseEntity.ok(employeeService.getAssignmentsByEmployee(employeeId));
    }

    @GetMapping("/station/{stationCode}/assignments")
    public ResponseEntity<List<EmployeeStationAssignment>> getAssignmentsByStation(
            @PathVariable String stationCode) {
        return ResponseEntity.ok(employeeService.getAssignmentsByStation(stationCode));
    }
}