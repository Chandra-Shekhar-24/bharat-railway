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
 * Spring Data JPA repository for fare_schema.base_fare_matrix.
 */

package com.bharatrailway.fare.infrastructure;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.fare.domain.BaseFareMatrix;

@Repository
public interface BaseFareMatrixRepository extends JpaRepository<BaseFareMatrix, Integer> {

    Optional<BaseFareMatrix> findByTrainTypeAndCoachClassAndDistanceFromKmLessThanEqualAndDistanceToKmGreaterThanEqualAndIsActiveTrue(
            String trainType, String coachClass, Integer distance, Integer distance2);

    List<BaseFareMatrix> findByTrainTypeAndCoachClassAndIsActiveTrue(String trainType, String coachClass);

    List<BaseFareMatrix> findByIsActiveTrue();
}