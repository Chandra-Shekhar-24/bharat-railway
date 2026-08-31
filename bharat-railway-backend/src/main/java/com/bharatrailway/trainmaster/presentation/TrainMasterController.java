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
 * REST controller for Train Master domain.
 * Provides endpoints for stations, trains, and routes.
 */

package com.bharatrailway.trainmaster.presentation;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.trainmaster.application.dto.RouteRequest;
import com.bharatrailway.trainmaster.application.dto.StationRequest;
import com.bharatrailway.trainmaster.application.dto.TrainRequest;
import com.bharatrailway.trainmaster.application.service.TrainMasterService;
import com.bharatrailway.trainmaster.domain.Route;
import com.bharatrailway.trainmaster.domain.Station;
import com.bharatrailway.trainmaster.domain.Train;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/v1/trainmaster")
public class TrainMasterController {

    private final TrainMasterService trainMasterService;

    public TrainMasterController(TrainMasterService trainMasterService) {
        this.trainMasterService = trainMasterService;
    }

    // ========== STATION ENDPOINTS ==========

    @PostMapping("/stations")
    public ResponseEntity<Station> createStation(@Valid @RequestBody StationRequest request) {
        Station station = trainMasterService.createStation(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(station);
    }

    @GetMapping("/stations")
    public ResponseEntity<List<Station>> getAllStations() {
        return ResponseEntity.ok(trainMasterService.getAllStations());
    }

    @GetMapping("/stations/{stationCode}")
    public ResponseEntity<Station> getStationByCode(@PathVariable String stationCode) {
        return ResponseEntity.ok(trainMasterService.getStationByCode(stationCode));
    }

    @GetMapping("/stations/city/{city}")
    public ResponseEntity<List<Station>> getStationsByCity(@PathVariable String city) {
        return ResponseEntity.ok(trainMasterService.getStationsByCity(city));
    }

    @GetMapping("/stations/state/{state}")
    public ResponseEntity<List<Station>> getStationsByState(@PathVariable String state) {
        return ResponseEntity.ok(trainMasterService.getStationsByState(state));
    }

    // ========== TRAIN ENDPOINTS ==========

    @PostMapping("/trains")
    public ResponseEntity<Train> createTrain(@Valid @RequestBody TrainRequest request) {
        Train train = trainMasterService.createTrain(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(train);
    }

    @GetMapping("/trains")
    public ResponseEntity<List<Train>> getAllTrains() {
        return ResponseEntity.ok(trainMasterService.getAllTrains());
    }

    @GetMapping("/trains/{trainNumber}")
    public ResponseEntity<Train> getTrainByNumber(@PathVariable String trainNumber) {
        return ResponseEntity.ok(trainMasterService.getTrainByNumber(trainNumber));
    }

    @GetMapping("/trains/search")
    public ResponseEntity<List<Train>> searchTrains(@RequestParam String origin,
                                                     @RequestParam String destination) {
        return ResponseEntity.ok(trainMasterService.getTrainsByRoute(origin, destination));
    }

    // ========== ROUTE ENDPOINTS ==========

    @PostMapping("/routes")
    public ResponseEntity<Route> createRoute(@Valid @RequestBody RouteRequest request) {
        Route route = trainMasterService.createRoute(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(route);
    }

    @GetMapping("/routes/train/{trainNumber}")
    public ResponseEntity<List<Route>> getRoutesByTrain(@PathVariable String trainNumber) {
        return ResponseEntity.ok(trainMasterService.getRoutesByTrain(trainNumber));
    }

    @GetMapping("/routes/station/{stationCode}")
    public ResponseEntity<List<Route>> getRoutesByStation(@PathVariable String stationCode) {
        return ResponseEntity.ok(trainMasterService.getRoutesByStation(stationCode));
    }
}