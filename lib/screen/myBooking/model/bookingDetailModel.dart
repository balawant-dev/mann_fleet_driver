// class BookingDetailModel {
//   bool? status;
//   String? message;
//   BookingData? data;
//
//   BookingDetailModel({this.status, this.message, this.data});
//
//   BookingDetailModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? BookingData.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'data': data?.toJson(),
//     };
//   }
// }
//
// class BookingData {
//   Location? pickup;
//   Location? dropoff;
//   PricingSnapshot? pricingSnapshot;
//   Payment? payment;
//   FareBreakup? fareBreakup;
//   User? user;
//   Segment? segment;
//   Region? region;
//   Vehicle? vehicle;
//
//   String? bookingNumber;
//   String? bookingType;
//   String? paymentStatus;
//   String? tripStatus;
//   String? overallStatus;
//   double? estimatedFare;
//   double? prepaidAmount;
//   String? otp;
//
//   BookingData({
//     this.pickup,
//     this.dropoff,
//     this.pricingSnapshot,
//     this.payment,
//     this.fareBreakup,
//     this.user,
//     this.segment,
//     this.region,
//     this.vehicle,
//     this.bookingNumber,
//     this.bookingType,
//     this.paymentStatus,
//     this.tripStatus,
//     this.overallStatus,
//     this.estimatedFare,
//     this.prepaidAmount,
//     this.otp,
//   });
//
//   BookingData.fromJson(Map<String, dynamic> json) {
//     pickup = json['pickup'] != null ? Location.fromJson(json['pickup']) : null;
//     dropoff = json['dropoff'] != null ? Location.fromJson(json['dropoff']) : null;
//
//     pricingSnapshot = json['pricingSnapshot'] != null
//         ? PricingSnapshot.fromJson(json['pricingSnapshot'])
//         : null;
//
//     payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;
//
//     fareBreakup = json['fareBreakup'] != null
//         ? FareBreakup.fromJson(json['fareBreakup'])
//         : null;
//
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//     segment = json['segment'] != null ? Segment.fromJson(json['segment']) : null;
//     region = json['region'] != null ? Region.fromJson(json['region']) : null;
//     vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
//
//     bookingNumber = json['bookingNumber'];
//     bookingType = json['bookingType'];
//     paymentStatus = json['paymentStatus'];
//     tripStatus = json['tripStatus'];
//     overallStatus = json['overallStatus'];
//     estimatedFare = (json['estimatedFare'] as num?)?.toDouble();
//     prepaidAmount = (json['prepaidAmount'] as num?)?.toDouble();
//     otp = json['otp'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'pickup': pickup?.toJson(),
//       'dropoff': dropoff?.toJson(),
//       'pricingSnapshot': pricingSnapshot?.toJson(),
//       'payment': payment?.toJson(),
//       'fareBreakup': fareBreakup?.toJson(),
//       'user': user?.toJson(),
//       'segment': segment?.toJson(),
//       'region': region?.toJson(),
//       'vehicle': vehicle?.toJson(),
//       'bookingNumber': bookingNumber,
//       'bookingType': bookingType,
//       'paymentStatus': paymentStatus,
//       'tripStatus': tripStatus,
//       'overallStatus': overallStatus,
//       'estimatedFare': estimatedFare,
//       'prepaidAmount': prepaidAmount,
//       'otp': otp,
//     };
//   }
// }
//
//
// class Location {
//   double? lat;
//   double? lng;
//   String? address;
//
//   Location({this.lat, this.lng, this.address});
//
//   Location.fromJson(Map<String, dynamic> json) {
//     lat = (json['lat'] as num?)?.toDouble();
//     lng = (json['lng'] as num?)?.toDouble();
//     address = json['address'];
//   }
//
//   Map<String, dynamic> toJson() => {
//     'lat': lat,
//     'lng': lng,
//     'address': address,
//   };
// }
// class Payment {
//   String? method;
//   String? status;
//   double? paidAmount;
//
//   Payment.fromJson(Map<String, dynamic> json) {
//     method = json['method'];
//     status = json['status'];
//     paidAmount = (json['paidAmount'] as num?)?.toDouble();
//   }
//
//   Map<String, dynamic> toJson() => {
//     'method': method,
//     'status': status,
//     'paidAmount': paidAmount,
//   };
// }
//
//
// class PricingSnapshot {
//   double? baseFare;
//   double? perKmRate;
//   double? perMinRate;
//   double? minFare;
//   double? gstPercent;
//
//   PricingSnapshot.fromJson(Map<String, dynamic> json) {
//     baseFare = (json['baseFare'] as num?)?.toDouble();
//     perKmRate = (json['perKmRate'] as num?)?.toDouble();
//     perMinRate = (json['perMinRate'] as num?)?.toDouble();
//     minFare = (json['minFare'] as num?)?.toDouble();
//     gstPercent = (json['gstPercent'] as num?)?.toDouble();
//   }
//
//   Map<String, dynamic> toJson() => {
//     'baseFare': baseFare,
//     'perKmRate': perKmRate,
//     'perMinRate': perMinRate,
//     'minFare': minFare,
//     'gstPercent': gstPercent,
//   };
// }
//
// class FareBreakup {
//   FareEstimated? estimated;
//
//   FareBreakup.fromJson(Map<String, dynamic> json) {
//     estimated = json['estimated'] != null
//         ? FareEstimated.fromJson(json['estimated'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() => {
//     'estimated': estimated?.toJson(),
//   };
// }
//
// class FareEstimated {
//   double? totalFare;
//
//   FareEstimated.fromJson(Map<String, dynamic> json) {
//     totalFare = (json['totalFare'] as num?)?.toDouble();
//   }
//
//   Map<String, dynamic> toJson() => {
//     'totalFare': totalFare,
//   };
// }
//
// class User {
//   String? name;
//   String? profilePic;
//
//   User.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     profilePic = json['profilePic'];
//   }
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'profilePic': profilePic,
//   };
// }
//
//
// class Vehicle {
//   String? brand;
//   String? model;
//   String? color;
//   String? carNumber;
//
//   Vehicle.fromJson(Map<String, dynamic> json) {
//     brand = json['brand'];
//     model = json['model'];
//     color = json['color'];
//     carNumber = json['carNumber'];
//   }
//
//   Map<String, dynamic> toJson() => {
//     'brand': brand,
//     'model': model,
//     'color': color,
//     'carNumber': carNumber,
//   };
// }
//
//
// class Segment {
//   String? name;
//
//   Segment.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() => {'name': name};
// }
//
// class Region {
//   String? name;
//   String? state;
//
//   Region.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     state = json['state'];
//   }
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'state': state,
//   };
// }



