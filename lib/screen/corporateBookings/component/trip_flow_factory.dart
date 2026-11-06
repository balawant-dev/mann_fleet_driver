import 'garage_to_garage_flow.dart';
import 'pickup_to_destination_flow.dart';
import 'pickup_to_garage_flow.dart';
import 'pickup_to_pickup_flow.dart';
import 'trip_context.dart';
import 'trip_flow.dart';

class TripFlowFactory {
  TripFlowFactory._();

  /// [tripType] must be lower case. Returns null for unknown trip types.
  static TripFlow? forTripType(String tripType) {
    switch (tripType) {
      case TripType.garageToGarage:
        return const GarageToGarageFlow();
      case TripType.pickupToGarage:
        return const PickupToGarageFlow();
      case TripType.pickupToDestination:
        return const PickupToDestinationFlow();
      case TripType.pickupToPickup:
        return const PickupToPickupFlow();
      default:
        return null;
    }
  }
}
