import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/corporateBookings/pro/self_fare_model.dart';
import '../../../apiservice/exceptions/app_exceptions.dart';
import '../../../widget/motionToastHelper.dart';
import '../../fuel_entry/service/open_ai_service.dart';
import '../component/corporate_booking_detail_screen.dart';
import '../model/corporate_booking_list_model.dart';
import '../model/corporate_booking_detail_model.dart';
import '../model/self_payment_model.dart';
import '../repo/corporate_booking_repo.dart';
import '../ui/corporate_booking_detail_screen.dart';

class CorporateBookingProvider extends ChangeNotifier {
  final CorporateBookingRepo _repo = CorporateBookingRepo();

  bool isLoading = false;
  bool isDetailLoading = false;
  bool isAccepting = false;
  bool isRejecting = false;
  bool isResponding = false;
// Existing flags ke saath yeh add karo
  bool isVerifyStartOtp = false;
  bool isVerifyEndOtp = false;
  String? errorMessage;
  bool isUploadExpenseImages = false;
  List<CorporateBooking> bookings = [];
  CorporateBookingDetail? bookingDetail;
  bool isGarageStarting = false;
  bool isPickupCheckpoint = false;
  bool isDropCheckpoint = false;
  bool isStartRide = false;
  bool isGarageEnd = false;
  bool isExtraCharge = false;
  bool isCompleteTrip = false;

  // Add these flags
  bool isSelfCalculateFare = false;
  bool isSelfPayOnline = false;
  bool isSelfPayCash = false;
  bool isCheckingPaymentStatus = false;

  // Map<String, dynamic>? selfFareData;      // from calculate-fare
  Map<String, dynamic>? selfOnlinePayData; // qr / payment link
  bool isSelfPaymentDone = false;

// ==================== SELF METHODS ====================

// pehle yeh tha
// Map<String, dynamic>? selfFareData;

