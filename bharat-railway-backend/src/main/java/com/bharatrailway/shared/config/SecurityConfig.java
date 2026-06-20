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
 * Spring Security configuration for Phase 1.
 * Public endpoints: /api/health, /api/v1/auth/register, /api/v1/auth/login,
 * /api/v1/auth/forgot-password, /api/v1/auth/reset-password
 * All other endpoints require authentication.
 * httpBasic disabled - auth handled by custom services.
 * JWT filter to be added for authenticated endpoints.
 */

package com.bharatrailway.shared.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/health").permitAll()
                .requestMatchers("/api/v1/auth/register").permitAll()
                .requestMatchers("/api/v1/auth/login").permitAll()
                .requestMatchers("/api/v1/auth/forgot-password").permitAll()
                .requestMatchers("/api/v1/auth/reset-password").permitAll()
                .anyRequest().authenticated()
            );

        return http.build();
    }
}