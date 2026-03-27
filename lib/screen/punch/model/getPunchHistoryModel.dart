class GetPunchHistoryModel {
  bool? status;
  String? message;
  int? totalResult;
  int? totalPages;
  int? currentPage;
  List<Data>? data;

  GetPunchHistoryModel(
      {this.status,
        this.message,
        this.totalResult,
        this.totalPages,
        this.currentPage,
        this.data});

  GetPunchHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalResult = json['totalResult'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
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
    data['message'] = this.message;
    data['totalResult'] = this.totalResult;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  PunchInLocation? punchInLocation;
  PunchInLocation? punchOutLocation;
  String? sId;
  String? driver;
  Region? region;
  PunchRegion? punchRegion;
  String? punchInAt;
  int? punchInDistanceFromZone;
  bool? punchInValid;
  String? punchOutAt;
  bool? punchOutValid;
  int? totalMinutes;
  String? status;
  bool? adminOverride;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? punchOutDistanceFromZone;
  String? punchInAtIST;
  String? punchOutAtIST;
  String? id;

  Data(
      {this.punchInLocation,
        this.punchOutLocation,
        this.sId,
        this.driver,
        this.region,
        this.punchRegion,
        this.punchInAt,
        this.punchInDistanceFromZone,
        this.punchInValid,
        this.punchOutAt,
        this.punchOutValid,
        this.totalMinutes,
        this.status,
        this.adminOverride,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.punchOutDistanceFromZone,
        this.punchInAtIST,
        this.punchOutAtIST,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    punchInLocation = json['punchInLocation'] != null
        ? new PunchInLocation.fromJson(json['punchInLocation'])
        : null;
    punchOutLocation = json['punchOutLocation'] != null
        ? new PunchInLocation.fromJson(json['punchOutLocation'])
        : null;
    sId = json['_id'];
    driver = json['driver'];
    region =
    json['region'] != null ? new Region.fromJson(json['region']) : null;
    punchRegion = json['punchRegion'] != null
        ? new PunchRegion.fromJson(json['punchRegion'])
        : null;
    punchInAt = json['punchInAt'];
    punchInDistanceFromZone = json['punchInDistanceFromZone'];
    punchInValid = json['punchInValid'];
    punchOutAt = json['punchOutAt'];
    punchOutValid = json['punchOutValid'];
    totalMinutes = json['totalMinutes'];
    status = json['status'];
    adminOverride = json['adminOverride'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    punchOutDistanceFromZone = json['punchOutDistanceFromZone'];
    punchInAtIST = json['punchInAtIST'];
    punchOutAtIST = json['punchOutAtIST'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.punchInLocation != null) {
      data['punchInLocation'] = this.punchInLocation!.toJson();
    }
    if (this.punchOutLocation != null) {
      data['punchOutLocation'] = this.punchOutLocation!.toJson();
    }
    data['_id'] = this.sId;
    data['driver'] = this.driver;
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    if (this.punchRegion != null) {
      data['punchRegion'] = this.punchRegion!.toJson();
    }
    data['punchInAt'] = this.punchInAt;
    data['punchInDistanceFromZone'] = this.punchInDistanceFromZone;
    data['punchInValid'] = this.punchInValid;
    data['punchOutAt'] = this.punchOutAt;
    data['punchOutValid'] = this.punchOutValid;
    data['totalMinutes'] = this.totalMinutes;
    data['status'] = this.status;
    data['adminOverride'] = this.adminOverride;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['punchOutDistanceFromZone'] = this.punchOutDistanceFromZone;
    data['punchInAtIST'] = this.punchInAtIST;
    data['punchOutAtIST'] = this.punchOutAtIST;
    data['id'] = this.id;
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

class Region {
  String? sId;
  String? name;

  Region({this.sId, this.name});

  Region.fromJson(Map<String, dynamic> json) {
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

class PunchRegion {
  String? sId;
  String? name;
  String? address;

  PunchRegion({this.sId, this.name, this.address});

  PunchRegion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
