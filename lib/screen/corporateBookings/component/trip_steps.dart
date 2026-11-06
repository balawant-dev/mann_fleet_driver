import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';

import '../../../../widget/motionToastHelper.dart';
import 'detail_widgets.dart';
import 'extra_charge_sheet.dart';
import 'odometer_sheet.dart';
import 'otp_sheet.dart';
import 'qr_payment_sheet.dart';
import 'trip_context.dart';

/// Single place for every action button used by the trip flows.
class TripSteps {
  TripSteps._();

  // ---------------------------------------------------------------------------
  // Groups shared by several flows
  // ---------------------------------------------------------------------------

  /// driver_enroute: start OTP -> pickup checkpoint (all flows except garage to garage).
  static List<Widget> pickupStartSteps(TripContext t) => [
    if (t.status == TripStatus.driverEnroute && !t.startOtpVerified)
      verifyStartOtp(t),
    if (t.status == TripStatus.driverEnroute && t.startOtpVerified)
      pickupCheckpoint(t),
  ];

  /// arrived -> in_progress: start ride -> end OTP -> drop checkpoint (all flows).
  static List<Widget> rideSteps(TripContext t) => [
    if (t.status == TripStatus.arrived) startRide(t),
    if (t.status == TripStatus.inProgress && !t.endOtpVerified) verifyEndOtp(t),
    if (t.status == TripStatus.inProgress && t.endOtpVerified)
      dropCheckpoint(t),
  ];

  /// Corporate billing after drop: extra charges + complete trip.
  static List<Widget> corporateDropActions(TripContext t) => [
    extraCharges(t),
    completeTrip(t),
  ];

  /// After drop for flows that continue to the garage (garage to garage / pickup to garage).
  static List<Widget> afterDropToGarage(TripContext t) => [
    if (t.isSelfBilling) completeTrip(t),
    if (t.isCorporateBilling) ...corporateDropActions(t),
  ];

  // ---------------------------------------------------------------------------
  // Odometer steps
  // ---------------------------------------------------------------------------

  static Widget garageStart(TripContext t) => _odometerStep(
    t,
    label: 'Garage Start',
    isLoading: t.provider.isGarageStarting,
    submit:
        (odometer, lat, lng, image) => t.provider.garageStart(
          context: t.context,
          bookingId: t.bookingId,
          odometer: odometer,
          currentLat: lat,
          currentLng: lng,
          odometerImage: image,
        ),
  );

  static Widget pickupCheckpoint(TripContext t) => _odometerStep(
    t,
    label: 'Pickup Checkpoint',
    isLoading: t.provider.isPickupCheckpoint,
    submit:
        (odometer, lat, lng, image) => t.provider.pickupCheckpoint(
          context: t.context,
          bookingId: t.bookingId,
          odometer: odometer,
          currentLat: lat,
          currentLng: lng,
          odometerImage: image,
        ),
  );

  static Widget dropCheckpoint(TripContext t) => _odometerStep(
    t,
    label: 'Drop Checkpoint',
    isLoading: t.provider.isDropCheckpoint,
    submit:
        (odometer, lat, lng, image) => t.provider.dropCheckpoint(
          context: t.context,
          bookingId: t.bookingId,
          odometer: odometer,
          currentLat: lat,
          currentLng: lng,
          odometerImage: image,
        ),
  );

  static Widget garageEnd(TripContext t) => _odometerStep(
    t,
    label: 'Garage End',
    isLoading: t.provider.isGarageEnd,
    submit:
        (odometer, lat, lng, image) => t.provider.garageEndApi(
          context: t.context,
          bookingId: t.bookingId,
          odometer: odometer,
          currentLat: lat,
          currentLng: lng,
          odometerImage: image,
        ),
  );

  static Widget _odometerStep(
    TripContext t, {
    required String label,
    required bool isLoading,
    required OdometerSubmit submit,
  }) {
    return ActionButton(
      label: label,
      color: ColorResource.primaryColor,
      isLoading: isLoading,
      onPressed:
          () => showOdometerSheet(
            context: t.context,
            provider: t.provider,
            title: label,
            submitLabel: 'Submit $label',
            isLoading: isLoading,
            successMessage: '$label successful',
            onSubmit: submit,
          ),
    );
  }

