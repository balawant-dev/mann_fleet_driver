
class SelfPaymentModel {
  final bool status;
  final String message;
  final SelfPaymentData? data;

  SelfPaymentModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory SelfPaymentModel.fromJson(Map<String, dynamic> json) {
    return SelfPaymentModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SelfPaymentData.fromJson(
        json['data'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SelfPaymentData {
  final String bookingId;
  final String bookingNumber;
  final SelfPaymentOrder? selfPaymentOrder;
  final String note;

  SelfPaymentData({
    required this.bookingId,
    required this.bookingNumber,
    this.selfPaymentOrder,
    required this.note,
  });

  factory SelfPaymentData.fromJson(Map<String, dynamic> json) {
    return SelfPaymentData(
      bookingId: json['bookingId'] ?? '',
      bookingNumber: json['bookingNumber'] ?? '',
      selfPaymentOrder: json['selfPaymentOrder'] != null
          ? SelfPaymentOrder.fromJson(
        json['selfPaymentOrder'] as Map<String, dynamic>,
      )
          : null,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'bookingNumber': bookingNumber,
      'selfPaymentOrder': selfPaymentOrder?.toJson(),
      'note': note,
    };
  }
}

class SelfPaymentOrder {
  final String orderId;
  final int amount;
  final String currency;
  final String key;
  final String paymentLink;
  final String qrCodeUrl;
  final String? qrCodeId;

  SelfPaymentOrder({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.key,
    required this.paymentLink,
    required this.qrCodeUrl,
    this.qrCodeId,
  });

  factory SelfPaymentOrder.fromJson(Map<String, dynamic> json) {
    return SelfPaymentOrder(
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      currency: json['currency'] ?? '',
      key: json['key'] ?? '',
      paymentLink: json['paymentLink'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
      qrCodeId: json['qrCodeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'key': key,
      'paymentLink': paymentLink,
      'qrCodeUrl': qrCodeUrl,
      'qrCodeId': qrCodeId,
    };
  }
}
