import 'package:flutter/material.dart';

import '../model/fetchedShiftBookingsModel.dart';
import '../model/shuttleShiftDetailModel.dart';
import '../model/shuttleShiftModel.dart';
import '../repo/shuttleShiftRepo.dart';

class ShuttleShiftProvider extends ChangeNotifier {
  final api = ShuttleShiftRepo();

  ShuttleShiftModel? shuttleShiftModel;
  ShuttleShiftDetailModel? shuttleShiftDetailModel;
  FetchedShiftBookingsModel? fetchedShiftBookingsModel;
  String? errorMessage; // ✅ NEW
  bool isLoading = false;

  // ── Get pending / assigned bookings ────────────────────────────────────────
  Future<void> shuttleShiftApi({
    required BuildContext context,

  }) async {
    try {
      isLoading = true;
      errorMessage = null; // reset
      notifyListeners();

      final res = await api.shuttleShiftApi(
        context: context,

      );

      if (res != null && res.status == true) {
        shuttleShiftModel = res;
      } else {
        shuttleShiftModel = null;
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

  Future<void> shuttleShiftDetailApi({
    required BuildContext context,
    required String shiftID,

  }) async {
    try {
      isLoading = true;
      errorMessage = null; // reset
      notifyListeners();

      final res = await api.shuttleShiftDetailApi(
        context: context,
        id: shiftID

      );

      if (res != null && res.status == true) {
        shuttleShiftDetailModel = res;
      } else {
        shuttleShiftModel = null;
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
  }  Future<void> fetchedShiftBookingsApi({
    required BuildContext context,
    required String shiftID,

  }) async {
    try {
      isLoading = true;
      errorMessage = null; // reset
      notifyListeners();

      final res = await api.fetchedShiftBookingsApi(
        context: context,
        id: shiftID

      );

      if (res != null && res.status == true) {
        fetchedShiftBookingsModel = res;
      } else {
        fetchedShiftBookingsModel = null;
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