  // ---------------------------------------------------------------------------
  // OTP steps
  // ---------------------------------------------------------------------------

  static Widget verifyStartOtp(TripContext t) => _otpStep(
    t,
    title: 'Verify Start OTP',
    successMessage: 'Start OTP verified successfully',
    isLoading: t.provider.isVerifyStartOtp,
    submit:
        (otp) => t.provider.verifyStartOtp(
          context: t.context,
          bookingId: t.bookingId,
          otp: otp,
        ),
  );

  static Widget verifyEndOtp(TripContext t) => _otpStep(
    t,
    title: 'Verify End OTP',
    successMessage: 'End OTP verified successfully',
    isLoading: t.provider.isVerifyEndOtp,
    submit:
        (otp) => t.provider.verifyEndOtp(
          context: t.context,
          bookingId: t.bookingId,
          otp: otp,
        ),
  );

  static Widget _otpStep(
    TripContext t, {
    required String title,
    required String successMessage,
    required bool isLoading,
    required Future<bool> Function(String otp) submit,
  }) {
    return ActionButton(
      label: title,
      color: ColorResource.primaryColor,
      isLoading: isLoading,
      onPressed:
          () => showOtpSheet(
            context: t.context,
            provider: t.provider,
            title: title,
            successMessage: successMessage,
            isLoading: isLoading,
            onSubmit: submit,
          ),
    );
  }

  // ---------------------------------------------------------------------------
  // Simple API steps
  // ---------------------------------------------------------------------------

  static Widget startRide(TripContext t) => ActionButton(
    label: 'Start Ride',
    color: ColorResource.primaryColor,
    isLoading: t.provider.isStartRide,
    onPressed:
        () => t.run(
          () => t.provider.startRide(
            context: t.context,
            bookingId: t.routeBookingId,
          ),
          successMessage: 'Start Ride successful',
        ),
  );

  static Widget completeTrip(TripContext t) => ActionButton(
    label: 'Complete Trip',
    color: ColorResource.primaryColor,
    isLoading: t.provider.isCompleteTrip,
    onPressed:
        () => t.run(
          () => t.provider.completeTripApi(
            context: t.context,
            bookingId: t.routeBookingId,
          ),
          successMessage: 'Complete trip successfully',
          fallbackError: 'Failed to complete trip',
        ),
  );

  // ---------------------------------------------------------------------------
  // Extra charges + self payment
  // ---------------------------------------------------------------------------

  static Widget extraCharges(TripContext t, {VoidCallback? onSuccess}) {
    return ActionButton(
      label: 'Add Extra Charges',
      color: Colors.deepOrange,
      isLoading: t.provider.isExtraCharge,
      onPressed:
          () => showExtraChargeSheet(
            context: t.context,
            provider: t.provider,
            bookingId: t.bookingId,
            onSuccess: onSuccess,
          ),
    );
  }

  static Widget payOnline(TripContext t) => ActionButton(
    label: 'Pay Online (QR)',
    color: Colors.blue,
    isLoading: t.provider.isSelfPayOnline,
    onPressed: () async {
      final success = await t.provider.selfPayOnlineApi(
        context: t.context,
        bookingId: t.bookingId,
      );
      if (!t.context.mounted) return;

      if (success) {
        showQrPaymentSheet(
          context: t.context,
          provider: t.provider,
          bookingId: t.bookingId,
        );
      } else {
        ToastHelper.show(
          t.context,
          message: t.provider.errorMessage ?? 'Failed',
          type: ToastType.error,
        );
      }
    },
  );

  static Widget payCash(TripContext t) => ActionButton(
    label: 'Pay by Cash',
    color: Colors.green,
    isLoading: t.provider.isSelfPayCash,
    onPressed:
        () => t.run(
          () => t.provider.selfPayCashApi(
            context: t.context,
            bookingId: t.bookingId,
          ),
          successMessage: 'Cash payment recorded',
        ),
  );
}
