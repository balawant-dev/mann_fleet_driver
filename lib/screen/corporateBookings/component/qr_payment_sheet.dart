import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../widget/motionToastHelper.dart';

import '../pro/corporate_booking_provider.dart';
import 'bottom_sheet_shell.dart';

Future<void> showQrPaymentSheet({
  required BuildContext context,
  required CorporateBookingProvider provider,
  required String bookingId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder:
        (_) => _QrPaymentSheet(
          parentContext: context,
          provider: provider,
          bookingId: bookingId,
        ),
  );
}

class _QrPaymentSheet extends StatefulWidget {
  const _QrPaymentSheet({
    required this.parentContext,
    required this.provider,
    required this.bookingId,
  });

  final BuildContext parentContext;
  final CorporateBookingProvider provider;
  final String bookingId;

  @override
  State<_QrPaymentSheet> createState() => _QrPaymentSheetState();
}

class _QrPaymentSheetState extends State<_QrPaymentSheet> {
  static const _pollInterval = Duration(seconds: 4);

  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkPayment());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkPayment() async {
    final paid = await widget.provider.checkSelfPaymentStatus(
      context: context,
      bookingId: widget.bookingId,
    );
    if (!paid || !mounted) return;

    _pollTimer?.cancel();
    final parent = widget.parentContext;
    Navigator.pop(context);

    if (parent.mounted) {
      ToastHelper.show(
        parent,
        message: 'Payment Successful!',
        type: ToastType.success,
      );
    }
  }

  void _cancel() {
    _pollTimer?.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;

    // Rebuild whenever provider changes (e.g. "checking status" flag).
    return AnimatedBuilder(
      animation: provider,
      builder: (context, _) {
        final qrData = provider.selfOnlinePaymentModel?.data;
        final qrUrl = (qrData?.selfPaymentOrder?.qrCodeUrl ?? '').toString();
        final amount = provider.selfFareData?.payableAmount ?? '';

        return BottomSheetShell(
          title: 'Scan QR to Pay',
          titleGap: 8,
          children: [
            Text(
              'Amount: ₹$amount',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            if (qrUrl.isNotEmpty)
              Image.network(qrUrl, height: 220)
            else
              const Text('QR not available', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            _buildStatus(provider.isCheckingPaymentStatus),
            const SizedBox(height: 24),
            TextButton(onPressed: _cancel, child: const Text('Cancel')),
          ],
        );
      },
    );
  }

  Widget _buildStatus(bool isChecking) {
    if (!isChecking) {
      return const Text(
        'Waiting for payment...',
        style: TextStyle(color: Colors.grey),
      );
    }
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 10),
        Text('Checking payment status...'),
      ],
    );
  }
}
