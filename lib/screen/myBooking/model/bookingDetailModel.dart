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
  FareBreakup? fareBreakup;
  User? user;
  Segment? segment;
  Region? region;
  Vehicle? vehicle;

  String? bookingNumber;
  String? bookingType;
  String? paymentStatus;
  String? tripStatus;
  String? overallStatus;
  double? estimatedFare;
  double? prepaidAmount;
  String? otp;

  BookingData({
    this.pickup,
    this.dropoff,
    this.pricingSnapshot,
    this.payment,
    this.fareBreakup,
    this.user,
    this.segment,
    this.region,
    this.vehicle,
    this.bookingNumber,
    this.bookingType,
    this.paymentStatus,
    this.tripStatus,
    this.overallStatus,
    this.estimatedFare,
    this.prepaidAmount,
    this.otp,
  });

  BookingData.fromJson(Map<String, dynamic> json) {
    pickup = json['pickup'] != null ? Location.fromJson(json['pickup']) : null;
    dropoff = json['dropoff'] != null ? Location.fromJson(json['dropoff']) : null;

    pricingSnapshot = json['pricingSnapshot'] != null
        ? PricingSnapshot.fromJson(json['pricingSnapshot'])
        : null;

    payment = json['payment'] != null ? Payment.fromJson(json['payment']) : null;

    fareBreakup = json['fareBreakup'] != null
        ? FareBreakup.fromJson(json['fareBreakup'])
        : null;

    user = json['user'] != null ? User.fromJson(json['user']) : null;
    segment = json['segment'] != null ? Segment.fromJson(json['segment']) : null;
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;

    bookingNumber = json['bookingNumber'];
    bookingType = json['bookingType'];
    paymentStatus = json['paymentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    estimatedFare = (json['estimatedFare'] as num?)?.toDouble();
    prepaidAmount = (json['prepaidAmount'] as num?)?.toDouble();
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': pickup?.toJson(),
      'dropoff': dropoff?.toJson(),
      'pricingSnapshot': pricingSnapshot?.toJson(),
      'payment': payment?.toJson(),
      'fareBreakup': fareBreakup?.toJson(),
      'user': user?.toJson(),
      'segment': segment?.toJson(),
      'region': region?.toJson(),
      'vehicle': vehicle?.toJson(),
      'bookingNumber': bookingNumber,
      'bookingType': bookingType,
      'paymentStatus': paymentStatus,
      'tripStatus': tripStatus,
      'overallStatus': overallStatus,
      'estimatedFare': estimatedFare,
      'prepaidAmount': prepaidAmount,
      'otp': otp,
    };
  }
}


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

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'address': address,
  };
}
class Payment {
  String? method;
  String? status;
  double? paidAmount;

  Payment.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    status = json['status'];
    paidAmount = (json['paidAmount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'method': method,
    'status': status,
    'paidAmount': paidAmount,
  };
}


class PricingSnapshot {
  double? baseFare;
  double? perKmRate;
  double? perMinRate;
  double? minFare;
  double? gstPercent;

  PricingSnapshot.fromJson(Map<String, dynamic> json) {
    baseFare = (json['baseFare'] as num?)?.toDouble();
    perKmRate = (json['perKmRate'] as num?)?.toDouble();
    perMinRate = (json['perMinRate'] as num?)?.toDouble();
    minFare = (json['minFare'] as num?)?.toDouble();
    gstPercent = (json['gstPercent'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'baseFare': baseFare,
    'perKmRate': perKmRate,
    'perMinRate': perMinRate,
    'minFare': minFare,
    'gstPercent': gstPercent,
  };
}

class FareBreakup {
  FareEstimated? estimated;

  FareBreakup.fromJson(Map<String, dynamic> json) {
    estimated = json['estimated'] != null
        ? FareEstimated.fromJson(json['estimated'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'estimated': estimated?.toJson(),
  };
}

class FareEstimated {
  double? totalFare;

  FareEstimated.fromJson(Map<String, dynamic> json) {
    totalFare = (json['totalFare'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
    'totalFare': totalFare,
  };
}

class User {
  String? name;
  String? profilePic;

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'profilePic': profilePic,
  };
}


class Vehicle {
  String? brand;
  String? model;
  String? color;
  String? carNumber;

  Vehicle.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    carNumber = json['carNumber'];
  }

  Map<String, dynamic> toJson() => {
    'brand': brand,
    'model': model,
    'color': color,
    'carNumber': carNumber,
  };
}


class Segment {
  String? name;

  Segment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {'name': name};
}

class Region {
  String? name;
  String? state;

  Region.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'state': state,
  };
}