class BookingDetailModel {
  bool? status;
  String? message;
  BookingData? data;

  BookingDetailModel({this.status, this.message, this.data});

  BookingDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BookingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class BookingData {
  Location? pickup;
  Location? dropoff;
  PricingSnapshot? pricingSnapshot;
  Payment? payment;
  ExtraCharge? extraCharge;
  FareBreakup? fareBreakup;
  Actual? actual;
  Intercity? intercity;
  Hourly? hourly;
  RoundTrip? roundTrip;
  DriverResponse? driverResponse;

  String? id;
  String? bookingNumber;
  User? user;
  Segment? segment;
  Region? region;
  String? bookingType;
  String? paymentStatus;
  String? assignmentStatus;
  String? tripStatus;
  String? overallStatus;
  double? estimatedKm;
  double? estimatedMins;
  double? estimatedFare;
  double? prepaidAmount;
  DateTime? scheduledAt;
  bool? isScheduled;
  String? otp;
  String? invoice;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driver;
  Vehicle? vehicle;
  String? tripEndOtp;
  bool? tripEndOtpVerify;
  bool? tripStartOtpVerify;
  bool? pickupVerification;

  BookingData({
    this.pickup,
    this.dropoff,
    this.pricingSnapshot,
    this.payment,
    this.extraCharge,
    this.fareBreakup,
    this.actual,
    this.intercity,
    this.hourly,
    this.roundTrip,
    this.driverResponse,
    this.id,
    this.bookingNumber,
    this.user,
    this.segment,
    this.region,
    this.bookingType,
    this.paymentStatus,
    this.assignmentStatus,
    this.tripStatus,
    this.overallStatus,
    this.estimatedKm,
    this.estimatedMins,
    this.estimatedFare,
    this.prepaidAmount,
    this.scheduledAt,
    this.isScheduled,
    this.otp,
    this.invoice,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.vehicle,
    this.tripEndOtp,
    this.tripEndOtpVerify,
    this.tripStartOtpVerify,
    this.pickupVerification,
  });

  BookingData.fromJson(Map<String, dynamic> json) {
    pickup = json['pickup'] != null ? Location.fromJson(json['pickup']) : null;
    dropoff = json['dropoff'] != null ? Location.fromJson(json['dropoff']) : null;
    pricingSnapshot = json['pricingSnapshot'] != null ? PricingSnapshot.fromJson(json['pricingSnapshot']) : null;
    payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    extraCharge = json['extraCharge'] != null ? ExtraCharge.fromJson(json['extraCharge']) : null;
    fareBreakup = json['fareBreakup'] != null ? FareBreakup.fromJson(json['fareBreakup']) : null;
    actual = json['actual'] != null ? Actual.fromJson(json['actual']) : null;
    intercity = json['intercity'] != null ? Intercity.fromJson(json['intercity']) : null;
    hourly = json['hourly'] != null ? Hourly.fromJson(json['hourly']) : null;
    roundTrip = json['roundTrip'] != null ? RoundTrip.fromJson(json['roundTrip']) : null;
    driverResponse = json['driverResponse'] != null ? DriverResponse.fromJson(json['driverResponse']) : null;

    id = json['_id'];
    bookingNumber = json['bookingNumber'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    segment = json['segment'] != null ? Segment.fromJson(json['segment']) : null;
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    bookingType = json['bookingType'];
    paymentStatus = json['paymentStatus'];
    assignmentStatus = json['assignmentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    estimatedKm = (json['estimatedKm'] as num?)?.toDouble();
    estimatedMins = (json['estimatedMins'] as num?)?.toDouble();
    estimatedFare = (json['estimatedFare'] as num?)?.toDouble();
    prepaidAmount = (json['prepaidAmount'] as num?)?.toDouble();
    scheduledAt = json['scheduledAt'] != null ? DateTime.parse(json['scheduledAt']) : null;
    isScheduled = json['isScheduled'];
    otp = json['otp'];
    invoice = json['invoice'];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    driver = json['driver'];
    vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    tripEndOtp = json['tripEndOtp'];
    tripEndOtpVerify = json['tripEndOtpVerify'];
    tripStartOtpVerify = json['tripStartOtpVerify'];
    pickupVerification = json['pickupVerification'];
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': pickup?.toJson(),
      'dropoff': dropoff?.toJson(),
      'pricingSnapshot': pricingSnapshot?.toJson(),
      'payment': payment?.toJson(),
      'extraCharge': extraCharge?.toJson(),
      'fareBreakup': fareBreakup?.toJson(),
      'actual': actual?.toJson(),
      'intercity': intercity?.toJson(),
      'hourly': hourly?.toJson(),
      'roundTrip': roundTrip?.toJson(),
      'driverResponse': driverResponse?.toJson(),
      '_id': id,
      'bookingNumber': bookingNumber,
      'user': user?.toJson(),
      'segment': segment?.toJson(),
      'region': region?.toJson(),
      'bookingType': bookingType,
      'paymentStatus': paymentStatus,
      'assignmentStatus': assignmentStatus,
      'tripStatus': tripStatus,
      'overallStatus': overallStatus,
      'estimatedKm': estimatedKm,
      'estimatedMins': estimatedMins,
      'estimatedFare': estimatedFare,
      'prepaidAmount': prepaidAmount,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'isScheduled': isScheduled,
      'otp': otp,
      'invoice': invoice,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'driver': driver,
      'vehicle': vehicle?.toJson(),
      'tripEndOtp': tripEndOtp,
      'tripEndOtpVerify': tripEndOtpVerify,
      'tripStartOtpVerify': tripStartOtpVerify,
      'pickupVerification': pickupVerification,
    };
  }
}

// ================== Supporting Models ==================

class Location {
  double? lat;
  double? lng;
  String? address;

  Location({this.lat, this.lng, this.address});

  Location.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();
    address = json['address'];
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'address': address};
}

class PricingSnapshot {
  HourlyPackage? hourlyPackage;
  double? baseFare;
  double? perKmRate;
  double? perMinRate;
  double? minFare;
  double? surgeMultiplier;
  double? gstPercent;
  double? cancellationFee;
  double? tollCharge;

