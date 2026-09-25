// import 'corporate_booking_list_model.dart';
//
// class CorporateBookingDetailModel {
//   final bool status;
//   final CorporateBookingDetail data;
//
//   CorporateBookingDetailModel({
//     required this.status,
//     required this.data,
//   });
//
//   factory CorporateBookingDetailModel.fromJson(Map<String, dynamic> json) {
//     return CorporateBookingDetailModel(
//       status: json['status'] ?? false,
//       data: CorporateBookingDetail.fromJson(json['data'] ?? {}),
//     );
//   }
// }
//
// class CorporateBookingDetail {
//   final GuestDetail guestDetail;
//   final Location pickup;
//   final Location dropoff;
//   final Actual actual;
//   final DriverResponse driverResponse;
//   final String id;
//   final Agreement agreement;
//   final String agreementCode;
//   final String bookingNumber;
//   final String corporateBookingNumber;
//   final int legNumber;
//   final int vehicleSlot;
//   final Corporate corporate;
//   final Booker booker;
//   final String vehicleReleaseDate;
//   final int numberofPassangers;
//   final String tripType;
//   final String scheduledAt;
//   final String corporatePackage;
//   final String assignmentStatus;
//   final String tripStatus;
//   final String overallStatus;
//   final String billingStatus;
//   final String? corporateInvoiceId;
//   final String? billedAt;
//   final String tripStartOtp;
//   final String tripEndOtp;
//   final bool tripStartOtpVerify;
//   final bool tripEndOtpVerify;
//   final String bookingRemark;
//   final dynamic travelPolicyApplied;
//   final String approvalCorporateBooking;
//   final String corporateApprovedBy;
//   final bool isOutOfPolicy;
//   final List<dynamic> policyViolationReasons;
//   final String user;
//   final Checkpoint garageStart;
//   final Checkpoint pickupCheckpoint;
//   final Checkpoint dropCheckpoint;
//   final Checkpoint garageEnd;
//   final String createdAt;
//   final String updatedAt;
//   final int v;
//   final String assignedAt;
//   final String assignedBy;
//   final String driver;
//   final Vehicle vehicle;
//   final String createdAtIST;
//   final String scheduledAtIST;
//
//   CorporateBookingDetail({
//     required this.guestDetail,
//     required this.pickup,
//     required this.dropoff,
//     required this.actual,
//     required this.driverResponse,
//     required this.id,
//     required this.agreement,
//     required this.agreementCode,
//     required this.bookingNumber,
//     required this.corporateBookingNumber,
//     required this.legNumber,
//     required this.vehicleSlot,
//     required this.corporate,
//     required this.booker,
//     required this.vehicleReleaseDate,
//     required this.numberofPassangers,
//     required this.tripType,
//     required this.scheduledAt,
//     required this.corporatePackage,
//     required this.assignmentStatus,
//     required this.tripStatus,
//     required this.overallStatus,
//     required this.billingStatus,
//     this.corporateInvoiceId,
//     this.billedAt,
//     required this.tripStartOtp,
//     required this.tripEndOtp,
//     required this.tripStartOtpVerify,
//     required this.tripEndOtpVerify,
//     required this.bookingRemark,
//     this.travelPolicyApplied,
//     required this.approvalCorporateBooking,
//     required this.corporateApprovedBy,
//     required this.isOutOfPolicy,
//     required this.policyViolationReasons,
//     required this.user,
//     required this.garageStart,
//     required this.pickupCheckpoint,
//     required this.dropCheckpoint,
//     required this.garageEnd,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.assignedAt,
//     required this.assignedBy,
//     required this.driver,
//     required this.vehicle,
//     required this.createdAtIST,
//     required this.scheduledAtIST,
//   });
//
//   factory CorporateBookingDetail.fromJson(Map<String, dynamic> json) {
//     return CorporateBookingDetail(
//       guestDetail: GuestDetail.fromJson(json['guestDetail'] ?? {}),
//       pickup: Location.fromJson(json['pickup'] ?? {}),
//       dropoff: Location.fromJson(json['dropoff'] ?? {}),
//       actual: Actual.fromJson(json['actual'] ?? {}),
//       driverResponse: DriverResponse.fromJson(json['driverResponse'] ?? {}),
//       id: json['_id'] ?? json['id'] ?? '',
//       agreement: Agreement.fromJson(json['agreement'] ?? {}),
//       agreementCode: json['agreementCode'] ?? '',
//       bookingNumber: json['bookingNumber'] ?? '',
//       corporateBookingNumber: json['corporateBookingNumber'] ?? '',
//       legNumber: json['legNumber'] ?? 0,
//       vehicleSlot: json['vehicleSlot'] ?? 0,
//       corporate: Corporate.fromJson(json['corporate'] ?? {}),
//       booker: Booker.fromJson(json['booker'] ?? {}),
//       vehicleReleaseDate: json['vehicleReleaseDate'] ?? '',
//       numberofPassangers: json['numberofPassangers'] ?? 0,
//       tripType: json['tripType'] ?? '',
//       scheduledAt: json['scheduledAt'] ?? '',
//       corporatePackage: json['corporatePackage'] ?? '',
//       assignmentStatus: json['assignmentStatus'] ?? '',
//       tripStatus: json['tripStatus'] ?? '',
//       overallStatus: json['overallStatus'] ?? '',
//       billingStatus: json['billingStatus'] ?? '',
//       corporateInvoiceId: json['corporateInvoiceId'],
//       billedAt: json['billedAt'],
//       tripStartOtp: json['tripStartOtp'] ?? '',
//       tripEndOtp: json['tripEndOtp'] ?? '',
//       tripStartOtpVerify: json['tripStartOtpVerify'] ?? false,
//       tripEndOtpVerify: json['tripEndOtpVerify'] ?? false,
//       bookingRemark: json['bookingRemark'] ?? '',
//       travelPolicyApplied: json['travelPolicyApplied'],
//       approvalCorporateBooking: json['approvalCorporateBooking'] ?? '',
//       corporateApprovedBy: json['corporateApprovedBy'] ?? '',
//       isOutOfPolicy: json['isOutOfPolicy'] ?? false,
//       policyViolationReasons: json['policyViolationReasons'] ?? [],
//       user: json['user'] ?? '',
//       garageStart: Checkpoint.fromJson(json['garageStart'] ?? {}),
//       pickupCheckpoint: Checkpoint.fromJson(json['pickupCheckpoint'] ?? {}),
//       dropCheckpoint: Checkpoint.fromJson(json['dropCheckpoint'] ?? {}),
//       garageEnd: Checkpoint.fromJson(json['garageEnd'] ?? {}),
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       v: json['__v'] ?? 0,
//       assignedAt: json['assignedAt'] ?? '',
//       assignedBy: json['assignedBy'] ?? '',
//       driver: json['driver'] ?? '',
//       vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
//       createdAtIST: json['createdAtIST'] ?? '',
//       scheduledAtIST: json['scheduledAtIST'] ?? '',
//     );
//   }
// }
//
// class Agreement {
//   final PackageSnapshot packageSnapshot;
//   final String id;
//   final String agreementCode;
//   final String status;
//
//   Agreement({
//     required this.packageSnapshot,
//     required this.id,
//     required this.agreementCode,
//     required this.status,
//   });
//
//   factory Agreement.fromJson(Map<String, dynamic> json) {
//     return Agreement(
//       packageSnapshot: PackageSnapshot.fromJson(json['packageSnapshot'] ?? {}),
//       id: json['_id'] ?? json['id'] ?? '',
//       agreementCode: json['agreementCode'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }
//
// class PackageSnapshot {
//   final String packageName;
//   final String segment;
//   final List<String> vechicleModel;
//   final String tripType;
//   final num nightFare;
//   final num hours;
//   final num includedKms;
//   final num baseFare;
//   final num extraPerKm;
//   final num extraPerMin;
//   final int nightCount;
//   final num fixAmount;
//   final num gstPercent;
//   final num driverCharge;
//   final num parkingCharge;
//   final num tollCharge;
//   final num stateCharge;
//   final num otherCharges;
//   final int numberOfVechicle;
//
//   PackageSnapshot({
//     required this.packageName,
//     required this.segment,
//     required this.vechicleModel,
//     required this.tripType,
//     required this.nightFare,
//     required this.hours,
//     required this.includedKms,
//     required this.baseFare,
//     required this.extraPerKm,
//     required this.extraPerMin,
//     required this.nightCount,
//     required this.fixAmount,
//     required this.gstPercent,
//     required this.driverCharge,
//     required this.parkingCharge,
//     required this.tollCharge,
//     required this.stateCharge,
//     required this.otherCharges,
//     required this.numberOfVechicle,
//   });
//
//   factory PackageSnapshot.fromJson(Map<String, dynamic> json) {
//     return PackageSnapshot(
//       packageName: json['packageName'] ?? '',
//       segment: json['segment'] ?? '',
//       vechicleModel: (json['vechicleModel'] as List? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//       tripType: json['tripType'] ?? '',
//       nightFare: json['nightFare'] ?? 0,
//       hours: json['hours'] ?? 0,
//       includedKms: json['includedKms'] ?? 0,
//       baseFare: json['baseFare'] ?? 0,
//       extraPerKm: json['extraPerKm'] ?? 0,
//       extraPerMin: json['extraPerMin'] ?? 0,
//       nightCount: json['nightCount'] ?? 0,
//       fixAmount: json['fixAmount'] ?? 0,
//       gstPercent: json['gstPercent'] ?? 0,
//       driverCharge: json['driverCharge'] ?? 0,
//       parkingCharge: json['parkingCharge'] ?? 0,
//       tollCharge: json['tollCharge'] ?? 0,
//       stateCharge: json['stateCharge'] ?? 0,
//       otherCharges: json['otherCharges'] ?? 0,
//       numberOfVechicle: json['numberOfVechicle'] ?? 0,
//     );
//   }
// }
//



