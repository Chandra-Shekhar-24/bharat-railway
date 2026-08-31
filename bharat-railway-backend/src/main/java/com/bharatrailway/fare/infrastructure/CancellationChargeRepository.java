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
 * Spring Data JPA repository for fare_schema.cancellation_charges.
 */

package com.bharatrailway.fare.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.fare.domain.CancellationCharge;

@Repository
public interface CancellationChargeRepository extends JpaRepository<CancellationCharge, Integer> {

    List<CancellationCharge> findByCoachClassAndIsActiveTrue(String coachClass);

    List<CancellationCharge> findByCancellationTypeAndCoachClassAndIsActiveTrue(
            String cancellationType, String coachClass);
}