  PricingSnapshot.fromJson(Map<String, dynamic> json) {
    hourlyPackage = json['hourlyPackage'] != null ? HourlyPackage.fromJson(json['hourlyPackage']) : null;
    baseFare = (json['baseFare'] as num?)?.toDouble();
    perKmRate = (json['perKmRate'] as num?)?.toDouble();
    perMinRate = (json['perMinRate'] as num?)?.toDouble();
    minFare = (json['minFare'] as num?)?.toDouble();
    surgeMultiplier = (json['surgeMultiplier'] as num?)?.toDouble();
    gstPercent = (json['gstPercent'] as num?)?.toDouble();
    cancellationFee = (json['cancellationFee'] as num?)?.toDouble();
    tollCharge = (json['tollCharge'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'hourlyPackage': hourlyPackage?.toJson(),
    'baseFare': baseFare,
    'perKmRate': perKmRate,
    'perMinRate': perMinRate,
    'minFare': minFare,
    'surgeMultiplier': surgeMultiplier,
    'gstPercent': gstPercent,
    'cancellationFee': cancellationFee,
    'tollCharge': tollCharge,
  };
}

class HourlyPackage {
  int? hours;
  int? includedKms;
  double? packageFare;
  double? extraPerKm;
  double? extraPerMin;

  HourlyPackage.fromJson(Map<String, dynamic> json) {
    hours = json['hours'];
    includedKms = json['includedKms'];
    packageFare = (json['packageFare'] as num?)?.toDouble();
    extraPerKm = (json['extraPerKm'] as num?)?.toDouble();
    extraPerMin = (json['extraPerMin'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'hours': hours,
    'includedKms': includedKms,
    'packageFare': packageFare,
    'extraPerKm': extraPerKm,
    'extraPerMin': extraPerMin,
  };
}

class Payment {
  ExtraPayment? extraPayment;
  String? method;
  String? orderId;
  String? gatewayRef;
  double? paidAmount;
  String? status;
  String? transactionId;

  Payment.fromJson(Map<String, dynamic> json) {
    extraPayment = json['extraPayment'] != null ? ExtraPayment.fromJson(json['extraPayment']) : null;
    method = json['method'];
    orderId = json['orderId'];
    gatewayRef = json['gatewayRef'];
    paidAmount = (json['paidAmount'] as num?)?.toDouble();
    status = json['status'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() => {
    'extraPayment': extraPayment?.toJson(),
    'method': method,
    'orderId': orderId,
    'gatewayRef': gatewayRef,
    'paidAmount': paidAmount,
    'status': status,
    'transactionId': transactionId,
  };
}

class ExtraPayment {
  String? orderId;
  double? amount;
  String? status;
  String? method;
  String? gatewayRef;

  ExtraPayment.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = (json['amount'] as num?)?.toDouble();
    status = json['status'];
    method = json['method'];
    gatewayRef = json['gatewayRef'];
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'amount': amount,
    'status': status,
    'method': method,
    'gatewayRef': gatewayRef,
  };
}

class ExtraCharge {
  double? amount;
  String? reason;
  bool? isPaid;

  ExtraCharge.fromJson(Map<String, dynamic> json) {
    amount = (json['amount'] as num?)?.toDouble();
    reason = json['reason'];
    isPaid = json['isPaid'];
  }

  Map<String, dynamic> toJson() => {'amount': amount, 'reason': reason, 'isPaid': isPaid};
}

class FareBreakup {
  EstimatedFare? estimated;
  FinalFare? finalFare;

  FareBreakup.fromJson(Map<String, dynamic> json) {
    estimated = json['estimated'] != null ? EstimatedFare.fromJson(json['estimated']) : null;
    finalFare = json['final'] != null ? FinalFare.fromJson(json['final']) : null;
  }

  Map<String, dynamic> toJson() => {'estimated': estimated?.toJson(), 'final': finalFare?.toJson()};
}

class EstimatedFare {
  double? baseFare;
  double? subtotal;
  double? gstAmount;
  double? totalFare;

  EstimatedFare.fromJson(Map<String, dynamic> json) {
    baseFare = (json['baseFare'] as num?)?.toDouble();
    subtotal = (json['subtotal'] as num?)?.toDouble();
    gstAmount = (json['gstAmount'] as num?)?.toDouble();
    totalFare = (json['totalFare'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'baseFare': baseFare,
    'subtotal': subtotal,
    'gstAmount': gstAmount,
    'totalFare': totalFare,
  };
}

class FinalFare {
  double? totalFare;
  // Add more fields if needed in future

  FinalFare.fromJson(Map<String, dynamic> json) {
    totalFare = (json['totalFare'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {'totalFare': totalFare};
}

class Actual {
  String? polyline;
  double? distanceKm;
  double? durationMins;
  double? tollAmount;

  Actual.fromJson(Map<String, dynamic> json) {
    polyline = json['polyline'];
    distanceKm = (json['distanceKm'] as num?)?.toDouble();
    durationMins = (json['durationMins'] as num?)?.toDouble();
    tollAmount = (json['tollAmount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'polyline': polyline,
    'distanceKm': distanceKm,
    'durationMins': durationMins,
    'tollAmount': tollAmount,
  };
}

class Intercity {
  int? tripDays;
  double? tollAmount;

  Intercity.fromJson(Map<String, dynamic> json) {
    tripDays = json['tripDays'];
    tollAmount = (json['tollAmount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {'tripDays': tripDays, 'tollAmount': tollAmount};
}

class Hourly {
  int? bookedHours;
  int? bookedKms;
  int? extraHours;
  int? extraKms;
  double? extraCharges;

  Hourly.fromJson(Map<String, dynamic> json) {
    bookedHours = json['bookedHours'];
    bookedKms = json['bookedKms'];
    extraHours = json['extraHours'];
    extraKms = json['extraKms'];
    extraCharges = (json['extraCharges'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'bookedHours': bookedHours,
    'bookedKms': bookedKms,
    'extraHours': extraHours,
    'extraKms': extraKms,
    'extraCharges': extraCharges,
  };
}

class RoundTrip {
  String? returnStatus;
  double? returnFare;

  RoundTrip.fromJson(Map<String, dynamic> json) {
    returnStatus = json['returnStatus'];
    returnFare = (json['returnFare'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {'returnStatus': returnStatus, 'returnFare': returnFare};
}

class DriverResponse {
  String? status;

  DriverResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {'status': status};
}

class User {
  String? name;
  String? profilePic;

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() => {'name': name, 'profilePic': profilePic};
}

class Segment {
  String? name;
  int? maxCapacity;

  Segment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    maxCapacity = json['maxCapacity'];
  }

  Map<String, dynamic> toJson() => {'name': name, 'maxCapacity': maxCapacity};
}

class Region {
  String? name;
  String? state;

  Region.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() => {'name': name, 'state': state};
}

class Vehicle {
  String? model;
  String? color;

  Vehicle.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() => {'model': model, 'color': color};
}