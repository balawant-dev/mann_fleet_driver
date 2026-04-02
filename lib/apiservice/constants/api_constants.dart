class ApiConstants {
  //Live Url
  // static const String baseUrl = 'https://maan.ablagro.in';
  static const String baseUrl = 'https://admin.mannfleetpartners.com';
  // static const String baseUrl = 'http://159.89.146.245:9020';



  static const String verifyOtp = '/api/driver/verifyOtp';

  static const String signUp = '/api/driver/signUp';
  // static const String banner = '/api/driver/banner';
  static const String bookingEstimate = '/api/driver/bookingEstimate';
  static const String booking = '/api/driver/booking';
  static const String profile = '/api/driver/profile';
  static const String fuelLogs = '/api/driver/fuelLogs';
  static const String getMyAssignedBookings = '/api/driver/getMyAssignedBookings';
  static const String banner = '/api/driver/banner?type=driver';
  static const String acceptBooking = '/api/driver/acceptBooking';
  static const String startTrip = '/api/driver/startTrip';
  static const String verifyBookingOtp = '/api/driver/verifyBookingOtp';
  static const String driverCancelRequest = '/api/driver/driverCancelRequest';
  static const String bookingDetail = '/api/driver/booking';
  static const String bookingHistory = '/api/driver/bookingHistory';
  static const String notifications = '/api/driver/notifications';
  static const String pickupVerification = '/api/driver/pickupVerification';
  static const String vehicle = '/api/driver/vehicle';
  static const String segment = '/api/driver/segment';
  static const String termsConditions = '/api/driver/termsConditions';
  static const String privacyPolicy = '/api/driver/privacyPolicy';
  static const String punchIn = '/api/driver/punch/in';
  static const String punchOut = '/api/driver/punch/out';
  static const String punchStatus = '/api/driver/punch/status';
  static const String punchHistory = '/api/driver/punch/history';
  static const String punchMyPunchRegion = '/api/driver/punch/myPunchRegion';

  static const String aboutUs = '/api/driver/aboutUs';
  static const String refundPolicy = '/api/driver/refundPolicy';

  static const String resendOtp = '/api/v1/driver/resend-otp';
  static const String update = '/api/v1/driver/update';
  static const String dashboardEndpoint = 'dashboard';
  static const String settingsEndpoint = 'settings';
  static const String uploadEndpoint = 'upload';
  static const token = "auth_token";
  static const onboardingComplete = "onboarding_complete";
  static const String tokenKey = 'token';
  static const String isAgentKey = 'isAgent';
  static const String isUserKey = 'isUser';
  static const String saveUserType = 'saveUserType';
  static const String gemini = 'gemini';
}
