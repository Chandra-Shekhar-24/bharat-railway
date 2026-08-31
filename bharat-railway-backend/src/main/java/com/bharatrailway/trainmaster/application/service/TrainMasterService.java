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
 * Application service for Train Master domain.
 * Handles CRUD operations for stations and trains.
 */

package com.bharatrailway.trainmaster.application.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.shared.exception.ResourceAlreadyExistsException;
import com.bharatrailway.trainmaster.application.dto.StationRequest;
import com.bharatrailway.trainmaster.application.dto.TrainRequest;
import com.bharatrailway.trainmaster.domain.Station;
import com.bharatrailway.trainmaster.domain.Train;
import com.bharatrailway.trainmaster.infrastructure.StationRepository;
import com.bharatrailway.trainmaster.infrastructure.TrainRepository;

@Service
public class TrainMasterService {

    private final StationRepository stationRepository;
    private final TrainRepository trainRepository;

    public TrainMasterService(StationRepository stationRepository,
                              TrainRepository trainRepository) {
        this.stationRepository = stationRepository;
        this.trainRepository = trainRepository;
    }

    // ========== STATION OPERATIONS ==========

    @Transactional
    public Station createStation(StationRequest request) {
        if (stationRepository.existsByStationCode(request.getStationCode())) {
            throw new ResourceAlreadyExistsException("Station", "station_code", request.getStationCode());
        }

        Station station = new Station();
        station.setStationCode(request.getStationCode());
        station.setStationName(request.getStationName());
        station.setCity(request.getCity());
        station.setState(request.getState());
        station.setZone(request.getZone());
        station.setDivision(request.getDivision());
        station.setStationCategory(request.getStationCategory());
        station.setStationType(request.getStationType());
        station.setNumberOfPlatforms(request.getNumberOfPlatforms());
        station.setPincode(request.getPincode());
        station.setStationStatus(request.getStationStatus());
        station.setIsHillStation(request.getIsHillStation());
        station.setIsInternational(request.getIsInternational());
        station.setOpeningYear(request.getOpeningYear());
        station.setCreatedAt(OffsetDateTime.now());
        station.setUpdatedAt(OffsetDateTime.now());

        return stationRepository.save(station);
    }

    public List<Station> getAllStations() {
        return stationRepository.findAll();
    }

    public Station getStationByCode(String stationCode) {
        return stationRepository.findByStationCode(stationCode)
                .orElseThrow(() -> new RuntimeException("Station not found: " + stationCode));
    }

    public List<Station> getStationsByCity(String city) {
        return stationRepository.findByCity(city);
    }

    public List<Station> getStationsByState(String state) {
        return stationRepository.findByState(state);
    }

    // ========== TRAIN OPERATIONS ==========

    @Transactional
    public Train createTrain(TrainRequest request) {
        if (trainRepository.existsByTrainNumber(request.getTrainNumber())) {
            throw new ResourceAlreadyExistsException("Train", "train_number", request.getTrainNumber());
        }

        if (request.getOriginStationCode().equals(request.getDestinationStationCode())) {
            throw new RuntimeException("Origin and destination stations cannot be the same");
        }

        Train train = new Train();
        train.setTrainNumber(request.getTrainNumber());
        train.setTrainName(request.getTrainName());
        train.setTrainType(request.getTrainType());
        train.setCategory(request.getCategory());
        train.setOriginStationCode(request.getOriginStationCode());
        train.setDestinationStationCode(request.getDestinationStationCode());
        train.setTotalDistance(request.getTotalDistance());
        train.setAverageSpeed(request.getAverageSpeed());
        train.setMaximumSpeed(request.getMaximumSpeed());
        train.setTotalCoaches(request.getTotalCoaches());
        train.setPantryCar(request.getPantryCar());
        train.setWifiAvailable(request.getWifiAvailable());
        train.setTrainStatus(request.getTrainStatus());
        train.setIntroductionDate(request.getIntroductionDate());
        train.setIsSpecialTrain(request.getIsSpecialTrain());
        train.setFareMultiplier(request.getFareMultiplier());
        train.setTatkalAvailable(request.getTatkalAvailable());
        train.setCreatedAt(OffsetDateTime.now());
        train.setUpdatedAt(OffsetDateTime.now());

        return trainRepository.save(train);
    }

    public List<Train> getAllTrains() {
        return trainRepository.findAll();
    }

    public Train getTrainByNumber(String trainNumber) {
        return trainRepository.findByTrainNumber(trainNumber)
                .orElseThrow(() -> new RuntimeException("Train not found: " + trainNumber));
    }

    public List<Train> getTrainsByRoute(String origin, String destination) {
        return trainRepository.findByOriginStationCodeAndDestinationStationCode(origin, destination);
    }
}