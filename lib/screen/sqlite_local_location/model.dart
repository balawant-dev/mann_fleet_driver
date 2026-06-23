class LocationLog {
  final int? id;

  final String bookingId;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  final double distanceFromPrev;
  final double cumulativeDistance;

  LocationLog({
    this.id,
    required this.bookingId,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.distanceFromPrev,
    required this.cumulativeDistance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'booking_id': bookingId,
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime.toIso8601String(),
      'distance_from_prev': distanceFromPrev,
      'cumulative_distance': cumulativeDistance,
    };
  }

  Map<String, dynamic> toApiMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime.toIso8601String(),
      'distance_from_prev': distanceFromPrev,
      'cumulative_distance': cumulativeDistance,
    };
  }

  factory LocationLog.fromMap(Map<String, dynamic> map) {
    return LocationLog(
      id: map['id'],
      bookingId: map['booking_id'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      dateTime: DateTime.parse(map['date_time']),
      distanceFromPrev: (map['distance_from_prev'] as num?)?.toDouble() ?? 0,
      cumulativeDistance: (map['cumulative_distance'] as num?)?.toDouble() ?? 0,
    );
  }
}
