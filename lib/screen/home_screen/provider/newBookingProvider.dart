import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/screen/fuel_entry/service/open_ai_service.dart';
import 'package:mann_fleet_driver/widget/motionToastHelper.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import '../../../apiservice/services/secure_storage_service.dart';
import '../../../widget/showLoaderFunction.dart';
import 'package:http/http.dart' as http;
import '../../bookingDetail/model/bookingDetailModel.dart';
import '../../bookingDetail/ui/VoiceCallScreen.dart';
import '../../fuel_entry/service/googleGeminiService.dart';
import '../model/bookingAcceptedModel.dart';
import '../model/bookingCancelModel.dart';
import '../model/extra_charges_payment_model.dart';
import '../model/final_fare_preview_model.dart';
import '../model/getBannerModel.dart';
import '../model/newBookingModel.dart';
import '../model/pickupVerificationModel.dart';
import '../model/startTripModel.dart';
import '../model/tripCompleteModel.dart';
import '../model/updateLocationModel.dart';
import '../model/verifyBookingOtpModel.dart';
import '../repo/newBookingRepo.dart';

class NewBookingProvider extends ChangeNotifier {
  final api = NewBookingRepo();

  NewBookingModel? newBookingModel;
  BookingAcceptedModel? bookingAcceptedModel;
  BookingCancelModel? bookingCancelModel;
  VerifyBookingOtpModel? verifyBookingOtpModel;
  StartTripModel? startTripModel;
  GetBannerModel? getBannerModel;
  TripCompleteModel? tripCompleteModel;
  TripExtraPaymentResponse? tripExtraPaymentResponse;
  FinalFarePreviewModel? finalFarePreviewModel;
  UpdateLocationModel? updateLocationModel;
  bool isLoading = false;
  Future<void> callUser({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      showLoader(context);

      final res = await api.initiateVoiceCall(
        context: context,
        bookingId: bookingId,
        initiatedBy: "driver",
      );

      Navigator.pop(context);

      if (res.status == true) {
        navPush(
          context: context,
          action: VoiceCallScreen(
            bookingId: bookingId,
            token: res.data!.token!,
            channelName: res.data!.channelName!,
            uid: res.data!.uid!,
            appId: "b2ec8d246fb3407f8bf76884a32d7a47",
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);

      ToastHelper.show(
        context,
        message: "Unable to start call",
        type: ToastType.error,
      );
    }
  }
  // ── Get pending / assigned bookings ────────────────────────────────────────
  Future<void> getBannerApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getBannerApi(context: context);
      getBannerModel = res;

      if (res != null && res.status == true) {
        debugPrint("getBannerApis fetched successfully");
      } else {
        debugPrint("Failed to fetch getBannerApis");
      }
    } catch (e) {
      debugPrint("Error fetching new bookings: $e");
      // TODO: show error toast/snackbar here
    } finally {
      isLoading = false;
      notifyListeners();
    }
  } // ── Update Location ────────────────────────────────────────

