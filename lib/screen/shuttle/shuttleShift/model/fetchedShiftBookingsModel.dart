class FetchedShiftBookingsModel {
  var status;
  var totalResult;
  var totalPage;
  var currentPage;
 var filterDate;
 var message;
  List<Data>? data;

  FetchedShiftBookingsModel(
      {this.status,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.filterDate,
        this.message,
        this.data});

  FetchedShiftBookingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    filterDate = json['filterDate'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    data['currentPage'] = this.currentPage;
    data['filterDate'] = this.filterDate;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
 var sId;
  ShuttlePass? shuttlePass;
  User? user;
 var source;
 var destination;
 var bookingDate;
  var pricePerRide;
  var totalRides;
  var remainingRides;
 var expiryDate;
  var totalAmount;
 var paymentStatus;
 var orderId;
 var createdAt;
 var tripStatus;
  Null? checkIn;
  Null? scannedAtStop;
  Null? travelDirection;
  var scanCount;

  Data(
      {this.sId,
        this.shuttlePass,
        this.user,
        this.source,
        this.destination,
        this.bookingDate,
        this.pricePerRide,
        this.totalRides,
        this.remainingRides,
        this.expiryDate,
        this.totalAmount,
        this.paymentStatus,
        this.orderId,
        this.createdAt,
        this.tripStatus,
        this.checkIn,
        this.scannedAtStop,
        this.travelDirection,
        this.scanCount});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shuttlePass = json['shuttlePass'] != null
        ? new ShuttlePass.fromJson(json['shuttlePass'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    source = json['source'];
    destination = json['destination'];
    bookingDate = json['bookingDate'];
    pricePerRide = json['pricePerRide'];
    totalRides = json['totalRides'];
    remainingRides = json['remainingRides'];
    expiryDate = json['expiryDate'];
    totalAmount = json['totalAmount'];
    paymentStatus = json['paymentStatus'];
    orderId = json['orderId'];
    createdAt = json['createdAt'];
    tripStatus = json['tripStatus'];
    checkIn = json['checkIn'];
    scannedAtStop = json['scannedAtStop'];
    travelDirection = json['travelDirection'];
    scanCount = json['scanCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.shuttlePass != null) {
      data['shuttlePass'] = this.shuttlePass!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['bookingDate'] = this.bookingDate;
    data['pricePerRide'] = this.pricePerRide;
    data['totalRides'] = this.totalRides;
    data['remainingRides'] = this.remainingRides;
    data['expiryDate'] = this.expiryDate;
    data['totalAmount'] = this.totalAmount;
    data['paymentStatus'] = this.paymentStatus;
    data['orderId'] = this.orderId;
    data['createdAt'] = this.createdAt;
    data['tripStatus'] = this.tripStatus;
    data['checkIn'] = this.checkIn;
    data['scannedAtStop'] = this.scannedAtStop;
    data['travelDirection'] = this.travelDirection;
    data['scanCount'] = this.scanCount;
    return data;
  }
}

class ShuttlePass {
 var sId;
 var name;
  var rideCount;
  var validityDays;

  ShuttlePass({this.sId, this.name, this.rideCount, this.validityDays});

  ShuttlePass.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    rideCount = json['rideCount'];
    validityDays = json['validityDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['rideCount'] = this.rideCount;
    data['validityDays'] = this.validityDays;
    return data;
  }
}

class User {
 var sId;
 var name;
 var profilePic;

  User({this.sId, this.name, this.profilePic});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    return data;
  }
}
