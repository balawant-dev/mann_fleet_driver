import 'package:flutter/material.dart';

import 'self_billing_section.dart';
import 'trip_context.dart';
import 'trip_flow.dart';
import 'trip_steps.dart';

/// Start OTP -> pickup -> ride -> drop -> (billing) -> garage end.
class PickupToGarageFlow extends TripFlow {
  const PickupToGarageFlow();

  @override
  List<Widget> build(TripContext t) => [
    ...TripSteps.pickupStartSteps(t),
    ...TripSteps.rideSteps(t),
    if (t.status == TripStatus.dropped) ...TripSteps.afterDropToGarage(t),
    if (t.status == TripStatus.returningGarage) ...[
      if (t.isCorporateBilling) TripSteps.garageEnd(t),
      if (t.isSelfBilling)
        ...SelfBillingSection.build(
          t,
          addressMode: GarageAddressMode.whenFareMissing,
          hideFareFormWhenPaid: true,
          finalStep: TripSteps.garageEnd(t),
        ),
    ],
  ];
}
