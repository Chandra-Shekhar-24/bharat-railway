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
 * Phase 1 Backend API - Spring Boot Entry Point.
 * Java 21 Virtual Threads enabled. DDD architecture.
 * Single DataSource to bharat_railway_core via PgBouncer.
 */

package com.bharatrailway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BharatRailwayApplication {

    public static void main(String[] args) {
        SpringApplication.run(BharatRailwayApplication.class, args);
    }
}