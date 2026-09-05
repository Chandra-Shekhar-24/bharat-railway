/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-02
 * Version: 1.0.0
 *
 * Description:
 * Repository for fetching base fare from fare matrix.
 */

package com.bharatrailway.booking.infrastructure;

import java.math.BigDecimal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FareRepositoryForBooking extends JpaRepository<com.bharatrailway.fare.domain.BaseFareMatrix, Long> {

    @Query(value = """
        SELECT f.base_fare FROM fare_schema.base_fare_matrix f 
        WHERE f.train_type = :trainType 
          AND f.coach_class = :coachClass
          AND :distance BETWEEN f.distance_from_km AND f.distance_to_km
        LIMIT 1
        """, nativeQuery = true)
    BigDecimal findBaseFare(@Param("trainType") String trainType,
                            @Param("coachClass") String coachClass,
                            @Param("distance") Double distance);
}