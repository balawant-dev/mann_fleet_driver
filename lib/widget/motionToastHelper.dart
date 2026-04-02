// import 'package:flutter/material.dart';
// import 'package:motion_toast/motion_toast.dart';
// import 'package:flutter/material.dart';
// import 'package:motion_toast/motion_toast.dart';
//
// enum ToastType { success, error, warning, info }
//
// class ToastHelper {
//   static void show(
//       BuildContext context, {
//         required String message,
//         ToastType type = ToastType.success,
//       }) {
//     MotionToast toast;
//
//     switch (type) {
//       case ToastType.success:
//         toast = MotionToast.success(
//           title: const Text(
//             "Success",
//             style: TextStyle(color: Colors.white),
//           ),
//           description: Text(
//             message,
//             style: const TextStyle(color: Colors.white),
//           ),
//           toastAlignment: Alignment.topCenter,
//           animationType: AnimationType.slideInFromTop,
//           margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
//         );
//         break;
//
//       case ToastType.error:
//         toast = MotionToast.error(
//           title: const Text(
//             "Error",
//             style: TextStyle(color: Colors.white),
//           ),
//           description: Text(
//             message,
//             style: const TextStyle(color: Colors.white),
//           ),
//           toastAlignment: Alignment.topCenter,
//           animationType: AnimationType.slideInFromTop,
//           margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
//         );
//         break;
//
//       case ToastType.warning:
//         toast = MotionToast.warning(
//           title: const Text(
//             "Warning",
//             style: TextStyle(color: Colors.white),
//           ),
//           description: Text(
//             message,
//             style: const TextStyle(color: Colors.white),
//           ),
//           toastAlignment: Alignment.topCenter,
//           animationType: AnimationType.slideInFromTop,
//           margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
//         );
//         break;
//
//       case ToastType.info:
//         toast = MotionToast.info(
//           title: const Text(
//             "Info",
//             style: TextStyle(color: Colors.white),
//           ),
//           description: Text(
//             message,
//             style: const TextStyle(color: Colors.white),
//           ),
//           toastAlignment: Alignment.topCenter,
//           animationType: AnimationType.slideInFromTop,
//           margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
//         );
//         break;
//     }
//
//     toast.show(context);
//   }
// }
// //
// // ToastHelper.show(
// // context,
// // message: "Something went wrong",
// // type: ToastType.error,
// // );



import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class ToastHelper {
  static void show(
      BuildContext context, {
        required String message,
        ToastType type = ToastType.success,
        Duration duration = const Duration(seconds: 3),
      }) {
    final overlay = Overlay.of(context);

    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;

  const _ToastWidget({
    required this.message,
    required this.type,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    controller.forward();
  }

  Color getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return Colors.blue;
    }
  }

  IconData getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: getBackgroundColor(),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(getIcon(), color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}