// import 'dart:convert';
// import 'dart:io';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_event.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/entities/ios_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../main.dart';
// import '../../screen/bookingDetail/ui/IncomingVoiceCallScreen.dart';
// import '../../screen/bookingDetail/ui/VoiceCallScreen.dart';
//
//
// /// ===============================================================
// /// GLOBAL BACKGROUND FCM HANDLER
// /// ===============================================================
//
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(
//     RemoteMessage message,
//     ) async {
//
//   try {
//
//     await Firebase.initializeApp();
//
//     debugPrint(
//       "========================================",
//     );
//
//     debugPrint(
//       "🔥 DRIVER BACKGROUND FCM RECEIVED",
//     );
//
//     debugPrint(
//       "TITLE: ${message.notification?.title}",
//     );
//
//     debugPrint(
//       "BODY: ${message.notification?.body}",
//     );
//
//     debugPrint(
//       "DATA: ${message.data}",
//     );
//
//     debugPrint(
//       "========================================",
//     );
//
//
//     /// -----------------------------------------------------------
//     /// Initialize Awesome Notifications
//     /// -----------------------------------------------------------
//
//     await FirebaseService.initializeAwesomeNotifications();
//
//
//     /// -----------------------------------------------------------
//     /// Convert payload
//     /// -----------------------------------------------------------
//
//     final data = <String, dynamic>{};
//
//     message.data.forEach(
//           (key, value) {
//         data[key] = value.toString();
//       },
//     );
//
//
//     /// -----------------------------------------------------------
//     /// Check voice call
//     /// -----------------------------------------------------------
//
//     final isIncomingVoiceCall =
//         data['type']?.toString() == 'voiceCall' &&
//             data['notificationType']?.toString() ==
//                 'incomingVoiceCall';
//
//
//     /// ===========================================================
//     /// INCOMING VOICE CALL
//     /// ===========================================================
//
//     if (isIncomingVoiceCall) {
//
//       debugPrint(
//         "📞 DRIVER: Incoming voice call in background",
//       );
//
//
//       /// ---------------------------------------------------------
//       /// Create notification ID
//       /// ---------------------------------------------------------
//
//       final notificationId =
//       DateTime.now()
//           .millisecondsSinceEpoch
//           .remainder(100000);
//
//
//       /// Save notification id also
//       data['notificationId'] =
//           notificationId.toString();
//
//
//       /// ---------------------------------------------------------
//       /// Save incoming call
//       /// ---------------------------------------------------------
//
//       await FirebaseService.saveIncomingCall(
//         data,
//       );
//       await FirebaseService.showIncomingCallKit(data);
//
//       debugPrint(
//         "📞 DRIVER: CallKit incoming call displayed",
//       );
//
//       /// ---------------------------------------------------------
//       /// Create full screen notification
//       /// ---------------------------------------------------------
//
//       // await AwesomeNotifications().createNotification(
//       //   content: NotificationContent(
//       //
//       //     id: notificationId,
//       //
//       //     channelKey: 'incoming_call',
//       //
//       //     title:
//       //     message.notification?.title ??
//       //         'Incoming Voice Call',
//       //
//       //     body:
//       //     message.notification?.body ??
//       //         '${data['callerName'] ?? 'Someone'} is calling you',
//       //
//       //     category:
//       //     NotificationCategory.Call,
//       //
//       //     wakeUpScreen: true,
//       //
//       //     fullScreenIntent: true,
//       //
//       //     autoDismissible: false,
//       //
//       //     locked: true,
//       //
//       //     notificationLayout:
//       //     NotificationLayout.Default,
//       //
//       //     payload: data.map(
//       //           (key, value) =>
//       //           MapEntry(
//       //             key,
//       //             value.toString(),
//       //           ),
//       //     ),
//       //   ),
//       // );
//
//
//       debugPrint(
//         "📞 DRIVER Incoming call notification created",
//       );
//
//       return;
//     }
//
//
//     /// ===========================================================
//     /// NORMAL NOTIFICATION
//     /// ===========================================================
//
//     final notificationId =
//     DateTime.now()
//         .millisecondsSinceEpoch
//         .remainder(100000);
//
//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//
//         id: notificationId,
//
//         channelKey: 'basic_channel',
//
//         title:
//         message.notification?.title ??
//             message.data['title']?.toString() ??
//             '',
//
//         body:
//         message.notification?.body ??
//             message.data['body']?.toString() ??
//             '',
//
//         payload: data.map(
//               (key, value) =>
//               MapEntry(
//                 key,
//                 value.toString(),
//               ),
//         ),
//       ),
//     );
//
//   } catch (e, stackTrace) {
//
//     debugPrint(
//       "❌ DRIVER Background FCM error: $e",
//     );
//
//     debugPrint(
//       stackTrace.toString(),
//     );
//   }
// }
//
//
// /// ===============================================================
// /// AWESOME NOTIFICATION ACTION HANDLER
// /// ===============================================================
//
// @pragma('vm:entry-point')
// Future<void> onActionReceivedMethod(
//     ReceivedAction action,
//     ) async {
//
//   try {
//
//     debugPrint(
//       "========================================",
//     );
//
//     debugPrint(
//       "🔔 DRIVER NOTIFICATION ACTION",
//     );
//
//     debugPrint(
//       "PAYLOAD: ${action.payload}",
//     );
//
//     debugPrint(
//       "NOTIFICATION ID: ${action.id}",
//     );
//
//     debugPrint(
//       "========================================",
//     );
//
//
//     final payload =
//         action.payload;
//
//
//     final data =
//     <String, dynamic>{};
//
//
//     payload?.forEach(
//           (key, value) {
//         data[key] = value;
//       },
//     );
//
//
//     final isIncomingVoiceCall =
//         data['type']?.toString() == 'voiceCall' &&
//             data['notificationType']?.toString() ==
//                 'incomingVoiceCall';
//
//
//     if (isIncomingVoiceCall) {
//
//       debugPrint(
//         "📞 DRIVER: Incoming call notification clicked",
//       );
//
//
//       /// ---------------------------------------------------------
//       /// Save payload
//       /// ---------------------------------------------------------
//
//       await FirebaseService.saveIncomingCall(
//         data,
//       );
//
//
//       /// ---------------------------------------------------------
//       /// IMPORTANT
//       /// Cancel notification after click
//       /// ---------------------------------------------------------
//
//       try {
//         if (action.id != null) {
//           await AwesomeNotifications().cancel(action.id!);
//         }
//
//         debugPrint(
//           "🔕 DRIVER call notification cancelled",
//         );
//
//       } catch (e) {
//
//         debugPrint(
//           "⚠️ DRIVER notification cancel error: $e",
//         );
//       }
//
//
//       /// ---------------------------------------------------------
//       /// Main isolate will detect app resume
//       /// and open IncomingVoiceCallScreen.
//       /// ---------------------------------------------------------
//
//       return;
//     }
//
//   } catch (e, stackTrace) {
//
//     debugPrint(
//       "❌ DRIVER Notification action error: $e",
//     );
//
//     debugPrint(
//       stackTrace.toString(),
//     );
//   }
// }
//
//
// /// ===============================================================
// /// FIREBASE SERVICE - DRIVER
// /// ===============================================================
//
// class FirebaseService {
//
//   static final FirebaseMessaging _messaging =
//       FirebaseMessaging.instance;
//
//
//   static bool _isOpeningIncomingCall =
//   false;
//
//
//   /// =============================================================
//   /// INITIALIZE
//   /// =============================================================
//
//   static Future<void> init() async {
//
//     try {
//
//       debugPrint(
//         "🔥 DRIVER FirebaseService initialization started",
//       );
//
// // ???????????????????????????????Balawant 25 agust
//       /// Permission
//
//       await _requestPermission();
//
//       await initializeCallKit();
//       /// Awesome Notifications
//
//       await initializeAwesomeNotifications();
//
//
//       /// Listener
//
//       await AwesomeNotifications().setListeners(
//         onActionReceivedMethod:
//         onActionReceivedMethod,
//       );
//
//
//       /// Device ID
//
//       await _printDeviceId();
//
//
//       /// FCM token
//
//       await _getFcmToken();
//
//
//       /// Token refresh
//
//       _listenTokenRefresh();
//
//
//       /// Foreground FCM
//
//       _listenForegroundNotification();
//
//
//       /// FCM cold start
//
//       await _checkInitialNotification();
//
//
//       debugPrint(
//         "✅ DRIVER FirebaseService initialized successfully",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER FirebaseService initialization error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// PERMISSION
//   /// =============================================================
//   /// INITIALIZE CALLKIT
//   /// =============================================================
//   static Future<void> initializeCallKit() async {
//
//     try {
//
//       debugPrint(
//         "📞 Initializing Flutter CallKit",
//       );
//
//       await FlutterCallkitIncoming.requestNotificationPermission({
//         "title": "Incoming Call Notification",
//         "rationaleMessagePermission":
//         "Notification permission is required to receive incoming calls.",
//         "postNotificationMessageRequired":
//         "Please allow notification permission from settings.",
//       });
//
//       final canUseFullScreen =
//       await FlutterCallkitIncoming.canUseFullScreenIntent();
//
//       debugPrint(
//         "📞 Full Screen Intent allowed: $canUseFullScreen",
//       );
//
//       if (!canUseFullScreen) {
//
//         await FlutterCallkitIncoming
//             .requestFullIntentPermission();
//       }
//
//       FlutterCallkitIncoming.onEvent.listen(
//             (CallEvent? event) async {
//
//           if (event == null) {
//             return;
//           }
//
//           debugPrint(
//             "========================================",
//           );
//
//           debugPrint(
//             "📞 CALLKIT EVENT RECEIVED",
//           );
//
//           debugPrint(
//             "📞 EVENT TYPE: ${event.runtimeType}",
//           );
//
//           debugPrint(
//             "📞 EVENT NAME: ${event.eventName}",
//           );
//
//           debugPrint(
//             "📞 EVENT: $event",
//           );
//
//           debugPrint(
//             "========================================",
//           );
//
//           await _handleCallKitEvent(event);
//         },
//       );
//
//       debugPrint(
//         "✅ Flutter CallKit initialized",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ CallKit initialization error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// HANDLE CALLKIT EVENT
//   /// =============================================================
//   static Future<void> _handleCallKitEvent(
//       CallEvent event,
//       ) async {
//
//     try {
//
//       debugPrint("========================================");
//       debugPrint("📞 HANDLING CALLKIT EVENT");
//       debugPrint("📞 EVENT NAME: ${event.eventName}");
//       debugPrint("📞 EVENT TYPE: ${event.runtimeType}");
//       debugPrint("========================================");
//
//
//       /// =========================================================
//       /// ACCEPT
//       /// =========================================================
//
//       if (event is CallEventActionCallAccept) {
//
//         debugPrint(
//           "📞 CALL ACCEPTED",
//         );
//
//         final CallKitParams callParams =
//             event.callKitParams;
//
//         debugPrint(
//           "📞 ACCEPT CALL PARAMS: $callParams",
//         );
//
//         final extra =
//             callParams.extra;
//
//         final Map<String, dynamic> data =
//         extra != null
//             ? Map<String, dynamic>.from(extra)
//             : <String, dynamic>{};
//
//         debugPrint(
//           "📞 ACCEPT EXTRA DATA: $data",
//         );
//
//         await _handleCallAccepted(
//           data,
//         );
//
//         return;
//       }
//
//
//       /// =========================================================
//       /// DECLINE
//       /// =========================================================
//
//       if (event is CallEventActionCallDecline) {
//
//         debugPrint(
//           "📞 CALL DECLINED",
//         );
//
//         final CallKitParams callParams =
//             event.callKitParams;
//
//         final extra =
//             callParams.extra;
//
//         final Map<String, dynamic> data =
//         extra != null
//             ? Map<String, dynamic>.from(extra)
//             : <String, dynamic>{};
//
//         debugPrint(
//           "📞 DECLINE EXTRA DATA: $data",
//         );
//
//         await _handleCallDeclined(data);
//
//         return;
//       }
//
//
//       /// =========================================================
//       /// END
//       /// =========================================================
//
//       if (event is CallEventActionCallEnded) {
//
//         debugPrint(
//           "📞 CALL ENDED",
//         );
//
//         final CallKitParams callParams =
//             event.callKitParams;
//
//         final extra =
//             callParams.extra;
//
//         final Map<String, dynamic> data =
//         extra != null
//             ? Map<String, dynamic>.from(extra)
//             : <String, dynamic>{};
//
//         debugPrint(
//           "📞 END EXTRA DATA: $data",
//         );
//
//         await _handleCallDeclined(data);
//
//         return;
//       }
//
//
//       /// =========================================================
//       /// TIMEOUT
//       /// =========================================================
//
//       if (event is CallEventActionCallTimeout) {
//
//         debugPrint(
//           "📞 CALL TIMEOUT",
//         );
//
//         await clearIncomingCall();
//
//         return;
//       }
//
//       if (event is CallEventActionCallToggleHold) {
//         debugPrint(
//           "📞 CALL HOLD TOGGLE: ${event.isOnHold}",
//         );
//         return;
//       }
//       // ============================================================
//       // INCOMING
//       // ============================================================
//
//       if (event is CallEventActionCallIncoming) {
//
//         debugPrint(
//           "📞 CALL INCOMING",
//         );
//
//         final CallKitParams callParams =
//             event.callKitParams;
//
//         debugPrint(
//           "📞 INCOMING CALL PARAMS: $callParams",
//         );
//
//         return;
//       }
//
//
//       /// =========================================================
//       /// OTHER EVENTS
//       /// =========================================================
//
//       debugPrint(
//         "📞 Other CallKit event: ${event.eventName}",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ CallKit event handling error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//   static Future<void> _handleCallAccepted(
//       Map<String, dynamic> data,
//       ) async {
//
//     try {
//       debugPrint("========================================");
//       debugPrint("📞 DRIVER CALLKIT CALL ACCEPTED");
//       debugPrint("📞 DATA = $data");
//       debugPrint("========================================");
//
//       final callId =
//           data['callId']?.toString() ?? '';
//
//       final token =
//           data['token']?.toString() ?? '';
//
//       final channelName =
//           data['channelName']?.toString() ?? '';
//
//       final uid =
//           int.tryParse(
//             data['uid']?.toString() ?? '',
//           ) ?? 0;
//
//       final bookingId =
//           data['bookingId']?.toString() ?? '';
//
//       debugPrint("📞 callId = $callId");
//       debugPrint("📞 token = $token");
//       debugPrint("📞 channelName = $channelName");
//       debugPrint("📞 uid = $uid");
//       debugPrint("📞 bookingId = $bookingId");
//
//       /// ---------------------------------------------------------
//       /// VALIDATE
//       /// ---------------------------------------------------------
//
//       if (token.isEmpty ||
//           channelName.isEmpty ||
//           uid == 0 ||
//           bookingId.isEmpty) {
//
//         debugPrint(
//           "❌ ACCEPT FAILED: Invalid CallKit data",
//         );
//
//         return;
//       }
//
//       /// ---------------------------------------------------------
//       /// MARK CALL CONNECTED IN CALLKIT
//       /// ---------------------------------------------------------
//
//       if (callId.isNotEmpty) {
//         try {
//
//           await FlutterCallkitIncoming.setCallConnected(
//             callId,
//           );
//
//           debugPrint(
//             "✅ CallKit call connected",
//           );
//
//         } catch (e) {
//
//           debugPrint(
//             "⚠️ setCallConnected error: $e",
//           );
//         }
//       }
//
//       /// ---------------------------------------------------------
//       /// REMOVE PENDING INCOMING CALL
//       /// ---------------------------------------------------------
//
//       await clearIncomingCall();
//
//       /// ---------------------------------------------------------
//       /// SAVE ACCEPTED CALL
//       ///
//       /// Important for:
//       /// app background / app killed / navigator not ready
//       /// ---------------------------------------------------------
//
//       final acceptedData =
//       <String, dynamic>{};
//
//       data.forEach((key, value) {
//         acceptedData[key] = value.toString();
//       });
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//       await prefs.setString(
//         'accepted_voice_call',
//         jsonEncode(acceptedData),
//       );
//
//       await prefs.setBool(
//         'has_accepted_voice_call',
//         true,
//       );
//
//       debugPrint(
//         "💾 ACCEPTED CALL SAVED",
//       );
//
//       /// ---------------------------------------------------------
//       /// WAIT FOR FLUTTER NAVIGATOR
//       /// ---------------------------------------------------------
//
//       await _waitForNavigator();
//
//       final navigator =
//           navigatorKey.currentState;
//
//       if (navigator == null) {
//
//         debugPrint(
//           "⏳ Navigator not ready. Main app will open accepted call.",
//         );
//
//         return;
//       }
//
//       /// ---------------------------------------------------------
//       /// PREVENT DUPLICATE
//       /// ---------------------------------------------------------
//
//       if (_isOpeningIncomingCall) {
//
//         debugPrint(
//           "⚠️ Call screen already opening",
//         );
//
//         return;
//       }
//
//       _isOpeningIncomingCall = true;
//
//       try {
//
//         debugPrint(
//           "🚀 OPENING VOICE CALL DIRECTLY AFTER CALLKIT ACCEPT",
//         );
//
//         await navigator.push(
//           MaterialPageRoute(
//             builder: (_) {
//
//               return VoiceCallScreen(
//
//                 appId:
//                 "b2ec8d246fb3407f8bf76884a32d7a47",
//
//                 token:
//                 token,
//
//                 channelName:
//                 channelName,
//
//                 uid:
//                 uid,
//
//                 bookingId:
//                 bookingId,
//               );
//             },
//           ),
//         );
//
//       } catch (e, stackTrace) {
//
//         debugPrint(
//           "❌ VOICE CALL NAVIGATION ERROR: $e",
//         );
//
//         debugPrint(
//           stackTrace.toString(),
//         );
//
//       } finally {
//
//         _isOpeningIncomingCall = false;
//       }
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER CALL ACCEPT ERROR: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//   static Future<void> _waitForNavigator() async {
//
//     for (int i = 0; i < 20; i++) {
//
//       final navigator =
//           navigatorKey.currentState;
//
//       if (navigator != null) {
//
//         debugPrint(
//           "✅ Navigator ready after ${i * 300}ms",
//         );
//
//         return;
//       }
//
//       debugPrint(
//         "⏳ Waiting for navigator... attempt ${i + 1}",
//       );
//
//       await Future.delayed(
//         const Duration(
//           milliseconds: 300,
//         ),
//       );
//     }
//
//     debugPrint(
//       "❌ Navigator not available after 6 seconds",
//     );
//   }
//   static Future<void> _openAcceptedCallScreen(
//       Map<String, dynamic> data,
//       ) async {
//     try {
//       final navigator =
//           navigatorKey.currentState;
//
//       if (navigator == null) {
//         debugPrint(
//           "⏳ Navigator still not ready",
//         );
//
//         Future.delayed(
//           const Duration(
//             milliseconds: 700,
//           ),
//               () async {
//             await _openAcceptedCallScreen(data);
//           },
//         );
//
//         return;
//       }
//
//       final token =
//           data['token']?.toString() ?? '';
//
//       final channelName =
//           data['channelName']?.toString() ?? '';
//
//       final uid =
//           int.tryParse(
//             data['uid']?.toString() ?? '',
//           ) ??
//               0;
//
//       final bookingId =
//           data['bookingId']?.toString() ?? '';
//
//       final callerName =
//           data['callerName']?.toString() ?? '';
//
//       final callerProfileImage =
//           data['callerProfileImage']?.toString() ?? '';
//
//       final initiatedBy =
//           data['initiatedBy']?.toString() ?? '';
//
//       if (token.isEmpty ||
//           channelName.isEmpty ||
//           uid == 0 ||
//           bookingId.isEmpty) {
//         debugPrint(
//           "❌ Cannot open call screen. Invalid data.",
//         );
//         return;
//       }
//
//       debugPrint(
//         "🚀 OPENING IncomingVoiceCallScreen AFTER ACCEPT",
//       );
//
//       await navigator.push(
//         MaterialPageRoute(
//           builder: (_) {
//             debugPrint(
//               "🎬 BUILDING IncomingVoiceCallScreen",
//             );
//
//             return IncomingVoiceCallScreen(
//               callerName: callerName,
//               callerProfileImage: callerProfileImage,
//               token: token,
//               channelName: channelName,
//               uid: uid,
//               bookingId: bookingId,
//               initiatedBy: initiatedBy,
//             );
//           },
//         ),
//       );
//
//       debugPrint(
//         "✅ IncomingVoiceCallScreen opened",
//       );
//
//     } catch (e, stackTrace) {
//       debugPrint(
//         "❌ Open accepted call screen error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//   static Future<void> showIncomingCallKit(
//       Map<String, dynamic> data,
//       ) async {
//
//     try {
//
//       final callerName =
//           data['callerName']?.toString() ??
//               'Incoming Call';
//
//       final callerProfileImage =
//           data['callerProfileImage']?.toString() ??
//               '';
//
//       final callId =
//       data['callId']?.toString().isNotEmpty == true
//           ? data['callId']!.toString()
//           : const Uuid().v4();
//
//
//       final params = CallKitParams(
//
//         id: callId,
//
//         nameCaller: callerName,
//
//         appName: 'Mann Fleet',
//
//         avatar: callerProfileImage,
//
//         handle: 'Mann Fleet',
//
//         type: 0,
//
//         duration: 60000,
//
//         extra: <String, dynamic>{
//
//           'token':
//           data['token']?.toString() ?? '',
//
//           'channelName':
//           data['channelName']?.toString() ?? '',
//
//           'uid':
//           data['uid']?.toString() ?? '',
//
//           'bookingId':
//           data['bookingId']?.toString() ?? '',
//
//           'callerName':
//           callerName,
//
//           'callerProfileImage':
//           callerProfileImage,
//
//           'initiatedBy':
//           data['initiatedBy']?.toString() ?? '',
//
//           'type':
//           'voiceCall',
//
//           'notificationType':
//           'incomingVoiceCall',
//
//           'callId':
//           callId,
//         },
//
//         android: const AndroidParams(
//
//           isCustomNotification: true,
//
//           isShowLogo: false,
//
//           ringtonePath:
//           'system_ringtone_default',
//
//           backgroundColor:
//           '#03045E',
//
//           actionColor:
//           '#4CAF50',
//
//           incomingCallNotificationChannelName:
//           'Incoming Calls',
//
//           missedCallNotificationChannelName:
//           'Missed Calls',
//
//           isShowFullLockedScreen:
//           true,
//
//           isFullScreen:
//           true,
//         ),
//
//         ios: const IOSParams(
//
//           iconName:
//           'CallKitLogo',
//
//           handleType:
//           'generic',
//
//           supportsVideo:
//           false,
//
//           maximumCallGroups:
//           1,
//
//           maximumCallsPerCallGroup:
//           1,
//
//           audioSessionMode:
//           'voiceChat',
//
//           audioSessionActive:
//           true,
//
//           supportsDTMF:
//           false,
//
//           supportsHolding:
//           false,
//
//           supportsGrouping:
//           false,
//
//           supportsUngrouping:
//           false,
//
//           ringtonePath:
//           'system_ringtone_default',
//         ),
//       );
//
//
//       debugPrint(
//         "📞 SHOWING CALLKIT",
//       );
//
//       debugPrint(
//         "📞 CALL ID: $callId",
//       );
//
//       debugPrint(
//         "📞 CALLER: $callerName",
//       );
//
//       await FlutterCallkitIncoming
//           .showCallkitIncoming(params);
//
//       debugPrint(
//         "✅ CALLKIT INCOMING SHOWN",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ showIncomingCallKit error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//   static Future<void> _requestPermission() async {
//
//     try {
//
//       final settings =
//       await _messaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );
//
//
//       debugPrint(
//         "DRIVER Notification permission: "
//             "${settings.authorizationStatus}",
//       );
//
//
//       if (Platform.isAndroid) {
//
//         final allowed =
//         await AwesomeNotifications()
//             .isNotificationAllowed();
//
//
//         if (!allowed) {
//
//           await AwesomeNotifications()
//               .requestPermissionToSendNotifications();
//         }
//       }
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ DRIVER Permission error: $e",
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// AWESOME NOTIFICATIONS
//   /// =============================================================
//
//   static Future<void>
//   initializeAwesomeNotifications() async {
//
//     try {
//       debugPrint("========================================");
//       debugPrint("🔔 DRIVER: INITIALIZING AWESOME NOTIFICATIONS");
//       debugPrint("========================================");
//
//
//       final initialized =
//       await AwesomeNotifications().initialize(
//
//         null,
//
//         [
//
//           /// -----------------------------------------------------
//           /// INCOMING CALL CHANNEL
//           /// -----------------------------------------------------
//
//           NotificationChannel(
//             channelKey: 'incoming_call',
//             channelName: 'Incoming Calls',
//             channelDescription: 'Incoming voice call notifications',
//
//             importance: NotificationImportance.Max,
//
//             channelShowBadge: true,
//
//             playSound: true,
//
//             soundSource: 'resource://raw/sound',
//
//             defaultRingtoneType: DefaultRingtoneType.Ringtone,
//
//             enableVibration: true,
//
//             locked: true,
//
//             defaultColor: const Color(0xFF03045E),
//
//             ledColor: Colors.white,
//
//             criticalAlerts: true,
//           ),
//
//
//           /// -----------------------------------------------------
//           /// BASIC CHANNEL
//           /// -----------------------------------------------------
//
//           NotificationChannel(
//
//             channelKey:
//             'basic_channel',
//
//             channelName:
//             'Basic Notifications',
//
//             channelDescription:
//             'Application notifications',
//
//             importance:
//             NotificationImportance.High,
//
//             channelShowBadge:
//             true,
//
//             playSound:
//             true,
//
//             soundSource:
//             'resource://raw/sound',
//
//             enableVibration:
//             true,
//           ),
//         ],
//
//         debug: true,
//       );
//
//
//       debugPrint("========================================");
//       debugPrint("🔔 AWESOME INITIALIZED: $initialized");
//       debugPrint("🔊 INCOMING CHANNEL: incoming_call");
//       debugPrint("🔊 SOUND SOURCE: resource://raw/sound");
//       debugPrint("🔊 PLAY SOUND: true");
//       debugPrint("📳 VIBRATION: true");
//       debugPrint("📢 IMPORTANCE: MAX");
//       debugPrint("📞 RINGTONE TYPE: Ringtone");
//       debugPrint("========================================");
//       final allowed =
//       await AwesomeNotifications().isNotificationAllowed();
//
//       debugPrint(
//         "🔔 NOTIFICATION PERMISSION: $allowed",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER Awesome Notification initialization error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//
//       rethrow;
//     }
//   }
//
//
//   /// =============================================================
//   /// DEVICE ID
//   /// =============================================================
//
//   static Future<void> _printDeviceId() async {
//
//     try {
//
//       final deviceInfo =
//       DeviceInfoPlugin();
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//
//       if (Platform.isAndroid) {
//
//         final androidInfo =
//         await deviceInfo.androidInfo;
//
//         final deviceId =
//             androidInfo.id;
//
//
//         await prefs.setString(
//           "deviceId",
//           deviceId,
//         );
//
//         await prefs.setString(
//           "deviceType",
//           "ANDROID",
//         );
//
//
//         debugPrint(
//           "DRIVER DEVICE ID : $deviceId",
//         );
//
//         debugPrint(
//           "DRIVER DEVICE TYPE : ANDROID",
//         );
//       }
//
//
//       if (Platform.isIOS) {
//
//         final iosInfo =
//         await deviceInfo.iosInfo;
//
//         final deviceId =
//             iosInfo.identifierForVendor ??
//                 '';
//
//
//         await prefs.setString(
//           "deviceId",
//           deviceId,
//         );
//
//         await prefs.setString(
//           "deviceType",
//           "IOS",
//         );
//
//
//         debugPrint(
//           "DRIVER DEVICE ID : $deviceId",
//         );
//
//         debugPrint(
//           "DRIVER DEVICE TYPE : IOS",
//         );
//       }
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ DRIVER Device ID error: $e",
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// FCM TOKEN
//   /// =============================================================
//
//   static Future<void> _getFcmToken() async {
//
//     try {
//
//       if (Platform.isIOS) {
//
//         String? apnsToken;
//
//         int retry = 0;
//
//
//         while (
//         apnsToken == null &&
//             retry < 5
//         ) {
//
//           apnsToken =
//           await _messaging.getAPNSToken();
//
//
//           if (apnsToken == null) {
//
//             await Future.delayed(
//               const Duration(
//                 seconds: 1,
//               ),
//             );
//           }
//
//           retry++;
//         }
//
//
//         debugPrint(
//           "DRIVER APNS TOKEN : $apnsToken",
//         );
//       }
//
//
//       final token =
//       await _messaging.getToken();
//
//
//       if (token != null &&
//           token.isNotEmpty) {
//
//         final prefs =
//         await SharedPreferences
//             .getInstance();
//
//
//         await prefs.setString(
//           "deviceToken",
//           token,
//         );
//
//
//         debugPrint(
//           "DRIVER FCM TOKEN : $token",
//         );
//       }
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ DRIVER FCM Token error: $e",
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// TOKEN REFRESH
//   /// =============================================================
//
//   static void _listenTokenRefresh() {
//
//     _messaging.onTokenRefresh.listen(
//           (token) async {
//
//         try {
//
//           final prefs =
//           await SharedPreferences
//               .getInstance();
//
//
//           await prefs.setString(
//             "deviceToken",
//             token,
//           );
//
//
//           debugPrint(
//             "🔄 DRIVER FCM TOKEN REFRESHED: $token",
//           );
//
//         } catch (e) {
//
//           debugPrint(
//             "❌ DRIVER token refresh error: $e",
//           );
//         }
//       },
//     );
//   }
//
//
//   /// =============================================================
//   /// FOREGROUND FCM
//   /// =============================================================
//
//   static void _listenForegroundNotification() {
//
//     FirebaseMessaging.onMessage.listen(
//           (RemoteMessage message) async {
//
//         try {
//
//           debugPrint(
//             "========================================",
//           );
//
//           debugPrint(
//             "📩 DRIVER FOREGROUND FCM RECEIVED",
//           );
//
//           debugPrint(
//             "TITLE: ${message.notification?.title}",
//           );
//
//           debugPrint(
//             "BODY: ${message.notification?.body}",
//           );
//
//           debugPrint(
//             "DATA: ${message.data}",
//           );
//
//           debugPrint(
//             "========================================",
//           );
//
//
//           final data =
//           <String, dynamic>{};
//
//
//           message.data.forEach(
//                 (key, value) {
//
//               data[key] =
//                   value.toString();
//             },
//           );
//
//
//           final isIncomingVoiceCall =
//               data['type']?.toString() ==
//                   'voiceCall' &&
//                   data['notificationType']
//                       ?.toString() ==
//                       'incomingVoiceCall';
//
//
//           /// =====================================================
//           /// INCOMING CALL
//           /// =====================================================
//
//           if (isIncomingVoiceCall) {
//
//             debugPrint(
//               "📞 DRIVER: Incoming call in foreground",
//             );
//
//
//             final notificationId =
//             DateTime.now()
//                 .millisecondsSinceEpoch
//                 .remainder(100000);
//
//
//             data['notificationId'] =
//                 notificationId.toString();
//
//
//             /// Save
//
//             await saveIncomingCall(
//               data,
//             );
//             await showIncomingCallKit(data);
//
//             debugPrint(
//               "📞 DRIVER: Foreground CallKit shown",
//             );
//
//
//             /// Notification
//
//             await AwesomeNotifications()
//                 .createNotification(
//
//               content:
//               NotificationContent(
//
//                 id:
//                 notificationId,
//
//                 channelKey:
//                 'incoming_call',
//
//                 title:
//                 message.notification?.title ??
//                     'Incoming Voice Call',
//
//                 body:
//                 message.notification?.body ??
//                     '${data['callerName'] ?? 'Someone'} is calling you',
//
//                 category:
//                 NotificationCategory.Call,
//
//                 wakeUpScreen:
//                 true,
//
//                 fullScreenIntent:
//                 true,
//
//                 autoDismissible:
//                 false,
//
//                 locked:
//                 true,
//
//                 notificationLayout:
//                 NotificationLayout.Default,
//
//                 payload:
//                 data.map(
//                       (key, value) =>
//                       MapEntry(
//                         key,
//                         value.toString(),
//                       ),
//                 ),
//               ),
//             );
//
//
//             /// ---------------------------------------------------
//             /// Foreground = directly open
//             /// ---------------------------------------------------
//
//             await openIncomingCallScreen(
//               data,
//             );
//
//
//             return;
//           }
//
//
//           /// =====================================================
//           /// NORMAL NOTIFICATION
//           /// =====================================================
//
//           final notificationId =
//           DateTime.now()
//               .millisecondsSinceEpoch
//               .remainder(100000);
//
//
//           await AwesomeNotifications()
//               .createNotification(
//
//             content:
//             NotificationContent(
//
//               id:
//               notificationId,
//
//               channelKey:
//               'basic_channel',
//
//               title:
//               message.notification?.title ??
//                   message.data['title']
//                       ?.toString() ??
//                   '',
//
//               body:
//               message.notification?.body ??
//                   message.data['body']
//                       ?.toString() ??
//                   '',
//
//               payload:
//               data.map(
//                     (key, value) =>
//                     MapEntry(
//                       key,
//                       value.toString(),
//                     ),
//               ),
//             ),
//           );
//
//         } catch (e, stackTrace) {
//
//           debugPrint(
//             "❌ DRIVER Foreground notification error: $e",
//           );
//
//           debugPrint(
//             stackTrace.toString(),
//           );
//         }
//       },
//     );
//   }
//
//
//   /// =============================================================
//   /// SAVE INCOMING CALL
//   /// =============================================================
//   /// =============================================================
//   /// CLEAR COMPLETE CALL STATE
//   /// =============================================================
//
//   static Future<void> clearCallState() async {
//
//     try {
//
//       debugPrint(
//         "🧹 DRIVER: Clearing COMPLETE call state",
//       );
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//       /// Incoming call
//       await prefs.remove(
//         'incoming_voice_call',
//       );
//
//       await prefs.setBool(
//         'has_incoming_voice_call',
//         false,
//       );
//
//       /// Accepted call
//       await prefs.remove(
//         'accepted_voice_call',
//       );
//
//       await prefs.setBool(
//         'has_accepted_voice_call',
//         false,
//       );
//
//       debugPrint(
//         "🧹 DRIVER: SharedPreferences call state cleared",
//       );
//
//       /// ---------------------------------------------------------
//       /// Cancel Awesome Notifications
//       /// ---------------------------------------------------------
//
//       try {
//
//         await AwesomeNotifications()
//             .cancelAll();
//
//         debugPrint(
//           "🔕 DRIVER: Awesome notifications cleared",
//         );
//
//       } catch (e) {
//
//         debugPrint(
//           "⚠️ DRIVER: Awesome notification clear error: $e",
//         );
//       }
//
//       debugPrint(
//         "✅ DRIVER: COMPLETE CALL STATE CLEARED",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER: Clear complete call state error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//   static Future<void> saveIncomingCall(
//       Map<String, dynamic> data,
//       ) async {
//
//     try {
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//       final cleanData =
//       <String, dynamic>{};
//
//       data.forEach((key, value) {
//         cleanData[key] = value.toString();
//       });
//
//       /// Call saved time
//       cleanData['savedAt'] =
//           DateTime.now().millisecondsSinceEpoch.toString();
//
//       await prefs.setString(
//         'incoming_voice_call',
//         jsonEncode(cleanData),
//       );
//
//       await prefs.setBool(
//         'has_incoming_voice_call',
//         true,
//       );
//
//       debugPrint(
//         "📞 DRIVER Incoming call saved: $cleanData",
//       );
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ DRIVER Save incoming call error: $e",
//       );
//     }
//   }
//
//   /// =============================================================
//   /// GET INCOMING CALL
//   /// =============================================================
//   static Future<void> _handleCallDeclined(
//       Map<String, dynamic> data,
//       ) async {
//
//     try {
//
//       final callId =
//           data['callId']?.toString() ?? '';
//
//       debugPrint(
//         "🔕 CALLKIT END/DECLINE CALL ID: $callId",
//       );
//
//       /// ---------------------------------------------------------
//       /// END CALLKIT CALL
//       /// ---------------------------------------------------------
//
//       if (callId.isNotEmpty) {
//
//         try {
//
//           await FlutterCallkitIncoming.endCall(
//             callId,
//           );
//
//           debugPrint(
//             "✅ CallKit call ended",
//           );
//
//         } catch (e) {
//
//           debugPrint(
//             "⚠️ CallKit endCall error: $e",
//           );
//         }
//       }
//
//       /// ---------------------------------------------------------
//       /// CLEAR PENDING CALL
//       /// ---------------------------------------------------------
//
//       await clearIncomingCall();
//
//       /// ---------------------------------------------------------
//       /// CLEAR ACCEPTED CALL
//       /// ---------------------------------------------------------
//
//       await clearAcceptedCall();
//
//       /// ---------------------------------------------------------
//       /// CANCEL ALL AWESOME CALL NOTIFICATIONS
//       /// ---------------------------------------------------------
//
//       try {
//
//         await AwesomeNotifications()
//             .cancelAll();
//
//         debugPrint(
//           "🔕 Awesome notifications cancelled",
//         );
//
//       } catch (e) {
//
//         debugPrint(
//           "⚠️ Awesome cancelAll error: $e",
//         );
//       }
//
//       debugPrint(
//         "✅ DRIVER Call ended completely",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER decline/end error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//   static Future<void> clearAcceptedCall() async {
//
//     try {
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//       await prefs.remove(
//         'accepted_voice_call',
//       );
//
//       await prefs.setBool(
//         'has_accepted_voice_call',
//         false,
//       );
//
//       debugPrint(
//         "🧹 Accepted voice call cleared",
//       );
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ Clear accepted call error: $e",
//       );
//     }
//   }
//   static Future<Map<String, dynamic>?> getIncomingCall() async {
//
//     try {
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//       final hasCall =
//           prefs.getBool(
//             'has_incoming_voice_call',
//           ) ??
//               false;
//
//       if (!hasCall) {
//         return null;
//       }
//
//       final value =
//       prefs.getString(
//         'incoming_voice_call',
//       );
//
//       if (value == null || value.isEmpty) {
//
//         await clearIncomingCall();
//
//         return null;
//       }
//
//       final decoded = jsonDecode(value);
//
//       if (decoded is! Map<String, dynamic>) {
//
//         await clearIncomingCall();
//
//         return null;
//       }
//
//       final savedAt =
//       int.tryParse(
//         decoded['savedAt']?.toString() ?? '',
//       );
//
//       if (savedAt != null) {
//
//         final age =
//             DateTime.now().millisecondsSinceEpoch -
//                 savedAt;
//
//         /// 60 seconds se purani call invalid
//         if (age > 60000) {
//
//           debugPrint(
//             "⏰ DRIVER Old incoming call found. Clearing...",
//           );
//
//           await clearIncomingCall();
//
//           return null;
//         }
//       }
//
//       return decoded;
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ DRIVER Get incoming call error: $e",
//       );
//
//       return null;
//     }
//   }
//
//
//   /// =============================================================
//   /// CLEAR INCOMING CALL
//   /// =============================================================
//
//   static Future<void> clearIncomingCall() async {
//
//     try {
//
//       final prefs =
//       await SharedPreferences.getInstance();
//
//       await prefs.remove(
//         'incoming_voice_call',
//       );
//
//       await prefs.setBool(
//         'has_incoming_voice_call',
//         false,
//       );
//
//       debugPrint(
//         "🔕 DRIVER Incoming call cleared",
//       );
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER Clear incoming call error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// OPEN INCOMING CALL SCREEN
//   /// =============================================================
//
//   static Future<void>
//   openIncomingCallScreen(
//       Map<String, dynamic> data,
//       ) async {
//
//     try {
//
//       if (_isOpeningIncomingCall) {
//
//         debugPrint(
//           "⚠️ DRIVER Incoming call screen already opening",
//         );
//
//         return;
//       }
//
//
//       final navigator =
//           navigatorKey.currentState;
//
//
//       /// ---------------------------------------------------------
//       /// Navigator not ready
//       /// ---------------------------------------------------------
//
//       if (navigator == null) {
//
//         debugPrint(
//           "⏳ DRIVER Navigator not ready, retrying...",
//         );
//
//
//         Future.delayed(
//           const Duration(
//             milliseconds: 700,
//           ),
//               () {
//
//             openIncomingCallScreen(
//               data,
//             );
//           },
//         );
//
//
//         return;
//       }
//
//
//       /// ---------------------------------------------------------
//       /// Extract data
//       /// ---------------------------------------------------------
//
//       final token =
//           data['token']?.toString() ??
//               '';
//
//       final channelName =
//           data['channelName']?.toString() ??
//               '';
//
//       final callerName =
//           data['callerName']?.toString() ??
//               '';
//
//       final callerProfileImage =
//           data['callerProfileImage']
//               ?.toString() ??
//               '';
//
//       final uid =
//           int.tryParse(
//             data['uid']?.toString() ??
//                 '',
//           ) ??
//               0;
//
//       final bookingId =
//           data['bookingId']?.toString() ??
//               '';
//
//       final initiatedBy =
//           data['initiatedBy']?.toString() ??
//               '';
//
//
//       /// ---------------------------------------------------------
//       /// Validate
//       /// ---------------------------------------------------------
//
//       if (token.isEmpty ||
//           channelName.isEmpty ||
//           uid == 0 ||
//           bookingId.isEmpty) {
//
//         debugPrint(
//           "❌ DRIVER Invalid incoming call data",
//         );
//
//         debugPrint(
//           "Token: $token",
//         );
//
//         debugPrint(
//           "Channel: $channelName",
//         );
//
//         debugPrint(
//           "UID: $uid",
//         );
//
//         debugPrint(
//           "Booking ID: $bookingId",
//         );
//
//         return;
//       }
//
//
//       /// ---------------------------------------------------------
//       /// Prevent duplicate
//       /// ---------------------------------------------------------
//
//       _isOpeningIncomingCall =
//       true;
//
//
//       debugPrint(
//         "========================================",
//       );
//
//       debugPrint(
//         "📞 DRIVER OPENING INCOMING VOICE CALL",
//       );
//
//       debugPrint(
//         "Caller: $callerName",
//       );
//
//       debugPrint(
//         "Channel: $channelName",
//       );
//
//       debugPrint(
//         "UID: $uid",
//       );
//
//       debugPrint(
//         "Booking ID: $bookingId",
//       );
//
//       debugPrint(
//         "Initiated By: $initiatedBy",
//       );
//
//       debugPrint(
//         "========================================",
//       );
//
//
//       /// ---------------------------------------------------------
//       /// Open screen
//       /// ---------------------------------------------------------
//
//       await navigator.push(
//         MaterialPageRoute(
//           builder: (_) =>
//               IncomingVoiceCallScreen(
//
//                 callerName: callerName,
//                 callerProfileImage: callerProfileImage,
//                 token: token,
//                 channelName: channelName,
//                 uid: uid,
//                 bookingId: bookingId,
//                 initiatedBy: initiatedBy,
//               ),
//         ),
//       );
//
//
//       _isOpeningIncomingCall =
//       false;
//
//     } catch (e, stackTrace) {
//
//       _isOpeningIncomingCall =
//       false;
//
//
//       debugPrint(
//         "❌ DRIVER Open incoming call screen error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// CHECK PENDING CALL
//   /// =============================================================
//
//   static Future<void>
//   checkAndOpenIncomingCall() async {
//
//     try {
//
//       if (_isOpeningIncomingCall) {
//         return;
//       }
//
//
//       final data =
//       await getIncomingCall();
//
//
//       if (data == null) {
//
//         debugPrint(
//           "📞 DRIVER No pending incoming call",
//         );
//
//         return;
//       }
//
//
//       debugPrint(
//         "📞 DRIVER Pending incoming call found",
//       );
//
//       debugPrint(
//         "$data",
//       );
//
//
//       await openIncomingCallScreen(
//         data,
//       );
//
//     } catch (e) {
//
//       debugPrint(
//         "❌ DRIVER Check incoming call error: $e",
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// CHECK INITIAL FCM
//   /// =============================================================
//
//   static Future<void>
//   _checkInitialNotification() async {
//
//     try {
//
//       final message =
//       await FirebaseMessaging.instance
//           .getInitialMessage();
//
//
//       if (message == null) {
//
//         debugPrint(
//           "DRIVER: No initial FCM notification",
//         );
//
//         return;
//       }
//
//
//       debugPrint(
//         "🚀 DRIVER APP OPENED FROM FCM",
//       );
//
//
//       debugPrint(
//         "Initial Data: ${message.data}",
//       );
//
//
//       final data =
//       <String, dynamic>{};
//
//
//       message.data.forEach(
//             (key, value) {
//
//           data[key] =
//               value.toString();
//         },
//       );
//
//
//       final isIncomingVoiceCall =
//           data['type']?.toString() ==
//               'voiceCall' &&
//               data['notificationType']
//                   ?.toString() ==
//                   'incomingVoiceCall';
//
//
//       if (isIncomingVoiceCall) {
//
//         await saveIncomingCall(
//           data,
//         );
//       }
//
//     } catch (e, stackTrace) {
//
//       debugPrint(
//         "❌ DRIVER Initial notification error: $e",
//       );
//
//       debugPrint(
//         stackTrace.toString(),
//       );
//     }
//   }
//
//
//   /// =============================================================
//   /// HAS INCOMING CALL
//   /// =============================================================
//
//   static Future<bool>
//   hasIncomingCall() async {
//
//     final prefs =
//     await SharedPreferences
//         .getInstance();
//
//
//     return prefs.getBool(
//       'has_incoming_voice_call',
//     ) ??
//         false;
//   }
// }