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
 * Razorpay webhook controller.
 * Handles payment success/failure callbacks with signature verification.
 * Updates transaction and booking status atomically.
 */

package com.bharatrailway.payment.presentation;

import java.util.Map;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bharatrailway.payment.application.service.PaymentService;
import com.bharatrailway.payment.application.service.RazorpayService;

@RestController
@RequestMapping("/webhook")
public class RazorpayWebhookController {

    private final RazorpayService razorpayService;
    private final PaymentService paymentService;

    public RazorpayWebhookController(RazorpayService razorpayService,
                                     PaymentService paymentService) {
        this.razorpayService = razorpayService;
        this.paymentService = paymentService;
    }

    @PostMapping("/payment")
    public ResponseEntity<String> handlePaymentWebhook(
            @RequestBody String payload,
            @RequestHeader("X-Razorpay-Signature") String signature) {

        // Verify signature first
        if (!razorpayService.verifyWebhookSignature(payload, signature)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid signature");
        }

        JSONObject webhookData = new JSONObject(payload);
        String event = webhookData.getString("event");

        if ("payment.captured".equals(event)) {
            JSONObject paymentEntity = webhookData.getJSONObject("payload")
                    .getJSONObject("payment")
                    .getJSONObject("entity");

            String orderId = paymentEntity.getString("order_id");
            String paymentId = paymentEntity.getString("id");
            String status = paymentEntity.getString("status");

            // Atomic update: transaction + booking status
            paymentService.processPaymentSuccess(orderId, paymentId, status);

            return ResponseEntity.ok("Webhook processed");
        } else if ("payment.failed".equals(event)) {
            JSONObject paymentEntity = webhookData.getJSONObject("payload")
                    .getJSONObject("payment")
                    .getJSONObject("entity");

            String orderId = paymentEntity.getString("order_id");
            String paymentId = paymentEntity.getString("id");

            paymentService.processPaymentFailure(orderId, paymentId);

            return ResponseEntity.ok("Webhook processed");
        }

        return ResponseEntity.ok("Event ignored");
    }
}