import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/widget/motionToastHelper.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import '../../../widget/showLoaderFunction.dart';
import 'package:http/http.dart' as http;
import '../../bookingDetail/model/bookingDetailModel.dart';
import '../model/bookingAcceptedModel.dart';
import '../model/bookingCancelModel.dart';
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
  FinalFarePreviewModel? finalFarePreviewModel;
  UpdateLocationModel? updateLocationModel;
  bool isLoading = false;

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
        type: type, //type value ["start", "end"]'
      );
      verifyBookingOtpModel = res; // ← fixed: was startTripModel

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

  final apiKey = "AIzaSyA2X6HG6ZE2pzrykNypPtoQ-KJR67gpWjM";
  Future<void> scanOdometerDisplayWithGemini(
    File imageFile,
    BuildContext context,
  ) async {
    try {
      showLoader(context);
      print("START ODOMETER OCR");

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final uri = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
      );

      int retry = 0;
      http.Response? response;

      /// RETRY FOR 503
      while (retry < 3) {
        response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {
                    "text": """
You are an odometer OCR validator.

RULES:
- Extract odometer reading if visible.
- Accept dashboard photos, meter photos, and dashboard screenshots.
- If image is unrelated or no odometer is visible, return error JSON.
- If digits are partially visible, return the best possible reading.
- Return ONLY valid JSON.
- No markdown.
- No explanation.

If valid odometer:
{
  "success": true,
  "km_reading": 12345
}

If invalid image:
{
  "success": false,
  "error": "Invalid odometer image"
}
""",
                  },
                  {
                    "inline_data": {
                      "mime_type": "image/jpeg",
                      "data": base64Image,
                    },
                  },
                ],
              },
            ],
            "generationConfig": {"temperature": 0},
          }),
        );

        print("STATUS => ${response.statusCode}");

        /// HANDLE 503
        if (response.statusCode == 503) {
          retry++;

          print("503 HEAVY USAGE RETRY => $retry");

          await Future.delayed(Duration(seconds: 2 * retry));

          continue;
        }

        break;
      }

      if (response == null) {
        print("NO RESPONSE");
        return;
      }

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String rawText =
            data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "";

        print("RAW => $rawText");

        /// CLEAN RESPONSE
        String cleaned =
            rawText
                .replaceAll("```json", "")
                .replaceAll("```", "")
                .replaceAll("\n", "")
                .trim();

        Map<String, dynamic> jsonData = {};

        try {
          jsonData = jsonDecode(cleaned);
        } catch (e) {
          print("JSON PARSE ERROR => $e");

          final regex = RegExp(r'\{.*\}');
          final match = regex.firstMatch(rawText);

          if (match != null) {
            jsonData = jsonDecode(match.group(0)!);
          }
        }

        /// STRICT VALIDATION
        bool success = jsonData["success"] == true;

        if (!success) {
          speedoMetervalue.clear();

          print("INVALID ODOMETER IMAGE");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Only odometer images are allowed")),
          );

          return;
        }

        double kmReading =
            double.tryParse(jsonData["km_reading"].toString()) ?? 0;

        if (kmReading <= 0) {
          speedoMetervalue.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Odometer reading not detected")),
          );

          return;
        }

        speedoMetervalue.text = kmReading.toStringAsFixed(0);

        print("AUTO FILL DONE");

        notifyListeners();
      } else {
        print("ERROR RESPONSE => ${response.body}");

        ToastHelper.show(
          context,
          message:
              response.statusCode == 503
                  ? "Server busy. Try again."
                  : "Failed to scan odometer",
        );
      }
    } catch (e) {
      print("OCR ERROR => $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    } finally {
      navPop(context: context);
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
      debugPrint("Error in Get Profile: $e");
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
