class BookingAcceptedModel {
  var status;
 var message;
  Data? data;

  BookingAcceptedModel({this.status, this.message, this.data});

  BookingAcceptedModel.fromJson(Map<String, dynamic> json) {
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
 var tripStatus;
 var overallStatus;
  DriverResponse? driverResponse;
  Pickup? pickup;
  Dropoff? dropoff;
  var estimatedFare;

  Data(
      {this.bookingId,
        this.bookingNumber,
        this.tripStatus,
        this.overallStatus,
        this.driverResponse,
        this.pickup,
        this.dropoff,
        this.estimatedFare});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    tripStatus = json['tripStatus'];
    overallStatus = json['overallStatus'];
    driverResponse = json['driverResponse'] != null
        ? new DriverResponse.fromJson(json['driverResponse'])
        : null;
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    dropoff =
    json['dropoff'] != null ? new Dropoff.fromJson(json['dropoff']) : null;
    estimatedFare = json['estimatedFare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['bookingNumber'] = this.bookingNumber;
    data['tripStatus'] = this.tripStatus;
    data['overallStatus'] = this.overallStatus;
    if (this.driverResponse != null) {
      data['driverResponse'] = this.driverResponse!.toJson();
    }
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoff != null) {
      data['dropoff'] = this.dropoff!.toJson();
    }
    data['estimatedFare'] = this.estimatedFare;
    return data;
  }
}

class DriverResponse {
 var respondedAt;
 var cancelRequestId;
 var status;

  DriverResponse({this.respondedAt, this.cancelRequestId, this.status});

  DriverResponse.fromJson(Map<String, dynamic> json) {
    respondedAt = json['respondedAt'];
    cancelRequestId = json['cancelRequestId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['respondedAt'] = this.respondedAt;
    data['cancelRequestId'] = this.cancelRequestId;
    data['status'] = this.status;
    return data;
  }
}

class Pickup {
  double? lat;
  double? lng;
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

class Dropoff {
  var lat;
  var lng;
 var address;

  Dropoff({this.lat, this.lng, this.address});

  Dropoff.fromJson(Map<String, dynamic> json) {
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
