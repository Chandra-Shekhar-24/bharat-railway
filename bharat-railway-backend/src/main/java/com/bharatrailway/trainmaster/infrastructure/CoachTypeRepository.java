/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-08-31
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Spring Data JPA repository for train_master_schema.coach_types.
 */

package com.bharatrailway.trainmaster.infrastructure;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.trainmaster.domain.CoachType;

@Repository
public interface CoachTypeRepository extends JpaRepository<CoachType, String> {

    Optional<CoachType> findByCoachCode(String coachCode);

    List<CoachType> findByComfortLevel(String comfortLevel);

    List<CoachType> findByHasAc(Boolean hasAc);

    boolean existsByCoachCode(String coachCode);
}