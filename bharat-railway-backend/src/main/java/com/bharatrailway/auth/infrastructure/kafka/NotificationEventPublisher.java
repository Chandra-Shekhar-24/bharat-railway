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
 * Spring Kafka producer for notification events.
 * Publishes password reset token to notification.events topic.
 */

package com.bharatrailway.auth.infrastructure.kafka;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
public class NotificationEventPublisher {

    private static final String TOPIC = "notification.events";

    private final KafkaTemplate<String, NotificationEvent> kafkaTemplate;

    public NotificationEventPublisher(KafkaTemplate<String, NotificationEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void publishPasswordReset(NotificationEvent event) {
        kafkaTemplate.send(TOPIC, event.getEmail(), event);
    }
}