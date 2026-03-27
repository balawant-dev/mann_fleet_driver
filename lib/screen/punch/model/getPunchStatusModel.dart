class PunchStatusModel {
  bool? status;
  String? message;
  Data? data;

  PunchStatusModel({this.status, this.message, this.data});

  PunchStatusModel.fromJson(Map<String, dynamic> json) {
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
  bool? isPunchedIn;
  PunchRegion? punchRegion;
  bool? activePunch;

  Data({this.isPunchedIn, this.punchRegion, this.activePunch});

  Data.fromJson(Map<String, dynamic> json) {
    isPunchedIn = json['isPunchedIn'];
    punchRegion = json['punchRegion'] != null
        ? new PunchRegion.fromJson(json['punchRegion'])
        : null;
    activePunch = json['activePunch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPunchedIn'] = this.isPunchedIn;
    if (this.punchRegion != null) {
      data['punchRegion'] = this.punchRegion!.toJson();
    }
    data['activePunch'] = this.activePunch;
    return data;
  }
}

class PunchRegion {
  String? sId;
  String? name;
  double? centerLat;
  double? centerLng;
  int? radiusMeters;
  String? address;

  PunchRegion(
      {this.sId,
        this.name,
        this.centerLat,
        this.centerLng,
        this.radiusMeters,
        this.address});

  PunchRegion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    centerLat = json['centerLat'];
    centerLng = json['centerLng'];
    radiusMeters = json['radiusMeters'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['centerLat'] = this.centerLat;
    data['centerLng'] = this.centerLng;
    data['radiusMeters'] = this.radiusMeters;
    data['address'] = this.address;
    return data;
  }
}
