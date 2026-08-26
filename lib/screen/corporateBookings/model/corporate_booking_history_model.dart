// corporate_booking_history_model.dart

class CorporateBookingHistoryResponse {
  final bool status;
  final int totalResult;
  final int totalPage;
  final int currentPage;
  final List<CorporateBooking> data;

  CorporateBookingHistoryResponse({
    required this.status,
    required this.totalResult,
    required this.totalPage,
    required this.currentPage,
    required this.data,
  });

  factory CorporateBookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CorporateBookingHistoryResponse(
      status: json['status'] ?? false,
      totalResult: json['totalResult'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CorporateBooking.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'totalResult': totalResult,
    'totalPage': totalPage,
    'currentPage': currentPage,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class CorporateBooking {
  final GuestDetail? guestDetail;
  final LocationPoint? pickup;
  final LocationPoint? dropoff;
  final ActualTripData? actual;
  final DriverResponse? driverResponse;
  final DriverCurrentLocation? driverCurrentLocation;
  final String? id;
  final String? agreement;
  final String? agreementCode;
  final String? bookingNumber;
  final String? corporateBookingNumber;
  final int? legNumber;
  final int? vehicleSlot;
  final Corporate? corporate;
  final String? booker;
  final String? vehicleReleaseDate;
  final int? numberofPassangers;
  final String? tripType;
  final String? scheduledAt;
  final String? corporatePackage;
  final String? assignmentStatus;
  final String? tripStatus;
  final String? overallStatus;
  final String? billingStatus;
  final String? corporateInvoiceId;
  final String? billedAt;
  final String? tripStartOtp;
  final String? tripEndOtp;
  final bool? tripStartOtpVerify;
  final bool? tripEndOtpVerify;
  final String? bookingRemark;
  final String? travelPolicyApplied;
  final String? approvalCorporateBooking;
  final String? corporateApprovedBy;
  final bool? isOutOfPolicy;
  final List<String>? policyViolationReasons;
  final String? user;
  final Checkpoint? garageStart;
  final Checkpoint? pickupCheckpoint;
  final Checkpoint? dropCheckpoint;
  final Checkpoint? garageEnd;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? assignedAt;
  final String? assignedBy;
  final String? driver;
  final Vehicle? vehicle;
  final String? pickupAt;
  final String? tripStartAt;
  final String? dropoffAt;
  final String? tripEndAt;
  final String? createdAtIST;
  final String? scheduledAtIST;

  CorporateBooking({
    this.guestDetail,
    this.pickup,
    this.dropoff,
    this.actual,
    this.driverResponse,
    this.driverCurrentLocation,
    this.id,
    this.agreement,
    this.agreementCode,
    this.bookingNumber,
    this.corporateBookingNumber,
    this.legNumber,
    this.vehicleSlot,
    this.corporate,
    this.booker,
    this.vehicleReleaseDate,
    this.numberofPassangers,
    this.tripType,
    this.scheduledAt,
    this.corporatePackage,
    this.assignmentStatus,
    this.tripStatus,
    this.overallStatus,
    this.billingStatus,
    this.corporateInvoiceId,
    this.billedAt,
    this.tripStartOtp,
    this.tripEndOtp,
    this.tripStartOtpVerify,
    this.tripEndOtpVerify,
    this.bookingRemark,
    this.travelPolicyApplied,
    this.approvalCorporateBooking,
    this.corporateApprovedBy,
    this.isOutOfPolicy,
    this.policyViolationReasons,
    this.user,
    this.garageStart,
    this.pickupCheckpoint,
    this.dropCheckpoint,
    this.garageEnd,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.assignedAt,
    this.assignedBy,
    this.driver,
    this.vehicle,
    this.pickupAt,
    this.tripStartAt,
    this.dropoffAt,
    this.tripEndAt,
    this.createdAtIST,
    this.scheduledAtIST,
  });

  factory CorporateBooking.fromJson(Map<String, dynamic> json) {
    return CorporateBooking(
      guestDetail: json['guestDetail'] != null
          ? GuestDetail.fromJson(json['guestDetail'])
          : null,
      pickup: json['pickup'] != null ? LocationPoint.fromJson(json['pickup']) : null,
      dropoff: json['dropoff'] != null ? LocationPoint.fromJson(json['dropoff']) : null,
      actual: json['actual'] != null ? ActualTripData.fromJson(json['actual']) : null,
      driverResponse: json['driverResponse'] != null
          ? DriverResponse.fromJson(json['driverResponse'])
          : null,
      driverCurrentLocation: json['driverCurrentLocation'] != null
          ? DriverCurrentLocation.fromJson(json['driverCurrentLocation'])
          : null,
      id: json['_id'] ?? json['id'],
      agreement: json['agreement']?.toString(),
      agreementCode: json['agreementCode']?.toString(),
      bookingNumber: json['bookingNumber']?.toString(),
      corporateBookingNumber: json['corporateBookingNumber']?.toString(),
      legNumber: json['legNumber'],
      vehicleSlot: json['vehicleSlot'],
      corporate: json['corporate'] != null ? Corporate.fromJson(json['corporate']) : null,
      booker: json['booker']?.toString(),
      vehicleReleaseDate: json['vehicleReleaseDate']?.toString(),
      numberofPassangers: json['numberofPassangers'],
      tripType: json['tripType']?.toString(),
      scheduledAt: json['scheduledAt']?.toString(),
      corporatePackage: json['corporatePackage']?.toString(),
      assignmentStatus: json['assignmentStatus']?.toString(),
      tripStatus: json['tripStatus']?.toString(),
      overallStatus: json['overallStatus']?.toString(),
      billingStatus: json['billingStatus']?.toString(),
      corporateInvoiceId: json['corporateInvoiceId']?.toString(),
      billedAt: json['billedAt']?.toString(),
      tripStartOtp: json['tripStartOtp']?.toString(),
      tripEndOtp: json['tripEndOtp']?.toString(),
      tripStartOtpVerify: json['tripStartOtpVerify'],
      tripEndOtpVerify: json['tripEndOtpVerify'],
      bookingRemark: json['bookingRemark']?.toString(),
      travelPolicyApplied: json['travelPolicyApplied']?.toString(),
      approvalCorporateBooking: json['approvalCorporateBooking']?.toString(),
      corporateApprovedBy: json['corporateApprovedBy']?.toString(),
      isOutOfPolicy: json['isOutOfPolicy'],
      policyViolationReasons: (json['policyViolationReasons'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      user: json['user']?.toString(),
      garageStart: json['garageStart'] != null
          ? Checkpoint.fromJson(json['garageStart'])
          : null,
      pickupCheckpoint: json['pickupCheckpoint'] != null
          ? Checkpoint.fromJson(json['pickupCheckpoint'])
          : null,
      dropCheckpoint: json['dropCheckpoint'] != null
          ? Checkpoint.fromJson(json['dropCheckpoint'])
          : null,
      garageEnd: json['garageEnd'] != null
          ? Checkpoint.fromJson(json['garageEnd'])
          : null,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      v: json['__v'],
      assignedAt: json['assignedAt']?.toString(),
      assignedBy: json['assignedBy']?.toString(),
      driver: json['driver']?.toString(),
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      pickupAt: json['pickupAt']?.toString(),
      tripStartAt: json['tripStartAt']?.toString(),
      dropoffAt: json['dropoffAt']?.toString(),
      tripEndAt: json['tripEndAt']?.toString(),
      createdAtIST: json['createdAtIST']?.toString(),
      scheduledAtIST: json['scheduledAtIST']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'guestDetail': guestDetail?.toJson(),
    'pickup': pickup?.toJson(),
    'dropoff': dropoff?.toJson(),
    'actual': actual?.toJson(),
    'driverResponse': driverResponse?.toJson(),
    'driverCurrentLocation': driverCurrentLocation?.toJson(),
    '_id': id,
    'agreement': agreement,
    'agreementCode': agreementCode,
    'bookingNumber': bookingNumber,
    'corporateBookingNumber': corporateBookingNumber,
    'legNumber': legNumber,
    'vehicleSlot': vehicleSlot,
    'corporate': corporate?.toJson(),
    'booker': booker,
    'vehicleReleaseDate': vehicleReleaseDate,
    'numberofPassangers': numberofPassangers,
    'tripType': tripType,
    'scheduledAt': scheduledAt,
    'corporatePackage': corporatePackage,
    'assignmentStatus': assignmentStatus,
    'tripStatus': tripStatus,
    'overallStatus': overallStatus,
    'billingStatus': billingStatus,
    'corporateInvoiceId': corporateInvoiceId,
    'billedAt': billedAt,
    'tripStartOtp': tripStartOtp,
    'tripEndOtp': tripEndOtp,
    'tripStartOtpVerify': tripStartOtpVerify,
    'tripEndOtpVerify': tripEndOtpVerify,
    'bookingRemark': bookingRemark,
    'travelPolicyApplied': travelPolicyApplied,
    'approvalCorporateBooking': approvalCorporateBooking,
    'corporateApprovedBy': corporateApprovedBy,
    'isOutOfPolicy': isOutOfPolicy,
    'policyViolationReasons': policyViolationReasons,
    'user': user,
    'garageStart': garageStart?.toJson(),
    'pickupCheckpoint': pickupCheckpoint?.toJson(),
    'dropCheckpoint': dropCheckpoint?.toJson(),
    'garageEnd': garageEnd?.toJson(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
    'assignedAt': assignedAt,
    'assignedBy': assignedBy,
    'driver': driver,
    'vehicle': vehicle?.toJson(),
    'pickupAt': pickupAt,
    'tripStartAt': tripStartAt,
    'dropoffAt': dropoffAt,
    'tripEndAt': tripEndAt,
    'createdAtIST': createdAtIST,
    'scheduledAtIST': scheduledAtIST,
    'id': id,
  };
}

class GuestDetail {
  final String? name;
  final String? email;
  final dynamic phone; // can be int or String

  GuestDetail({this.name, this.email, this.phone});

  factory GuestDetail.fromJson(Map<String, dynamic> json) {
    return GuestDetail(
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
  };
}

class LocationPoint {
  final double? lat;
  final double? lng;
  final String? address;

  LocationPoint({this.lat, this.lng, this.address});

  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'address': address,
  };
}

class ActualTripData {
  final num? distanceKm;
  final num? durationMins;
  final num? startOdometer;
  final num? endOdometer;
  final String? startedAt;
  final String? endedAt;
  final num? nightFare;
  final num? nightCount;
  final num? parkingCharge;
  final num? tollAmount;
  final String? polyline;
  final num? stateCharge;
  final num? otherCharges;
  final String? waitingMins;

  ActualTripData({
    this.distanceKm,
    this.durationMins,
    this.startOdometer,
    this.endOdometer,
    this.startedAt,
    this.endedAt,
    this.nightFare,
    this.nightCount,
    this.parkingCharge,
    this.tollAmount,
    this.polyline,
    this.stateCharge,
    this.otherCharges,
    this.waitingMins,
  });

  factory ActualTripData.fromJson(Map<String, dynamic> json) {
    return ActualTripData(
      distanceKm: json['distanceKm'],
      durationMins: json['durationMins'],
      startOdometer: json['startOdometer'],
      endOdometer: json['endOdometer'],
      startedAt: json['startedAt']?.toString(),
      endedAt: json['endedAt']?.toString(),
      nightFare: json['nightFare'],
      nightCount: json['nightCount'],
      parkingCharge: json['parkingCharge'],
      tollAmount: json['tollAmount'],
      polyline: json['polyline']?.toString(),
      stateCharge: json['stateCharge'],
      otherCharges: json['otherCharges'],
      waitingMins: json['waitingMins']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'distanceKm': distanceKm,
    'durationMins': durationMins,
    'startOdometer': startOdometer,
    'endOdometer': endOdometer,
    'startedAt': startedAt,
    'endedAt': endedAt,
    'nightFare': nightFare,
    'nightCount': nightCount,
    'parkingCharge': parkingCharge,
    'tollAmount': tollAmount,
    'polyline': polyline,
    'stateCharge': stateCharge,
    'otherCharges': otherCharges,
    'waitingMins': waitingMins,
  };
}

class DriverResponse {
  final String? cancelRequestId;
  final String? status;
  final String? respondedAt;

  DriverResponse({this.cancelRequestId, this.status, this.respondedAt});

  factory DriverResponse.fromJson(Map<String, dynamic> json) {
    return DriverResponse(
      cancelRequestId: json['cancelRequestId']?.toString(),
      status: json['status']?.toString(),
      respondedAt: json['respondedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'cancelRequestId': cancelRequestId,
    'status': status,
    'respondedAt': respondedAt,
  };
}

class DriverCurrentLocation {
  final double? lat;
  final double? lng;
  final String? updatedAt;

  DriverCurrentLocation({this.lat, this.lng, this.updatedAt});

  factory DriverCurrentLocation.fromJson(Map<String, dynamic> json) {
    return DriverCurrentLocation(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'updatedAt': updatedAt,
  };
}

class Corporate {
  final String? id;
  final String? companyName;
  final String? createdAtIST;

  Corporate({this.id, this.companyName, this.createdAtIST});

  factory Corporate.fromJson(Map<String, dynamic> json) {
    return Corporate(
      id: json['_id'] ?? json['id'],
      companyName: json['companyName']?.toString(),
      createdAtIST: json['createdAtIST']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyName': companyName,
    'createdAtIST': createdAtIST,
    'id': id,
  };
}

class Checkpoint {
  final num? odometer;
  final String? odometerImage;
  final double? lat;
  final double? lng;
  final String? address;
  final String? capturedAt;

  Checkpoint({
    this.odometer,
    this.odometerImage,
    this.lat,
    this.lng,
    this.address,
    this.capturedAt,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      odometer: json['odometer'],
      odometerImage: json['odometerImage']?.toString(),
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address']?.toString(),
      capturedAt: json['capturedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'odometer': odometer,
    'odometerImage': odometerImage,
    'lat': lat,
    'lng': lng,
    'address': address,
    'capturedAt': capturedAt,
  };
}

class Vehicle {
  final String? id;
  final String? brand;
  final String? carNumber;

  Vehicle({this.id, this.brand, this.carNumber});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id']?.toString(),
      brand: json['brand']?.toString(),
      carNumber: json['carNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'brand': brand,
    'carNumber': carNumber,
  };
}