class BookingHistoryModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  int? currentPage;
  String? message;
  List<Data>? data;

  BookingHistoryModel({
    this.status,
    this.totalResult,
    this.totalPage,
    this.currentPage,
    this.message,
    this.data,
  });

  BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Pickup? pickup;
  Pickup? dropoff;
  String? sId;
  String? bookingNumber;
  Segment? segment;
  Region? region;
  String? bookingType;
  String? paymentStatus;
  String? tripStatus;
  String? overallStatus;
  dynamic estimatedFare;
  dynamic prepaidAmount;
  String? scheduledAt;
  String? createdAt;
  Driver? driver;
  Vehicle? vehicle;
  String? createdAtIST;
  String? scheduledAtIST;
  Null? paymentAtIST;
  Null? assignedAtIST;
  Null? tripStartAtIST;
  Null? tripEndAtIST;
  Null? cancelledAtIST;
  String? id;

  Data({
    this.pickup,
    this.dropoff,
    this.sId,
    this.bookingNumber,
    this.segment,
    this.region,
    this.bookingType,
    this.paymentStatus,
    this.tripStatus,
    this.overallStatus,
    this.estimatedFare,
    this.prepaidAmount,
    this.scheduledAt,
    this.createdAt,
    this.driver,
    this.vehicle,
    this.createdAtIST,
    this.scheduledAtIST,
    this.paymentAtIST,
    this.assignedAtIST,
    this.tripStartAtIST,
    this.tripEndAtIST,
    this.cancelledAtIST,
    this.id,
  });

  Data.fromJson(Map<String, dynamic> json) {
    pickup =
        json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    dropoff =
        json['dropoff'] != null ? new Pickup.fromJson(json['dropoff']) : null;
    sId = json['_id'];
    bookingNumber = json['bookingNumber'];
    segment =
        json['segment'] != null ? new Segment.fromJson(json['segment']) : null;
    region =
        json['region'] != null ? new Region.fromJson(json['region']) : null;
    bookingType = json['bookingType'];
    paymentStatus = json['paymentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    estimatedFare = json['estimatedFare'];
    prepaidAmount = json['prepaidAmount'];
    scheduledAt = json['scheduledAt'];
    createdAt = json['createdAt'];
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    createdAtIST = json['createdAtIST'];
    scheduledAtIST = json['scheduledAtIST'];
    paymentAtIST = json['paymentAtIST'];
    assignedAtIST = json['assignedAtIST'];
    tripStartAtIST = json['tripStartAtIST'];
    tripEndAtIST = json['tripEndAtIST'];
    cancelledAtIST = json['cancelledAtIST'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoff != null) {
      data['dropoff'] = this.dropoff!.toJson();
    }
    data['_id'] = this.sId;
    data['bookingNumber'] = this.bookingNumber;
    if (this.segment != null) {
      data['segment'] = this.segment!.toJson();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    data['bookingType'] = this.bookingType;
    data['paymentStatus'] = this.paymentStatus;
    data['tripStatus'] = this.tripStatus;
    data['overallStatus'] = this.overallStatus;
    data['estimatedFare'] = this.estimatedFare;
    data['prepaidAmount'] = this.prepaidAmount;
    data['scheduledAt'] = this.scheduledAt;
    data['createdAt'] = this.createdAt;
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['createdAtIST'] = this.createdAtIST;
    data['scheduledAtIST'] = this.scheduledAtIST;
    data['paymentAtIST'] = this.paymentAtIST;
    data['assignedAtIST'] = this.assignedAtIST;
    data['tripStartAtIST'] = this.tripStartAtIST;
    data['tripEndAtIST'] = this.tripEndAtIST;
    data['cancelledAtIST'] = this.cancelledAtIST;
    data['id'] = this.id;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    return data;
  }
}

class Segment {
  String? sId;
  String? name;

  Segment({this.sId, this.name});

  Segment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Region {
  String? sId;
  String? name;
  String? state;

  Region({this.sId, this.name, this.state});

  Region.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['state'] = this.state;
    return data;
  }
}

class Driver {
  String? sId;
  String? phone;
  int? rating;
  String? name;
  String? profilePic;
  String? id;

  Driver({
    this.sId,
    this.phone,
    this.rating,
    this.name,
    this.profilePic,
    this.id,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    rating = json['rating'];
    name = json['name'];
    profilePic = json['profilePic'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    data['id'] = this.id;
    return data;
  }
}

class Vehicle {
  String? sId;
  String? brand;
  String? model;
  String? color;
  String? carNumber;

  Vehicle({this.sId, this.brand, this.model, this.color, this.carNumber});

  Vehicle.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    brand = json['brand'];
    model = json['model'];
    color = json['color'];
    carNumber = json['carNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['color'] = this.color;
    data['carNumber'] = this.carNumber;
    return data;
  }
}
