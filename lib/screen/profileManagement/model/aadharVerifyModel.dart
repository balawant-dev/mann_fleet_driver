// class AadharVerifyModel {
//   final bool success;
//   final int statusCode;
//   final String message;
//   final AadharData? data;
//
//   AadharVerifyModel({
//     required this.success,
//     required this.statusCode,
//     required this.message,
//     this.data,
//   });
//
//   factory AadharVerifyModel.fromJson(Map<String, dynamic> json) {
//     return AadharVerifyModel(
//       success: json['success'] ?? false,
//       statusCode: json['status_code'] ?? 0,
//       message: json['message'] ?? '',
//       data: json['data'] != null ? AadharData.fromJson(json['data']) : null,
//     );
//   }
// }
//
// class AadharData {
//   String? url;
//   String? clientId;
//
//   AadharData({
//     this.url,
//     this.clientId,
//   });
//
//   factory AadharData.fromJson(Map<String, dynamic> json) {
//     return AadharData(
//       url: json['url'],
//       clientId: json['clientId'],
//     );
//   }
// }



class AadharVerifyModel {
  bool? status;
  String? message;
  bool? requiresManualConsent;
  AadharData? data;

  AadharVerifyModel(
      {this.status, this.message, this.requiresManualConsent, this.data});

  AadharVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    requiresManualConsent = json['requires_manual_consent'];
    data = json['data'] != null ? new AadharData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['requires_manual_consent'] = this.requiresManualConsent;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AadharData {
  String? clientId;
  String? digilockerUrl;
  int? expiresInSeconds;
  String? expiresAt;

  AadharData(
      {this.clientId,
        this.digilockerUrl,
        this.expiresInSeconds,
        this.expiresAt});

  AadharData.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    digilockerUrl = json['digilockerUrl'];
    expiresInSeconds = json['expiresInSeconds'];
    expiresAt = json['expiresAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientId'] = this.clientId;
    data['digilockerUrl'] = this.digilockerUrl;
    data['expiresInSeconds'] = this.expiresInSeconds;
    data['expiresAt'] = this.expiresAt;
    return data;
  }
}
