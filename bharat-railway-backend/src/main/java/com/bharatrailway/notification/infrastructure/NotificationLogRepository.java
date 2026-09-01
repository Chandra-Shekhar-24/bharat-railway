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
 * Spring Data JPA repository for notification_schema.notification_logs.
 */

package com.bharatrailway.notification.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.notification.domain.NotificationLog;

@Repository
public interface NotificationLogRepository extends JpaRepository<NotificationLog, Integer> {

    List<NotificationLog> findByUserIdOrderByCreatedAtDesc(Integer userId);

    List<NotificationLog> findByStatus(String status);

    List<NotificationLog> findByBookingId(Integer bookingId);
}