class AadharVerificationComplteModel {
  final bool status;
  final String message;
  final AadharDetails? data;

  AadharVerificationComplteModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AadharVerificationComplteModel.fromJson(Map<String, dynamic> json) {
    return AadharVerificationComplteModel(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? AadharDetails.fromJson(json['data']) : null,
    );
  }
}

class AadharDetails {
  final String? fullName;
  final String? dob;
  final String? gender;
  final String? address;
  final String? careOf;
  final String? profileImage; // Base64 string or URL
  final String? maskedAadhar;
  final String? clientId; // Important for OTP verification step
  final bool? isVerified;

  AadharDetails({
    this.fullName,
    this.dob,
    this.gender,
    this.address,
    this.careOf,
    this.profileImage,
    this.maskedAadhar,
    this.clientId,
    this.isVerified,
  });

  factory AadharDetails.fromJson(Map<String, dynamic> json) {
    return AadharDetails(
      fullName: json['full_name'],
      dob: json['dob'],
      gender: json['gender'],
      address: json['address'],
      careOf: json['care_of'],
      profileImage: json['profile_image'],
      maskedAadhar: json['masked_aadhar'],
      clientId: json['client_id'],
      isVerified: json['is_verified'] ?? false,
    );
  }
}