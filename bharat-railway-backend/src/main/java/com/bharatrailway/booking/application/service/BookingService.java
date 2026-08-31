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
 * Application service for Booking domain.
 * Handles PNR generation, passenger management, and booking operations.
 */

package com.bharatrailway.booking.application.service;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.booking.application.dto.BookingRequest;
import com.bharatrailway.booking.application.dto.PassengerRequest;
import com.bharatrailway.booking.domain.Booking;
import com.bharatrailway.booking.domain.BookingPassenger;
import com.bharatrailway.booking.infrastructure.BookingPassengerRepository;
import com.bharatrailway.booking.infrastructure.BookingRepository;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final BookingPassengerRepository bookingPassengerRepository;

    public BookingService(BookingRepository bookingRepository,
                          BookingPassengerRepository bookingPassengerRepository) {
        this.bookingRepository = bookingRepository;
        this.bookingPassengerRepository = bookingPassengerRepository;
    }

    @Transactional
    public Booking createBooking(BookingRequest request) {
        String pnr = generatePnr();

        Booking booking = new Booking();
        booking.setPnrNumber(pnr);
        booking.setUserId(request.getUserId());
        booking.setTrainNumber(request.getTrainNumber());
        booking.setSourceStationCode(request.getSourceStationCode());
        booking.setDestinationStationCode(request.getDestinationStationCode());
        booking.setJourneyDate(request.getJourneyDate());
        booking.setBookingDate(OffsetDateTime.now());
        booking.setTotalFare(BigDecimal.ZERO);
        booking.setBookingStatus("PENDING");
        booking.setPaymentStatus("PENDING");
        booking.setCreatedAt(OffsetDateTime.now());
        booking.setUpdatedAt(OffsetDateTime.now());

        Booking savedBooking = bookingRepository.save(booking);

        // Save passengers
        for (PassengerRequest passengerReq : request.getPassengers()) {
            BookingPassenger passenger = new BookingPassenger();
            passenger.setBookingId(savedBooking.getBookingId());
            passenger.setFullName(passengerReq.getFullName());
            passenger.setAge(passengerReq.getAge());
            passenger.setGender(passengerReq.getGender().charAt(0));
            passenger.setBerthPreference(passengerReq.getBerthPreference());
            passenger.setBookingStatus("CONFIRMED");
            passenger.setCreatedAt(OffsetDateTime.now());
            bookingPassengerRepository.save(passenger);
        }

        return savedBooking;
    }

    public Booking getBookingByPnr(String pnrNumber) {
        return bookingRepository.findByPnrNumber(pnrNumber)
                .orElseThrow(() -> new RuntimeException("Booking not found with PNR: " + pnrNumber));
    }

    public List<Booking> getBookingsByUser(Integer userId) {
        return bookingRepository.findByUserIdOrderByBookingDateDesc(userId);
    }

    public List<BookingPassenger> getPassengersByBooking(Integer bookingId) {
        return bookingPassengerRepository.findByBookingId(bookingId);
    }

    private String generatePnr() {
        SecureRandom random = new SecureRandom();
        StringBuilder pnr = new StringBuilder();
        String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        for (int i = 0; i < 10; i++) {
            pnr.append(chars.charAt(random.nextInt(chars.length())));
        }
        return pnr.toString();
    }
}