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
 * Kafka notification event payload for password reset.
 * Produced to notification.events topic for future Notification service.
 */

package com.bharatrailway.auth.infrastructure.kafka;

public class NotificationEvent {

    private Integer userId;
    private String email;
    private String resetToken;
    private String channel;

    public NotificationEvent() {
    }

    public NotificationEvent(Integer userId, String email, String resetToken, String channel) {
        this.userId = userId;
        this.email = email;
        this.resetToken = resetToken;
        this.channel = channel;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }
}