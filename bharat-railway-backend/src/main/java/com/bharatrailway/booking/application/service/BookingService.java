/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-09-02
 * Version: 1.1.0
 *
 * Description:
 * Application service for Booking domain.
 * Handles PNR generation, passenger management, and booking operations.
 * v1.1.0: Added fare calculation from fare_schema.base_fare_matrix.
 */

package com.bharatrailway.booking.application.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
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
import com.bharatrailway.booking.infrastructure.FareRepositoryForBooking;
import com.bharatrailway.booking.infrastructure.TrainRepositoryForBooking;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final BookingPassengerRepository bookingPassengerRepository;
    private final TrainRepositoryForBooking trainRepositoryForBooking;
    private final FareRepositoryForBooking fareRepositoryForBooking;

    public BookingService(BookingRepository bookingRepository,
                          BookingPassengerRepository bookingPassengerRepository,
                          TrainRepositoryForBooking trainRepositoryForBooking,
                          FareRepositoryForBooking fareRepositoryForBooking) {
        this.bookingRepository = bookingRepository;
        this.bookingPassengerRepository = bookingPassengerRepository;
        this.trainRepositoryForBooking = trainRepositoryForBooking;
        this.fareRepositoryForBooking = fareRepositoryForBooking;
    }

    @Transactional
    public Booking createBooking(BookingRequest request) {
        String pnr = generatePnr();

        // Calculate fare based on distance and train type
        BigDecimal totalFare = calculateFare(request);

        Booking booking = new Booking();
        booking.setPnrNumber(pnr);
        booking.setUserId(request.getUserId());
        booking.setTrainNumber(request.getTrainNumber());
        booking.setSourceStationCode(request.getSourceStationCode());
        booking.setDestinationStationCode(request.getDestinationStationCode());
        booking.setJourneyDate(request.getJourneyDate());
        booking.setBookingDate(OffsetDateTime.now());
        booking.setTotalFare(totalFare);
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

    /**
     * Calculate total fare based on:
     * - Train distance
     * - Base fare from fare matrix
     * - Number of passengers
     * - Convenience fee per passenger (₹35 + 18% GST)
     */
    private BigDecimal calculateFare(BookingRequest request) {
        try {
            Double distance = trainRepositoryForBooking.findDistanceByTrainNumber(request.getTrainNumber());
            
            if (distance == null) {
                // Fallback: estimate distance based on route
                distance = 1000.0;
            }

            // Get train type and coach class
            String trainType = getTrainType(request.getTrainNumber());
            String coachClass = "SL"; // Default Sleeper class

            BigDecimal baseFare = fareRepositoryForBooking.findBaseFare(trainType, coachClass, distance);

            if (baseFare == null) {
                // Fallback fare if not found in matrix
                baseFare = BigDecimal.valueOf(distance * 0.50);
            }

            int passengerCount = request.getPassengers().size();
            BigDecimal farePerPassenger = baseFare;

            // Add reservation charge (₹40 per passenger)
            farePerPassenger = farePerPassenger.add(BigDecimal.valueOf(40));

            // Add convenience fee (₹35 per ticket + 18% GST)
            BigDecimal convenienceFee = BigDecimal.valueOf(35);
            BigDecimal gstOnFee = convenienceFee.multiply(BigDecimal.valueOf(0.18));
            farePerPassenger = farePerPassenger.add(convenienceFee).add(gstOnFee);

            // Calculate total
            BigDecimal totalFare = farePerPassenger.multiply(BigDecimal.valueOf(passengerCount));
            return totalFare.setScale(2, RoundingMode.HALF_UP);

        } catch (Exception e) {
            // Fallback: ₹500 per passenger
            return BigDecimal.valueOf(500).multiply(BigDecimal.valueOf(request.getPassengers().size()));
        }
    }

    private String getTrainType(String trainNumber) {
        // Simple mapping - can be enhanced to fetch from DB
        try {
            if (trainNumber.startsWith("12") || trainNumber.startsWith("22")) {
                return "Rajdhani";
            } else if (trainNumber.startsWith("120")) {
                return "Shatabdi";
            } else if (trainNumber.startsWith("126") || trainNumber.startsWith("127")) {
                return "Superfast";
            } else if (trainNumber.startsWith("128")) {
                return "Mail";
            } else {
                return "Express";
            }
        } catch (Exception e) {
            return "Express";
        }
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