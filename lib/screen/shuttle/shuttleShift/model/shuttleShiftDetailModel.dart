class ShuttleShiftDetailModel {
  var status;
  var message;
  Data? data;

  ShuttleShiftDetailModel({this.status, this.message, this.data});

  ShuttleShiftDetailModel.fromJson(Map<String, dynamic> json) {
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
  var sId;
  ShuttleRoute? shuttleRoute;
  ShuttleRouteShift? shuttleRouteShift;
  Driver? driver;
  Vehicle? vehicle;
  var createdAt;
  var updatedAt;
  var iV;

  Data(
      {this.sId,
        this.shuttleRoute,
        this.shuttleRouteShift,
        this.driver,
        this.vehicle,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shuttleRoute = json['shuttleRoute'] != null
        ? new ShuttleRoute.fromJson(json['shuttleRoute'])
        : null;
    shuttleRouteShift = json['shuttleRouteShift'] != null
        ? new ShuttleRouteShift.fromJson(json['shuttleRouteShift'])
        : null;
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.shuttleRoute != null) {
      data['shuttleRoute'] = this.shuttleRoute!.toJson();
    }
    if (this.shuttleRouteShift != null) {
      data['shuttleRouteShift'] = this.shuttleRouteShift!.toJson();
    }
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ShuttleRoute {
  var sId;
  var name;

  ShuttleRoute({this.sId, this.name});

  ShuttleRoute.fromJson(Map<String, dynamic> json) {
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

class ShuttleRouteShift {
  var sId;
  var shiftName;
  List<StoppageTimes>? stoppageTimes;
  var gst;
  var isActive;

  ShuttleRouteShift(
      {this.sId, this.shiftName, this.stoppageTimes, this.gst, this.isActive});

  ShuttleRouteShift.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shiftName = json['shiftName'];
    if (json['stoppageTimes'] != null) {
      stoppageTimes = <StoppageTimes>[];
      json['stoppageTimes'].forEach((v) {
        stoppageTimes!.add(new StoppageTimes.fromJson(v));
      });
    }
    gst = json['gst'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['shiftName'] = this.shiftName;
    if (this.stoppageTimes != null) {
      data['stoppageTimes'] =
          this.stoppageTimes!.map((v) => v.toJson()).toList();
    }
    data['gst'] = this.gst;
    data['isActive'] = this.isActive;
    return data;
  }
}

class StoppageTimes {
  var name;
  var lat;
  var lng;
  var address;
  var order;
  var arrivalTime;
  var departureTime;
  var price;
  var sId;

  StoppageTimes(
      {this.name,
        this.lat,
        this.lng,
        this.address,
        this.order,
        this.arrivalTime,
        this.departureTime,
        this.price,
        this.sId});

  StoppageTimes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    order = json['order'];
    arrivalTime = json['arrivalTime'];
    departureTime = json['departureTime'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['order'] = this.order;
    data['arrivalTime'] = this.arrivalTime;
    data['departureTime'] = this.departureTime;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
  }
}

class Driver {
  var sId;
  var phone;
  var rating;
  var name;
  var profilePic;
  var id;

  Driver(
      {this.sId, this.phone, this.rating, this.name, this.profilePic, this.id});

  Driver.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    rating = json['rating'];
    name = json['name'];
    profilePic = json['profilePic'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['rating'] = this.rating;
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    data['id'] = this.id;
    return data;
  }
}

class Vehicle {
  var sId;
  var brand;
  var model;
  var fuelType;
  var color;
  var carNumber;
  var capacity;

  Vehicle(
      {this.sId,
        this.brand,
        this.model,
        this.fuelType,
        this.color,
        this.carNumber,
        this.capacity});

  Vehicle.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    brand = json['brand'];
    model = json['model'];
    fuelType = json['fuelType'];
    color = json['color'];
    carNumber = json['carNumber'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['fuelType'] = this.fuelType;
    data['color'] = this.color;
    data['carNumber'] = this.carNumber;
    data['capacity'] = this.capacity;
    return data;
  }
}
