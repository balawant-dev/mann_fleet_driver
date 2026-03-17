class EditProfileModel {
  bool? success;
  String? message;
  Data? data;

  EditProfileModel({
    this.success,
    this.message,
    this.data,
  });

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class Data {
  String? id;
  String? name;
  String? number;
  String? dob;
  String? gender;
  String? bio;

  List<String> secondaryImages;     // non-nullable
  List<String> languages;
  List<String> interests;
  Lifestyle lifestyle;              // non-nullable

  String? education;
  String? profession;
  String? company;
  int? heightCm;
  String? relationshipGoal;
  Preferences? preferences;
  Location? location;
  Privacy? privacy;
  bool? isVerified;
  int? profileCompletionPercent;
  String? updatedAt;

  Data({
    this.id,
    this.name,
    this.number,
    this.dob,
    this.gender,
    this.bio,
    List<String>? secondaryImages,
    this.education,
    this.profession,
    this.company,
    this.heightCm,
    List<String>? languages,
    List<String>? interests,
    Lifestyle? lifestyle,
    this.relationshipGoal,
    this.preferences,
    this.location,
    this.privacy,
    this.isVerified,
    this.profileCompletionPercent,
    this.updatedAt,
  })  : secondaryImages = secondaryImages ?? const [],   // ← key fix
        languages       = languages       ?? const [],
        interests       = interests       ?? const [],
        lifestyle       = lifestyle       ?? Lifestyle();

  // fromJson remains almost the same — just make sure lists are never null
  Data.fromJson(Map<String, dynamic> json)
      : secondaryImages = json['secondaryImages'] != null
      ? List<String>.from(json['secondaryImages'])
      : const [],
        languages = json['languages'] != null
            ? List<String>.from(json['languages'])
            : const [],
        interests = json['interests'] != null
            ? List<String>.from(json['interests'])
            : const [],
        lifestyle = (json['lifestyle'] is Map<String, dynamic>)
            ? Lifestyle.fromJson(json['lifestyle'] as Map<String, dynamic>)
            : Lifestyle(),
        id = json['id'],
        name = json['name'],
        number = json['number'],
        dob = json['dob'],
        gender = json['gender'],
        bio = json['bio'],
        education = json['education'],
        profession = json['profession'],
        company = json['company'],
        heightCm = json['heightCm'],
        relationshipGoal = json['relationshipGoal'],
        preferences = (json['preferences'] is Map<String, dynamic>)
            ? Preferences.fromJson(json['preferences'] as Map<String, dynamic>)
            : null,
        location = (json['location'] is Map<String, dynamic>)
            ? Location.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        privacy = (json['privacy'] is Map<String, dynamic>)
            ? Privacy.fromJson(json['privacy'] as Map<String, dynamic>)
            : null,
        isVerified = json['isVerified'],
        profileCompletionPercent = json['profileCompletionPercent'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['number'] = number;
    map['dob'] = dob;
    map['gender'] = gender;
    map['bio'] = bio;
    map['secondaryImages'] = secondaryImages;
    map['education'] = education;
    map['profession'] = profession;
    map['company'] = company;
    map['heightCm'] = heightCm;
    map['languages'] = languages;
    map['interests'] = interests;
    map['lifestyle'] = lifestyle.toJson();
    map['relationshipGoal'] = relationshipGoal;
    if (preferences != null) map['preferences'] = preferences!.toJson();
    if (location != null)     map['location']     = location!.toJson();
    if (privacy != null)      map['privacy']      = privacy!.toJson();
    map['isVerified'] = isVerified;
    map['profileCompletionPercent'] = profileCompletionPercent;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Lifestyle {
  String? drinking;
  String? smoking;
  String? workout;
  String? diet;

  Lifestyle({
    this.drinking,
    this.smoking,
    this.workout,
    this.diet,
  });

  Lifestyle.fromJson(Map<String, dynamic> json) {
    drinking = json['drinking'];
    smoking = json['smoking'];
    workout = json['workout'];
    diet = json['diet'];
  }

  Map<String, dynamic> toJson() {
    return {
      'drinking': drinking,
      'smoking': smoking,
      'workout': workout,
      'diet': diet,
    };
  }
}

class Preferences {
  String? interestedIn;
  int? minAge;
  int? maxAge;
  int? maxDistanceKm;

  Preferences({
    this.interestedIn,
    this.minAge,
    this.maxAge,
    this.maxDistanceKm,
  });

  Preferences.fromJson(Map<String, dynamic> json) {
    interestedIn = json['interestedIn'];
    minAge = json['minAge'];
    maxAge = json['maxAge'];
    maxDistanceKm = json['maxDistanceKm'];
  }

  Map<String, dynamic> toJson() {
    return {
      'interestedIn': interestedIn,
      'minAge': minAge,
      'maxAge': maxAge,
      'maxDistanceKm': maxDistanceKm,
    };
  }
}

class Location {
  String? type;
  List<double>? coordinates;
  String? city;
  String? country;

  Location({
    this.type,
    this.coordinates,
    this.city,
    this.country,
  });

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'])
        : null;
    city = json['city'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'city': city,
      'country': country,
    };
  }
}

class Privacy {
  bool? showAge;
  bool? showDistance;

  Privacy({
    this.showAge,
    this.showDistance,
  });

  Privacy.fromJson(Map<String, dynamic> json) {
    showAge = json['showAge'];
    showDistance = json['showDistance'];
  }

  Map<String, dynamic> toJson() {
    return {
      'showAge': showAge,
      'showDistance': showDistance,
    };
  }
}