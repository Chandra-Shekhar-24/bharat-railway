/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-backend
 * Branch: feature/backend-developer-hitanshu
 * Developer: Chandra Shekhar Bansal
 * Assisted by: DeepSeek (AI Scribe)
 * Date: 2026-09-05
 * Version: 0.1.0-SNAPSHOT
 *
 * Description:
 * Spring Data JPA repository for payment_schema.payment_transactions.
 */

package com.bharatrailway.payment.infrastructure;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bharatrailway.payment.domain.PaymentTransaction;

@Repository
public interface PaymentTransactionRepository extends JpaRepository<PaymentTransaction, Integer> {

    Optional<PaymentTransaction> findByBookingId(Integer bookingId);

    Optional<PaymentTransaction> findByGatewayReference(String gatewayReference);

    List<PaymentTransaction> findByUserIdOrderByCreatedAtDesc(Integer userId);

    List<PaymentTransaction> findByTransactionStatus(String transactionStatus);
}