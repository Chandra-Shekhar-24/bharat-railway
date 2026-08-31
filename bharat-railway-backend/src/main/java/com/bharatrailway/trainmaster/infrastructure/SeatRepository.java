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
 * Spring Data JPA repository for train_master_schema.seats.
 */

package com.bharatrailway.trainmaster.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.trainmaster.domain.Seat;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Integer> {

    List<Seat> findByTrainNumberAndCoachClass(String trainNumber, String coachClass);

    List<Seat> findByTrainNumber(String trainNumber);

    boolean existsByTrainNumberAndCoachClassAndSeatNumber(String trainNumber, String coachClass, String seatNumber);
}