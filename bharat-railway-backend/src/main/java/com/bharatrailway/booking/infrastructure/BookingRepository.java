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
 * Spring Data JPA repository for booking_schema.bookings.
 */

package com.bharatrailway.booking.infrastructure;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.booking.domain.Booking;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer> {

    Optional<Booking> findByPnrNumber(String pnrNumber);

    List<Booking> findByUserIdOrderByBookingDateDesc(Integer userId);

    List<Booking> findByTrainNumberAndJourneyDate(String trainNumber, LocalDate journeyDate);

    List<Booking> findByBookingStatus(String bookingStatus);

    boolean existsByPnrNumber(String pnrNumber);
}