import 'trip_context.dart';
import 'trip_flow.dart';

/// Billing and "Complete Trip" happen once the trip is dropped.
class PickupToDestinationFlow extends PickupBillingFlow {
  const PickupToDestinationFlow();

  @override
  String get billingStatus => TripStatus.dropped;
}
