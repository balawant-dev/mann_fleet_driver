class TripExtraPaymentResponse {
  final bool status;
  final String message;
  final TripExtraPaymentData data;

  TripExtraPaymentResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TripExtraPaymentResponse.fromJson(Map<String, dynamic> json) {
    return TripExtraPaymentResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: TripExtraPaymentData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TripExtraPaymentData {
  final String bookingId;
  final String bookingNumber;
  final Trip trip;
  final Fare fare;
  final FareBreakdown fareBreakdown;
  final ExtraPaymentOrder extraPaymentOrder;
  final String nextStep;

  TripExtraPaymentData({
    required this.bookingId,
    required this.bookingNumber,
    required this.trip,
    required this.fare,
    required this.fareBreakdown,
    required this.extraPaymentOrder,
    required this.nextStep,
  });

  factory TripExtraPaymentData.fromJson(Map<String, dynamic> json) {
    return TripExtraPaymentData(
      bookingId: json['bookingId'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      trip: Trip.fromJson(json['trip'] ?? {}),
      fare: Fare.fromJson(json['fare'] ?? {}),
      fareBreakdown:
      FareBreakdown.fromJson(json['fareBreakdown'] ?? {}),
      extraPaymentOrder:
      ExtraPaymentOrder.fromJson(json['extraPaymentOrder'] ?? {}),
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
      'extraPaymentOrder': extraPaymentOrder.toJson(),
      'nextStep': nextStep,
    };
  }
}

class Trip {
  final double actualKm;
  final int actualMins;
  final String distanceSource;

  Trip({
    required this.actualKm,
    required this.actualMins,
    required this.distanceSource,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      actualKm: (json['actualKm'] ?? 0).toDouble(),
      actualMins: json['actualMins'] ?? 0,
      distanceSource: json['distanceSource'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actualKm': actualKm,
      'actualMins': actualMins,
      'distanceSource': distanceSource,
    };
  }
}

class Fare {
  final double estimatedFare;
  final double prepaidAmount;
  final double extraCharge;
  final double finalFare;
  final List<String> adjustmentReasons;

  Fare({
    required this.estimatedFare,
    required this.prepaidAmount,
    required this.extraCharge,
    required this.finalFare,
    required this.adjustmentReasons,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      estimatedFare: (json['estimatedFare'] ?? 0).toDouble(),
      prepaidAmount: (json['prepaidAmount'] ?? 0).toDouble(),
      extraCharge: (json['extraCharge'] ?? 0).toDouble(),
      finalFare: (json['finalFare'] ?? 0).toDouble(),
      adjustmentReasons:
      List<String>.from(json['adjustmentReasons'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estimatedFare': estimatedFare,
      'prepaidAmount': prepaidAmount,
      'extraCharge': extraCharge,
      'finalFare': finalFare,
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

class ExtraPaymentOrder {
  final String orderId;
  final int amount;
  final String currency;
  final String key;
  final String description;
  final String paymentLink;
  final String qrCodeUrl;
  final String? qrCodeId;

  ExtraPaymentOrder({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.key,
    required this.description,
    required this.paymentLink,
    required this.qrCodeUrl,
    this.qrCodeId,
  });

  factory ExtraPaymentOrder.fromJson(Map<String, dynamic> json) {
    return ExtraPaymentOrder(
      orderId: json['orderId'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
      key: json['key'] ?? '',
      description: json['description'] ?? '',
      paymentLink: json['paymentLink'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      qrCodeId: json['qrCodeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'key': key,
      'description': description,
      'paymentLink': paymentLink,
      'qrCodeUrl': qrCodeUrl,
      'qrCodeId': qrCodeId,
    };
  }
}