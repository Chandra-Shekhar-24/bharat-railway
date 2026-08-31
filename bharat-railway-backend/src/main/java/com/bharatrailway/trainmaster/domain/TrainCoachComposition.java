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
 * Spring Data JPA repository for train_master_schema.routes.
 */

package com.bharatrailway.trainmaster.domain;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(schema = "train_master_schema", name = "train_coach_composition")
public class TrainCoachComposition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "composition_id")
    private Integer compositionId;

    @Column(name = "train_number", length = 5, nullable = false)
    private String trainNumber;

    @Column(name = "coach_class", length = 3, nullable = false)
    private String coachClass;

    @Column(name = "number_of_coaches", nullable = false)
    private Short numberOfCoaches;

    @Column(name = "coach_numbers", columnDefinition = "jsonb")
    private String coachNumbers;

    @Column(name = "coach_position_from_engine", nullable = false)
    private Short coachPositionFromEngine;

    @Column(name = "has_disabled_access", nullable = false)
    private Boolean hasDisabledAccess;

    @Column(name = "effective_from", nullable = false)
    private LocalDate effectiveFrom;

    @Column(name = "effective_to")
    private LocalDate effectiveTo;

    public TrainCoachComposition() {
    }

    public Integer getCompositionId() {
        return compositionId;
    }

    public void setCompositionId(Integer compositionId) {
        this.compositionId = compositionId;
    }

    public String getTrainNumber() {
        return trainNumber;
    }

    public void setTrainNumber(String trainNumber) {
        this.trainNumber = trainNumber;
    }

    public String getCoachClass() {
        return coachClass;
    }

    public void setCoachClass(String coachClass) {
        this.coachClass = coachClass;
    }

    public Short getNumberOfCoaches() {
        return numberOfCoaches;
    }

    public void setNumberOfCoaches(Short numberOfCoaches) {
        this.numberOfCoaches = numberOfCoaches;
    }

    public String getCoachNumbers() {
        return coachNumbers;
    }

    public void setCoachNumbers(String coachNumbers) {
        this.coachNumbers = coachNumbers;
    }

    public Short getCoachPositionFromEngine() {
        return coachPositionFromEngine;
    }

    public void setCoachPositionFromEngine(Short coachPositionFromEngine) {
        this.coachPositionFromEngine = coachPositionFromEngine;
    }

    public Boolean getHasDisabledAccess() {
        return hasDisabledAccess;
    }

    public void setHasDisabledAccess(Boolean hasDisabledAccess) {
        this.hasDisabledAccess = hasDisabledAccess;
    }

    public LocalDate getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(LocalDate effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }

    public LocalDate getEffectiveTo() {
        return effectiveTo;
    }

    public void setEffectiveTo(LocalDate effectiveTo) {
        this.effectiveTo = effectiveTo;
    }
}