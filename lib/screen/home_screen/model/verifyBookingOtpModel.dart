class VerifyBookingOtpModel {
  var status;
  var message;
  Data? data;

  VerifyBookingOtpModel({this.status, this.message, this.data});

  VerifyBookingOtpModel.fromJson(Map<String, dynamic> json) {
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
  var bookingId;
  var bookingNumber;
  var otpType;
  var verified;
  var tripStatus;
  User? user;
  Pickup? pickup;
  Pickup? dropoff;
  var bookingType;

  Data(
      {this.bookingId,
        this.bookingNumber,
        this.otpType,
        this.verified,
        this.tripStatus,
        this.user,
        this.pickup,
        this.dropoff,
        this.bookingType});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    otpType = json['otpType'];
    verified = json['verified'];
    tripStatus = json['tripStatus'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    dropoff =
    json['dropoff'] != null ? new Pickup.fromJson(json['dropoff']) : null;
    bookingType = json['bookingType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['bookingNumber'] = this.bookingNumber;
    data['otpType'] = this.otpType;
    data['verified'] = this.verified;
    data['tripStatus'] = this.tripStatus;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoff != null) {
      data['dropoff'] = this.dropoff!.toJson();
    }
    data['bookingType'] = this.bookingType;
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

class Pickup {
  var lat;
  var lng;
  var address;

  Pickup({this.lat, this.lng, this.address});

  Pickup.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    return data;
  }
}
