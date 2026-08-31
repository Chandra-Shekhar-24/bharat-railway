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
 * Spring Data JPA repository for fare_schema.convenience_fee_config.
 */

package com.bharatrailway.fare.infrastructure;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.fare.domain.ConvenienceFeeConfig;

@Repository
public interface ConvenienceFeeConfigRepository extends JpaRepository<ConvenienceFeeConfig, Integer> {

    Optional<ConvenienceFeeConfig> findByBookingChannelAndCoachClassAndIsActiveTrue(
            String bookingChannel, String coachClass);

    List<ConvenienceFeeConfig> findByBookingChannelAndIsActiveTrue(String bookingChannel);

    List<ConvenienceFeeConfig> findByIsActiveTrue();
}