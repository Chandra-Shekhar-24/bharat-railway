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
 * Spring Data JPA repository for train_master_schema.train_coach_composition.
 */

package com.bharatrailway.trainmaster.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.trainmaster.domain.TrainCoachComposition;

@Repository
public interface TrainCoachCompositionRepository extends JpaRepository<TrainCoachComposition, Integer> {

    List<TrainCoachComposition> findByTrainNumber(String trainNumber);

    List<TrainCoachComposition> findByTrainNumberAndCoachClass(String trainNumber, String coachClass);

    boolean existsByTrainNumberAndCoachClass(String trainNumber, String coachClass);
}