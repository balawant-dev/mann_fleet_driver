class SelfFareResponse {
  final bool status;
  final String message;
  final SelfFareData2? data;

  SelfFareResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SelfFareResponse.fromJson(Map<String, dynamic> json) {
    return SelfFareResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? SelfFareData2.fromJson(json['data'])
          : null,
    );
  }
}

class SelfFareData2 {
  final String? tripType;
  final num? distanceKm;
  final num? durationMins;
  final num? nightCount;
  final num? payableAmount;
  final SelfFareInfo? selfFare;
  final FareBreakdown? fare;

  SelfFareData2({
    this.tripType,
    this.distanceKm,
    this.durationMins,
    this.nightCount,
    this.payableAmount,
    this.selfFare,
    this.fare,
  });

  factory SelfFareData2.fromJson(Map<String, dynamic> json) {
    return SelfFareData2(
      tripType: json['tripType']?.toString(),
      distanceKm: json['distanceKm'],
      durationMins: json['durationMins'],
      nightCount: json['nightCount'],
      payableAmount: json['payableAmount'],
      selfFare: json['selfFare'] != null
          ? SelfFareInfo.fromJson(json['selfFare'])
          : null,
      fare: json['fare'] != null
          ? FareBreakdown.fromJson(json['fare'])
          : null,
    );
  }
}

class SelfFareInfo {
  final bool locked;
  final String? stage;
  final String? lockedAt;
  final num? tripDistanceKm;
  final num? tripDurationMins;
  final num? returnDistanceKm;
  final num? returnDurationMins;

  SelfFareInfo({
    this.locked = false,
    this.stage,
    this.lockedAt,
    this.tripDistanceKm,
    this.tripDurationMins,
    this.returnDistanceKm,
    this.returnDurationMins,
  });

  factory SelfFareInfo.fromJson(Map<String, dynamic> json) {
    return SelfFareInfo(
      locked: json['locked'] ?? false,
      stage: json['stage']?.toString(),
      lockedAt: json['lockedAt']?.toString(),
      tripDistanceKm: json['tripDistanceKm'],
      tripDurationMins: json['tripDurationMins'],
      returnDistanceKm: json['returnDistanceKm'],
      returnDurationMins: json['returnDurationMins'],
    );
  }
}

class FareBreakdown {
  final num baseCharge;
  final num totalDistance;
  final num totalDurationMins;
  final num totalHours;
  final num driverCharge;
  final num extraPrKm;
  final num extraPrMint;
  final num extraDistance;
  final num extraDuration;
  final num extraCharge;
  final num extraTimeCharge;
  final num nightFare;
  final num nightCount;
  final num parkingCharge;
  final num tollAmount;
  final num stateCharge;
  final num otherCharges;
  final List<OtherChargeDetail> otherChargesDetail;
  final num gstCharge;
  final num gstPercent;
  final num totalAmount;

  FareBreakdown({
    this.baseCharge = 0,
    this.totalDistance = 0,
    this.totalDurationMins = 0,
    this.totalHours = 0,
    this.driverCharge = 0,
    this.extraPrKm = 0,
    this.extraPrMint = 0,
    this.extraDistance = 0,
    this.extraDuration = 0,
    this.extraCharge = 0,
    this.extraTimeCharge = 0,
    this.nightFare = 0,
    this.nightCount = 0,
    this.parkingCharge = 0,
    this.tollAmount = 0,
    this.stateCharge = 0,
    this.otherCharges = 0,
    this.otherChargesDetail = const [],
    this.gstCharge = 0,
    this.gstPercent = 0,
    this.totalAmount = 0,
  });

  factory FareBreakdown.fromJson(Map<String, dynamic> json) {
    return FareBreakdown(
      baseCharge: json['baseCharge'] ?? 0,
      totalDistance: json['totalDistance'] ?? 0,
      totalDurationMins: json['totalDurationMins'] ?? 0,
      totalHours: json['totalHours'] ?? 0,
      driverCharge: json['driverCharge'] ?? 0,
      extraPrKm: json['extraPrKm'] ?? 0,
      extraPrMint: json['extraPrMint'] ?? 0,
      extraDistance: json['extraDistace'] ?? json['extraDistance'] ?? 0, // backend me typo hai
      extraDuration: json['extraDuration'] ?? 0,
      extraCharge: json['extraCharge'] ?? 0,
      extraTimeCharge: json['extraTimeCharge'] ?? 0,
      nightFare: json['nightFare'] ?? 0,
      nightCount: json['nightCount'] ?? 0,
      parkingCharge: json['parkingCharge'] ?? 0,
      tollAmount: json['tollAmount'] ?? 0,
      stateCharge: json['stateCharge'] ?? 0,
      otherCharges: json['otherCharges'] ?? 0,
      otherChargesDetail: (json['otherChargesDetail'] as List?)
          ?.map((e) => OtherChargeDetail.fromJson(e))
          .toList() ??
          [],
      gstCharge: json['gstCharge'] ?? 0,
      gstPercent: json['gstPercent'] ?? 0,
      totalAmount: json['totalAmount'] ?? 0,
    );
  }
}

class OtherChargeDetail {
  final String id;
  final String name;
  final num amount;

  OtherChargeDetail({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory OtherChargeDetail.fromJson(Map<String, dynamic> json) {
    return OtherChargeDetail(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount: json['amount'] ?? 0,
    );
  }
}