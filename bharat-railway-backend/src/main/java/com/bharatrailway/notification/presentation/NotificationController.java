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
 * REST controller for Notification domain.
 * Provides endpoints for templates and notification logs.
 */

package com.bharatrailway.notification.presentation;

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

import com.bharatrailway.notification.application.service.NotificationService;
import com.bharatrailway.notification.domain.NotificationLog;
import com.bharatrailway.notification.domain.NotificationTemplate;

@RestController
@RequestMapping("/api/v1/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/templates")
    public ResponseEntity<NotificationTemplate> createTemplate(
            @RequestBody NotificationTemplate template) {
        NotificationTemplate created = notificationService.createTemplate(template);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping("/templates")
    public ResponseEntity<List<NotificationTemplate>> getAllActiveTemplates() {
        return ResponseEntity.ok(notificationService.getAllActiveTemplates());
    }

    @GetMapping("/templates/{templateCode}")
    public ResponseEntity<NotificationTemplate> getTemplateByCode(
            @PathVariable String templateCode) {
        return ResponseEntity.ok(notificationService.getTemplateByCode(templateCode));
    }

    @PostMapping("/send")
    public ResponseEntity<NotificationLog> sendNotification(
            @RequestBody Map<String, Object> request) {
        Integer userId = (Integer) request.get("userId");
        String templateCode = (String) request.get("templateCode");
        String recipient = (String) request.get("recipient");
        Integer bookingId = request.get("bookingId") != null ? (Integer) request.get("bookingId") : null;

        NotificationLog log = notificationService.sendNotification(userId, templateCode, recipient, bookingId);
        return ResponseEntity.status(HttpStatus.CREATED).body(log);
    }

    @GetMapping("/logs/user/{userId}")
    public ResponseEntity<List<NotificationLog>> getLogsByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(notificationService.getLogsByUser(userId));
    }

    @GetMapping("/logs/status/{status}")
    public ResponseEntity<List<NotificationLog>> getLogsByStatus(@PathVariable String status) {
        return ResponseEntity.ok(notificationService.getLogsByStatus(status));
    }

    @GetMapping("/logs/booking/{bookingId}")
    public ResponseEntity<List<NotificationLog>> getLogsByBooking(@PathVariable Integer bookingId) {
        return ResponseEntity.ok(notificationService.getLogsByBooking(bookingId));
    }
}