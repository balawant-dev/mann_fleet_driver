// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import '../../app/router/navigation/routes.dart';
// import '../../main.dart';
//
//
// class AwesomeNotificationService {
//
//   /// 🔹 INIT NOTIFICATION
//   static Future<void> init() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'booking_channel',
//           channelName: 'Booking Notifications',
//           channelDescription: 'Notification for booking assignment',
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//           playSound: true,
//         ),
//       ],
//     );
//
//     /// 🔔 Permission
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) {
//       await AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//
//     /// ✅ LISTENER REGISTER (VERY IMPORTANT)
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: _onActionReceivedMethod,
//     );
//   }
//
//   /// 🔹 SHOW BOOKING NOTIFICATION
//   static Future<void> showBookingNotification({
//     required String title,
//     required String body,
//     Map<String, String>? payload,
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//         channelKey: 'booking_channel',
//         title: title,
//         body: body,
//         payload: payload,
//         notificationLayout: NotificationLayout.Default,
//       ),
//     );
//   }
//
//   /// 🔥 NOTIFICATION CLICK HANDLER
//   static Future<void> _onActionReceivedMethod(
//       ReceivedAction action) async {
//
//     debugPrint("🔔 Notification Clicked => ${action.payload}");
//
//     if (action.payload?['screen'] == 'home') {
//       // navigatorKey.currentState?.pushNamedAndRemoveUntil(
//       //   Routes.bottomBar,
//       //       (route) => false,
//       // );
//     }
//   }
// }
