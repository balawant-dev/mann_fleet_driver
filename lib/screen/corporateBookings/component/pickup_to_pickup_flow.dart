import 'trip_context.dart';
import 'trip_flow.dart';

/// Billing and "Complete Trip" happen at the returning_garage status.
class PickupToPickupFlow extends PickupBillingFlow {
  const PickupToPickupFlow();

  @override
  String get billingStatus => TripStatus.returningGarage;
}
