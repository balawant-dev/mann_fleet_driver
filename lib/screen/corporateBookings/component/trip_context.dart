import 'package:flutter/material.dart';

import '../../../../widget/motionToastHelper.dart';

import '../pro/corporate_booking_provider.dart';
import 'run_with_toast.dart';

class TripStatus {
  TripStatus._();

  static const driverEnroute = 'driver_enroute';
  static const garageStarted = 'garage_started';
  static const arrived = 'arrived';
  static const inProgress = 'in_progress';
  static const dropped = 'dropped';
  static const returningGarage = 'returning_garage';
}

class TripType {
  TripType._();

  static const garageToGarage = 'garage to garage';
  static const pickupToGarage = 'pickup to garage';
  static const pickupToDestination = 'pickup to destination';
  static const pickupToPickup = 'pickup to pickup';

  /// Trip types where the driver must pick a garage address.
  static bool needsGarageAddress(String tripType) =>
      tripType == garageToGarage || tripType == pickupToGarage;
}

class BillingType {
  BillingType._();

  static const self = 'self';
  static const corporate = 'corporate';
}

/// Garage address chosen by the driver. Listenable so the picker rebuilds.
class GarageLocation extends ChangeNotifier {
  double? lat;
  double? lng;
  String? address;

  bool get isSelected =>
      lat != null && lng != null && (address?.trim().isNotEmpty ?? false);

  void select({double? lat, double? lng, String? address}) {
    this.lat = lat;
    this.lng = lng;
    this.address = address;
    notifyListeners();
  }
}

/// Everything a trip flow needs to build its action buttons.
class TripContext {
  TripContext({
    required this.context,
    required this.provider,
    required this.garage,
    required this.routeBookingId,
    required this.bookingId,
    required this.tripType,
    required this.billingType,
    required this.status,
    required this.startOtpVerified,
    required this.endOtpVerified,
  });

  /// Screen-level context (stays mounted while sheets open/close).
  final BuildContext context;
  final CorporateBookingProvider provider;
  final GarageLocation garage;

  /// `widget.bookingId` (used by startRide / completeTrip, same as before).
  final String routeBookingId;

  /// `bookingDetail.id` (used by every other API).
  final String bookingId;

  final String tripType; // lower case
  final String billingType; // lower case
  final String status;
  final bool startOtpVerified;
  final bool endOtpVerified;

  bool get isSelfBilling => billingType == BillingType.self;
  bool get isCorporateBilling => billingType == BillingType.corporate;

  Future<void> run(
    Future<bool> Function() action, {
    required String successMessage,
    String fallbackError = 'Failed',
  }) => runWithToast(
    context,
    provider,
    action,
    successMessage: successMessage,
    fallbackError: fallbackError,
  );

  bool validateGarageAddress() {
    if (!TripType.needsGarageAddress(tripType) || garage.isSelected) {
      return true;
    }
    ToastHelper.show(
      context,
      message: 'Please select Garage Address',
      type: ToastType.warning,
    );
    return false;
  }
}
