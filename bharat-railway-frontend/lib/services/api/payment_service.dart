/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Payment service using Razorpay.
 */

import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  static const String razorpayKey = 'rzp_test_XXXXXXXXXXXXXXXX';

  static void openPayment({
    required int amount,
    required String name,
    required String email,
    required String contact,
    required String description,
    required Function(String? paymentId, String? signature) onSuccess,
    required Function(int code, String? message) onError,
    required Function() onExternal,
  }) {
    final razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      onSuccess(response.paymentId, response.signature);
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      onError(response.code ?? 0, response.message);
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      onExternal();
    });

    final options = {
      'key': razorpayKey,
      'amount': amount * 100,
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'theme': {
        'color': '#1E40AF',
      }
    };

    razorpay.open(options);
  }
}