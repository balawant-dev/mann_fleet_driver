import 'package:flutter/material.dart';

import '../model/qrScanSucessModel.dart';
import '../repo/qrScanRepo.dart';

class QrScanProvider extends ChangeNotifier {
  final api = QrScanRepo();

  QrScanSuccessModel? qrScanSuccessModel;
  String? errorMessage; // ✅ NEW
  bool isLoading = false;

  // ── Get pending / assigned bookings ────────────────────────────────────────
  Future<void> postQrApi({
    required BuildContext context,
    required String qrToken,
    required String currentStopName,
    required String shiftId,
    required String travelDirection,
  }) async {
    try {
      isLoading = true;
      errorMessage = null; // reset
      notifyListeners();

      final res = await api.postQrApi(
        context: context,
        travelDirection: travelDirection,
        shiftId: shiftId,
        qrToken: qrToken,
        currentStopName: currentStopName,
      );

      if (res != null && res.status == true) {
        qrScanSuccessModel = res;
      } else {
        qrScanSuccessModel = null;
        errorMessage = res.message ?? "Something went wrong";

      }
    } catch (e) {
      errorMessage = "Something went wrong";
      // debugPrint("Error: $e");
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