  Future<void> updateDriverLocationApi({
    required BuildContext context,
    required String id,
    required double lat,
    required double lng,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.updateDriverLocationApi(
        context: context,
        lat: lat,
        lng: lng,
        id: id,
      );
      updateLocationModel = res;

      if (res != null && res.status == true) {
        debugPrint("updateLocationModel fetched successfully");
      } else {
        debugPrint("Failed to fetch updateLocationModel");
      }
    } catch (e) {
      debugPrint("Error fetching new bookings: $e");
      // TODO: show error toast/snackbar here
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

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
    required double currentLat,
    required double currentLng,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.acceptBookingApi(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
      );
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
      showLoader(context);
      final res = await api.driverCancelRequest(
        context: context,
        id: id,
        reason: reason,
      );
      navPop(context: context);
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

  Future<bool> driverArrived({
    required BuildContext context,
    required String id,
    required double currentLat,
    required double currentLng,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.driverArrived(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
      );

      if (res != null && res == true) {
        getNewBookingDetail(context: context, id: id);
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

  Future<bool> checkDriverPickupRange({
    required BuildContext context,
    required String id,
    required double currentLat,
    required double currentLng,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.checkDriverPickupRange(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
      );

      if (res != null && res == true) {
        getNewBookingDetail(context: context, id: id);
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
        await getNewBookingDetail(context: context, id: id);
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
  } // ── Complete trip ─────────────────────────────────────────────────────────────

  Future<bool> completeTripApi({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.completeTripApi(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
      );
      tripCompleteModel = res;

      if (res != null && res.status == true) {
        await getNewBookingDetail(context: context, id: id);
        await getNewBooking(context: context);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });

        debugPrint("Complete trip 🎈🎈🎈🎈🎈🎈🎈🎈 for booking $id");
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

  Future<TripExtraPaymentResponse?> payFinalFare({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
    required String durationMins,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.payFinalFare(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
        durationMins: durationMins,
      );
      tripExtraPaymentResponse = res;

      if (res != null && res.status == true) {
        await getNewBookingDetail(context: context, id: id);
        await getNewBooking(context: context);

        debugPrint("Complete trip 🎈🎈🎈🎈🎈🎈🎈🎈 for booking $id");
        return res;
      } else {
        debugPrint("Failed to start trip for booking $id");
        return null;
      }
    } catch (e) {
      debugPrint("Error starting trip $id: $e");
      return null;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> extraPaymentCash({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.extraPaymentCash(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
      );

      if (res != null && res == true) {
        await getNewBookingDetail(context: context, id: id);
        await getNewBooking(context: context);

        debugPrint("Complete trip 🎈🎈🎈🎈🎈🎈🎈🎈 for booking $id");
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

  Future<bool> waiveExtraPayment({
    required BuildContext context,
    required String currentLat,
    required String currentLng,
    required String id,
    required String reason,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.waiveExtraPayment(
        context: context,
        currentLat: currentLat,
        currentLng: currentLng,
        id: id,
        reason: reason,
      );

      if (res != null && res == true) {
        await getNewBookingDetail(context: context, id: id);
        await getNewBooking(context: context);

        debugPrint("Complete trip 🎈🎈🎈🎈🎈🎈🎈🎈 for booking $id");
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

  Future<bool> forcedCompleteBooking({
    required BuildContext context,
    required String id,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.forcedCompleteBooking(context: context, id: id);

      if (res != null && res == true) {
        await getNewBookingDetail(context: context, id: id);
        await getNewBooking(context: context);

        debugPrint("Complete trip 🎈🎈🎈🎈🎈🎈🎈🎈 for booking $id");
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

  Future<FarePreviewData?> checkFinalFare({
    required BuildContext context,
    required String id,
    required String currentLat,
    required String currentLng,
    required String durationMins,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.checkFinalFare(
        context: context,
        id: id,
        currentLat: currentLat,
        currentLng: currentLng,
        durationMins: durationMins,
      );
      finalFarePreviewModel = res;

      if (res != null && res.status == true) {
        return res.data;
      } else {
        debugPrint("Failed to start trip for booking");
        return null;
      }
    } catch (e) {
      debugPrint("Error starting trip: $e");
      return null;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> checkPaymentStatus({
    required BuildContext context,
    required String id,
  }) async {
    try {
      // isLoading = true;
      notifyListeners();

      final res = await api.extraPaymentStatus(context: context, id: id);

      if (res != null && res == "success") {
        ToastHelper.show(context, message: "Payment Success");
        return true;
      } else {
        debugPrint("Failed to start trip for booking");
        return null;
      }
    } catch (e) {
      debugPrint("Error starting trip: $e");
      return null;
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
        type: type,
      );
      verifyBookingOtpModel = res;

      if (res != null && res.status == true) {
        // startTripApi(context: context,id: id);
        getNewBookingDetail(context: context, id: id);
        getNewBooking(context: context);
        debugPrint("OTP verified successfully for booking $id");
        return true;
      } else {
        debugPrint("OTP verification failed for booking $id");
        return false;
      }
    } catch (e) {
      debugPrint("Error verifying OTP for booking $id: $e");
      ToastHelper.show(
        context,
        message: "Invalid OTP: Please Try Again",
        type: ToastType.error,
      );
      return false;
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  final ImagePicker picker = ImagePicker();

  File? front;
  File? back;
  File? left;
  File? right;
  File? interior;
  File? speedometer;
  File? speedometerEndImage;
  TextEditingController speedoMetervalue = TextEditingController();


  Future<void> scanOdometerDisplayWithGemini(
    File imageFile,
    BuildContext context,
  ) async {
    showLoader(context);

    try {
      double reading = await getOdometerReadingFromImageOpenAi(imageFile);

      speedoMetervalue.text = reading.toStringAsFixed(0);
      notifyListeners();

      print("Odometer reading auto-filled successfully!");
    } catch (error) {
      if (context.mounted) {
        speedoMetervalue.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst("Exception: ", "")),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        navPop(context: context);
      }
    }
  }

  Future pickImage(String type, BuildContext context) async {
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    File file = File(picked.path);

    switch (type) {
      case "front":
        front = file;
        break;
      case "back":
        back = file;
        break;
      case "left":
        left = file;
        break;
      case "right":
        right = file;
        break;
      case "interior":
        interior = file;
        break;
      case "speedometer":
        scanOdometerDisplayWithGemini(file, context);
        speedometer = file;
        break;
      case "speedometerEndImage":
        scanOdometerDisplayWithGemini(file, context);
        speedometerEndImage = file;
        break;
    }

    notifyListeners();
  }

  BookingDetailModel? bookingDetailModel;
  PickupVerificationModel? pickupVerificationModel;

  bool isLoading2 = false;

  Future<void> getNewBookingDetail({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isLoading2 = true;
      notifyListeners();

      final res = await api.getBookingDetailApi(context: context, id: id);
      bookingDetailModel = res;
      if (res != null || res.status == true) {
        print("Get Profile Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile4: $e");
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
  }

  Future<void> pickupVerificationApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isLoading2 = true;
      notifyListeners();
      debugPrint("frontViewImage: ${front?.path ?? ""}");
      debugPrint("backViewImage: ${back?.path ?? ""}");
      debugPrint("leftViewImage: ${left?.path ?? ""}");
      debugPrint("rightViewImage: ${right?.path ?? ""}");
      debugPrint("interiorImage: ${interior?.path ?? ""}");
      debugPrint("speedometerImage: ${speedometer?.path ?? ""}");
      debugPrint("speedoMetervalue: ${speedoMetervalue.text}");

      final res = await api.pickupVerificationApi(
        context: context,
        id: id,
        frontViewImage: front?.path ?? "",
        backViewImage: back?.path ?? "",
        leftViewImage: left?.path ?? "",
        rightViewImage: right?.path ?? "",
        interiorImage: interior?.path ?? "",
        speedometerImage: speedometer?.path ?? "",
        speedoMetervalue: speedoMetervalue.text,
      );
      Navigator.pop(context);
      pickupVerificationModel = res;
      if (res.status == true) {
        speedoMetervalue.clear();
        speedometer = null;
      }
      getNewBookingDetail(context: context, id: id);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
  }

  Future<void> speedometerVerification({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isLoading2 = true;
      notifyListeners();
      debugPrint("speedoMetervalue: ${speedoMetervalue.text ?? ""}");
      debugPrint("speedometerImage: ${speedometer?.path ?? ""}");

      final res = await api.speedometerVerification(
        context: context,
        speedoMetervalue: speedoMetervalue.text,
        id: id,

        speedometerImage: speedometerEndImage?.path ?? "",
      );

      pickupVerificationModel = res;
      if (res.status == true) {
        speedoMetervalue.clear();
        speedometer = null;
      }
      getNewBookingDetail(context: context, id: id);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
  }
}
