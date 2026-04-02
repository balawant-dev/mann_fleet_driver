class FuelEntryModel {
  FuelEntry? fuelEntry;
  bool? status;
  String? message;

  FuelEntryModel({this.fuelEntry, this.status, this.message});

  FuelEntryModel.fromJson(Map<String, dynamic> json) {
    fuelEntry = json['fuelEntry'] != null
        ? new FuelEntry.fromJson(json['fuelEntry'])
        : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fuelEntry != null) {
      data['fuelEntry'] = this.fuelEntry!.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class FuelEntry {
  String? vehicleId;
  String? driverId;
  String? fuelType;
  double? fuelQuantity;
  double? pricePerLiter;
  double? totalAmount;
  String? fuelStationName;
  Location? location;
  int? odometerReading;
  String? paymentMode;
  String? transactionId;
  String? date;
  String? time;
  String? notes;

  FuelEntry(
      {this.vehicleId,
        this.driverId,
        this.fuelType,
        this.fuelQuantity,
        this.pricePerLiter,
        this.totalAmount,
        this.fuelStationName,
        this.location,
        this.odometerReading,
        this.paymentMode,
        this.transactionId,
        this.date,
        this.time,
        this.notes});

  FuelEntry.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicleId'];
    driverId = json['driverId'];
    fuelType = json['fuelType'];
    fuelQuantity = json['fuelQuantity'];
    pricePerLiter = json['pricePerLiter'];
    totalAmount = json['totalAmount'];
    fuelStationName = json['fuelStationName'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    odometerReading = json['odometerReading'];
    paymentMode = json['paymentMode'];
    transactionId = json['transactionId'];
    date = json['date'];
    time = json['time'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleId'] = this.vehicleId;
    data['driverId'] = this.driverId;
    data['fuelType'] = this.fuelType;
    data['fuelQuantity'] = this.fuelQuantity;
    data['pricePerLiter'] = this.pricePerLiter;
    data['totalAmount'] = this.totalAmount;
    data['fuelStationName'] = this.fuelStationName;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['odometerReading'] = this.odometerReading;
    data['paymentMode'] = this.paymentMode;
    data['transactionId'] = this.transactionId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['notes'] = this.notes;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;
  String? address;

  Location({this.latitude, this.longitude, this.address});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    return data;
  }
}
