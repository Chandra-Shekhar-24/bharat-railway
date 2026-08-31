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
 * Spring Data JPA repository for booking_schema.booking_seats.
 */

package com.bharatrailway.booking.infrastructure;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.booking.domain.BookingSeat;

@Repository
public interface BookingSeatRepository extends JpaRepository<BookingSeat, BookingSeat.BookingSeatId> {

    List<BookingSeat> findByBookingId(Integer bookingId);

    List<BookingSeat> findBySeatId(Integer seatId);
}