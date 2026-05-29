class UpdateLocationModel {
  bool? status;
  String? message;
  Data? data;

  UpdateLocationModel({this.status, this.message, this.data});

  UpdateLocationModel.fromJson(Map<String, dynamic> json) {
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
  DriverCurrentLocation? driverCurrentLocation;

  Data({this.bookingId, this.driverCurrentLocation});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    driverCurrentLocation = json['driverCurrentLocation'] != null
        ? new DriverCurrentLocation.fromJson(json['driverCurrentLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    if (this.driverCurrentLocation != null) {
      data['driverCurrentLocation'] = this.driverCurrentLocation!.toJson();
    }
    return data;
  }
}

class DriverCurrentLocation {
  double? lat;
  double? lng;
  String? updatedAt;

  DriverCurrentLocation({this.lat, this.lng, this.updatedAt});

  DriverCurrentLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
