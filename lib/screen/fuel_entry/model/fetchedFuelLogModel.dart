class FetchedFuelLogModel {
  bool? status;
 var totalResult;
 var totalPage;
 var currentPage;
  var message;
  List<FuelLogData>? data;

  FetchedFuelLogModel(
      {this.status,
        this.totalResult,
        this.totalPage,
        this.currentPage,
        this.message,
        this.data});

  FetchedFuelLogModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    currentPage = json['currentPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FuelLogData>[];
      json['data'].forEach((v) {
        data!.add(new FuelLogData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    data['currentPage'] = this.currentPage;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FuelLogData {
  var sId;
  Vehicle? vehicle;
  var driver;
  var carNumber;
  var fuelType;
  var locationAddress;
  var locationLat;
  var locationLng;
 var odometerReading;
 var currentVechicleAverage;
 var actualAverage;
  var odometerMeterImage;
  var odometerAfterFuelImage;
 var fuelQuantity;
  var startFuelMeterImage;
  var endFuelMeterImage;
  var invoiceNumber;
 var fuelAmount;
  bool? isTankFull;
  var paymentSource;
 var fuelPrice;
  var billImage;
  var date;
  var createdAt;
 var iV;

  FuelLogData(
      {this.sId,
        this.vehicle,
        this.driver,
        this.carNumber,
        this.fuelType,
        this.locationAddress,
        this.locationLat,
        this.locationLng,
        this.odometerReading,
        this.currentVechicleAverage,
        this.actualAverage,
        this.odometerMeterImage,
        this.odometerAfterFuelImage,
        this.fuelQuantity,
        this.startFuelMeterImage,
        this.endFuelMeterImage,
        this.invoiceNumber,
        this.fuelAmount,
        this.isTankFull,
        this.paymentSource,
        this.fuelPrice,
        this.billImage,
        this.date,
        this.createdAt,
        this.iV});

  FuelLogData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    driver = json['driver'];
    carNumber = json['carNumber'];
    fuelType = json['fuelType'];
    locationAddress = json['locationAddress'];
    locationLat = json['locationLat'];
    locationLng = json['locationLng'];
    odometerReading = json['odometerReading'];
    currentVechicleAverage = json['currentVechicleAverage'];
    actualAverage = json['actualAverage'];
    odometerMeterImage = json['odometerMeterImage'];
    odometerAfterFuelImage = json['odometerAfterFuelImage'];
    fuelQuantity = json['fuelQuantity'];
    startFuelMeterImage = json['startFuelMeterImage'];
    endFuelMeterImage = json['endFuelMeterImage'];
    invoiceNumber = json['invoiceNumber'];
    fuelAmount = json['fuelAmount'];
    isTankFull = json['isTankFull'];
    paymentSource = json['paymentSource'];
    fuelPrice = json['fuelPrice'];
    billImage = json['billImage'];
    date = json['date'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    data['driver'] = this.driver;
    data['carNumber'] = this.carNumber;
    data['fuelType'] = this.fuelType;
    data['locationAddress'] = this.locationAddress;
    data['locationLat'] = this.locationLat;
    data['locationLng'] = this.locationLng;
    data['odometerReading'] = this.odometerReading;
    data['currentVechicleAverage'] = this.currentVechicleAverage;
    data['actualAverage'] = this.actualAverage;
    data['odometerMeterImage'] = this.odometerMeterImage;
    data['odometerAfterFuelImage'] = this.odometerAfterFuelImage;
    data['fuelQuantity'] = this.fuelQuantity;
    data['startFuelMeterImage'] = this.startFuelMeterImage;
    data['endFuelMeterImage'] = this.endFuelMeterImage;
    data['invoiceNumber'] = this.invoiceNumber;
    data['fuelAmount'] = this.fuelAmount;
    data['isTankFull'] = this.isTankFull;
    data['paymentSource'] = this.paymentSource;
    data['fuelPrice'] = this.fuelPrice;
    data['billImage'] = this.billImage;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Vehicle {
  var sId;
  var brand;
  var model;
  var carNumber;

  Vehicle({this.sId, this.brand, this.model, this.carNumber});

  Vehicle.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    brand = json['brand'];
    model = json['model'];
    carNumber = json['carNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['carNumber'] = this.carNumber;
    return data;
  }
}
