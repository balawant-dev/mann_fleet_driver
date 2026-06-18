// import 'dart:async';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../home_screen/repo/newBookingRepo.dart';
// import '../../sqlite_local_location/local_db_service.dart';
//
// class LocationTrackingService extends TaskHandler {
//   String bookingId = "";
//
//   StreamSubscription<Position>? _positionStream;
//   StreamSubscription<Position>? _positionStreamLocal;
//
//   LocationTrackingService();
//
//   @override
//   Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
//     _positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 1500,
//       ),
//     ).listen((position) async {
//       final prefs = await SharedPreferences.getInstance();
//
//       bookingId = prefs.getString("tracking_booking_id") ?? "";
//
//       print("🟢🟢🟢🟢🟢🟢🟢🟢🟢Location Booking Id => $bookingId");
//
//       print("Location => ${position.latitude}, ${position.longitude}");
//       await NewBookingRepo().updateDriverLocationBackgroundApi(
//         id: bookingId,
//         lat: position.latitude,
//         lng: position.longitude,
//       );
//     });
//
//     _positionStreamLocal = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 1,
//       ),
//     ).listen((position) async {
//       final prefs = await SharedPreferences.getInstance();
//
//       bookingId = prefs.getString("tracking_booking_id") ?? "";
//
//       print("🟢🟢🟢🟢🟢🟢🟢🟢🟢Location Booking Id => $bookingId");
//
//       print("Location => ${position.latitude}, ${position.longitude}");
//       await LocalDbService.instance.saveLocation(
//         bookingId: bookingId,
//         latitude: position.latitude,
//         longitude: position.longitude,
//         dateTime: DateTime.now(),
//       );
//     });
//   }
//
//   @override
//   Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
//     await _positionStream?.cancel();
//     await _positionStreamLocal?.cancel();
//   }
//
//   @override
//   void onRepeatEvent(DateTime timestamp) {}
// }

import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home_screen/repo/newBookingRepo.dart';
import '../../sqlite_local_location/local_db_service.dart';

class LocationTrackingService extends TaskHandler {
  LocationTrackingService();

  String bookingId = "";

  StreamSubscription<Position>? _positionStream;

  Position? _lastApiPosition;
  DateTime? _lastApiCallTime;

  static const double apiDistanceFilter = 1500; // meters
  static const int apiTimeFilter = 5; // minutes

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final prefs = await SharedPreferences.getInstance();

    bookingId = prefs.getString("tracking_booking_id") ?? "";

    if (bookingId.isEmpty) {
      print("❌ No booking id found");
      return;
    }

    print("🚀 Tracking Started");
    print("📦 Booking Id => $bookingId");

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 200,
      ),
    ).listen(
      (position) async {
        try {
          print(
            "📍 Location => "
            "${position.latitude}, "
            "${position.longitude}",
          );

          /// Save every point locally
          await _saveToLocal(position);

          /// Sync to API only when needed
          if (_shouldCallApi(position)) {
            await _callApi(position);
          }
        } catch (e) {
          print("❌ Tracking Error => $e");
        }
      },
      onError: (e) {
        print("❌ Location Stream Error => $e");
      },
    );
  }

  Future<void> _saveToLocal(Position position) async {
    await LocalDbService.instance.saveLocation(
      bookingId: bookingId,
      latitude: position.latitude,
      longitude: position.longitude,
      dateTime: DateTime.now(),
    );

    print("💾 Saved Locally");
  }

  bool _shouldCallApi(Position currentPosition) {
    /// First location -> call API immediately
    if (_lastApiPosition == null) {
      return true;
    }

    final distance = Geolocator.distanceBetween(
      _lastApiPosition!.latitude,
      _lastApiPosition!.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    final minutesPassed =
        DateTime.now().difference(_lastApiCallTime ?? DateTime.now()).inMinutes;

    return distance >= apiDistanceFilter || minutesPassed >= apiTimeFilter;
  }

  Future<void> _callApi(Position position) async {
    try {
      print("🌐 Sending Location To API");

      await NewBookingRepo().updateDriverLocationBackgroundApi(
        id: bookingId,
        lat: position.latitude,
        lng: position.longitude,
      );

      _lastApiPosition = position;
      _lastApiCallTime = DateTime.now();

      print("✅ API Sync Success");
    } catch (e) {
      print("❌ API Sync Failed => $e");
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print("🛑 Tracking Stopped");

    await _positionStream?.cancel();

    _positionStream = null;
    _lastApiPosition = null;
    _lastApiCallTime = null;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}
}
