import 'package:flutter/material.dart';

import '../../../widget/motionToastHelper.dart';
import '../model/getPunchHistoryModel.dart';
import '../model/getPunchRegionsModel.dart';
import '../model/getPunchStatusModel.dart';

import '../model/punchInModel.dart';
import '../model/punchOutModel.dart';

import '../repo/punchRepo.dart';

class PunchProvider extends ChangeNotifier {
  final api = PunchRepo();

  GetPunchHistoryModel? getPunchHistoryModel;
  GetPunchRegionsModel? getPunchRegionsModel;
  PunchStatusModel? punchStatusModel;
  PunchInModel? punchInModel;
  PunchOutModel? punchOutModel;

  bool isLoading = false;
  String? errorMessage;

  // Main state
  bool get hasAssignedRegion => getPunchRegionsModel?.data?.punchRegion != null;

  bool get isCurrentlyPunchedIn =>
      getPunchRegionsModel?.data?.isPunchedIn ?? false;

  Future<void> loadAllData({required BuildContext context}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        getPunchMyPunchRegionApi(context: context),
        getPunchStatusApi(context: context),
        getPunchHistoryApi(context: context),
      ]);
    } catch (e) {
      errorMessage = "Failed to load data. Please try again.";
      debugPrint("Error loading punch data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPunchMyPunchRegionApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getPunchMyPunchRegionApi(context: context);
      getPunchRegionsModel = res;
      if (res != null || res.status == true) {
        print("Get getPunchMyPunchRegionApi Successfully");
      }
    } catch (e) {
      debugPrint("Error in getPunchMyPunchRegionApi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPunchStatusApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getPunchStatusApi(context: context);
      punchStatusModel = res;
      if (res != null || res.status == true) {
        print("Get punchStatusModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in punchStatusModel: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> postPunchInApi({
    required BuildContext context,
    required String lat,
    required String lng,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await api.postPunchInApi(
        context: context,
        lat: lat,
        lng: lng,
      );

      punchInModel = res;

      if (res?.status == true) {
        // Success
        await loadAllData(context: context);
        ToastHelper.show(
          context,
          message: res?.message ?? "Punched in successfully",
          type: ToastType.success,
        );
      } else {
        // Error Handling
        String errorMsg = res?.error?.message ??
            res?.message ??
            "Something went wrong";

        ToastHelper.show(
          context,
          message: errorMsg,
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastHelper.show(
        context,
        message: "Failed to punch in. Please try again.",
        type: ToastType.error,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  // Future<void> postPunchInApi({
  //   required BuildContext context,
  //   required String lat,
  //   required String lng,
  // }) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     final res = await api.postPunchInApi(
  //       context: context,
  //       lng: lng,
  //       lat: lat,
  //     );
  //     punchInModel = res;
  //     if (res != null || res.status == true) {
  //       loadAllData(context: context);
  //       //
  //       ToastHelper.show(
  //         context,
  //         message: "Punched in successfully",
  //         type: ToastType.success,
  //       );
  //       print("Punched in successfully");
  //     }
  //   } catch (e) {
  //     debugPrint("Error in Get Profile: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> postPunchOutApi({
    required BuildContext context,
    required String lat,
    required String lng,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await api.postPunchOutApi(
        context: context,
        lat: lat,
        lng: lng,
      );

      punchOutModel = res;

      if (res?.success == true) {
        // Success
        ToastHelper.show(
          context,
          message: res.message ?? "Punched out successfully",
          type: ToastType.success,
        );
        await loadAllData(context: context);
      } else {
        // Error Handling
        String errorMsg = res.error?.message ??
            res.message ??
            "Something went wrong";

        ToastHelper.show(
          context,
          message: errorMsg,   // Yeh "You are not punched in." dikhega
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastHelper.show(
        context,
        message: "Failed to punch out. Please try again.",
        type: ToastType.error,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> postPunchOutApi({
  //   required BuildContext context,
  //   required String lat,
  //   required String lng,
  // }) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     final res = await api.postPunchOutApi(
  //       context: context,
  //       lat: lat,
  //       lng: lng,
  //     );
  //     punchOutModel = res;
  //     if (res != null || res.success == true) {
  //       ToastHelper.show(
  //         context,
  //         message: "Punched out successfully",
  //         type: ToastType.success,
  //       );
  //       loadAllData(context: context);
  //       print("Punched out successfully");
  //     }
  //   } catch (e) {
  //     debugPrint("Error in Get Profile: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> getPunchHistoryApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getPunchHistoryApi(context: context);
      getPunchHistoryModel = res;
      if (res != null || res.status == true) {
        print(" postPunchInApi Successfully");
      }
    } catch (e) {
      debugPrint("Error in postPunchInApi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
