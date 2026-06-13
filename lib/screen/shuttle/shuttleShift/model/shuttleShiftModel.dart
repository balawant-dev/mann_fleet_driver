class ShuttleShiftModel {
  var status;
  var total;
  var message;
  List<Data>? data;

  ShuttleShiftModel({this.status, this.total, this.message, this.data});

  ShuttleShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    message = json['message'];
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
    data['total'] = this.total;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  var sId;
  ShuttleRoute? shuttleRoute;
  ShuttleRouteShift? shuttleRouteShift;
  var driver;
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
    driver = json['driver'];
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
    data['driver'] = this.driver;
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
  double? lat;
  double? lng;
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
