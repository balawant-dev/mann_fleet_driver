class PunchOutModel {
  bool? status;
  String? message;
  PunchOutData? data;
  ApiError? error;

  PunchOutModel({this.status, this.message, this.data, this.error});

  PunchOutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PunchOutData.fromJson(json['data']) : null;

    error = json['error'] != null ? ApiError.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['status'] = status;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.toJson();
    }

    if (error != null) {
      dataMap['error'] = error!.toJson();
    }

    return dataMap;
  }
}

class PunchOutData {
  String? punchId;
  String? punchInAt;
  String? punchOutAt;
  int? totalMinutes;
  String? durationText;
  PunchOutLocation? punchOutLocation;
  String? distanceFromZone;
  bool? punchOutValid;
  dynamic warning;

  PunchOutData({
    this.punchId,
    this.punchInAt,
    this.punchOutAt,
    this.totalMinutes,
    this.durationText,
    this.punchOutLocation,
    this.distanceFromZone,
    this.punchOutValid,
    this.warning,
  });

  PunchOutData.fromJson(Map<String, dynamic> json) {
    punchId = json['punchId'];
    punchInAt = json['punchInAt'];
    punchOutAt = json['punchOutAt'];
    totalMinutes = json['totalMinutes'];
    durationText = json['durationText'];

    punchOutLocation =
        json['punchOutLocation'] != null
            ? PunchOutLocation.fromJson(json['punchOutLocation'])
            : null;

    distanceFromZone = json['distanceFromZone'];
    punchOutValid = json['punchOutValid'];
    warning = json['warning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['punchId'] = punchId;
    data['punchInAt'] = punchInAt;
    data['punchOutAt'] = punchOutAt;
    data['totalMinutes'] = totalMinutes;
    data['durationText'] = durationText;

    if (punchOutLocation != null) {
      data['punchOutLocation'] = punchOutLocation!.toJson();
    }

    data['distanceFromZone'] = distanceFromZone;
    data['punchOutValid'] = punchOutValid;
    data['warning'] = warning;

    return data;
  }
}

class PunchOutLocation {
  double? lat;
  double? lng;

  PunchOutLocation({this.lat, this.lng});

  PunchOutLocation.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] ?? 0).toDouble();
    lng = (json['lng'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
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