  SelfFareData2? selfFareData;
  // ← ab model use karo
  SelfPaymentModel?selfOnlinePaymentModel;
String paymentStatusCheck="pending";
  Future<bool> selfCalculateFareApi({
    required BuildContext context,
    required String bookingId,
    double? garageLat,
    double? garageLng,
    String? garageAddress,
  }) async {
    isSelfCalculateFare = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _repo.selfCalculateFare(
        context: context,
        bookingId: bookingId,
        garageLat: garageLat,
        garageLng: garageLng,
        garageAddress: garageAddress,
      );

      if (response != null && response.status && response.data != null) {
        selfFareData = response.data;
        await fetchBookingDetail(context, bookingId);
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e is ApiException ? e.message : e.toString();
      return false;
    } finally {
      isSelfCalculateFare = false;
      notifyListeners();
    }
  }
  Future<bool> selfPayOnlineApi({
    required BuildContext context,
    required String bookingId,
  }) async {
    isSelfPayOnline = true;
    errorMessage = null;
    selfOnlinePaymentModel = null;
    notifyListeners();

    try {
      final data = await _repo.selfPayOnline(context: context, bookingId: bookingId);
      if (data != null) {
        selfOnlinePaymentModel = data;
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e is ApiException ? e.message : e.toString();
      return false;
    } finally {
      isSelfPayOnline = false;
      notifyListeners();
    }
  }

  Future<bool> selfPayCashApi({
    required BuildContext context,
    required String bookingId,
  }) async {
    isSelfPayCash = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.selfPayCash(context: context, bookingId: bookingId);
      if (success) {
        isSelfPaymentDone = true;
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      errorMessage = e is ApiException ? e.message : e.toString();
      return false;
    } finally {
      isSelfPayCash = false;
      notifyListeners();
    }
  }

  Future<bool> checkSelfPaymentStatus({
    required BuildContext context,
    required String bookingId,
  }) async {
    isCheckingPaymentStatus = true;
    notifyListeners();

    try {
      final response = await _repo.getSelfPaymentStatus(
        context: context,
        bookingId: bookingId,
      );

      if (response != null) {
        final paymentData = response['data'] as Map<String, dynamic>?;

        final paymentState = (
            paymentData?['paymentState'] ??
                response['paymentState'] ??
                response['paymentStatus'] ??
                ''
        ).toString().toLowerCase();
        paymentStatusCheck=paymentState;
        if (paymentState == 'paid') {
          isSelfPaymentDone = true;

          await fetchBookingDetail(context, bookingId);
          return true;
        } else if (paymentState == 'pending') {
          isSelfPaymentDone = false;
          return false;
        }
      }

      isSelfPaymentDone = false;
      return false;
    } catch (e) {
      debugPrint('Check self payment status error: $e');
      return false;
    } finally {
      isCheckingPaymentStatus = false;
      notifyListeners();
    }
  }
  Future<bool> uploadExpenseImages({
    required BuildContext context,
    required String bookingId,
    required List<File> expenseImages,
  }) async {
    isUploadExpenseImages = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.uploadExpenseImages(
        context: context,
        bookingId: bookingId,
        expenseImages: expenseImages,
      );

      if (success) {
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isUploadExpenseImages = false;
      notifyListeners();
    }
  }
  Future<bool> verifyStartOtp({
    required BuildContext context,
    required String bookingId,
    required String otp,
  }) async {
    isVerifyStartOtp = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.verifyStartOtp(
        context: context,
        bookingId: bookingId,
        otp: otp,
      );

      if (success) {
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isVerifyStartOtp = false;
      notifyListeners();
    }
  }

  Future<bool> verifyEndOtp({
    required BuildContext context,
    required String bookingId,
    required String otp,
  }) async {
    isVerifyEndOtp = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.verifyEndOtp(
        context: context,
        bookingId: bookingId,
        otp: otp,
      );

      if (success) {
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isVerifyEndOtp = false;
      notifyListeners();
    }
  }

  Future<bool> extraChargeApi({
    required BuildContext context,
    required String bookingId,
    required String parkingCharge,
    required String tollAmount,
    required String stateCharge,
    required String otherCharges,
  }) async {
    isExtraCharge = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.extraChargeApi(
        context: context,
        bookingId: bookingId,
        stateCharge: stateCharge,
        parkingCharge: parkingCharge,
        otherCharges: otherCharges,
        tollAmount: tollAmount,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isExtraCharge = false;
      notifyListeners();
    }
  }

  Future<bool> completeTripApi({
    required BuildContext context,
    required String bookingId,
  }) async {
    isCompleteTrip = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.completeTripApi(
        context: context,
        bookingId: bookingId,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isCompleteTrip = false;
      notifyListeners();
    }
  }

  Future<bool> garageStart({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    isGarageStarting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.garageStart(
        context: context,
        bookingId: bookingId,
        odometer: odometer,
        currentLat: currentLat,
        currentLng: currentLng,
        odometerImage: odometerImage,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isGarageStarting = false;
      notifyListeners();
    }
  }

  Future<bool> garageEndApi({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    isGarageEnd = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.garageEndApi(
        context: context,
        bookingId: bookingId,
        odometer: odometer,
        currentLat: currentLat,
        currentLng: currentLng,
        odometerImage: odometerImage,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isGarageEnd = false;
      notifyListeners();
    }
  }

  Future<bool> pickupCheckpoint({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    isPickupCheckpoint = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.pickupCheckpoint(
        context: context,
        bookingId: bookingId,
        odometer: odometer,
        currentLat: currentLat,
        currentLng: currentLng,
        odometerImage: odometerImage,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isPickupCheckpoint = false;
      notifyListeners();
    }
  }

  Future<bool> dropCheckpoint({
    required BuildContext context,
    required String bookingId,
    required String odometer,
    required double currentLat,
    required double currentLng,
    required File odometerImage,
  }) async {
    isDropCheckpoint = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.dropCheckpoint(
        context: context,
        bookingId: bookingId,
        odometer: odometer,
        currentLat: currentLat,
        currentLng: currentLng,
        odometerImage: odometerImage,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isDropCheckpoint = false;
      notifyListeners();
    }
  }

  Future<bool> startRide({
    required BuildContext context,
    required String bookingId,
  }) async {
    isStartRide = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.startRide(
        context: context,
        bookingId: bookingId,
      );

      if (success) {
        // Refresh detail after success
        await fetchBookingDetail(context, bookingId);
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isStartRide = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookings(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.getCorporateBookings(context: context);
      bookings = result.data;
    } catch (e) {
      errorMessage = e.toString();
      bookings = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookingDetail(BuildContext context, String id) async {
    isDetailLoading = true;
    errorMessage = null;
    bookingDetail = null;
    notifyListeners();

    try {
      final result = await _repo.getCorporateBookingDetail(
        context: context,
        id: id,
      );
      bookingDetail = result.data;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  /// Accept booking – needs current lat/lng
  Future<bool> acceptBooking({
    required BuildContext context,
    required String bookingId,
    required double currentLat,
    required double currentLng,
  }) async {
    isAccepting = true;
    isResponding = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.acceptToBooking(
        context: context,
        bookingId: bookingId,
        currentLat: currentLat,
        currentLng: currentLng,
      );

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CorporateBookingDetailScreen(bookingId: bookingId),
          ),
        );
        // Refresh detail after success
        // await fetchBookingDetail(context, bookingId);
      }
      return success;

      // if (success) {
      //   // Remove from list after successful accept
      //   final index = bookings.indexWhere((b) => b.id == bookingId);
      //   if (index != -1) {
      //     bookings.removeAt(index);
      //   }
      //   // Also update detail if open
      //   if (bookingDetail?.id == bookingId) {
      //     // optionally refresh detail or just mark accepted
      //   }
      //   notifyListeners();
      // }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isAccepting = false;
      isResponding = false;
      notifyListeners();
    }
  }

  /// Reject – temporary (you will update repo later)
  Future<bool> rejectBooking(BuildContext context, String bookingId) async {
    isRejecting  = true;
    isResponding  = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await _repo.respondToBooking(
        context: context,
        bookingId: bookingId,
        status: "rejected",
      );

      if (success) {
        final index = bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          bookings.removeAt(index);
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (e is ApiException) {
        errorMessage = e.message; // clean message
      } else {
        errorMessage = e.toString();
      }
      return false;
    } finally {
      isRejecting  = false;
      isResponding  = false;
      notifyListeners();
    }
  }

  // CorporateBookingProvider ke andar add karo

  final TextEditingController odometerController = TextEditingController();
  File? selectedOdometerImage;

  Future<void> scanOdometerAndPrefill(File imageFile, BuildContext context) async {
    try {
      // yahan wohi function use karo jo normal booking me use ho raha hai
      // Example: getOdometerReadingFromImageOpenAi  OR  Gemini wala
      final double reading = await getOdometerReadingFromImageOpenAi(imageFile);

      odometerController.text = reading.toStringAsFixed(0);
      notifyListeners();
    } catch (e) {
      odometerController.clear();
      if (context.mounted) {
        ToastHelper.show(
          context,
          message: e.toString().replaceFirst("Exception: ", ""),
          type: ToastType.error,
        );
      }
    }
  }
}
