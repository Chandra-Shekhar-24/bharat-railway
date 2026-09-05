/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-09-02
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Train search response DTO with departure/arrival time, duration,
 * fare estimate, and available seats per class.
 */

package com.bharatrailway.trainmaster.application.dto;

import java.math.BigDecimal;
import java.util.Map;

public class TrainSearchResponse {

    private String trainNumber;
    private String trainName;
    private String departureTime;
    private String arrivalTime;
    private String duration;
    private BigDecimal fareEstimate;
    private Map<String, Integer> availableSeats;

    public TrainSearchResponse() {
    }

    public TrainSearchResponse(String trainNumber, String trainName,
                               String departureTime, String arrivalTime,
                               String duration, BigDecimal fareEstimate,
                               Map<String, Integer> availableSeats) {
        this.trainNumber = trainNumber;
        this.trainName = trainName;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.duration = duration;
        this.fareEstimate = fareEstimate;
        this.availableSeats = availableSeats;
    }

    public String getTrainNumber() {
        return trainNumber;
    }

    public void setTrainNumber(String trainNumber) {
        this.trainNumber = trainNumber;
    }

    public String getTrainName() {
        return trainName;
    }

    public void setTrainName(String trainName) {
        this.trainName = trainName;
    }

    public String getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(String departureTime) {
        this.departureTime = departureTime;
    }

    public String getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(String arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public BigDecimal getFareEstimate() {
        return fareEstimate;
    }

    public void setFareEstimate(BigDecimal fareEstimate) {
        this.fareEstimate = fareEstimate;
    }

    public Map<String, Integer> getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(Map<String, Integer> availableSeats) {
        this.availableSeats = availableSeats;
    }
}