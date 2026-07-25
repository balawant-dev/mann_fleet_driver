class GetProfileModel {
  var status;
  var message;
  Data? data;

  GetProfileModel({this.status, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class Data {
  DriverProfile? driver;

  Data({this.driver});

  Data.fromJson(Map<String, dynamic> json) {
    driver =
        json['driver'] != null ? DriverProfile.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    return {'driver': driver?.toJson()};
  }
}

class DriverProfile {
  var id;
  var phone;

  var isAdharVerified;
  var isVerified;
  var isOnline;
  var isAvailable;
  var firstUser;
  var isPunchedIn;
  var isDeleted;
  var isProfileComplete;
  var isVehicleAssigned;

 var rating;
 var ratingCount;
 var totalRides;
 var v;

  var gender;
  var deviceId;
  var deviceType;
  var activePunch;
  var createdAt;
  var fcmToken;
  var email;
  var licenseNumber;
  var name;
  var lastName;
  var midName;

  var profilePic;
  var currentAddress;
  var permanentAddress;
  var alternatePhone;

  var licenseExpiry;
  var licensePhoto;

  var adhaarNumber;
  var adhaarFrontPhoto;
  var adhaarBackPhoto;

  var panNumber;
  var panFrontPhoto;
  var panBackPhoto;

  var policeVerificationPhoto;
  var policeVerificationExpiry;

  var city;
  var state;
  var pincode;
  var grade;

  LastLocation? lastLocation;
  Region? region;
  PunchRegion? punchRegion;

  List<Vehicle>? vehicles;

  DriverProfile({
    this.id,
    this.phone,
    this.isAdharVerified,
    this.isVerified,
    this.isOnline,
    this.isAvailable,
    this.firstUser,
    this.isPunchedIn,
    this.isDeleted,
    this.isProfileComplete,
    this.isVehicleAssigned,
    this.rating,
    this.ratingCount,
    this.totalRides,
    this.v,
    this.gender,
    this.deviceId,
    this.deviceType,
    this.activePunch,
    this.createdAt,
    this.fcmToken,
    this.email,
    this.licenseNumber,
    this.name,
    this.lastName,
    this.midName,
    this.profilePic,
    this.currentAddress,
    this.permanentAddress,
    this.alternatePhone,
    this.licenseExpiry,
    this.licensePhoto,
    this.adhaarNumber,
    this.adhaarFrontPhoto,
    this.adhaarBackPhoto,
    this.panNumber,
    this.panFrontPhoto,
    this.panBackPhoto,
    this.policeVerificationPhoto,
    this.policeVerificationExpiry,
    this.city,
    this.state,
    this.pincode,
    this.grade,
    this.lastLocation,
    this.region,
    this.punchRegion,
    this.vehicles,
  });

  DriverProfile.fromJson(Map<String, dynamic> json) {
    lastLocation =
        json['lastLocation'] != null
            ? LastLocation.fromJson(json['lastLocation'])
            : null;

    id = json['_id'];
    phone = json['phone'];

    isAdharVerified = json['isAdharVerified'];
    isVerified = json['isVerified'];
    isOnline = json['isOnline'];
    isAvailable = json['isAvailable'];
    firstUser = json['firstUser'];
    isPunchedIn = json['isPunchedIn'];
    isDeleted = json['isDeleted'];
    isProfileComplete = json['isProfileComplete'];
    isVehicleAssigned = json['isVehicleAssigned'];

    rating = json['rating'];
    ratingCount = json['ratingCount'];
    totalRides = json['totalRides'];
    v = json['__v'];

    gender = json['gender'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    activePunch = json['activePunch'];
    createdAt = json['createdAt'];
    fcmToken = json['fcmToken'];

    email = json['email'];
    licenseNumber = json['licenseNumber'];

    name = json['name'];
    lastName = json['lastName'];
    midName = json['midName'];

    profilePic = json['profilePic'];

    currentAddress = json['currentAddress'];
    permanentAddress = json['permanentAddress'];
    alternatePhone = json['alternatePhone'];

    licenseExpiry = json['licenseExpiry'];
    licensePhoto = json['licensePhoto'];

    adhaarNumber = json['adhaarNumber'];
    adhaarFrontPhoto = json['adhaarFrontPhoto'];
    adhaarBackPhoto = json['adhaarBackPhoto'];

    panNumber = json['panNumber'];
    panFrontPhoto = json['panFrontPhoto'];
    panBackPhoto = json['panBackPhoto'];

    policeVerificationPhoto = json['policeVerificationPhoto'];
    policeVerificationExpiry = json['policeVerificationExpiry'];

    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    grade = json['grade'];

    region = json['region'] != null ? Region.fromJson(json['region']) : null;

    punchRegion =
        json['punchRegion'] != null
            ? PunchRegion.fromJson(json['punchRegion'])
            : null;

    if (json['vehicles'] != null) {
      vehicles = <Vehicle>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'isAdharVerified': isAdharVerified,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'isAvailable': isAvailable,
      'firstUser': firstUser,
      'isPunchedIn': isPunchedIn,
      'isDeleted': isDeleted,
      'isProfileComplete': isProfileComplete,
      'isVehicleAssigned': isVehicleAssigned,
      'rating': rating,
      'ratingCount': ratingCount,
      'totalRides': totalRides,
      '__v': v,
      'gender': gender,
      'deviceId': deviceId,
      'deviceType': deviceType,
      'activePunch': activePunch,
      'createdAt': createdAt,
      'fcmToken': fcmToken,
      'email': email,
      'licenseNumber': licenseNumber,
      'name': name,
      'lastName': lastName,
      'midName': midName,
      'profilePic': profilePic,
      'currentAddress': currentAddress,
      'permanentAddress': permanentAddress,
      'alternatePhone': alternatePhone,
      'licenseExpiry': licenseExpiry,
      'licensePhoto': licensePhoto,
      'adhaarNumber': adhaarNumber,
      'adhaarFrontPhoto': adhaarFrontPhoto,
      'adhaarBackPhoto': adhaarBackPhoto,
      'panNumber': panNumber,
      'panFrontPhoto': panFrontPhoto,
      'panBackPhoto': panBackPhoto,
      'policeVerificationPhoto': policeVerificationPhoto,
      'policeVerificationExpiry': policeVerificationExpiry,
      'city': city,
      'state': state,
      'pincode': pincode,
      'grade': grade,
      'lastLocation': lastLocation?.toJson(),
      'region': region?.toJson(),
      'punchRegion': punchRegion?.toJson(),
      'vehicles': vehicles?.map((e) => e.toJson()).toList(),
    };
  }
}

class LastLocation {
  double? lat;
  double? lng;
  var updatedAt;

  LastLocation({this.lat, this.lng, this.updatedAt});

  LastLocation.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'updatedAt': updatedAt};
  }
}

class Region {
  var id;
  var name;
  var state;

  Region({this.id, this.name, this.state});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'state': state};
  }
}

class PunchRegion {
  var id;
  var name;

  PunchRegion({this.id, this.name});

  PunchRegion.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Vehicle {
  var id;
  var brand;
  var model;
  var fuelType;
 var year;
  var color;
  var carNumber;
 var capacity;
  var isActive;
  var driver;

  Vehicle({
    this.id,
    this.brand,
    this.model,
    this.fuelType,
    this.year,
    this.color,
    this.carNumber,
    this.capacity,
    this.isActive,
    this.driver,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    brand = json['brand'];
    model = json['model'];
    fuelType = json['fuelType'];
    year = json['year'];
    color = json['color'];
    carNumber = json['carNumber'];
    capacity = json['capacity'];
    isActive = json['isActive'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'brand': brand,
      'model': model,
      'fuelType': fuelType,
      'year': year,
      'color': color,
      'carNumber': carNumber,
      'capacity': capacity,
      'isActive': isActive,
      'driver': driver,
    };
  }
}
