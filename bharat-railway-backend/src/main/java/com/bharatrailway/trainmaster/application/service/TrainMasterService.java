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
 * Handles CRUD operations for stations, trains, routes, coach composition, and seats.
 */

package com.bharatrailway.trainmaster.application.service;

import java.time.OffsetDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.shared.exception.ResourceAlreadyExistsException;
import com.bharatrailway.trainmaster.application.dto.RouteRequest;
import com.bharatrailway.trainmaster.application.dto.SeatRequest;
import com.bharatrailway.trainmaster.application.dto.StationRequest;
import com.bharatrailway.trainmaster.application.dto.TrainCoachCompositionRequest;
import com.bharatrailway.trainmaster.application.dto.TrainRequest;
import com.bharatrailway.trainmaster.domain.Route;
import com.bharatrailway.trainmaster.domain.Seat;
import com.bharatrailway.trainmaster.domain.Station;
import com.bharatrailway.trainmaster.domain.Train;
import com.bharatrailway.trainmaster.domain.TrainCoachComposition;
import com.bharatrailway.trainmaster.infrastructure.RouteRepository;
import com.bharatrailway.trainmaster.infrastructure.SeatRepository;
import com.bharatrailway.trainmaster.infrastructure.StationRepository;
import com.bharatrailway.trainmaster.infrastructure.TrainCoachCompositionRepository;
import com.bharatrailway.trainmaster.infrastructure.TrainRepository;

@Service
public class TrainMasterService {

    private final StationRepository stationRepository;
    private final TrainRepository trainRepository;
    private final RouteRepository routeRepository;
    private final TrainCoachCompositionRepository trainCoachCompositionRepository;
    private final SeatRepository seatRepository;

    public TrainMasterService(StationRepository stationRepository,
                              TrainRepository trainRepository,
                              RouteRepository routeRepository,
                              TrainCoachCompositionRepository trainCoachCompositionRepository,
                              SeatRepository seatRepository) {
        this.stationRepository = stationRepository;
        this.trainRepository = trainRepository;
        this.routeRepository = routeRepository;
        this.trainCoachCompositionRepository = trainCoachCompositionRepository;
        this.seatRepository = seatRepository;
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

    // ========== ROUTE OPERATIONS ==========

    @Transactional
    public Route createRoute(RouteRequest request) {
        if (routeRepository.existsByTrainNumberAndStationCode(request.getTrainNumber(), request.getStationCode())) {
            throw new ResourceAlreadyExistsException("Route", "train_station",
                    request.getTrainNumber() + "-" + request.getStationCode());
        }

        Route route = new Route();
        route.setTrainNumber(request.getTrainNumber());
        route.setStationCode(request.getStationCode());
        route.setSequenceNumber(request.getSequenceNumber());
        route.setArrivalTime(request.getArrivalTime());
        route.setDepartureTime(request.getDepartureTime());
        route.setHaltDuration(request.getHaltDuration());
        route.setDistanceFromOrigin(request.getDistanceFromOrigin());
        route.setDayNumber(request.getDayNumber());
        route.setPlatformNumber(request.getPlatformNumber());
        route.setIsCommercialStop(request.getIsCommercialStop());
        route.setIsTechnicalHalt(request.getIsTechnicalHalt());
        route.setIsOriginatingStation(request.getIsOriginatingStation());
        route.setIsTerminatingStation(request.getIsTerminatingStation());
        route.setIsMajorJunction(request.getIsMajorJunction());
        route.setBookingQuota(request.getBookingQuota());
        route.setWaitingListQuota(request.getWaitingListQuota());
        route.setCreatedAt(OffsetDateTime.now());

        return routeRepository.save(route);
    }

    public List<Route> getRoutesByTrain(String trainNumber) {
        return routeRepository.findByTrainNumberOrderBySequenceNumberAsc(trainNumber);
    }

    public List<Route> getRoutesByStation(String stationCode) {
        return routeRepository.findByStationCode(stationCode);
    }

    // ========== COACH COMPOSITION OPERATIONS ==========

    @Transactional
    public TrainCoachComposition createCoachComposition(TrainCoachCompositionRequest request) {
        if (trainCoachCompositionRepository.existsByTrainNumberAndCoachClass(
                request.getTrainNumber(), request.getCoachClass())) {
            throw new ResourceAlreadyExistsException("CoachComposition", "train_class",
                    request.getTrainNumber() + "-" + request.getCoachClass());
        }

        TrainCoachComposition composition = new TrainCoachComposition();
        composition.setTrainNumber(request.getTrainNumber());
        composition.setCoachClass(request.getCoachClass());
        composition.setNumberOfCoaches(request.getNumberOfCoaches());
        
        // Convert comma-separated string to JSON array format for jsonb column
        String jsonCoachNumbers = "[\"" + request.getCoachNumbers().replace(",", "\",\"") + "\"]";
        composition.setCoachNumbers(jsonCoachNumbers);
        
        composition.setCoachPositionFromEngine(request.getCoachPositionFromEngine());
        composition.setHasDisabledAccess(request.getHasDisabledAccess());
        composition.setEffectiveFrom(request.getEffectiveFrom());
        composition.setEffectiveTo(request.getEffectiveTo());

        return trainCoachCompositionRepository.save(composition);
    }

    public List<TrainCoachComposition> getCoachCompositionByTrain(String trainNumber) {
        return trainCoachCompositionRepository.findByTrainNumber(trainNumber);
    }

    public List<TrainCoachComposition> getCoachCompositionByTrainAndClass(String trainNumber, String coachClass) {
        return trainCoachCompositionRepository.findByTrainNumberAndCoachClass(trainNumber, coachClass);
    }

    // ========== SEAT OPERATIONS ==========

    @Transactional
    public Seat createSeat(SeatRequest request) {
        if (seatRepository.existsByTrainNumberAndCoachClassAndSeatNumber(
                request.getTrainNumber(), request.getCoachClass(), request.getSeatNumber())) {
            throw new ResourceAlreadyExistsException("Seat", "train_class_seat",
                    request.getTrainNumber() + "-" + request.getCoachClass() + "-" + request.getSeatNumber());
        }

        Seat seat = new Seat();
        seat.setTrainNumber(request.getTrainNumber());
        seat.setCoachClass(request.getCoachClass());
        seat.setSeatNumber(request.getSeatNumber());
        seat.setBerthType(request.getBerthType());
        seat.setIsActive(request.getIsActive());

        return seatRepository.save(seat);
    }

    public List<Seat> getSeatsByTrainAndClass(String trainNumber, String coachClass) {
        return seatRepository.findByTrainNumberAndCoachClass(trainNumber, coachClass);
    }

    public List<Seat> getSeatsByTrain(String trainNumber) {
        return seatRepository.findByTrainNumber(trainNumber);
    }
}