

class TripCompleteModel {
  bool? status;
  String? message;
  Data? data;

  TripCompleteModel({this.status, this.message, this.data});

  TripCompleteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? bookingId;
  String? bookingNumber;
  String? paymentStatus;
  String? assignmentStatus;
  String? tripStatus;
  String? overallStatus;
  String? tripStartAt;
  String? tripEndAt;
  int? actualMins;
  double? estimatedKm;
  double? actualKm;
  int? extraKm;
  String? distanceSource;
  double? estimatedFare;
  double? prepaidAmount;
  double? finalFare;
  int? extraCharge;
  bool? requiresExtraPayment;
  FareBreakup? fareBreakup;

  Data(
      {this.bookingId,
        this.bookingNumber,
        this.paymentStatus,
        this.assignmentStatus,
        this.tripStatus,
        this.overallStatus,
        this.tripStartAt,
        this.tripEndAt,
        this.actualMins,
        this.estimatedKm,
        this.actualKm,
        this.extraKm,
        this.distanceSource,
        this.estimatedFare,
        this.prepaidAmount,
        this.finalFare,
        this.extraCharge,
        this.requiresExtraPayment,
        this.fareBreakup});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    paymentStatus = json['paymentStatus'];
    assignmentStatus = json['assignmentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    tripStartAt = json['tripStartAt'];
    tripEndAt = json['tripEndAt'];
    actualMins = json['actualMins'];
    estimatedKm = json['estimatedKm'];
    actualKm = json['actualKm'];
    extraKm = json['extraKm'];
    distanceSource = json['distanceSource'];
    estimatedFare = json['estimatedFare'];
    prepaidAmount = json['prepaidAmount'];
    finalFare = json['finalFare'];
    extraCharge = json['extraCharge'];
    requiresExtraPayment = json['requiresExtraPayment'];
    fareBreakup = json['fareBreakup'] != null
        ? new FareBreakup.fromJson(json['fareBreakup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['bookingNumber'] = this.bookingNumber;
    data['paymentStatus'] = this.paymentStatus;
    data['assignmentStatus'] = this.assignmentStatus;
    data['tripStatus'] = this.tripStatus;
    data['overallStatus'] = this.overallStatus;
    data['tripStartAt'] = this.tripStartAt;
    data['tripEndAt'] = this.tripEndAt;
    data['actualMins'] = this.actualMins;
    data['estimatedKm'] = this.estimatedKm;
    data['actualKm'] = this.actualKm;
    data['extraKm'] = this.extraKm;
    data['distanceSource'] = this.distanceSource;
    data['estimatedFare'] = this.estimatedFare;
    data['prepaidAmount'] = this.prepaidAmount;
    data['finalFare'] = this.finalFare;
    data['extraCharge'] = this.extraCharge;
    data['requiresExtraPayment'] = this.requiresExtraPayment;
    if (this.fareBreakup != null) {
      data['fareBreakup'] = this.fareBreakup!.toJson();
    }
    return data;
  }
}

class FareBreakup {
  int? baseFare;
  double? distanceCharge;
  int? timeCharge;
  int? surgeCharge;
  double? subtotal;
  double? gstAmount;
  int? tollCharge;
  int? surchargeAmount;
  int? waitingChargeAmount;
  int? waitingMins;
  int? extraKmCharge;
  int? extraTimeCharge;
  int? discountAmount;
  int? walletUsed;
  int? airportFare;
  int? nightFare;
  double? totalFare;

  FareBreakup(
      {this.baseFare,
        this.distanceCharge,
        this.timeCharge,
        this.surgeCharge,
        this.subtotal,
        this.gstAmount,
        this.tollCharge,
        this.surchargeAmount,
        this.waitingChargeAmount,
        this.waitingMins,
        this.extraKmCharge,
        this.extraTimeCharge,
        this.discountAmount,
        this.walletUsed,
        this.airportFare,
        this.nightFare,
        this.totalFare});

  FareBreakup.fromJson(Map<String, dynamic> json) {
    baseFare = json['baseFare'];
    distanceCharge = json['distanceCharge'];
    timeCharge = json['timeCharge'];
    surgeCharge = json['surgeCharge'];
    subtotal = json['subtotal'];
    gstAmount = json['gstAmount'];
    tollCharge = json['tollCharge'];
    surchargeAmount = json['surchargeAmount'];
    waitingChargeAmount = json['waitingChargeAmount'];
    waitingMins = json['waitingMins'];
    extraKmCharge = json['extraKmCharge'];
    extraTimeCharge = json['extraTimeCharge'];
    discountAmount = json['discountAmount'];
    walletUsed = json['walletUsed'];
    airportFare = json['airportFare'];
    nightFare = json['nightFare'];
    totalFare = json['totalFare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseFare'] = this.baseFare;
    data['distanceCharge'] = this.distanceCharge;
    data['timeCharge'] = this.timeCharge;
    data['surgeCharge'] = this.surgeCharge;
    data['subtotal'] = this.subtotal;
    data['gstAmount'] = this.gstAmount;
    data['tollCharge'] = this.tollCharge;
    data['surchargeAmount'] = this.surchargeAmount;
    data['waitingChargeAmount'] = this.waitingChargeAmount;
    data['waitingMins'] = this.waitingMins;
    data['extraKmCharge'] = this.extraKmCharge;
    data['extraTimeCharge'] = this.extraTimeCharge;
    data['discountAmount'] = this.discountAmount;
    data['walletUsed'] = this.walletUsed;
    data['airportFare'] = this.airportFare;
    data['nightFare'] = this.nightFare;
    data['totalFare'] = this.totalFare;
    return data;
  }
}
