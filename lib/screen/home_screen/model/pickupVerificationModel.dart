class PickupVerificationModel {
  bool? status;
  String? message;
  Data? data;

  PickupVerificationModel({this.status, this.message, this.data});

  PickupVerificationModel.fromJson(Map<String, dynamic> json) {
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
  String? bookingId;
  String? driverId;
  String? frontViewImage;
  String? backViewImage;
  String? leftViewImage;
  String? rightViewImage;
  String? interiorImage;
  String? speedometerImage;
  String? submittedAt;
  String? status;

  Data(
      {this.bookingId,
        this.driverId,
        this.frontViewImage,
        this.backViewImage,
        this.leftViewImage,
        this.rightViewImage,
        this.interiorImage,
        this.speedometerImage,
        this.submittedAt,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    driverId = json['driverId'];
    frontViewImage = json['frontViewImage'];
    backViewImage = json['backViewImage'];
    leftViewImage = json['leftViewImage'];
    rightViewImage = json['rightViewImage'];
    interiorImage = json['interiorImage'];
    speedometerImage = json['speedometerImage'];
    submittedAt = json['submittedAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['driverId'] = this.driverId;
    data['frontViewImage'] = this.frontViewImage;
    data['backViewImage'] = this.backViewImage;
    data['leftViewImage'] = this.leftViewImage;
    data['rightViewImage'] = this.rightViewImage;
    data['interiorImage'] = this.interiorImage;
    data['speedometerImage'] = this.speedometerImage;
    data['submittedAt'] = this.submittedAt;
    data['status'] = this.status;
    return data;
  }
}
