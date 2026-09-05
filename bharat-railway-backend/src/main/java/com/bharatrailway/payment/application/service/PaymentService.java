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
 * Application service for Payment domain.
 * Handles payment initiation, status update, refund processing,
 * and Razorpay webhook processing with atomic transactions.
 */

package com.bharatrailway.payment.application.service;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bharatrailway.payment.domain.PaymentTransaction;
import com.bharatrailway.payment.domain.Refund;
import com.bharatrailway.payment.infrastructure.PaymentTransactionRepository;
import com.bharatrailway.payment.infrastructure.RefundRepository;

@Service
public class PaymentService {

    private final PaymentTransactionRepository paymentTransactionRepository;
    private final RefundRepository refundRepository;

    public PaymentService(PaymentTransactionRepository paymentTransactionRepository,
                          RefundRepository refundRepository) {
        this.paymentTransactionRepository = paymentTransactionRepository;
        this.refundRepository = refundRepository;
    }

    @Transactional
    public PaymentTransaction initiatePayment(Integer bookingId, Integer userId,
                                               BigDecimal amount, String paymentMethod) {
        PaymentTransaction transaction = new PaymentTransaction();
        transaction.setBookingId(bookingId);
        transaction.setUserId(userId);
        transaction.setAmount(amount);
        transaction.setPaymentMethod(paymentMethod);
        transaction.setTransactionStatus("PENDING");
        transaction.setGatewayReference(UUID.randomUUID().toString());
        transaction.setPaymentGateway("RAZORPAY");
        transaction.setCreatedAt(OffsetDateTime.now());
        transaction.setUpdatedAt(OffsetDateTime.now());

        return paymentTransactionRepository.save(transaction);
    }

    @Transactional
    public PaymentTransaction updatePaymentStatus(Integer transactionId, String status,
                                                   String gatewayReference) {
        PaymentTransaction transaction = paymentTransactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("Transaction not found: " + transactionId));

        transaction.setTransactionStatus(status);
        if (gatewayReference != null) {
            transaction.setGatewayReference(gatewayReference);
        }
        transaction.setUpdatedAt(OffsetDateTime.now());

        return paymentTransactionRepository.save(transaction);
    }

    @Transactional
    public void processPaymentSuccess(String orderId, String paymentId, String status) {
        PaymentTransaction transaction = paymentTransactionRepository
                .findByGatewayReference(orderId)
                .orElseThrow(() -> new RuntimeException("Transaction not found for order: " + orderId));

        // Idempotency check - already processed
        if ("SUCCESS".equals(transaction.getTransactionStatus())) {
            return;
        }

        transaction.setTransactionStatus("SUCCESS");
        transaction.setGatewayReference(paymentId);
        transaction.setUpdatedAt(OffsetDateTime.now());
        paymentTransactionRepository.save(transaction);
    }

    @Transactional
    public void processPaymentFailure(String orderId, String paymentId) {
        PaymentTransaction transaction = paymentTransactionRepository
                .findByGatewayReference(orderId)
                .orElseThrow(() -> new RuntimeException("Transaction not found for order: " + orderId));

        transaction.setTransactionStatus("FAILED");
        transaction.setGatewayReference(paymentId);
        transaction.setUpdatedAt(OffsetDateTime.now());
        paymentTransactionRepository.save(transaction);
    }

    public PaymentTransaction getPaymentByBooking(Integer bookingId) {
        return paymentTransactionRepository.findByBookingId(bookingId)
                .orElseThrow(() -> new RuntimeException("No payment found for booking: " + bookingId));
    }

    public List<PaymentTransaction> getPaymentsByUser(Integer userId) {
        return paymentTransactionRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Transactional
    public Refund processRefund(Integer transactionId, BigDecimal refundAmount,
                                 String reason, Integer requestedBy) {
        PaymentTransaction transaction = paymentTransactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("Transaction not found: " + transactionId));

        if (!"SUCCESS".equals(transaction.getTransactionStatus())) {
            throw new RuntimeException("Cannot refund a non-successful transaction");
        }

        Refund refund = new Refund();
        refund.setTransactionId(transactionId);
        refund.setRefundAmount(refundAmount);
        refund.setRefundReason(reason);
        refund.setRefundStatus("PENDING");
        refund.setRequestedBy(requestedBy);
        refund.setCreatedAt(OffsetDateTime.now());

        return refundRepository.save(refund);
    }

    public List<Refund> getRefundsByStatus(String status) {
        return refundRepository.findByRefundStatus(status);
    }
}