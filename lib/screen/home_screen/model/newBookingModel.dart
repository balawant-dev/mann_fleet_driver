// class NewBookingModel {
//   bool? status;
//   int? totalResult;
//   int? totalPage;
//   int? currentPage;
//   String? message;
//   List<NewBookingData>? data;
//
//   NewBookingModel(
//       {this.status,
//         this.totalResult,
//         this.totalPage,
//         this.currentPage,
//         this.message,
//         this.data});
//
//   NewBookingModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     totalResult = json['totalResult'];
//     totalPage = json['totalPage'];
//     currentPage = json['currentPage'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <NewBookingData>[];
//       json['data'].forEach((v) {
//         data!.add(new NewBookingData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['totalResult'] = this.totalResult;
//     data['totalPage'] = this.totalPage;
//     data['currentPage'] = this.currentPage;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class NewBookingData {
//   Pickup? pickup;
//   Pickup? dropoff;
//   String? sId;
//   String? bookingNumber;
//   User? user;
//   Segment? segment;
//   Region? region;
//   String? bookingType;
//   String? paymentStatus;
//   String? assignmentStatus;
//   String? tripStatus;
//   String? overallStatus;
//   double? estimatedFare;
//   double? prepaidAmount;
//   String? scheduledAt;
//   String? otp;
//   String? createdAt;
//   Vehicle? vehicle;
//   String? createdAtIST;
//   String? scheduledAtIST;
//   String? paymentAtIST;
//   String? assignedAtIST;
//   String? tripStartAtIST;
//   String? tripEndAtIST;
//   String? cancelledAtIST;
//   String? id;
//
//   NewBookingData(
//       {this.pickup,
//         this.dropoff,
//         this.sId,
//         this.bookingNumber,
//         this.user,
//         this.segment,
//         this.region,
//         this.bookingType,
//         this.paymentStatus,
//         this.assignmentStatus,
//         this.tripStatus,
//         this.overallStatus,
//         this.estimatedFare,
//         this.prepaidAmount,
//         this.scheduledAt,
//         this.otp,
//         this.createdAt,
//         this.vehicle,
//         this.createdAtIST,
//         this.scheduledAtIST,
//         this.paymentAtIST,
//         this.assignedAtIST,
//         this.tripStartAtIST,
//         this.tripEndAtIST,
//         this.cancelledAtIST,
//         this.id});
//
//   NewBookingData.fromJson(Map<String, dynamic> json) {
//     pickup =
//     json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
//     dropoff =
//     json['dropoff'] != null ? new Pickup.fromJson(json['dropoff']) : null;
//     sId = json['_id'];
//     bookingNumber = json['bookingNumber'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     segment =
//     json['segment'] != null ? new Segment.fromJson(json['segment']) : null;
//     region =
//     json['region'] != null ? new Region.fromJson(json['region']) : null;
//     bookingType = json['bookingType'];
//     paymentStatus = json['paymentStatus'];
//     assignmentStatus = json['assignmentStatus'];
//     tripStatus = json['tripStatus'];
//     overallStatus = json['overallStatus'];
//     estimatedFare = json['estimatedFare'];
//     prepaidAmount = json['prepaidAmount'];
//     scheduledAt = json['scheduledAt'];
//     otp = json['otp'];
//     createdAt = json['createdAt'];
//     vehicle =
//     json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
//     createdAtIST = json['createdAtIST'];
//     scheduledAtIST = json['scheduledAtIST'];
//     paymentAtIST = json['paymentAtIST'];
//     assignedAtIST = json['assignedAtIST'];
//     tripStartAtIST = json['tripStartAtIST'];
//     tripEndAtIST = json['tripEndAtIST'];
//     cancelledAtIST = json['cancelledAtIST'];
//     id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.pickup != null) {
//       data['pickup'] = this.pickup!.toJson();
//     }
//     if (this.dropoff != null) {
//       data['dropoff'] = this.dropoff!.toJson();
//     }
//     data['_id'] = this.sId;
//     data['bookingNumber'] = this.bookingNumber;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     if (this.segment != null) {
//       data['segment'] = this.segment!.toJson();
//     }
//     if (this.region != null) {
//       data['region'] = this.region!.toJson();
//     }
//     data['bookingType'] = this.bookingType;
//     data['paymentStatus'] = this.paymentStatus;
//     data['assignmentStatus'] = this.assignmentStatus;
//     data['tripStatus'] = this.tripStatus;
//     data['overallStatus'] = this.overallStatus;
//     data['estimatedFare'] = this.estimatedFare;
//     data['prepaidAmount'] = this.prepaidAmount;
//     data['scheduledAt'] = this.scheduledAt;
//     data['otp'] = this.otp;
//     data['createdAt'] = this.createdAt;
//     if (this.vehicle != null) {
//       data['vehicle'] = this.vehicle!.toJson();
//     }
//     data['createdAtIST'] = this.createdAtIST;
//     data['scheduledAtIST'] = this.scheduledAtIST;
//     data['paymentAtIST'] = this.paymentAtIST;
//     data['assignedAtIST'] = this.assignedAtIST;
//     data['tripStartAtIST'] = this.tripStartAtIST;
//     data['tripEndAtIST'] = this.tripEndAtIST;
//     data['cancelledAtIST'] = this.cancelledAtIST;
//     data['id'] = this.id;
//     return data;
//   }
// }
//
// class Pickup {
//   String? address;
//
//   Pickup({this.address});
//
//   Pickup.fromJson(Map<String, dynamic> json) {
//     address = json['address'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['address'] = this.address;
//     return data;
//   }
// }
//
// class User {
//   String? sId;
//   String? name;
//   String? profilePic;
//   String? id;
//
//   User({this.sId, this.name, this.profilePic, this.id});
//
//   User.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     profilePic = json['profilePic'];
//     id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['profilePic'] = this.profilePic;
//     data['id'] = this.id;
//     return data;
//   }
// }
//
// class Segment {
//   String? sId;
//   String? name;
//
//   Segment({this.sId, this.name});
//
//   Segment.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     return data;
//   }
// }
//
// class Region {
//   String? sId;
//   String? name;
//   String? state;
//
//   Region({this.sId, this.name, this.state});
//
//   Region.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     state = json['state'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['state'] = this.state;
//     return data;
//   }
// }
//
// class Vehicle {
//   String? sId;
//   String? brand;
//   String? model;
//   String? color;
//   String? carNumber;
//
//   Vehicle({this.sId, this.brand, this.model, this.color, this.carNumber});
//
//   Vehicle.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     brand = json['brand'];
//     model = json['model'];
//     color = json['color'];
//     carNumber = json['carNumber'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['brand'] = this.brand;
//     data['model'] = this.model;
//     data['color'] = this.color;
//     data['carNumber'] = this.carNumber;
//     return data;
//   }
// }
class NewBookingModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  int? currentPage;
  String? message;
  List<NewBookingData>? data;

  NewBookingModel({
    this.status,
    this.totalResult,
    this.totalPage,
    this.currentPage,
    this.message,
    this.data,
  });

  NewBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NewBookingData>[];
      json['data'].forEach((v) {
        data!.add(NewBookingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResult'] = totalResult;
    data['totalPage'] = totalPage;
    data['currentPage'] = currentPage;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewBookingData {
  Pickup? pickup;
  Pickup? dropoff;
  DriverResponse? driverResponse; // ← added (was missing)
  String? id;                    // ← renamed from _id / sId / id confusion
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
  String? scheduledAt;           // ISO string or null
  String? createdAt;             // ISO string
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
    driverResponse = json['driverResponse'] != null
        ? DriverResponse.fromJson(json['driverResponse'])
        : null;
    id = json['_id'] ?? json['id']; // handles both _id and id
    bookingNumber = json['bookingNumber'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    segment = json['segment'] != null ? Segment.fromJson(json['segment']) : null;
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    bookingType = json['bookingType'];
    paymentStatus = json['paymentStatus'];
    assignmentStatus = json['assignmentStatus'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    estimatedFare = json['estimatedFare']?.toDouble();
    prepaidAmount = json['prepaidAmount']?.toDouble();
    scheduledAt = json['scheduledAt'];
    createdAt = json['createdAt'];
    vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
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
    if (driverResponse != null) data['driverResponse'] = driverResponse!.toJson();
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
    if (vehicle != null) data['vehicle'] = vehicle!.toJson();
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

  DriverResponse({
    this.respondedAt,
    this.cancelRequestId,
    this.status,
  });

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

  User({
    this.id,
    this.name,
    this.profilePic,
  });

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
  String? model;
  String? color;
  // String? brand;     // not present in your JSON → commented out
  // String? carNumber; // not present in your JSON → commented out

  Vehicle({
    this.id,
    this.model,
    this.color,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    model = json['model'];
    color = json['color'];
    // brand = json['brand'];
    // carNumber = json['carNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['model'] = model;
    data['color'] = color;
    // data['brand'] = brand;
    // data['carNumber'] = carNumber;
    return data;
  }
}