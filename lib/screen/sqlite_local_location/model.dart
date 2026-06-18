class LocationLog {
  final String bookingId;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  LocationLog({
    required this.bookingId,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime.toIso8601String(),
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime.toIso8601String(),
    };
  }

  factory LocationLog.fromMap(Map<String, dynamic> map) {
    return LocationLog(
      bookingId: map['booking_id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dateTime: DateTime.parse(map['date_time']),
    );
  }
}
