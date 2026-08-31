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
 * REST controller for Booking domain.
 * Provides endpoints for creating bookings, retrieving by PNR, and user history.
 */

package com.bharatrailway.booking.presentation;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.booking.application.dto.BookingRequest;
import com.bharatrailway.booking.application.service.BookingService;
import com.bharatrailway.booking.domain.Booking;
import com.bharatrailway.booking.domain.BookingPassenger;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping
    public ResponseEntity<Booking> createBooking(@Valid @RequestBody BookingRequest request) {
        Booking booking = bookingService.createBooking(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(booking);
    }

    @GetMapping("/pnr/{pnrNumber}")
    public ResponseEntity<Booking> getBookingByPnr(@PathVariable String pnrNumber) {
        return ResponseEntity.ok(bookingService.getBookingByPnr(pnrNumber));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Booking>> getBookingsByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(bookingService.getBookingsByUser(userId));
    }

    @GetMapping("/{bookingId}/passengers")
    public ResponseEntity<List<BookingPassenger>> getPassengersByBooking(@PathVariable Integer bookingId) {
        return ResponseEntity.ok(bookingService.getPassengersByBooking(bookingId));
    }
}