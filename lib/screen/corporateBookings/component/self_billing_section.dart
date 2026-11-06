import 'package:flutter/material.dart';

import '../../../../widget/motionToastHelper.dart';
import 'detail_widgets.dart';
import 'fare_breakdown_card.dart';
import 'garage_address_picker.dart';
import 'trip_context.dart';
import 'trip_steps.dart';

/// Where the garage address picker appears in the self billing flow.
enum GarageAddressMode {
  /// Never shown (pickup to destination / pickup to pickup).
  none,

  /// Always shown at the top (garage to garage).
  always,

  /// Shown only together with the extra-charges form (pickup to garage).
  whenFareMissing,
}

/// Self billing: extra charges -> fare breakdown -> pay -> [finalStep].
class SelfBillingSection {
  SelfBillingSection._();

  static List<Widget> build(
    TripContext t, {
    required GarageAddressMode addressMode,
    required Widget finalStep,
    bool hideFareFormWhenPaid = false,
  }) {
    final provider = t.provider;
    final hasFare = provider.selfFareData != null;
    final paymentDone = provider.isSelfPaymentDone;

    final showFareForm =
        !hasFare && !(hideFareFormWhenPaid && provider.paymentStatusCheck == 'paid');

    return [
      if (addressMode == GarageAddressMode.always)
        GarageAddressPicker(garage: t.garage),

      // Step 1: extra charges (or skip) -> calculates fare
      if (showFareForm) ...[
        if (addressMode == GarageAddressMode.whenFareMissing)
          GarageAddressPicker(garage: t.garage),
        TripSteps.extraCharges(
          t,
          onSuccess:
              () => _calculateFare(
                t,
                successMessage: 'Fare calculated',
                toastOnError: false,
              ),
        ),
        ActionButton(
          label: 'Skip Extra Charges',
          color: Colors.grey,
          isOutlined: true,
          isLoading: provider.isSelfCalculateFare,
          onPressed:
              () => _calculateFare(
                t,
                successMessage: 'Fare calculated (no extra charges)',
                toastOnError: true,
              ),
        ),
      ],

      // Step 2: fare + payment options
      if (hasFare && !paymentDone) ...[
        FareBreakdownCard(provider: provider),
        const SizedBox(height: 8),
        TripSteps.payOnline(t),
        TripSteps.payCash(t),
      ],

      // Step 3: payment done
      if (paymentDone) finalStep,
    ];
  }

  static Future<void> _calculateFare(
    TripContext t, {
    required String successMessage,
    required bool toastOnError,
  }) async {
    if (!t.validateGarageAddress()) return;

    final success = await t.provider.selfCalculateFareApi(
      context: t.context,
      bookingId: t.bookingId,
      garageLat: t.garage.lat,
      garageLng: t.garage.lng,
      garageAddress: t.garage.address,
    );
    if (!t.context.mounted) return;

    if (success) {
      ToastHelper.show(
        t.context,
        message: successMessage,
        type: ToastType.success,
      );
    } else if (toastOnError) {
      ToastHelper.show(
        t.context,
        message: t.provider.errorMessage ?? 'Failed to calculate fare',
        type: ToastType.error,
      );
    }
  }
}
