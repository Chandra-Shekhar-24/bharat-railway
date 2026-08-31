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
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.trainmaster.domain.Station;

@Repository
public interface StationRepository extends JpaRepository<Station, String> {

    Optional<Station> findByStationCode(String stationCode);

    List<Station> findByCity(String city);

    List<Station> findByState(String state);

    List<Station> findByZone(String zone);

    List<Station> findByStationStatus(String stationStatus);

    boolean existsByStationCode(String stationCode);
}