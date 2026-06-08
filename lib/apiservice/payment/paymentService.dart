import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  Razorpay? _razorpay;
  BuildContext? _context;
  VoidCallback? onPaymentSuccessCallback;
  VoidCallback? onPaymentFailedCallback;

  PaymentService({
    this.onPaymentSuccessCallback,
    this.onPaymentFailedCallback,
  }) {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay!.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: PAYMENT SUCCESS");

    if (onPaymentSuccessCallback != null) {
      onPaymentSuccessCallback!();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (onPaymentFailedCallback != null) {
      onPaymentFailedCallback!();
    } else {
      print("FAILED: PAYMENT FAILED");
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("SUCCESS: PAYMENT SUCCESS");
    if (onPaymentSuccessCallback != null) {
      onPaymentSuccessCallback!();
    }
  }

  Future<void> openCheckout({
    required String price,
    required String orderId,
    required String userContact,
    required String userEmail,
    required BuildContext context,
  }) async {
    _context = context;

    var options = {
      'key': 'rzp_live_F4jT620Eae1IW7',
      'order_id': orderId,
      'amount': (double.parse(price) * 100).toInt(),
      'name': 'Astrology Matrix',
      'currency': "INR",
      'description': '',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': userContact, 'email': userEmail},
      'theme': {'color': '#0E0E0E'},
      'notes': {'country': "IN"},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
