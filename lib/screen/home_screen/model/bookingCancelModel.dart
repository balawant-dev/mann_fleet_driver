class BookingCancelModel {
  bool? status;
  String? message;
  Data? data;

  BookingCancelModel({this.status, this.message, this.data});

  BookingCancelModel.fromJson(Map<String, dynamic> json) {
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
  String? cancelRequestId;
  String? bookingId;
  String? bookingNumber;
  String? reason;
  String? status;
  String? requestedAt;

  Data(
      {this.cancelRequestId,
        this.bookingId,
        this.bookingNumber,
        this.reason,
        this.status,
        this.requestedAt});

  Data.fromJson(Map<String, dynamic> json) {
    cancelRequestId = json['cancelRequestId'];
    bookingId = json['bookingId'];
    bookingNumber = json['bookingNumber'];
    reason = json['reason'];
    status = json['status'];
    requestedAt = json['requestedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancelRequestId'] = this.cancelRequestId;
    data['bookingId'] = this.bookingId;
    data['bookingNumber'] = this.bookingNumber;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['requestedAt'] = this.requestedAt;
    return data;
  }
}
