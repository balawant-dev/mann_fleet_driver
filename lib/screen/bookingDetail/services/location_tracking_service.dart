import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home_screen/repo/newBookingRepo.dart';

class LocationTrackingService extends TaskHandler {
  String bookingId = "";

  StreamSubscription<Position>? _positionStream;

  LocationTrackingService();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 30,
      ),
    ).listen((position) async {
      final prefs = await SharedPreferences.getInstance();

      bookingId =
          prefs.getString("tracking_booking_id") ?? "";

      print("🟢🟢🟢🟢🟢🟢🟢🟢🟢Location Booking Id => $bookingId");

      print(
        "Location => ${position.latitude}, ${position.longitude}",
      );
      await NewBookingRepo().updateDriverLocationBackgroundApi(
        id: bookingId,
        lat: position.latitude,
        lng: position.longitude,
      );

      // API Call
      // updateDriverLocationApi(...)
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _positionStream?.cancel();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}
}