class FinalFarePreviewModel {
  final bool status;
  final String message;
  final FarePreviewData data;

  FinalFarePreviewModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FinalFarePreviewModel.fromJson(Map<String, dynamic> json) {
    return FinalFarePreviewModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: FarePreviewData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class FarePreviewData {
  final String bookingId;
  final String bookingNumber;
  final Trip trip;
  final Fare fare;
  final FareBreakdown fareBreakdown;
  final String nextStep;

  FarePreviewData({
    required this.bookingId,
    required this.bookingNumber,
    required this.trip,
    required this.fare,
    required this.fareBreakdown,
    required this.nextStep,
  });

  factory FarePreviewData.fromJson(Map<String, dynamic> json) {
    return FarePreviewData(
      bookingId: json['bookingId'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      trip: Trip.fromJson(json['trip'] ?? {}),
      fare: Fare.fromJson(json['fare'] ?? {}),
      fareBreakdown: FareBreakdown.fromJson(json['fareBreakdown'] ?? {}),
      nextStep: json['nextStep'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'bookingNumber': bookingNumber,
      'trip': trip.toJson(),
      'fare': fare.toJson(),
      'fareBreakdown': fareBreakdown.toJson(),
      'nextStep': nextStep,
    };
  }
}

class Trip {
  final double estimatedKm;
  final int estimatedMins;
  final double actualKm;
  final int actualMins;
  final double kmVariance;
  final int minVariance;
  final bool withinBuffer;
  final bool kmWithinBuffer;
  final bool minWithinBuffer;
  final String durationSource;
  final BufferConfig bufferConfig;
  final String tripStartAt;
  final String checkedAt;
  final DriverLocation driverLocation;
  final String distanceSource;

  Trip({
    required this.estimatedKm,
    required this.estimatedMins,
    required this.actualKm,
    required this.actualMins,
    required this.kmVariance,
    required this.minVariance,
    required this.withinBuffer,
    required this.kmWithinBuffer,
    required this.minWithinBuffer,
    required this.durationSource,
    required this.bufferConfig,
    required this.tripStartAt,
    required this.checkedAt,
    required this.driverLocation,
    required this.distanceSource,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      estimatedKm: (json['estimatedKm'] ?? 0).toDouble(),
      estimatedMins: json['estimatedMins'] ?? 0,
      actualKm: (json['actualKm'] ?? 0).toDouble(),
      actualMins: json['actualMins'] ?? 0,
      kmVariance: (json['kmVariance'] ?? 0).toDouble(),
      minVariance: json['minVariance'] ?? 0,
      withinBuffer: json['withinBuffer'] ?? false,
      kmWithinBuffer: json['kmWithinBuffer'] ?? false,
      minWithinBuffer: json['minWithinBuffer'] ?? false,
      durationSource: json['durationSource'] ?? '',
      bufferConfig: BufferConfig.fromJson(json['bufferConfig'] ?? {}),
      tripStartAt: json['tripStartAt'] ?? '',
      checkedAt: json['checkedAt'] ?? '',
      driverLocation: DriverLocation.fromJson(json['driverLocation'] ?? {}),
      distanceSource: json['distanceSource'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estimatedKm': estimatedKm,
      'estimatedMins': estimatedMins,
      'actualKm': actualKm,
      'actualMins': actualMins,
      'kmVariance': kmVariance,
      'minVariance': minVariance,
      'withinBuffer': withinBuffer,
      'kmWithinBuffer': kmWithinBuffer,
      'minWithinBuffer': minWithinBuffer,
      'durationSource': durationSource,
      'bufferConfig': bufferConfig.toJson(),
      'tripStartAt': tripStartAt,
      'checkedAt': checkedAt,
      'driverLocation': driverLocation.toJson(),
      'distanceSource': distanceSource,
    };
  }
}

class BufferConfig {
  final double maxExtraKm;
  final int maxExtraMins;

  BufferConfig({required this.maxExtraKm, required this.maxExtraMins});

  factory BufferConfig.fromJson(Map<String, dynamic> json) {
    return BufferConfig(
      maxExtraKm: (json['maxExtraKm'] ?? 0).toDouble(),
      maxExtraMins: json['maxExtraMins'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'maxExtraKm': maxExtraKm, 'maxExtraMins': maxExtraMins};
  }
}

class DriverLocation {
  final double lat;
  final double lng;

  DriverLocation({required this.lat, required this.lng});

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}

class Fare {
  final double estimatedFare;
  final double prepaidAmount;
  final double finalFare;
  final String adjustmentType;
  final double adjustmentAmount;
  final bool requiresExtraPayment;
  final bool refundApplicable;
  final bool bufferApplied;
  final dynamic adjustmentReasons;

  Fare({
    required this.estimatedFare,
    required this.prepaidAmount,
    required this.finalFare,
    required this.adjustmentType,
    required this.adjustmentAmount,
    required this.requiresExtraPayment,
    required this.refundApplicable,
    required this.bufferApplied,
    this.adjustmentReasons,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      estimatedFare: (json['estimatedFare'] ?? 0).toDouble(),
      prepaidAmount: (json['prepaidAmount'] ?? 0).toDouble(),
      finalFare: (json['finalFare'] ?? 0).toDouble(),
      adjustmentType: json['adjustmentType'] ?? '',
      adjustmentAmount: (json['adjustmentAmount'] ?? 0).toDouble(),
      requiresExtraPayment: json['requiresExtraPayment'] ?? false,
      refundApplicable: json['refundApplicable'] ?? false,
      bufferApplied: json['bufferApplied'] ?? false,
      adjustmentReasons: json['adjustmentReasons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estimatedFare': estimatedFare,
      'prepaidAmount': prepaidAmount,
      'finalFare': finalFare,
      'adjustmentType': adjustmentType,
      'adjustmentAmount': adjustmentAmount,
      'requiresExtraPayment': requiresExtraPayment,
      'refundApplicable': refundApplicable,
      'bufferApplied': bufferApplied,
      'adjustmentReasons': adjustmentReasons,
    };
  }
}

class FareBreakdown {
  final double baseFare;
  final double distanceCharge;
  final double timeCharge;
  final double surgeCharge;
  final double subtotal;
  final int gstPercent;
  final double gstAmount;
  final double tollCharge;
  final double totalFare;

  FareBreakdown({
    required this.baseFare,
    required this.distanceCharge,
    required this.timeCharge,
    required this.surgeCharge,
    required this.subtotal,
    required this.gstPercent,
    required this.gstAmount,
    required this.tollCharge,
    required this.totalFare,
  });

  factory FareBreakdown.fromJson(Map<String, dynamic> json) {
    return FareBreakdown(
      baseFare: (json['baseFare'] ?? 0).toDouble(),
      distanceCharge: (json['distanceCharge'] ?? 0).toDouble(),
      timeCharge: (json['timeCharge'] ?? 0).toDouble(),
      surgeCharge: (json['surgeCharge'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      gstPercent: json['gstPercent'] ?? 0,
      gstAmount: (json['gstAmount'] ?? 0).toDouble(),
      tollCharge: (json['tollCharge'] ?? 0).toDouble(),
      totalFare: (json['totalFare'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseFare': baseFare,
      'distanceCharge': distanceCharge,
      'timeCharge': timeCharge,
      'surgeCharge': surgeCharge,
      'subtotal': subtotal,
      'gstPercent': gstPercent,
      'gstAmount': gstAmount,
      'tollCharge': tollCharge,
      'totalFare': totalFare,
    };
  }
}
