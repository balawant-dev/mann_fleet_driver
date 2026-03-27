class GetPunchRegionsModel {
  bool? status;
  String? message;
  Data? data;

  GetPunchRegionsModel({this.status, this.message, this.data});

  GetPunchRegionsModel.fromJson(Map<String, dynamic> json) {
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
  String? driverId;
  String? driverName;
  bool? isPunchedIn;
  PunchRegion? punchRegion;

  Data({this.driverId, this.driverName, this.isPunchedIn, this.punchRegion});

  Data.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    driverName = json['driverName'];
    isPunchedIn = json['isPunchedIn'];
    punchRegion = json['punchRegion'] != null
        ? new PunchRegion.fromJson(json['punchRegion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverId'] = this.driverId;
    data['driverName'] = this.driverName;
    data['isPunchedIn'] = this.isPunchedIn;
    if (this.punchRegion != null) {
      data['punchRegion'] = this.punchRegion!.toJson();
    }
    return data;
  }
}

class PunchRegion {
  String? sId;
  String? name;
  String? region;
  double? centerLat;
  double? centerLng;
  int? radiusMeters;
  String? address;
  bool? isActive;

  PunchRegion(
      {this.sId,
        this.name,
        this.region,
        this.centerLat,
        this.centerLng,
        this.radiusMeters,
        this.address,
        this.isActive});

  PunchRegion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    region = json['region'];
    centerLat = json['centerLat'];
    centerLng = json['centerLng'];
    radiusMeters = json['radiusMeters'];
    address = json['address'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['region'] = this.region;
    data['centerLat'] = this.centerLat;
    data['centerLng'] = this.centerLng;
    data['radiusMeters'] = this.radiusMeters;
    data['address'] = this.address;
    data['isActive'] = this.isActive;
    return data;
  }
}
