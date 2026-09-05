/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-02
 * Version: 1.0.0
 *
 * Description:
 * Repository for fetching train distance and fare info for booking.
 */

package com.bharatrailway.booking.infrastructure;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.bharatrailway.trainmaster.domain.Train;

@Repository
public interface TrainRepositoryForBooking extends JpaRepository<Train, String> {

    @Query(value = """
        SELECT t.total_distance FROM train_master_schema.trains t 
        WHERE t.train_number = :trainNumber
        """, nativeQuery = true)
    Double findDistanceByTrainNumber(@Param("trainNumber") String trainNumber);
}