// import 'dart:async';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import '../../main.dart'; // 🔥 USE GLOBAL navigatorKey from main.dart
//
// class FirebaseNotificationService {
//   static final FirebaseNotificationService _instance =
//   FirebaseNotificationService._internal();
//
//   factory FirebaseNotificationService() => _instance;
//
//   FirebaseNotificationService._internal();
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   /// 🔔 Init notifications
//   Future<void> initNotifications() async {
//     /// ✅ Firebase safety check
//     if (Firebase.apps.isEmpty) {
//       debugPrint("❌ Firebase not initialized");
//       return;
//     }
//
//     /// 🔐 Permission
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       debugPrint("❌ Notification permission denied");
//       return;
//     }
//
//     /// 🔑 FCM Token
//     String? token = await _messaging.getToken();
//     if (token != null) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString("fcmToken", token);
//       debugPrint("✅ FCM Token: $token");
//     }
//
//     /// 📩 FOREGROUND message
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final notification = message.notification;
//       if (notification != null) {
//         AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//             channelKey: 'basic_channel',
//             title: notification.title,
//             body: notification.body,
//             bigPicture:
//             message.data['image'] ?? notification.android?.imageUrl,
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {
//               'screen': message.data['screen'] ?? 'notification',
//             },
//           ),
//         );
//       }
//     });
//
//     /// 📩 BACKGROUND → OPENED
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNavigation(message.data);
//     });
//
//     /// 📩 TERMINATED → OPENED
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       Future.delayed(const Duration(seconds: 1), () {
//         _handleNavigation(initialMessage.data);
//       });
//     }
//
//     /// 🖱 Awesome notification click
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: _onActionReceived,
//     );
//   }
//
//   /// 🖱 Awesome notification click handler
//   static Future<void> _onActionReceived(ReceivedAction action) async {
//     final payload = action.payload;
//     if (payload == null) return;
//
//     final screen = payload['screen'];
//     _navigate(screen);
//   }
//
//   /// 🧭 Navigation handler
//   void _handleNavigation(Map<String, dynamic> data) {
//     final screen = data['screen'];
//     _navigate(screen);
//   }
//
//   /// 🚀 Central navigation
//   static void _navigate(String? screen) {
//     if (screen == null) return;
//
//     debugPrint("🔔 Navigate to: $screen");
//
//     if (screen == 'notification') {
//       // navigatorKey.currentState?.push(
//       //   MaterialPageRoute(builder: (_) => const NotificationScreen()),
//       // );
//     }
//
//     // 👉 Add more screens here
//   }
// }
