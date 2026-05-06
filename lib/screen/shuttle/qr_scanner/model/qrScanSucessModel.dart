class QrScanSuccessModel {
  var status;
  var message;
  Data? data;

  QrScanSuccessModel({this.status, this.message, this.data});

  QrScanSuccessModel.fromJson(Map<String, dynamic> json) {
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
  User? user;
  Journey? journey;
  ShiftInfo? shiftInfo;
  RideInfo? rideInfo;
  var passStatus;

  Data(
      {this.user,
        this.journey,
        this.shiftInfo,
        this.rideInfo,
        this.passStatus});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    journey =
    json['journey'] != null ? new Journey.fromJson(json['journey']) : null;
    shiftInfo = json['shiftInfo'] != null
        ? new ShiftInfo.fromJson(json['shiftInfo'])
        : null;
    rideInfo = json['rideInfo'] != null
        ? new RideInfo.fromJson(json['rideInfo'])
        : null;
    passStatus = json['passStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.journey != null) {
      data['journey'] = this.journey!.toJson();
    }
    if (this.shiftInfo != null) {
      data['shiftInfo'] = this.shiftInfo!.toJson();
    }
    if (this.rideInfo != null) {
      data['rideInfo'] = this.rideInfo!.toJson();
    }
    data['passStatus'] = this.passStatus;
    return data;
  }
}

class User {
  var name;

  User({this.name});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Journey {
  var from;
  var to;
  var direction;

  Journey({this.from, this.to, this.direction});

  Journey.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['direction'] = this.direction;
    return data;
  }
}

class ShiftInfo {
  var shiftId;
  var shiftName;

  ShiftInfo({this.shiftId, this.shiftName});

  ShiftInfo.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId'];
    shiftName = json['shiftName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftId'] = this.shiftId;
    data['shiftName'] = this.shiftName;
    return data;
  }
}

class RideInfo {
  int? rideNumber;
  int? remainingRides;
  int? totalRides;

  RideInfo({this.rideNumber, this.remainingRides, this.totalRides});

  RideInfo.fromJson(Map<String, dynamic> json) {
    rideNumber = json['rideNumber'];
    remainingRides = json['remainingRides'];
    totalRides = json['totalRides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rideNumber'] = this.rideNumber;
    data['remainingRides'] = this.remainingRides;
    data['totalRides'] = this.totalRides;
    return data;
  }
}
