// import 'package:url_launcher/url_launcher.dart';
//
// Future<void> openMap(double? pLat, double? pLng, double? dLat, double? dLng) async {
//   // Google Maps URL format for navigation/directions
//   final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$pLat,$pLng&destination=$dLat,$dLng&travelmode=driving";
//   final Uri uri = Uri.parse(googleMapsUrl);
//
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not open the map.';
//   }
// }


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/// open navigation from current location -> destination
Future<void> openMapNavigation({
  required double destLat,
  required double destLng,
}) async {
  try {
    /// current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double currentLat = position.latitude;
    double currentLng = position.longitude;

    /// Google Maps navigation URL
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1"
        "&origin=$currentLat,$currentLng"
        "&destination=$destLat,$destLng"
        "&travelmode=driving";

    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw "Could not open map";
    }
  } catch (e) {
    debugPrint("Map Error: $e");
  }
}