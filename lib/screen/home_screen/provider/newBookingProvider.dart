//
// import 'package:flutter/material.dart';
//
//
//
// import '../model/bookingAcceptedModel.dart';
// import '../model/bookingCancelModel.dart';
// import '../model/newBookingModel.dart';
// import '../model/startTripModel.dart';
// import '../model/verifyBookingOtpModel.dart';
// import '../repo/newBookingRepo.dart';
//
//
//
// class NewBookingProvider extends ChangeNotifier {
//   final api = NewBookingRepo();
//
//   NewBookingModel? newBookingModel;
//   BookingAcceptedModel? bookingAcceptedModel;
//   BookingCancelModel? bookingCancelModel;
//   VerifyBookingOtpModel? verifyBookingOtpModel;
//   StartTripModel?startTripModel;
//
//
//   bool isLoading = false;
//
//   Future<void> getNewBooking({required BuildContext context}) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final res = await api.getNewBooking( context: context);
//       newBookingModel = res;
//       if(res!=null||res.status==true){
//         print("Get Profile Successfully");
//       }
//
//     } catch (e) {
//       debugPrint("Error in Get Profile: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//
//   }  Future<void> acceptBookingApi({required BuildContext context,required String id}) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final res = await api.acceptBookingApi( context: context,id: id);
//       bookingAcceptedModel = res;
//       if(res!=null||res.status==true){
//         print("Get acceptBookingApi Successfully");
//       }
//
//     } catch (e) {
//       debugPrint("Error in Get Profile: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//
//   }
//   Future<void> driverCancelApi({required BuildContext context,required String id ,required String reason}) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final res = await api.driverCancelRequest(
//           context: context, id: id, reason: reason);
//       bookingCancelModel = res;
//       if (res != null || res.status == true) {
//         print("Get Profile Successfully");
//       }
//     } catch (e) {
//       debugPrint("Error in Get Profile: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//
//     Future<void> startTripApi(
//         {required BuildContext context, required String id }) async {
//       try {
//         isLoading = true;
//         notifyListeners();
//
//         final res = await api.startTripApi(context: context, id: id);
//         startTripModel = res;
//         if (res != null || res.status == true) {
//           print("Get Profile Successfully");
//         }
//       } catch (e) {
//         debugPrint("Error in Get Profile: $e");
//       } finally {
//         isLoading = false;
//         notifyListeners();
//       }
//     }
//
//
//     Future<void> verifyBookingOtpApi(
//         {required BuildContext context, required String id, required String otp}) async {
//       try {
//         isLoading = true;
//         notifyListeners();
//
//         final res = await api.verifyBookingOtpApi(
//             context: context, id: id, otp: otp);
//         startTripModel = res;
//         if (res != null || res.status == true) {
//           print("Get Profile Successfully");
//         }
//       } catch (e) {
//         debugPrint("Error in Get Profile: $e");
//       } finally {
//         isLoading = false;
//         notifyListeners();
//       }
//     }
//   }
//
import 'package:flutter/material.dart';
import '../model/bookingAcceptedModel.dart';
import '../model/bookingCancelModel.dart';
import '../model/newBookingModel.dart';
import '../model/startTripModel.dart';
import '../model/verifyBookingOtpModel.dart';
import '../repo/newBookingRepo.dart';

class NewBookingProvider extends ChangeNotifier {
  final api = NewBookingRepo();

  NewBookingModel? newBookingModel;
  BookingAcceptedModel? bookingAcceptedModel;
  BookingCancelModel? bookingCancelModel;
  VerifyBookingOtpModel? verifyBookingOtpModel;
  StartTripModel? startTripModel;

  bool isLoading = false;

  // ── Get pending / assigned bookings ────────────────────────────────────────
  Future<void> getNewBooking({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getNewBooking(context: context);
      newBookingModel = res;

      if (res != null && res.status == true) {
        debugPrint("New bookings fetched successfully");
      } else {
        debugPrint("Failed to fetch new bookings");
      }
    } catch (e) {
      debugPrint("Error fetching new bookings: $e");
      // TODO: show error toast/snackbar here
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Accept booking ─────────────────────────────────────────────────────────
  Future<bool> acceptBookingApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.acceptBookingApi(context: context, id: id);
      bookingAcceptedModel = res;

      if (res != null && res.status == true) {
        getNewBooking(context: context);
        debugPrint("Booking $id accepted successfully");
        return true;
      } else {
        debugPrint("Failed to accept booking $id");
        return false;
      }
    } catch (e) {
      debugPrint("Error accepting booking $id: $e");
      return false;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  // ── Driver cancel request ──────────────────────────────────────────────────
  Future<bool> driverCancelApi({
    required BuildContext context,
    required String id,
    required String reason,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.driverCancelRequest(
        context: context,
        id: id,
        reason: reason,
      );
      bookingCancelModel = res;

      if (res != null && res.status == true) {
        getNewBooking(context: context);
        debugPrint("Booking $id cancelled successfully");
        return true;
      } else {
        debugPrint("Failed to cancel booking $id");
        return false;
      }
    } catch (e) {
      debugPrint("Error cancelling booking $id: $e");
      return false;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  // ── Start trip ─────────────────────────────────────────────────────────────
  Future<bool> startTripApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.startTripApi(context: context, id: id);
      startTripModel = res;

      if (res != null && res.status == true) {
        getNewBooking(context: context);
        debugPrint("Trip started successfully for booking $id");
        return true;
      } else {
        debugPrint("Failed to start trip for booking $id");
        return false;
      }
    } catch (e) {
      debugPrint("Error starting trip $id: $e");
      return false;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  // ── Verify OTP ─────────────────────────────────────────────────────────────
  Future<bool> verifyBookingOtpApi({
    required BuildContext context,
    required String id,
    required String otp,
    required String type,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.verifyBookingOtpApi(
        context: context,
        id: id,
        otp: otp,
        type:type //type value ["start", "end"]'


      );
      verifyBookingOtpModel = res; // ← fixed: was startTripModel

      if (res != null && res.status == true) {
        // startTripApi(context: context,id: id);
        getNewBooking(context: context);
        debugPrint("OTP verified successfully for booking $id");
        return true;
      } else {
        debugPrint("OTP verification failed for booking $id");
        return false;
      }
    } catch (e) {
      debugPrint("Error verifying OTP for booking $id: $e");
      return false;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }
}