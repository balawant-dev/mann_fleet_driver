

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import '../../../widget/showLoaderFunction.dart';

import '../../bookingDetail/model/bookingDetailModel.dart';
import '../model/getNotificationModel.dart';
import '../model/notificationDetailModel.dart';
import '../repo/notificationRepo.dart';

class NotificationProvider extends ChangeNotifier {
  final api = NotificationRepo();

  GetNotificationModel? getNotificationModel;
  NotificationDetailModel? notificationDetailModel;


  bool isLoading = false;

  // ── Get pending / assigned bookings ────────────────────────────────────────
  Future<void> getNotificationApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getNotificationApi(context: context);

      if (res != null && res.status == true) {
        getNotificationModel = res;
      } else {
        getNotificationModel = null;
      }

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }  Future<void> getNotificationDetailApi({required BuildContext context,required String id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getNotificationDetailApi(context: context, id: id);

      if (res != null && res.status == true) {
        notificationDetailModel = res;
      } else {
        notificationDetailModel = null;
      }

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}