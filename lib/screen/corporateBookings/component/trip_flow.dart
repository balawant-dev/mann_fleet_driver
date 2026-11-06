import 'package:flutter/material.dart';

import 'self_billing_section.dart';
import 'trip_context.dart';
import 'trip_steps.dart';

/// One trip type = one flow. Returns the action widgets for the current status.
abstract class TripFlow {
  const TripFlow();

  List<Widget> build(TripContext t);
}

/// Shared by flows that end with billing + "Complete Trip"
/// (pickup to destination / pickup to pickup).
/// Only the status at which billing starts differs.
abstract class PickupBillingFlow extends TripFlow {
  const PickupBillingFlow();

  /// Trip status at which extra charges / payment / complete trip are shown.
  String get billingStatus;

  @override
  List<Widget> build(TripContext t) => [
    ...TripSteps.pickupStartSteps(t),
    ...TripSteps.rideSteps(t),
    if (t.status == billingStatus) ...[
      if (t.isCorporateBilling) ...TripSteps.corporateDropActions(t),
      if (t.isSelfBilling)
        ...SelfBillingSection.build(
          t,
          addressMode: GarageAddressMode.none,
          finalStep: TripSteps.completeTrip(t),
        ),
    ],
  ];
}
