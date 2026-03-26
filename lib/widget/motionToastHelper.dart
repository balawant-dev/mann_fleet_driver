import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

enum ToastType { success, error, warning, info }

class ToastHelper {
  static void show(
      BuildContext context, {
        required String message,
        ToastType type = ToastType.success,
      }) {
    MotionToast toast;

    switch (type) {
      case ToastType.success:
        toast = MotionToast.success(
          title: const Text(
            "Success",
            style: TextStyle(color: Colors.white),
          ),
          description: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          toastAlignment: Alignment.topCenter,
          animationType: AnimationType.slideInFromTop,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        );
        break;

      case ToastType.error:
        toast = MotionToast.error(
          title: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          description: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          toastAlignment: Alignment.topCenter,
          animationType: AnimationType.slideInFromTop,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        );
        break;

      case ToastType.warning:
        toast = MotionToast.warning(
          title: const Text(
            "Warning",
            style: TextStyle(color: Colors.white),
          ),
          description: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          toastAlignment: Alignment.topCenter,
          animationType: AnimationType.slideInFromTop,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        );
        break;

      case ToastType.info:
        toast = MotionToast.info(
          title: const Text(
            "Info",
            style: TextStyle(color: Colors.white),
          ),
          description: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          toastAlignment: Alignment.topCenter,
          animationType: AnimationType.slideInFromTop,
          margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        );
        break;
    }

    toast.show(context);
  }
}
//
// ToastHelper.show(
// context,
// message: "Something went wrong",
// type: ToastType.error,
// );