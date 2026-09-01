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
 * REST controller for Payment domain.
 * Provides endpoints for payment initiation, status, and refunds.
 */

package com.bharatrailway.payment.presentation;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.payment.application.service.PaymentService;
import com.bharatrailway.payment.domain.PaymentTransaction;
import com.bharatrailway.payment.domain.Refund;

@RestController
@RequestMapping("/api/v1/payments")
public class PaymentController {

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/initiate")
    public ResponseEntity<PaymentTransaction> initiatePayment(
            @RequestBody Map<String, Object> request) {
        Integer bookingId = (Integer) request.get("bookingId");
        Integer userId = (Integer) request.get("userId");
        BigDecimal amount = new BigDecimal(request.get("amount").toString());
        String paymentMethod = (String) request.get("paymentMethod");

        PaymentTransaction transaction = paymentService.initiatePayment(bookingId, userId, amount, paymentMethod);
        return ResponseEntity.status(HttpStatus.CREATED).body(transaction);
    }

    @PutMapping("/{transactionId}/status")
    public ResponseEntity<PaymentTransaction> updatePaymentStatus(
            @PathVariable Integer transactionId,
            @RequestParam String status,
            @RequestParam(required = false) String gatewayReference) {
        PaymentTransaction transaction = paymentService.updatePaymentStatus(transactionId, status, gatewayReference);
        return ResponseEntity.ok(transaction);
    }

    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<PaymentTransaction> getPaymentByBooking(@PathVariable Integer bookingId) {
        return ResponseEntity.ok(paymentService.getPaymentByBooking(bookingId));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PaymentTransaction>> getPaymentsByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(paymentService.getPaymentsByUser(userId));
    }

    @PostMapping("/{transactionId}/refund")
    public ResponseEntity<Refund> processRefund(
            @PathVariable Integer transactionId,
            @RequestBody Map<String, Object> request) {
        BigDecimal refundAmount = new BigDecimal(request.get("refundAmount").toString());
        String reason = (String) request.get("reason");
        Integer requestedBy = (Integer) request.get("requestedBy");

        Refund refund = paymentService.processRefund(transactionId, refundAmount, reason, requestedBy);
        return ResponseEntity.status(HttpStatus.CREATED).body(refund);
    }

    @GetMapping("/refunds/status/{status}")
    public ResponseEntity<List<Refund>> getRefundsByStatus(@PathVariable String status) {
        return ResponseEntity.ok(paymentService.getRefundsByStatus(status));
    }
}