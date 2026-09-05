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
 * Razorpay payment service for UPI integration.
 * Creates orders, verifies webhooks, and handles payments.
 */

package com.bharatrailway.payment.application.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.razorpay.Order;
import com.razorpay.Payment;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;

@Service
public class RazorpayService {

    private final RazorpayClient razorpayClient;

    @Value("${razorpay.key-id}")
    private String keyId;

    @Value("${razorpay.webhook-secret}")
    private String webhookSecret;

    @Value("${razorpay.currency}")
    private String currency;

    public RazorpayService(RazorpayClient razorpayClient) {
        this.razorpayClient = razorpayClient;
    }

    public Map<String, Object> createOrder(BigDecimal amount, String bookingReference) {
        try {
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amount.multiply(new BigDecimal("100")).intValue());
            orderRequest.put("currency", currency);
            orderRequest.put("receipt", bookingReference);
            orderRequest.put("payment_capture", 1);

            Order order = razorpayClient.orders.create(orderRequest);

            Map<String, Object> response = new HashMap<>();
            response.put("orderId", order.get("id"));
            response.put("amount", order.get("amount"));
            response.put("currency", order.get("currency"));
            response.put("receipt", order.get("receipt"));
            response.put("keyId", keyId);
            return response;
        } catch (RazorpayException e) {
            throw new RuntimeException("Razorpay order creation failed: " + e.getMessage());
        }
    }

    public boolean verifyWebhookSignature(String payload, String signature) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(webhookSecret.getBytes(), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] computedSignature = mac.doFinal(payload.getBytes());

            StringBuilder hexString = new StringBuilder();
            for (byte b : computedSignature) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            return hexString.toString().equals(signature);
        } catch (Exception e) {
            return false;
        }
    }

    public Map<String, Object> fetchPayment(String paymentId) {
        try {
            Payment payment = razorpayClient.payments.fetch(paymentId);
            Map<String, Object> response = new HashMap<>();
            response.put("paymentId", payment.get("id"));
            response.put("status", payment.get("status"));
            response.put("orderId", payment.get("order_id"));
            response.put("amount", payment.get("amount"));
            response.put("method", payment.get("method"));
            return response;
        } catch (RazorpayException e) {
            throw new RuntimeException("Razorpay payment fetch failed: " + e.getMessage());
        }
    }

    public Map<String, Object> createRefund(String paymentId, BigDecimal amount) {
        try {
            JSONObject refundRequest = new JSONObject();
            refundRequest.put("payment_id", paymentId);
            refundRequest.put("amount", amount.multiply(new BigDecimal("100")).intValue());

            Object refund = razorpayClient.payments.refund(paymentId, refundRequest);
            JSONObject refundJson = new JSONObject(refund.toString());

            Map<String, Object> response = new HashMap<>();
            response.put("refundId", refundJson.get("id"));
            response.put("status", refundJson.get("status"));
            return response;
        } catch (RazorpayException e) {
            throw new RuntimeException("Razorpay refund failed: " + e.getMessage());
        }
    }
}