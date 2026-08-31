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
 * Application service for Fare domain.
 * Provides fare calculation and fare matrix queries.
 */

package com.bharatrailway.fare.application.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;

import com.bharatrailway.fare.domain.BaseFareMatrix;
import com.bharatrailway.fare.domain.CancellationCharge;
import com.bharatrailway.fare.domain.ConvenienceFeeConfig;
import com.bharatrailway.fare.infrastructure.BaseFareMatrixRepository;
import com.bharatrailway.fare.infrastructure.CancellationChargeRepository;
import com.bharatrailway.fare.infrastructure.ConvenienceFeeConfigRepository;

@Service
public class FareService {

    private final BaseFareMatrixRepository baseFareMatrixRepository;
    private final CancellationChargeRepository cancellationChargeRepository;
    private final ConvenienceFeeConfigRepository convenienceFeeConfigRepository;

    public FareService(BaseFareMatrixRepository baseFareMatrixRepository,
                       CancellationChargeRepository cancellationChargeRepository,
                       ConvenienceFeeConfigRepository convenienceFeeConfigRepository) {
        this.baseFareMatrixRepository = baseFareMatrixRepository;
        this.cancellationChargeRepository = cancellationChargeRepository;
        this.convenienceFeeConfigRepository = convenienceFeeConfigRepository;
    }

    public BigDecimal calculateBaseFare(String trainType, String coachClass, Integer distance) {
        BaseFareMatrix matrix = baseFareMatrixRepository
                .findByTrainTypeAndCoachClassAndDistanceFromKmLessThanEqualAndDistanceToKmGreaterThanEqualAndIsActiveTrue(
                        trainType, coachClass, distance, distance)
                .orElseThrow(() -> new RuntimeException(
                        "No fare matrix found for " + trainType + " - " + coachClass + " at " + distance + " km"));

        BigDecimal baseFare = matrix.getBaseFare();
        if (matrix.getPerKmRateBeyond().compareTo(BigDecimal.ZERO) > 0) {
            int extraKm = distance - matrix.getDistanceFromKm();
            if (extraKm > 0) {
                baseFare = baseFare.add(matrix.getPerKmRateBeyond().multiply(BigDecimal.valueOf(extraKm)));
            }
        }
        return baseFare.max(matrix.getMinimumFare());
    }

    public List<BaseFareMatrix> getAllBaseFares() {
        return baseFareMatrixRepository.findByIsActiveTrue();
    }

    public List<BaseFareMatrix> getFaresByClass(String trainType, String coachClass) {
        return baseFareMatrixRepository.findByTrainTypeAndCoachClassAndIsActiveTrue(trainType, coachClass);
    }

    public List<CancellationCharge> getCancellationCharges(String coachClass) {
        return cancellationChargeRepository.findByCoachClassAndIsActiveTrue(coachClass);
    }

    public List<ConvenienceFeeConfig> getConvenienceFees(String bookingChannel) {
        return convenienceFeeConfigRepository.findByBookingChannelAndIsActiveTrue(bookingChannel);
    }
}