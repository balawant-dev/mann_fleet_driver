class StartTripModel {
  bool? status;
  String? message;
  Data? data;

  StartTripModel({this.status, this.message, this.data});

  StartTripModel.fromJson(Map<String, dynamic> json) {
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
  User? user;
  Segment? segment;
  Pickup? pickup;
  Pickup? dropoff;
  String? bookingType;
  double? estimatedKm;
  int? estimatedMins;
  double? estimatedFare;

  Data(
      {this.bookingId,
        this.bookingNumber,
        this.paymentStatus,
        this.assignmentStatus,
        this.tripStatus,
        this.overallStatus,
        this.tripStartAt,
        this.user,
        this.segment,
        this.pickup,
        this.dropoff,
        this.bookingType,
        this.estimatedKm,
        this.estimatedMins,
        this.estimatedFare});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    paymentStatus = json['paymentStatus'];
    assignmentStatus = json['assignmentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    tripStartAt = json['tripStartAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    segment =
    json['segment'] != null ? new Segment.fromJson(json['segment']) : null;
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    dropoff =
    json['dropoff'] != null ? new Pickup.fromJson(json['dropoff']) : null;
    bookingType = json['bookingType'];
    estimatedKm = json['estimatedKm'];
    estimatedMins = json['estimatedMins'];
    estimatedFare = json['estimatedFare'];
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.segment != null) {
      data['segment'] = this.segment!.toJson();
    }
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoff != null) {
      data['dropoff'] = this.dropoff!.toJson();
    }
    data['bookingType'] = this.bookingType;
    data['estimatedKm'] = this.estimatedKm;
    data['estimatedMins'] = this.estimatedMins;
    data['estimatedFare'] = this.estimatedFare;
    return data;
  }
}

class User {
  String? name;

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

class Segment {
  String? name;
  String? image;

  Segment({this.name, this.image});

  Segment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Pickup {
  double? lat;
  double? lng;
  String? address;

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
