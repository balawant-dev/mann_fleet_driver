class GetProfileModel {
  bool? status;
  String? message;
  Data? data;

  GetProfileModel({
    this.status,
    this.message,
    this.data,
  });

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class Data {
  DriverProfile? driver;

  Data({this.driver});

  Data.fromJson(Map<String, dynamic> json) {
    driver = json['driver'] != null ? DriverProfile.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (driver != null) {
      map['driver'] = driver!.toJson();
    }
    return map;
  }
}

class DriverProfile {
  String? id;                       // _id
  String? phone;
  bool? isAdharVerified;
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
  int? v;                           // __v
  String? fcmToken;
  String? email;
  String? licenseNumber;
  String? name;
  String? profilePic;
  String? currentAddress;
  String? permanentAddress;
  String? gender;
  bool? isDeleted;
  String? licenseExpiry;
  String? licensePhoto;
  String? licenseBackPhoto;
  String? adhaarNumber;
  String? adhaarFrontPhoto;
  String? adhaarBackPhoto;
  String? panNumber;

  String? panFrontPhoto;
  String? panBackPhoto;
  String? policeVerificationPhoto;
  String? policeVerificationExpiry;
  bool? isProfileComplete;

  DriverProfile({
    this.id,
    this.phone,
    this.isAdharVerified,
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
    this.v,
    this.fcmToken,
    this.email,
    this.licenseNumber,
    this.name,
    this.profilePic,
    this.currentAddress,
    this.permanentAddress,
    this.gender,
    this.isDeleted,
    this.licenseExpiry,
    this.licensePhoto,
    this.licenseBackPhoto,
    this.adhaarNumber,
    this.adhaarFrontPhoto,
    this.adhaarBackPhoto,
    this.panNumber,
    this.panFrontPhoto,
    this.panBackPhoto,
    this.policeVerificationPhoto,
    this.policeVerificationExpiry,
    this.isProfileComplete,
  });

  DriverProfile.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    phone = json['phone'];
    isAdharVerified = json['isAdharVerified'];
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
    v = json['__v'];
    fcmToken = json['fcmToken'];
    email = json['email'];
    licenseNumber = json['licenseNumber'];
    name = json['name'];
    profilePic = json['profilePic'];
    currentAddress = json['currentAddress'];
    permanentAddress = json['permanentAddress'];
    gender = json['gender'];
    isDeleted = json['isDeleted'];
    licenseExpiry = json['licenseExpiry'];
    licensePhoto = json['licensePhoto'];
    licenseBackPhoto = json['licenseBackPhoto'];
    adhaarNumber = json['adhaarNumber'];
    adhaarFrontPhoto = json['adhaarFrontPhoto'];
    adhaarBackPhoto = json['adhaarBackPhoto'];
    panNumber = json['panNumber'];
    panFrontPhoto = json['panFrontPhoto'];
    panBackPhoto = json['panBackPhoto'];
    policeVerificationPhoto = json['policeVerificationPhoto'];
    policeVerificationExpiry = json['policeVerificationExpiry'];
    isProfileComplete = json['isProfileComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['_id'] = id;
    map['phone'] = phone;
    map['isAdharVerified'] = isAdharVerified;
    map['isVerified'] = isVerified;
    map['isOnline'] = isOnline;
    map['isAvailable'] = isAvailable;
    map['rating'] = rating;
    map['ratingCount'] = ratingCount;
    map['totalRides'] = totalRides;
    map['firstUser'] = firstUser;
    map['deviceId'] = deviceId;
    map['deviceType'] = deviceType;
    map['isPunchedIn'] = isPunchedIn;
    map['activePunch'] = activePunch;
    map['createdAt'] = createdAt;
    map['__v'] = v;
    map['fcmToken'] = fcmToken;
    map['email'] = email;
    map['licenseNumber'] = licenseNumber;
    map['name'] = name;
    map['profilePic'] = profilePic;
    map['currentAddress'] = currentAddress;
    map['permanentAddress'] = permanentAddress;
    map['gender'] = gender;
    map['isDeleted'] = isDeleted;
    map['licenseExpiry'] = licenseExpiry;
    map['licensePhoto'] = licensePhoto;
    map['licenseBackPhoto'] = licenseBackPhoto;
    map['adhaarNumber'] = adhaarNumber;
    map['adhaarFrontPhoto'] = adhaarFrontPhoto;
    map['adhaarBackPhoto'] = adhaarBackPhoto;
    map['panNumber'] = panNumber;
    map['panFrontPhoto'] = panFrontPhoto;
    map['panBackPhoto'] = panBackPhoto;
    map['policeVerificationPhoto'] = policeVerificationPhoto;
    map['policeVerificationExpiry'] = policeVerificationExpiry;
    map['isProfileComplete'] = isProfileComplete;
    return map;
  }
}