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
 * JWT service for access token generation and validation.
 * TTL: 60 minutes. Claims: user_id, username, status.
 * Uses HMAC-SHA256 with a secret key.
 * Secret key to be externalized to environment variable in production.
 */

package com.bharatrailway.auth.application;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

    private static final String SECRET = "Bhr@tR@ilway_JWT_S3cr3t_K3y_2026_Min_32_Chars!";
    private static final long EXPIRATION_MS = 60 * 60 * 1000; // 60 minutes

    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
    }

    public String generateToken(Integer userId, String username, Short status) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + EXPIRATION_MS);

        return Jwts.builder()
                .claim("user_id", userId)
                .claim("username", username)
                .claim("status", status)
                .issuedAt(now)
                .expiration(expiry)
                .signWith(getSigningKey())
                .compact();
    }

    public Claims validateToken(String token) {
        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public boolean isTokenExpired(String token) {
        try {
            Claims claims = validateToken(token);
            return claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    public Integer getUserId(String token) {
        return validateToken(token).get("user_id", Integer.class);
    }

    public String getUsername(String token) {
        return validateToken(token).get("username", String.class);
    }

    public Short getStatus(String token) {
        return validateToken(token).get("status", Short.class);
    }

    public long getExpirationMs() {
        return EXPIRATION_MS;
    }
}