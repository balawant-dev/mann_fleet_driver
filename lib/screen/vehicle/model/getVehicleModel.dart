class GetVehicleModel {
  bool? status;
  String? message;
  Data? data;

  GetVehicleModel({this.status, this.message, this.data});

  GetVehicleModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? driver;
  Segment? segment;
  String? brand;
  String? model;
  String? fuelType;
  List<String>? carImage;
  List<String>? documentImage;
  int? year;
  String? color;
  String? carNumber;
  String? bootSpace;
  String? certificateNumber;
  String? certificatePhoto;
  String? certificateExpiry;
  String? insuranceExpiry;
  String? pollutionExpiry;
  String? rcExpeiry;
  String? rcFrontPhoto;
  String? rcBackPhoto;
  int? capacity;
  bool? isActive;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
        this.driver,
        this.segment,
        this.brand,
        this.model,
        this.fuelType,
        this.carImage,
        this.documentImage,
        this.year,
        this.color,
        this.carNumber,
        this.bootSpace,
        this.certificateNumber,
        this.certificatePhoto,
        this.certificateExpiry,
        this.insuranceExpiry,
        this.pollutionExpiry,
        this.rcExpeiry,
        this.rcFrontPhoto,
        this.rcBackPhoto,
        this.capacity,
        this.isActive,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    driver = json['driver'];
    segment =
    json['segment'] != null ? new Segment.fromJson(json['segment']) : null;
    brand = json['brand'];
    model = json['model'];
    fuelType = json['fuelType'];
    carImage = json['carImage'].cast<String>();
    documentImage = json['documentImage'].cast<String>();
    year = json['year'];
    color = json['color'];
    carNumber = json['carNumber'];
    bootSpace = json['bootSpace'];
    certificateNumber = json['certificateNumber'];
    certificatePhoto = json['certificatePhoto'];
    certificateExpiry = json['certificateExpiry'];
    insuranceExpiry = json['insuranceExpiry'];
    pollutionExpiry = json['pollutionExpiry'];
    rcExpeiry = json['rcExpeiry'];
    rcFrontPhoto = json['rcFrontPhoto'];
    rcBackPhoto = json['rcBackPhoto'];
    capacity = json['capacity'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['driver'] = this.driver;
    if (this.segment != null) {
      data['segment'] = this.segment!.toJson();
    }
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['fuelType'] = this.fuelType;
    data['carImage'] = this.carImage;
    data['documentImage'] = this.documentImage;
    data['year'] = this.year;
    data['color'] = this.color;
    data['carNumber'] = this.carNumber;
    data['bootSpace'] = this.bootSpace;
    data['certificateNumber'] = this.certificateNumber;
    data['certificatePhoto'] = this.certificatePhoto;
    data['certificateExpiry'] = this.certificateExpiry;
    data['insuranceExpiry'] = this.insuranceExpiry;
    data['pollutionExpiry'] = this.pollutionExpiry;
    data['rcExpeiry'] = this.rcExpeiry;
    data['rcFrontPhoto'] = this.rcFrontPhoto;
    data['rcBackPhoto'] = this.rcBackPhoto;
    data['capacity'] = this.capacity;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Segment {
  String? sId;
  String? name;
  String? description;
  String? image;
  int? maxCapacity;
  String? createdAt;
  int? iV;

  Segment(
      {this.sId,
        this.name,
        this.description,
        this.image,
        this.maxCapacity,
        this.createdAt,
        this.iV});

  Segment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    maxCapacity = json['maxCapacity'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['maxCapacity'] = this.maxCapacity;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
