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
 * REST controller for Fare domain.
 * Provides endpoints for fare calculation and fare queries.
 */

package com.bharatrailway.fare.presentation;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.fare.application.service.FareService;
import com.bharatrailway.fare.domain.BaseFareMatrix;
import com.bharatrailway.fare.domain.CancellationCharge;
import com.bharatrailway.fare.domain.ConvenienceFeeConfig;

@RestController
@RequestMapping("/api/v1/fares")
public class FareController {

    private final FareService fareService;

    public FareController(FareService fareService) {
        this.fareService = fareService;
    }

    @GetMapping("/calculate")
    public ResponseEntity<Map<String, BigDecimal>> calculateFare(
            @RequestParam String trainType,
            @RequestParam String coachClass,
            @RequestParam Integer distance) {
        BigDecimal fare = fareService.calculateBaseFare(trainType, coachClass, distance);
        return ResponseEntity.ok(Map.of("baseFare", fare));
    }

    @GetMapping("/matrix")
    public ResponseEntity<List<BaseFareMatrix>> getAllBaseFares() {
        return ResponseEntity.ok(fareService.getAllBaseFares());
    }

    @GetMapping("/matrix/{trainType}/{coachClass}")
    public ResponseEntity<List<BaseFareMatrix>> getFaresByClass(
            @PathVariable String trainType,
            @PathVariable String coachClass) {
        return ResponseEntity.ok(fareService.getFaresByClass(trainType, coachClass));
    }

    @GetMapping("/cancellation/{coachClass}")
    public ResponseEntity<List<CancellationCharge>> getCancellationCharges(
            @PathVariable String coachClass) {
        return ResponseEntity.ok(fareService.getCancellationCharges(coachClass));
    }

    @GetMapping("/convenience/{bookingChannel}")
    public ResponseEntity<List<ConvenienceFeeConfig>> getConvenienceFees(
            @PathVariable String bookingChannel) {
        return ResponseEntity.ok(fareService.getConvenienceFees(bookingChannel));
    }
}