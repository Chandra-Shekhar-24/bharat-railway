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

import com.bharatrailway.trainmaster.domain.Train;

@Repository
public interface TrainRepository extends JpaRepository<Train, String> {

    Optional<Train> findByTrainNumber(String trainNumber);

    List<Train> findByOriginStationCode(String originStationCode);

    List<Train> findByDestinationStationCode(String destinationStationCode);

    List<Train> findByOriginStationCodeAndDestinationStationCode(String origin, String destination);

    List<Train> findByTrainStatus(String trainStatus);

    List<Train> findByTrainType(String trainType);

    boolean existsByTrainNumber(String trainNumber);
}