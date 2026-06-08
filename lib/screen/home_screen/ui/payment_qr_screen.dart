import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/extra_charges_payment_model.dart';
import '../provider/newBookingProvider.dart';

class PaymentQrScreen extends StatefulWidget {
  final TripExtraPaymentData data;
  const PaymentQrScreen({super.key, required this.data});

  @override
  State<PaymentQrScreen> createState() => _PaymentQrScreenState();
}

class _PaymentQrScreenState extends State<PaymentQrScreen> {
  Timer? _paymentTimer;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<NewBookingProvider>(context, listen: false);

    _paymentTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final success = await provider.checkPaymentStatus(
        context: context,
        id: widget.data.bookingId,
      );

      print(success);

      if (success == true && mounted) {
        _paymentTimer?.cancel();
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    _paymentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan & Pay')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.data.extraPaymentOrder.qrCodeUrl,
                height: 260,
                width: 260,
              ),

              const SizedBox(height: 20),

              Text(
                '₹${widget.data.extraPaymentOrder.amount / 100}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.data.extraPaymentOrder.description,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // ElevatedButton(
              //   onPressed: () async {
              //     final url = data.extraPaymentOrder.paymentLink;
              //
              //     await launchUrl(
              //       Uri.parse(url),
              //       mode: LaunchMode.externalApplication,
              //     );
              //   },
              //   child: const Text('Open Payment Link'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
