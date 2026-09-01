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
 * Application service for Notification domain.
 * Handles template management and notification logging.
 */

package com.bharatrailway.notification.application.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.notification.domain.NotificationLog;
import com.bharatrailway.notification.domain.NotificationTemplate;
import com.bharatrailway.notification.infrastructure.NotificationLogRepository;
import com.bharatrailway.notification.infrastructure.NotificationTemplateRepository;

@Service
public class NotificationService {

    private final NotificationTemplateRepository templateRepository;
    private final NotificationLogRepository logRepository;

    public NotificationService(NotificationTemplateRepository templateRepository,
                               NotificationLogRepository logRepository) {
        this.templateRepository = templateRepository;
        this.logRepository = logRepository;
    }

    @Transactional
    public NotificationTemplate createTemplate(NotificationTemplate template) {
        template.setCreatedAt(OffsetDateTime.now());
        template.setUpdatedAt(OffsetDateTime.now());
        if (template.getIsActive() == null) {
            template.setIsActive(true);
        }
        return templateRepository.save(template);
    }

    public NotificationTemplate getTemplateByCode(String templateCode) {
        return templateRepository.findByTemplateCode(templateCode)
                .orElseThrow(() -> new RuntimeException("Template not found: " + templateCode));
    }

    public List<NotificationTemplate> getTemplatesByChannel(String channel) {
        return templateRepository.findByChannelAndIsActiveTrue(channel);
    }

    public List<NotificationTemplate> getAllActiveTemplates() {
        return templateRepository.findByIsActiveTrue();
    }

    @Transactional
    public NotificationLog sendNotification(Integer userId, String templateCode,
                                             String recipient, Integer bookingId) {
        NotificationTemplate template = getTemplateByCode(templateCode);

        NotificationLog log = new NotificationLog();
        log.setUserId(userId);
        log.setTemplateId(template.getTemplateId());
        log.setChannel(template.getChannel());
        log.setRecipient(recipient);
        log.setSubject(template.getSubject());
        log.setBody(template.getBody());
        log.setStatus("SENT");
        log.setBookingId(bookingId);
        log.setCreatedAt(OffsetDateTime.now());

        return logRepository.save(log);
    }

    public List<NotificationLog> getLogsByUser(Integer userId) {
        return logRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public List<NotificationLog> getLogsByStatus(String status) {
        return logRepository.findByStatus(status);
    }

    public List<NotificationLog> getLogsByBooking(Integer bookingId) {
        return logRepository.findByBookingId(bookingId);
    }
}