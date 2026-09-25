import 'dart:io';

import 'package:flutter/material.dart';
import '../../../apiservice/exceptions/app_exceptions.dart';
import '../../../widget/motionToastHelper.dart';
import '../../fuel_entry/service/open_ai_service.dart';
import '../model/corporate_booking_list_model.dart';
import '../model/corporate_booking_detail_model.dart';
import '../repo/corporate_booking_repo.dart';
import '../ui/corporate_booking_detail_screen.dart';

class CorporateBookingProvider extends ChangeNotifier {
  final CorporateBookingRepo _repo = CorporateBookingRepo();

  bool isLoading = false;
  bool isDetailLoading = false;
  bool isAccepting = false;
  bool isRejecting = false;
  bool isResponding = false;

  String? errorMessage;

  List<CorporateBooking> bookings = [];
  CorporateBookingDetail? bookingDetail;
  bool isGarageStarting = false;
  bool isPickupCheckpoint = false;
  bool isDropCheckpoint = false;
  bool isStartRide = false;
  bool isGarageEnd = false;
  bool isExtraCharge = false;
  bool isCompleteTrip = false;

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
