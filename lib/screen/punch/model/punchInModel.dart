class PunchInModel {
  bool? status;
  String? message;
  Data? data;
  ApiError? error;
  PunchInModel({this.status, this.message, this.data,
    this.error
  });

  PunchInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'] != null ? ApiError.fromJson(json['error']) : null; // ← Yeh line active rakho
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // if (this.error != null) {
    //   data['error'] = this.error!.toJson();
    // }
    return data;
  }
}

class Data {
  String? punchId;
  String? punchInAt;
  PunchInLocation? punchInLocation;
  String? distanceFromZone;
  PunchRegion? punchRegion;

  Data(
      {this.punchId,
        this.punchInAt,
        this.punchInLocation,
        this.distanceFromZone,
        this.punchRegion});

  Data.fromJson(Map<String, dynamic> json) {
    punchId = json['punchId'];
    punchInAt = json['punchInAt'];
    punchInLocation = json['punchInLocation'] != null
        ? new PunchInLocation.fromJson(json['punchInLocation'])
        : null;
    distanceFromZone = json['distanceFromZone'];
    punchRegion = json['punchRegion'] != null
        ? new PunchRegion.fromJson(json['punchRegion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['punchId'] = this.punchId;
    data['punchInAt'] = this.punchInAt;
    if (this.punchInLocation != null) {
      data['punchInLocation'] = this.punchInLocation!.toJson();
    }
    data['distanceFromZone'] = this.distanceFromZone;
    if (this.punchRegion != null) {
      data['punchRegion'] = this.punchRegion!.toJson();
    }
    return data;
  }
}

class PunchInLocation {
  double? lat;
  double? lng;

  PunchInLocation({this.lat, this.lng});

  PunchInLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class PunchRegion {
  String? name;
  String? address;
  int? radiusMeters;

  PunchRegion({this.name, this.address, this.radiusMeters});

  PunchRegion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    radiusMeters = json['radiusMeters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['radiusMeters'] = this.radiusMeters;
    return data;
  }
}
class ApiError {
  int? statusCode;
  bool? status;
  String? message;
  String? name;

  ApiError({this.statusCode, this.status, this.message, this.name});

  ApiError.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'name': name,
    };
  }
}