class SignInModel {
  bool? status;
  String? message;
  Data? data;
  bool? newDriver;

  SignInModel({this.status, this.message, this.data, this.newDriver});

  SignInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    newDriver = json['newDriver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['newDriver'] = this.newDriver;
    return data;
  }
}

class Data {
  String? phone;
  String? email;
  String? otpExpiry;
  String? driverId;
  String? type;

  Data({this.phone, this.email, this.otpExpiry, this.driverId, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    otpExpiry = json['otpExpiry'];
    driverId = json['driverId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['otpExpiry'] = this.otpExpiry;
    data['driverId'] = this.driverId;
    data['type'] = this.type;
    return data;
  }
}
