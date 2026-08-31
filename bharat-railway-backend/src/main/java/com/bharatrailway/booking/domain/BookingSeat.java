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
 * JPA Entity mapped to booking_schema.booking_seats.
 * Seat allocation for each booking.
 */

package com.bharatrailway.booking.domain;

import java.io.Serializable;
import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

@Entity
@Table(schema = "booking_schema", name = "booking_seats")
@IdClass(BookingSeat.BookingSeatId.class)
public class BookingSeat {

    @Id
    @Column(name = "booking_id", nullable = false)
    private Integer bookingId;

    @Id
    @Column(name = "seat_id", nullable = false)
    private Integer seatId;

    @Column(name = "passenger_id")
    private Integer passengerId;

    @Column(name = "booked_price", precision = 10, scale = 2, nullable = false)
    private BigDecimal bookedPrice;

    @Column(name = "seat_status", length = 20, nullable = false)
    private String seatStatus;

    public BookingSeat() {
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public Integer getSeatId() {
        return seatId;
    }

    public void setSeatId(Integer seatId) {
        this.seatId = seatId;
    }

    public Integer getPassengerId() {
        return passengerId;
    }

    public void setPassengerId(Integer passengerId) {
        this.passengerId = passengerId;
    }

    public BigDecimal getBookedPrice() {
        return bookedPrice;
    }

    public void setBookedPrice(BigDecimal bookedPrice) {
        this.bookedPrice = bookedPrice;
    }

    public String getSeatStatus() {
        return seatStatus;
    }

    public void setSeatStatus(String seatStatus) {
        this.seatStatus = seatStatus;
    }

    public static class BookingSeatId implements Serializable {
        private Integer bookingId;
        private Integer seatId;

        public BookingSeatId() {
        }

        public BookingSeatId(Integer bookingId, Integer seatId) {
            this.bookingId = bookingId;
            this.seatId = seatId;
        }

        public Integer getBookingId() {
            return bookingId;
        }

        public void setBookingId(Integer bookingId) {
            this.bookingId = bookingId;
        }

        public Integer getSeatId() {
            return seatId;
        }

        public void setSeatId(Integer seatId) {
            this.seatId = seatId;
        }

        @Override
        public int hashCode() {
            return bookingId.hashCode() + seatId.hashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            BookingSeatId that = (BookingSeatId) obj;
            return bookingId.equals(that.bookingId) && seatId.equals(that.seatId);
        }
    }
}