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
 * Spring Data JPA repository for train_master_schema.routes.
 */

package com.bharatrailway.trainmaster.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.trainmaster.domain.Route;

@Repository
public interface RouteRepository extends JpaRepository<Route, Integer> {

    List<Route> findByTrainNumberOrderBySequenceNumberAsc(String trainNumber);

    List<Route> findByStationCode(String stationCode);

    List<Route> findByTrainNumberAndStationCode(String trainNumber, String stationCode);

    boolean existsByTrainNumberAndStationCode(String trainNumber, String stationCode);
}