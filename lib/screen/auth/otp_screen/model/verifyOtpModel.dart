class VerifyOtpModel {
  var status;
  var message;
  var token;
  Data? data;

  VerifyOtpModel({this.status, this.message, this.token, this.data});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Astrologer? astrologer;

  Data({this.astrologer});

  Data.fromJson(Map<String, dynamic> json) {
    astrologer = json['astrologer'] != null
        ? new Astrologer.fromJson(json['astrologer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.astrologer != null) {
      data['astrologer'] = this.astrologer!.toJson();
    }
    return data;
  }
}

class Astrologer {
  var sId;
  var phone;
  var isVerified;
  var isOnline;
  var isAvailable;
  var rating;
  var ratingCount;
  var totalRides;
  var gender;
  var firstUser;
  var isProfileComplete;
  var deviceId;
  var deviceType;
  var isPunchedIn;
  var isDeleted;
  var activePunch;
  var createdAt;
  var iV;
  var fcmToken;
  var id;

  Astrologer(
      {this.sId,
        this.phone,
        this.isVerified,
        this.isOnline,
        this.isAvailable,
        this.rating,
        this.ratingCount,
        this.totalRides,
        this.gender,
        this.firstUser,
        this.isProfileComplete,
        this.deviceId,
        this.deviceType,
        this.isPunchedIn,
        this.isDeleted,
        this.activePunch,
        this.createdAt,
        this.iV,
        this.fcmToken,
        this.id});

  Astrologer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    isVerified = json['isVerified'];
    isOnline = json['isOnline'];
    isAvailable = json['isAvailable'];
    rating = json['rating'];
    ratingCount = json['ratingCount'];
    totalRides = json['totalRides'];
    gender = json['gender'];
    firstUser = json['firstUser'];
    isProfileComplete = json['isProfileComplete'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    isPunchedIn = json['isPunchedIn'];
    isDeleted = json['isDeleted'];
    activePunch = json['activePunch'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    fcmToken = json['fcmToken'];
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
    data['gender'] = this.gender;
    data['firstUser'] = this.firstUser;
    data['isProfileComplete'] = this.isProfileComplete;
    data['deviceId'] = this.deviceId;
    data['deviceType'] = this.deviceType;
    data['isPunchedIn'] = this.isPunchedIn;
    data['isDeleted'] = this.isDeleted;
    data['activePunch'] = this.activePunch;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['fcmToken'] = this.fcmToken;
    data['id'] = this.id;
    return data;
  }
}
