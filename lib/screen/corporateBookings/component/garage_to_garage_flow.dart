import 'package:flutter/material.dart';

import 'self_billing_section.dart';
import 'trip_context.dart';
import 'trip_flow.dart';
import 'trip_steps.dart';

/// Garage start -> start OTP -> pickup -> ride -> drop -> (billing) -> garage end.
class GarageToGarageFlow extends TripFlow {
  const GarageToGarageFlow();

  @override
  List<Widget> build(TripContext t) => [
    if (t.status == TripStatus.driverEnroute) TripSteps.garageStart(t),
    if (t.status == TripStatus.garageStarted && !t.startOtpVerified)
      TripSteps.verifyStartOtp(t),
    if (t.status == TripStatus.garageStarted && t.startOtpVerified)
      TripSteps.pickupCheckpoint(t),
    ...TripSteps.rideSteps(t),
    if (t.status == TripStatus.dropped) ...TripSteps.afterDropToGarage(t),
    if (t.status == TripStatus.returningGarage) ...[
      if (t.isCorporateBilling) TripSteps.garageEnd(t),
      if (t.isSelfBilling)
        ...SelfBillingSection.build(
          t,
          addressMode: GarageAddressMode.always,
          finalStep: TripSteps.garageEnd(t),
        ),
    ],
  ];
}
