class PunchOutModel {
  bool? success;
  String? message;
  Data? data;

  PunchOutModel({this.success, this.message, this.data});

  PunchOutModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? driverId;
  String? name;
  String? status;
  String? punchInTime;
  Location? location;
  Vehicle? vehicle;
  Shift? shift;

  Data(
      {this.driverId,
        this.name,
        this.status,
        this.punchInTime,
        this.location,
        this.vehicle,
        this.shift});

  Data.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    name = json['name'];
    status = json['status'];
    punchInTime = json['punchInTime'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverId'] = this.driverId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['punchInTime'] = this.punchInTime;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;
  String? address;

  Location({this.latitude, this.longitude, this.address});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    return data;
  }
}

class Vehicle {
  String? vehicleId;
  String? vehicleType;
  String? vehicleNumber;

  Vehicle({this.vehicleId, this.vehicleType, this.vehicleNumber});

  Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicleId'];
    vehicleType = json['vehicleType'];
    vehicleNumber = json['vehicleNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleId'] = this.vehicleId;
    data['vehicleType'] = this.vehicleType;
    data['vehicleNumber'] = this.vehicleNumber;
    return data;
  }
}

class Shift {
  String? shiftId;
  String? startTime;
  String? endTime;

  Shift({this.shiftId, this.startTime, this.endTime});

  Shift.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftId'] = this.shiftId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
