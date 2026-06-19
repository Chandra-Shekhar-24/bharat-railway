/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Hitanshu Dhakrey
 * Assisted by: Chandra Shekhar Bansal (Infrastructure), DeepSeek (AI Scribe)
 * Date: 2026-06-20
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Temporary health-check controller to verify database connectivity.
 * Returns JSON with connection status, DB version, and entity count.
 * REMOVE after Phase 1 controllers are live.
 */

package com.bharatrailway;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.identity.infrastructure.UserRepository;

@RestController
public class HealthController {

    private final DataSource dataSource;
    private final UserRepository userRepository;

    public HealthController(DataSource dataSource, UserRepository userRepository) {
        this.dataSource = dataSource;
        this.userRepository = userRepository;
    }

    @GetMapping("/api/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new LinkedHashMap<>();

        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            response.put("status", "CONNECTED");
            response.put("database", metaData.getDatabaseProductName() + " " + metaData.getDatabaseProductVersion());
            response.put("url", metaData.getURL());
            response.put("schema", "identity_schema, auth_schema");
            response.put("entities", 4);
            response.put("userTableRows", userRepository.count());
            response.put("timestamp", OffsetDateTime.now().toString());
        } catch (Exception e) {
            response.put("status", "DISCONNECTED");
            response.put("error", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}