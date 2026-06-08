class NewBookingModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  int? currentPage;
  String? message;
  List<NewBookingData>? data;

  NewBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    message = json['message'];

    data =
        json['data'] != null
            ? (json['data'] as List)
                .map((e) => NewBookingData.fromJson(e))
                .toList()
            : [];
  }
}

class NewBookingData {
  Pickup? pickup;
  Pickup? dropoff;
  DriverResponse? driverResponse;
  String? id;
  String? bookingNumber;
  User? user;
  Segment? segment;
  Region? region;
  String? bookingType;
  String? paymentStatus;
  String? assignmentStatus;
  String? tripStatus;
  String? overallStatus;
  double? estimatedFare;
  double? prepaidAmount;
  DateTime? scheduledAt; // ISO string or null
  String? createdAt; // ISO string
  Vehicle? vehicle;
  String? createdAtIST;
  String? scheduledAtIST;
  String? paymentAtIST;
  String? assignedAtIST;
  String? tripStartAtIST;
  String? tripEndAtIST;
  String? cancelledAtIST;
  bool? tripEndOtpVerify;
  bool? tripStartOtpVerify;
  // bool? tripStatus;

  NewBookingData({
    this.pickup,
    this.dropoff,
    this.driverResponse,
    this.id,
    this.bookingNumber,
    this.user,
    this.segment,
    this.region,
    this.bookingType,
    this.paymentStatus,
    this.assignmentStatus,
    this.tripStatus,
    this.overallStatus,
    this.estimatedFare,
    this.prepaidAmount,
    this.scheduledAt,
    this.createdAt,
    this.vehicle,
    this.createdAtIST,
    this.scheduledAtIST,
    this.paymentAtIST,
    this.assignedAtIST,
    this.tripStartAtIST,
    this.tripEndAtIST,
    this.cancelledAtIST,
    this.tripEndOtpVerify,
    this.tripStartOtpVerify,
  });

  NewBookingData.fromJson(Map<String, dynamic> json) {
    pickup = json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null;
    dropoff = json['dropoff'] != null ? Pickup.fromJson(json['dropoff']) : null;
    driverResponse =
        json['driverResponse'] != null
            ? DriverResponse.fromJson(json['driverResponse'])
            : null;
    id = json['_id'] ?? json['id']; // handles both _id and id
    bookingNumber = json['bookingNumber'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    segment =
        json['segment'] != null ? Segment.fromJson(json['segment']) : null;
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    bookingType = json['bookingType'];
    paymentStatus = json['paymentStatus'];
    assignmentStatus = json['assignmentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    estimatedFare = json['estimatedFare']?.toDouble();
    prepaidAmount = json['prepaidAmount']?.toDouble();
    scheduledAt =
        json['scheduledAt'] != null
            ? DateTime.parse(json['scheduledAt'])
            : null;
    createdAt = json['createdAt'];
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    createdAtIST = json['createdAtIST'];
    scheduledAtIST = json['scheduledAtIST'];
    paymentAtIST = json['paymentAtIST'];
    assignedAtIST = json['assignedAtIST'];
    tripStartAtIST = json['tripStartAtIST'];
    tripEndAtIST = json['tripEndAtIST'];
    cancelledAtIST = json['cancelledAtIST'];
    tripEndOtpVerify = json['tripEndOtpVerify'];
    tripStartOtpVerify = json['tripStartOtpVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickup != null) data['pickup'] = pickup!.toJson();
    if (dropoff != null) data['dropoff'] = dropoff!.toJson();
    if (driverResponse != null)
      data['driverResponse'] = driverResponse!.toJson();
    data['_id'] = id;
    data['bookingNumber'] = bookingNumber;
    if (user != null) data['user'] = user!.toJson();
    if (segment != null) data['segment'] = segment!.toJson();
    if (region != null) data['region'] = region!.toJson();
    data['bookingType'] = bookingType;
    data['paymentStatus'] = paymentStatus;
    data['assignmentStatus'] = assignmentStatus;
    data['tripStatus'] = tripStatus;
    data['overallStatus'] = overallStatus;
    data['estimatedFare'] = estimatedFare;
    data['prepaidAmount'] = prepaidAmount;
    data['scheduledAt'] = scheduledAt;
    data['createdAt'] = createdAt;
    if (vehicle != null) data['vehicle'] = vehicle!;
    data['createdAtIST'] = createdAtIST;
    data['scheduledAtIST'] = scheduledAtIST;
    data['paymentAtIST'] = paymentAtIST;
    data['assignedAtIST'] = assignedAtIST;
    data['tripStartAtIST'] = tripStartAtIST;
    data['tripEndAtIST'] = tripEndAtIST;
    data['cancelledAtIST'] = cancelledAtIST;
    data['tripEndOtpVerify'] = tripEndOtpVerify;
    data['tripStartOtpVerify'] = tripStartOtpVerify;
    return data;
  }
}

class Pickup {
  String? address;

  Pickup({this.address});

  Pickup.fromJson(Map<String, dynamic> json) {
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    return data;
  }
}

class DriverResponse {
  String? respondedAt;
  String? cancelRequestId;
  String? status;

  DriverResponse({this.respondedAt, this.cancelRequestId, this.status});

  DriverResponse.fromJson(Map<String, dynamic> json) {
    respondedAt = json['respondedAt'];
    cancelRequestId = json['cancelRequestId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['respondedAt'] = respondedAt;
    data['cancelRequestId'] = cancelRequestId;
    data['status'] = status;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profilePic;

  User({this.id, this.name, this.profilePic});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['profilePic'] = profilePic;
    return data;
  }
}

class Segment {
  String? id;
  String? name;

  Segment({this.id, this.name});

  Segment.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    return data;
  }
}

class Region {
  String? id;
  String? name;
  String? state;

  Region({this.id, this.name, this.state});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['state'] = state;
    return data;
  }
}

class Vehicle {
  String? id;
  String? brand;
  String? model;
  String? fuelType;
  String? color;
  String? carNumber;
  int? capacity;

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    brand = json['brand'];
    model = json['model'];
    fuelType = json['fuelType'];
    color = json['color'];
    carNumber = json['carNumber'];
    capacity = json['capacity'];
  }
}
