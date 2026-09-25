class CorporateBookingListModel {
  final bool status;
  final int totalResult;
  final int totalPage;
  final int currentPage;
  final List<CorporateBooking> data;

  CorporateBookingListModel({
    required this.status,
    required this.totalResult,
    required this.totalPage,
    required this.currentPage,
    required this.data,
  });

  factory CorporateBookingListModel.fromJson(Map<String, dynamic> json) {
    return CorporateBookingListModel(
      status: json['status'] ?? false,
      totalResult: json['totalResult'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      data: (json['data'] as List? ?? [])
          .map((e) => CorporateBooking.fromJson(e))
          .toList(),
    );
  }
}

class CorporateBooking {
  // final GuestDetail guestDetail;
  final List<GuestDetail> guestDetail;
  final Location pickup;
  final Location dropoff;
  final Actual actual;
  final DriverResponse driverResponse;
  final String id;
  final String agreement;
  final String agreementCode;
  final String bookingNumber;
  final String corporateBookingNumber;
  final int legNumber;
  final int vehicleSlot;
  final Corporate corporate;
  final Booker booker;
  final String vehicleReleaseDate;
  final int numberofPassangers;
  final String tripType;
  final String scheduledAt;
  final String corporatePackage;
  final String assignmentStatus;
  final String tripStatus;
  final String overallStatus;
  final String billingStatus;
  final String? corporateInvoiceId;
  final String? billedAt;
  final String tripStartOtp;
  final String tripEndOtp;
  final bool tripStartOtpVerify;
  final bool tripEndOtpVerify;
  final String bookingRemark;
  final dynamic travelPolicyApplied;
  final String approvalCorporateBooking;
  final String corporateApprovedBy;
  final bool isOutOfPolicy;
  final List<dynamic> policyViolationReasons;
  final String user;
  final Checkpoint garageStart;
  final Checkpoint pickupCheckpoint;
  final Checkpoint dropCheckpoint;
  final Checkpoint garageEnd;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String assignedAt;
  final String assignedBy;
  final String driver;
  final Vehicle vehicle;
  final String createdAtIST;
  final String scheduledAtIST;

  CorporateBooking({
    required this.guestDetail,
    required this.pickup,
    required this.dropoff,
    required this.actual,
    required this.driverResponse,
    required this.id,
    required this.agreement,
    required this.agreementCode,
    required this.bookingNumber,
    required this.corporateBookingNumber,
    required this.legNumber,
    required this.vehicleSlot,
    required this.corporate,
    required this.booker,
    required this.vehicleReleaseDate,
    required this.numberofPassangers,
    required this.tripType,
    required this.scheduledAt,
    required this.corporatePackage,
    required this.assignmentStatus,
    required this.tripStatus,
    required this.overallStatus,
    required this.billingStatus,
    this.corporateInvoiceId,
    this.billedAt,
    required this.tripStartOtp,
    required this.tripEndOtp,
    required this.tripStartOtpVerify,
    required this.tripEndOtpVerify,
    required this.bookingRemark,
    this.travelPolicyApplied,
    required this.approvalCorporateBooking,
    required this.corporateApprovedBy,
    required this.isOutOfPolicy,
    required this.policyViolationReasons,
    required this.user,
    required this.garageStart,
    required this.pickupCheckpoint,
    required this.dropCheckpoint,
    required this.garageEnd,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.assignedAt,
    required this.assignedBy,
    required this.driver,
    required this.vehicle,
    required this.createdAtIST,
    required this.scheduledAtIST,
  });

  factory CorporateBooking.fromJson(Map<String, dynamic> json) {
    return CorporateBooking(
      guestDetail: (json['guestDetail'] as List? ?? [])
          .map((e) => GuestDetail.fromJson(e))
          .toList(),
      // guestDetail: GuestDetail.fromJson(json['guestDetail'] ?? {}),
      pickup: Location.fromJson(json['pickup'] ?? {}),
      dropoff: Location.fromJson(json['dropoff'] ?? {}),
      actual: Actual.fromJson(json['actual'] ?? {}),
      user: json['user']?.toString() ?? '',
      corporateApprovedBy: json['corporateApprovedBy']?.toString() ?? '',
      driver: json['driver']?.toString() ?? '',
      assignedBy: json['assignedBy']?.toString() ?? '',
      driverResponse: DriverResponse.fromJson(json['driverResponse'] ?? {}),
      id: json['_id'] ?? json['id'] ?? '',
      agreement: json['agreement'] is String
          ? json['agreement']
          : (json['agreement']?['_id'] ?? ''),
      agreementCode: json['agreementCode'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      corporateBookingNumber: json['corporateBookingNumber'] ?? '',
      legNumber: json['legNumber'] ?? 0,
      vehicleSlot: json['vehicleSlot'] ?? 0,
      corporate: Corporate.fromJson(json['corporate'] ?? {}),
      booker: json['booker'] != null ? Booker.fromJson(json['booker']) : Booker(id: '', name: '', email: '', mobile: ''),
      // booker: Booker.fromJson(json['booker'] ?? {}),
      vehicleReleaseDate: json['vehicleReleaseDate'] ?? '',
      numberofPassangers: json['numberofPassangers'] ?? 0,
      tripType: json['tripType'] ?? '',
      scheduledAt: json['scheduledAt'] ?? '',
      corporatePackage: json['corporatePackage'] ?? '',
      assignmentStatus: json['assignmentStatus'] ?? '',
      tripStatus: json['tripStatus'] ?? '',
      overallStatus: json['overallStatus'] ?? '',
      billingStatus: json['billingStatus'] ?? '',
      corporateInvoiceId: json['corporateInvoiceId'],
      billedAt: json['billedAt'],
      tripStartOtp: json['tripStartOtp'] ?? '',
      tripEndOtp: json['tripEndOtp'] ?? '',
      tripStartOtpVerify: json['tripStartOtpVerify'] ?? false,
      tripEndOtpVerify: json['tripEndOtpVerify'] ?? false,
      bookingRemark: json['bookingRemark'] ?? '',
      travelPolicyApplied: json['travelPolicyApplied'],
      approvalCorporateBooking: json['approvalCorporateBooking'] ?? '',
      // corporateApprovedBy: json['corporateApprovedBy'] ?? '',
      isOutOfPolicy: json['isOutOfPolicy'] ?? false,
      policyViolationReasons: json['policyViolationReasons'] ?? [],
      // user: json['user'] ?? '',
      garageStart: Checkpoint.fromJson(json['garageStart'] ?? {}),
      pickupCheckpoint: Checkpoint.fromJson(json['pickupCheckpoint'] ?? {}),
      dropCheckpoint: Checkpoint.fromJson(json['dropCheckpoint'] ?? {}),
      garageEnd: Checkpoint.fromJson(json['garageEnd'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      assignedAt: json['assignedAt'] ?? '',
      // assignedBy: json['assignedBy'] ?? '',
      // driver: json['driver'] ?? '',
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      createdAtIST: json['createdAtIST'] ?? '',
      scheduledAtIST: json['scheduledAtIST'] ?? '',
    );
  }
}

class GuestDetail {
  final String name;
  final String email;
  final dynamic phone;

  GuestDetail({required this.name, required this.email, required this.phone});

  factory GuestDetail.fromJson(Map<String, dynamic> json) {
    return GuestDetail(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
    );
  }
}

class Location {
  final double? lat;
  final double? lng;
  final String address;

  Location({this.lat, this.lng, required this.address});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'] ?? '',
    );
  }
}

class Actual {
  final dynamic distanceKm;
  final dynamic durationMins;
  final dynamic startOdometer;
  final dynamic endOdometer;
  final dynamic startedAt;
  final dynamic endedAt;
  final num? nightFare;
  final int nightCount;
  final num? parkingCharge;
  final dynamic tollAmount;
  final dynamic polyline;
  final num? stateCharge;
  final num? otherCharges;
  final dynamic waitingMins;

  Actual({
    this.distanceKm,
    this.durationMins,
    this.startOdometer,
    this.endOdometer,
    this.startedAt,
    this.endedAt,
    this.nightFare,
    required this.nightCount,
    this.parkingCharge,
    this.tollAmount,
    this.polyline,
    this.stateCharge,
    this.otherCharges,
    this.waitingMins,
  });

  factory Actual.fromJson(Map<String, dynamic> json) {
    return Actual(
      distanceKm: json['distanceKm'],
      durationMins: json['durationMins'],
      startOdometer: json['startOdometer'],
      endOdometer: json['endOdometer'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      nightFare: json['nightFare'],
      nightCount: json['nightCount'] ?? 0,
      parkingCharge: json['parkingCharge'],
      tollAmount: json['tollAmount'],
      polyline: json['polyline'],
      stateCharge: json['stateCharge'],
      otherCharges: json['otherCharges'],
      waitingMins: json['waitingMins'],
    );
  }
}

class DriverResponse {
  final String status;
  final String? respondedAt;
  final String? cancelRequestId;

  DriverResponse({
    required this.status,
    this.respondedAt,
    this.cancelRequestId,
  });

  factory DriverResponse.fromJson(Map<String, dynamic> json) {
    return DriverResponse(
      status: json['status'] ?? 'pending',
      respondedAt: json['respondedAt'],
      cancelRequestId: json['cancelRequestId'],
    );
  }
}

class Corporate {
  final String id;
  final String companyName;
  final String companyCode;
  final String createdAtIST;

  Corporate({
    required this.id,
    required this.companyName,
    required this.companyCode,
    required this.createdAtIST,
  });

  factory Corporate.fromJson(Map<String, dynamic> json) {
    return Corporate(
      id: json['_id'] ?? json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      companyCode: json['companyCode'] ?? '',
      createdAtIST: json['createdAtIST'] ?? '',
    );
  }
}

class Booker {
  final String id;
  final String name;
  final String email;
  final String mobile;

  Booker({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory Booker.fromJson(Map<String, dynamic> json) {
    return Booker(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}

class Checkpoint {
  final dynamic odometer;
  final dynamic odometerImage;
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
      odometerImage: json['odometerImage'],
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'],
      capturedAt: json['capturedAt'],
    );
  }
}

class Vehicle {
  final String id;
  final String brand;
  final String model;
  final String carNumber;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.carNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      carNumber: json['carNumber'] ?? '',
    );
  }
}