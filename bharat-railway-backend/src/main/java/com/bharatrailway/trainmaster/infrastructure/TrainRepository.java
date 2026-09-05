/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-09-05
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Spring Data JPA repository for train_master_schema.trains.
 * Enhanced with mid-station search using route sequences.
 */

package com.bharatrailway.trainmaster.infrastructure;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    @Query(value = "SELECT DISTINCT t.* FROM train_master_schema.trains t " +
           "JOIN train_master_schema.routes r1 ON r1.train_number = t.train_number " +
           "JOIN train_master_schema.routes r2 ON r2.train_number = t.train_number " +
           "WHERE r1.station_code = :source " +
           "AND r2.station_code = :destination " +
           "AND r1.sequence_number < r2.sequence_number " +
           "AND r1.is_commercial_stop = TRUE " +
           "AND r2.is_commercial_stop = TRUE " +
           "AND t.train_status = 'Active'", nativeQuery = true)
    List<Train> searchTrainsByStations(@Param("source") String source,
                                       @Param("destination") String destination);
}