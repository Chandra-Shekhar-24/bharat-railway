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
 * Spring Data JPA repository for payment_schema.refunds.
 */

package com.bharatrailway.payment.infrastructure;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.payment.domain.Refund;

@Repository
public interface RefundRepository extends JpaRepository<Refund, Integer> {

    Optional<Refund> findByTransactionId(Integer transactionId);

    List<Refund> findByRefundStatus(String refundStatus);
}