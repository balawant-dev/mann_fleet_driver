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
  final String? tripStartAt;
  final String? checkedAt;
  final Trip trip;
  final Fare fare;
  final FareBreakdown fareBreakdown;
  final bool isExtraPaymentPending;
  final bool? extraPaymentCompleted;
  final String nextStep;

  FarePreviewData({
    required this.bookingId,
    required this.bookingNumber,
    required this.tripStartAt,
    required this.checkedAt,
    required this.trip,
    required this.fare,
    required this.fareBreakdown,
    required this.isExtraPaymentPending,
    this.extraPaymentCompleted,
    required this.nextStep,
  });

  factory FarePreviewData.fromJson(Map<String, dynamic> json) {
    return FarePreviewData(
      bookingId: json['bookingId'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      tripStartAt: json['tripStartAt'],
      checkedAt: json['checkedAt'],
      trip: Trip.fromJson(json['trip'] ?? {}),
      fare: Fare.fromJson(json['fare'] ?? {}),
      fareBreakdown: FareBreakdown.fromJson(json['fareBreakdown'] ?? {}),
      isExtraPaymentPending: json['isExtraPaymentPending'] ?? false,
      extraPaymentCompleted: json['extraPaymentCompleted'],
      nextStep: json['nextStep'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'bookingNumber': bookingNumber,
      'trip': trip.toJson(),
      'fare': fare.toJson(),
      'tripStartAt': tripStartAt,
      'checkedAt': checkedAt,
      'fareBreakdown': fareBreakdown.toJson(),
      'isExtraPaymentPending': isExtraPaymentPending,
      'extraPaymentCompleted': extraPaymentCompleted,
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
  final String distanceSource;

  final BufferConfig? bufferConfig;
  final String? tripStartAt;
  final String? checkedAt;
  final DriverLocation? driverLocation;

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
    required this.distanceSource,
    this.bufferConfig,
    this.tripStartAt,
    this.checkedAt,
    this.driverLocation,
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
      distanceSource: json['distanceSource'] ?? '',
      bufferConfig:
          json['bufferConfig'] != null
              ? BufferConfig.fromJson(json['bufferConfig'])
              : null,
      tripStartAt: json['tripStartAt'],
      checkedAt: json['checkedAt'],
      driverLocation:
          json['driverLocation'] != null
              ? DriverLocation.fromJson(json['driverLocation'])
              : null,
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
      'distanceSource': distanceSource,
      'bufferConfig': bufferConfig?.toJson(),
      'tripStartAt': tripStartAt,
      'checkedAt': checkedAt,
      'driverLocation': driverLocation?.toJson(),
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
  final List<String>? adjustmentReasons;

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
      adjustmentReasons:
          json['adjustmentReasons'] != null
              ? List<String>.from(json['adjustmentReasons'])
              : null,
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
  final RoundTripDetail? roundTripDetail;

  final double baseFare;
  final double distanceCharge;
  final double timeCharge;
  final double surgeCharge;
  final double subtotal;

  final int? gstPercent;
  final double gstAmount;

  final double tollCharge;
  final double mcdTollCharge;

  final double surchargeAmount;
  final double waitingChargeAmount;
  final int waitingMins;

  final double extraKmCharge;
  final double extraTimeCharge;

  final double discountAmount;
  final double walletUsed;

  final double airportFare;
  final double nightFare;

  final double totalFare;

  FareBreakdown({
    this.roundTripDetail,
    required this.baseFare,
    required this.distanceCharge,
    required this.timeCharge,
    required this.surgeCharge,
    required this.subtotal,
    this.gstPercent,
    required this.gstAmount,
    required this.tollCharge,
    required this.mcdTollCharge,
    required this.surchargeAmount,
    required this.waitingChargeAmount,
    required this.waitingMins,
    required this.extraKmCharge,
    required this.extraTimeCharge,
    required this.discountAmount,
    required this.walletUsed,
    required this.airportFare,
    required this.nightFare,
    required this.totalFare,
  });

  factory FareBreakdown.fromJson(Map<String, dynamic> json) {
    return FareBreakdown(
      roundTripDetail:
          json['roundTripDetail'] != null
              ? RoundTripDetail.fromJson(json['roundTripDetail'])
              : null,
      baseFare: (json['baseFare'] ?? 0).toDouble(),
      distanceCharge: (json['distanceCharge'] ?? 0).toDouble(),
      timeCharge: (json['timeCharge'] ?? 0).toDouble(),
      surgeCharge: (json['surgeCharge'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      gstPercent: json['gstPercent'],
      gstAmount: (json['gstAmount'] ?? 0).toDouble(),
      tollCharge: (json['tollCharge'] ?? 0).toDouble(),
      mcdTollCharge: (json['mcdTollCharge'] ?? 0).toDouble(),
      surchargeAmount: (json['surchargeAmount'] ?? 0).toDouble(),
      waitingChargeAmount: (json['waitingChargeAmount'] ?? 0).toDouble(),
      waitingMins: json['waitingMins'] ?? 0,
      extraKmCharge: (json['extraKmCharge'] ?? 0).toDouble(),
      extraTimeCharge: (json['extraTimeCharge'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      walletUsed: (json['walletUsed'] ?? 0).toDouble(),
      airportFare: (json['airportFare'] ?? 0).toDouble(),
      nightFare: (json['nightFare'] ?? 0).toDouble(),
      totalFare: (json['totalFare'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundTripDetail': roundTripDetail?.toJson(),
      'baseFare': baseFare,
      'distanceCharge': distanceCharge,
      'timeCharge': timeCharge,
      'surgeCharge': surgeCharge,
      'subtotal': subtotal,
      'gstPercent': gstPercent,
      'gstAmount': gstAmount,
      'tollCharge': tollCharge,
      'mcdTollCharge': mcdTollCharge,
      'surchargeAmount': surchargeAmount,
      'waitingChargeAmount': waitingChargeAmount,
      'waitingMins': waitingMins,
      'extraKmCharge': extraKmCharge,
      'extraTimeCharge': extraTimeCharge,
      'discountAmount': discountAmount,
      'walletUsed': walletUsed,
      'airportFare': airportFare,
      'nightFare': nightFare,
      'totalFare': totalFare,
    };
  }
}

class RoundTripDetail {
  final double? oneWayDistanceKm;
  final double? effectiveDistanceKm;
  final int? oneWayTravelMins;
  final int? idleMinsBetweenLegs;
  final int? returnTravelMins;
  final int? effectiveTotalMins;

  RoundTripDetail({
    this.oneWayDistanceKm,
    this.effectiveDistanceKm,
    this.oneWayTravelMins,
    this.idleMinsBetweenLegs,
    this.returnTravelMins,
    this.effectiveTotalMins,
  });

  factory RoundTripDetail.fromJson(Map<String, dynamic> json) {
    return RoundTripDetail(
      oneWayDistanceKm: (json['oneWayDistanceKm'] as num?)?.toDouble(),
      effectiveDistanceKm: (json['effectiveDistanceKm'] as num?)?.toDouble(),
      oneWayTravelMins: json['oneWayTravelMins'],
      idleMinsBetweenLegs: json['idleMinsBetweenLegs'],
      returnTravelMins: json['returnTravelMins'],
      effectiveTotalMins: json['effectiveTotalMins'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oneWayDistanceKm': oneWayDistanceKm,
      'effectiveDistanceKm': effectiveDistanceKm,
      'oneWayTravelMins': oneWayTravelMins,
      'idleMinsBetweenLegs': idleMinsBetweenLegs,
      'returnTravelMins': returnTravelMins,
      'effectiveTotalMins': effectiveTotalMins,
    };
  }
}
