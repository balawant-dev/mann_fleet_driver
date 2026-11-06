import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../widget/motionToastHelper.dart';
// import '../../pro/corporate_booking_provider.dart';
import '../pro/corporate_booking_provider.dart';
import 'detail_widgets.dart';

/// Accept / Reject buttons shown while driver response is "pending".
class BookingResponseActions extends StatelessWidget {
  const BookingResponseActions({
    super.key,
    required this.hostContext,
    required this.provider,
    required this.bookingId,
  });

  /// Screen-level context. It stays mounted after this widget disappears
  /// (the buttons vanish once the booking is accepted).
  final BuildContext hostContext;
  final CorporateBookingProvider provider;
  final String bookingId;

  Future<void> _accept() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final success = await provider.acceptBooking(
      context: hostContext,
      bookingId: bookingId,
      currentLat: position.latitude,
      currentLng: position.longitude,
    );

    if (success && hostContext.mounted) {
      ToastHelper.show(
        hostContext,
        message: 'Booking Accepted',
        type: ToastType.success,
      );
    }
  }

  Future<void> _reject() async {
    final success = await provider.rejectBooking(
      hostContext,
      provider.bookingDetail!.id,
    );

    if (success && hostContext.mounted) {
      ToastHelper.show(
        hostContext,
        message: 'Booking Rejected',
        type: ToastType.error,
      );
      Navigator.pop(hostContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionButton(
          label: 'Accept Booking',
          color: Colors.green,
          isLoading: provider.isResponding,
          onPressed: _accept,
        ),
        const SizedBox(height: 12),
        ActionButton(
          label: 'Reject Booking',
          color: Colors.red,
          isOutlined: true,
          isLoading: provider.isResponding,
          onPressed: _reject,
        ),
      ],
    );
  }
}
