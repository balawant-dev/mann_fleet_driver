import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  final String keyId = "rzp_test_hCRLFPf6rY3elm";

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openCheckout({
    required String amount,
    required String name,
    required String description,
    required String email,
    required String contact,
  }) {
    var options = {
      'key': keyId,
      'amount': (double.parse(amount) * 100).toInt(), // in paisa
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      }
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}