import 'corporate_booking_list_model.dart';

class CorporateBookingDetailModel {
  final bool status;
  final CorporateBookingDetail data;

  CorporateBookingDetailModel({
    required this.status,
    required this.data,
  });

  factory CorporateBookingDetailModel.fromJson(Map<String, dynamic> json) {
    return CorporateBookingDetailModel(
      status: json['status'] ?? false,
      data: CorporateBookingDetail.fromJson(json['data'] ?? {}),
    );
  }
}

class CorporateBookingDetail {
  final GuestDetail guestDetail;
  final Location pickup;
  final Location dropoff;
  final Actual actual;
  final DriverResponse driverResponse;
  final String id;
  final Agreement agreement;
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

  CorporateBookingDetail({
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

  factory CorporateBookingDetail.fromJson(Map<String, dynamic> json) {
    // Safely handle guestDetail (can be List or Map)
    GuestDetail guest;
    final guestRaw = json['guestDetail'];
    if (guestRaw is List && guestRaw.isNotEmpty) {
      guest = GuestDetail.fromJson(Map<String, dynamic>.from(guestRaw.first));
    } else if (guestRaw is Map) {
      guest = GuestDetail.fromJson(Map<String, dynamic>.from(guestRaw));
    } else {
      guest = GuestDetail(name: '', email: '', phone: '');
    }

    return CorporateBookingDetail(
      guestDetail: guest, // ← yahan guest use karo (pehle wali line mat use karna)
      pickup: Location.fromJson(json['pickup'] ?? {}),
      dropoff: Location.fromJson(json['dropoff'] ?? {}),
      actual: Actual.fromJson(json['actual'] ?? {}),
      driverResponse: DriverResponse.fromJson(json['driverResponse'] ?? {}),
      id: json['_id'] ?? json['id'] ?? '',
      agreement: Agreement.fromJson(json['agreement'] ?? {}),
      agreementCode: json['agreementCode'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      corporateBookingNumber: json['corporateBookingNumber'] ?? '',
      legNumber: json['legNumber'] ?? 0,
      vehicleSlot: json['vehicleSlot'] ?? 0,
      corporate: Corporate.fromJson(json['corporate'] ?? {}),
      booker: json['booker'] != null
          ? Booker.fromJson(json['booker'])
          : Booker(id: '', name: '', email: '', mobile: ''),
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
      corporateApprovedBy: json['corporateApprovedBy']?.toString() ?? '',
      isOutOfPolicy: json['isOutOfPolicy'] ?? false,
      policyViolationReasons: json['policyViolationReasons'] ?? [],
      user: json['user']?.toString() ?? '',
      garageStart: Checkpoint.fromJson(json['garageStart'] ?? {}),
      pickupCheckpoint: Checkpoint.fromJson(json['pickupCheckpoint'] ?? {}),
      dropCheckpoint: Checkpoint.fromJson(json['dropCheckpoint'] ?? {}),
      garageEnd: Checkpoint.fromJson(json['garageEnd'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      assignedAt: json['assignedAt'] ?? '',
      assignedBy: json['assignedBy']?.toString() ?? '',
      driver: json['driver']?.toString() ?? '',
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      createdAtIST: json['createdAtIST'] ?? '',
      scheduledAtIST: json['scheduledAtIST'] ?? '',
    );
  }
}

class Agreement {
  final PackageSnapshot packageSnapshot;
  final String id;
  final String agreementCode;
  final String status;

  Agreement({
    required this.packageSnapshot,
    required this.id,
    required this.agreementCode,
    required this.status,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      packageSnapshot: PackageSnapshot.fromJson(json['packageSnapshot'] ?? {}),
      id: json['_id'] ?? json['id'] ?? '',
      agreementCode: json['agreementCode'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class PackageSnapshot {
  final String packageName;
  final String segment;
  final List<String> vechicleModel;
  final String tripType;
  final num nightFare;
  final num hours;
  final num includedKms;
  final num baseFare;
  final num extraPerKm;
  final num extraPerMin;
  final int nightCount;
  final num fixAmount;
  final num gstPercent;
  final num driverCharge;
  final num parkingCharge;
  final num tollCharge;
  final num stateCharge;
  final num otherCharges;
  final int numberOfVechicle;

  PackageSnapshot({
    required this.packageName,
    required this.segment,
    required this.vechicleModel,
    required this.tripType,
    required this.nightFare,
    required this.hours,
    required this.includedKms,
    required this.baseFare,
    required this.extraPerKm,
    required this.extraPerMin,
    required this.nightCount,
    required this.fixAmount,
    required this.gstPercent,
    required this.driverCharge,
    required this.parkingCharge,
    required this.tollCharge,
    required this.stateCharge,
    required this.otherCharges,
    required this.numberOfVechicle,
  });

  factory PackageSnapshot.fromJson(Map<String, dynamic> json) {
    return PackageSnapshot(
      packageName: json['packageName'] ?? '',
      segment: json['segment'] ?? '',
      vechicleModel: (json['vechicleModel'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      tripType: json['tripType'] ?? '',
      nightFare: json['nightFare'] ?? 0,
      hours: json['hours'] ?? 0,
      includedKms: json['includedKms'] ?? 0,
      baseFare: json['baseFare'] ?? 0,
      extraPerKm: json['extraPerKm'] ?? 0,
      extraPerMin: json['extraPerMin'] ?? 0,
      nightCount: json['nightCount'] ?? 0,
      fixAmount: json['fixAmount'] ?? 0,
      gstPercent: json['gstPercent'] ?? 0,
      driverCharge: json['driverCharge'] ?? 0,
      parkingCharge: json['parkingCharge'] ?? 0,
      tollCharge: json['tollCharge'] ?? 0,
      stateCharge: json['stateCharge'] ?? 0,
      otherCharges: json['otherCharges'] ?? 0,
      numberOfVechicle: json['numberOfVechicle'] ?? 0,
    );
  }
}