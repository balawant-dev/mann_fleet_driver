class RegisterModel {
  bool? status;
  String? message;
  Data? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  String? phone;
  bool? isVerified;
  bool? isOnline;
  bool? isAvailable;
  int? rating;
  int? ratingCount;
  int? totalRides;
  bool? firstUser;
  String? deviceId;
  String? deviceType;
  bool? isPunchedIn;
  String? activePunch;
  String? createdAt;
  int? iV;
  String? fcmToken;
  String? email;
  String? licenseNumber;
  String? name;
  String? profilePic;
  String? id;

  Data(
      {this.sId,
        this.phone,
        this.isVerified,
        this.isOnline,
        this.isAvailable,
        this.rating,
        this.ratingCount,
        this.totalRides,
        this.firstUser,
        this.deviceId,
        this.deviceType,
        this.isPunchedIn,
        this.activePunch,
        this.createdAt,
        this.iV,
        this.fcmToken,
        this.email,
        this.licenseNumber,
        this.name,
        this.profilePic,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    isVerified = json['isVerified'];
    isOnline = json['isOnline'];
    isAvailable = json['isAvailable'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    totalRides = json['totalRides'];
    firstUser = json['firstUser'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    isPunchedIn = json['isPunchedIn'];
    activePunch = json['activePunch'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    fcmToken = json['fcmToken'];
    email = json['email'];
    licenseNumber = json['licenseNumber'];
    name = json['name'];
    profilePic = json['profilePic'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['isVerified'] = this.isVerified;
    data['isOnline'] = this.isOnline;
    data['isAvailable'] = this.isAvailable;
    data['rating'] = this.rating;
    data['ratingCount'] = this.ratingCount;
    data['totalRides'] = this.totalRides;
    data['firstUser'] = this.firstUser;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['isPunchedIn'] = this.isPunchedIn;
    data['activePunch'] = this.activePunch;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['fcmToken'] = this.fcmToken;
    data['email'] = this.email;
    data['licenseNumber'] = this.licenseNumber;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    data['id'] = this.id;
    return data;
  }
}
