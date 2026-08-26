import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../screen/bookingDetail/ui/IncomingVoiceCallScreen.dart';


/// ===============================================================
/// GLOBAL BACKGROUND FCM HANDLER
/// ===============================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {

  try {

    await Firebase.initializeApp();

    debugPrint(
      "========================================",
    );

    debugPrint(
      "🔥 DRIVER BACKGROUND FCM RECEIVED",
    );

    debugPrint(
      "TITLE: ${message.notification?.title}",
    );

    debugPrint(
      "BODY: ${message.notification?.body}",
    );

    debugPrint(
      "DATA: ${message.data}",
    );

    debugPrint(
      "========================================",
    );


    /// -----------------------------------------------------------
    /// Initialize Awesome Notifications
    /// -----------------------------------------------------------

    await FirebaseService.initializeAwesomeNotifications();


    /// -----------------------------------------------------------
    /// Convert payload
    /// -----------------------------------------------------------

    final data = <String, dynamic>{};

    message.data.forEach(
          (key, value) {
        data[key] = value.toString();
      },
    );


    /// -----------------------------------------------------------
    /// Check voice call
    /// -----------------------------------------------------------

    final isIncomingVoiceCall =
        data['type']?.toString() == 'voiceCall' &&
            data['notificationType']?.toString() ==
                'incomingVoiceCall';


    /// ===========================================================
    /// INCOMING VOICE CALL
    /// ===========================================================

    if (isIncomingVoiceCall) {

      debugPrint(
        "📞 DRIVER: Incoming voice call in background",
      );


      /// ---------------------------------------------------------
      /// Create notification ID
      /// ---------------------------------------------------------

      final notificationId =
      DateTime.now()
          .millisecondsSinceEpoch
          .remainder(100000);


      /// Save notification id also
      data['notificationId'] =
          notificationId.toString();


      /// ---------------------------------------------------------
      /// Save incoming call
      /// ---------------------------------------------------------

      await FirebaseService.saveIncomingCall(
        data,
      );


      /// ---------------------------------------------------------
      /// Create full screen notification
      /// ---------------------------------------------------------

      await AwesomeNotifications().createNotification(
        content: NotificationContent(

          id: notificationId,

          channelKey: 'incoming_call',

          title:
          message.notification?.title ??
              'Incoming Voice Call',

          body:
          message.notification?.body ??
              '${data['callerName'] ?? 'Someone'} is calling you',

          category:
          NotificationCategory.Call,

          wakeUpScreen: true,

          fullScreenIntent: true,

          autoDismissible: false,

          locked: true,

          notificationLayout:
          NotificationLayout.Default,

          payload: data.map(
                (key, value) =>
                MapEntry(
                  key,
                  value.toString(),
                ),
          ),
        ),
      );


      debugPrint(
        "📞 DRIVER Incoming call notification created",
      );

      return;
    }


    /// ===========================================================
    /// NORMAL NOTIFICATION
    /// ===========================================================

    final notificationId =
    DateTime.now()
        .millisecondsSinceEpoch
        .remainder(100000);


    await AwesomeNotifications().createNotification(
      content: NotificationContent(

        id: notificationId,

        channelKey: 'basic_channel',

        title:
        message.notification?.title ??
            message.data['title']?.toString() ??
            '',

        body:
        message.notification?.body ??
            message.data['body']?.toString() ??
            '',

        payload: data.map(
              (key, value) =>
              MapEntry(
                key,
                value.toString(),
              ),
        ),
      ),
    );

  } catch (e, stackTrace) {

    debugPrint(
      "❌ DRIVER Background FCM error: $e",
    );

    debugPrint(
      stackTrace.toString(),
    );
  }
}


/// ===============================================================
/// AWESOME NOTIFICATION ACTION HANDLER
/// ===============================================================

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(
    ReceivedAction action,
    ) async {

  try {

    debugPrint(
      "========================================",
    );

    debugPrint(
      "🔔 DRIVER NOTIFICATION ACTION",
    );

    debugPrint(
      "PAYLOAD: ${action.payload}",
    );

    debugPrint(
      "NOTIFICATION ID: ${action.id}",
    );

    debugPrint(
      "========================================",
    );


    final payload =
        action.payload;


    final data =
    <String, dynamic>{};


    payload?.forEach(
          (key, value) {
        data[key] = value;
      },
    );


    final isIncomingVoiceCall =
        data['type']?.toString() == 'voiceCall' &&
            data['notificationType']?.toString() ==
                'incomingVoiceCall';


    if (isIncomingVoiceCall) {

      debugPrint(
        "📞 DRIVER: Incoming call notification clicked",
      );


      /// ---------------------------------------------------------
      /// Save payload
      /// ---------------------------------------------------------

      await FirebaseService.saveIncomingCall(
        data,
      );


      /// ---------------------------------------------------------
      /// IMPORTANT
      /// Cancel notification after click
      /// ---------------------------------------------------------

      try {
        if (action.id != null) {
          await AwesomeNotifications().cancel(action.id!);
        }

        debugPrint(
          "🔕 DRIVER call notification cancelled",
        );

      } catch (e) {

        debugPrint(
          "⚠️ DRIVER notification cancel error: $e",
        );
      }


      /// ---------------------------------------------------------
      /// Main isolate will detect app resume
      /// and open IncomingVoiceCallScreen.
      /// ---------------------------------------------------------

      return;
    }

  } catch (e, stackTrace) {

    debugPrint(
      "❌ DRIVER Notification action error: $e",
    );

    debugPrint(
      stackTrace.toString(),
    );
  }
}


/// ===============================================================
/// FIREBASE SERVICE - DRIVER
/// ===============================================================

class FirebaseService {

  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;


  static bool _isOpeningIncomingCall =
  false;


  /// =============================================================
  /// INITIALIZE
  /// =============================================================

  static Future<void> init() async {

    try {

      debugPrint(
        "🔥 DRIVER FirebaseService initialization started",
      );

// ???????????????????????????????Balawant 25 agust
      /// Permission

      await _requestPermission();

      // await initializeCallKit();
      /// Awesome Notifications

      await initializeAwesomeNotifications();


      /// Listener

      await AwesomeNotifications().setListeners(
        onActionReceivedMethod:
        onActionReceivedMethod,
      );


      /// Device ID

      await _printDeviceId();


      /// FCM token

      await _getFcmToken();


      /// Token refresh

      _listenTokenRefresh();


      /// Foreground FCM

      _listenForegroundNotification();


      /// FCM cold start

      await _checkInitialNotification();


      debugPrint(
        "✅ DRIVER FirebaseService initialized successfully",
      );

    } catch (e, stackTrace) {

      debugPrint(
        "❌ DRIVER FirebaseService initialization error: $e",
      );

      debugPrint(
        stackTrace.toString(),
      );
    }
  }


  /// =============================================================
  /// PERMISSION
  /// =============================================================

  static Future<void> _requestPermission() async {

    try {

      final settings =
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );


      debugPrint(
        "DRIVER Notification permission: "
            "${settings.authorizationStatus}",
      );


      if (Platform.isAndroid) {

        final allowed =
        await AwesomeNotifications()
            .isNotificationAllowed();


        if (!allowed) {

          await AwesomeNotifications()
              .requestPermissionToSendNotifications();
        }
      }

    } catch (e) {

      debugPrint(
        "❌ DRIVER Permission error: $e",
      );
    }
  }


  /// =============================================================
  /// AWESOME NOTIFICATIONS
  /// =============================================================

  static Future<void>
  initializeAwesomeNotifications() async {

    try {
      debugPrint("========================================");
      debugPrint("🔔 DRIVER: INITIALIZING AWESOME NOTIFICATIONS");
      debugPrint("========================================");


      final initialized =
      await AwesomeNotifications().initialize(

        null,

        [

          /// -----------------------------------------------------
          /// INCOMING CALL CHANNEL
          /// -----------------------------------------------------

          NotificationChannel(
            channelKey: 'incoming_call',
            channelName: 'Incoming Calls',
            channelDescription: 'Incoming voice call notifications',

            importance: NotificationImportance.Max,

            channelShowBadge: true,

            playSound: true,

            soundSource: 'resource://raw/sound',

            defaultRingtoneType: DefaultRingtoneType.Ringtone,

            enableVibration: true,

            locked: true,

            defaultColor: const Color(0xFF03045E),

            ledColor: Colors.white,

            criticalAlerts: true,
          ),


          /// -----------------------------------------------------
          /// BASIC CHANNEL
          /// -----------------------------------------------------

          NotificationChannel(

            channelKey:
            'basic_channel',

            channelName:
            'Basic Notifications',

            channelDescription:
            'Application notifications',

            importance:
            NotificationImportance.High,

            channelShowBadge:
            true,

            playSound:
            true,

            soundSource:
            'resource://raw/sound',

            enableVibration:
            true,
          ),
        ],

        debug: true,
      );


      debugPrint("========================================");
      debugPrint("🔔 AWESOME INITIALIZED: $initialized");
      debugPrint("🔊 INCOMING CHANNEL: incoming_call");
      debugPrint("🔊 SOUND SOURCE: resource://raw/sound");
      debugPrint("🔊 PLAY SOUND: true");
      debugPrint("📳 VIBRATION: true");
      debugPrint("📢 IMPORTANCE: MAX");
      debugPrint("📞 RINGTONE TYPE: Ringtone");
      debugPrint("========================================");
      final allowed =
      await AwesomeNotifications().isNotificationAllowed();

      debugPrint(
        "🔔 NOTIFICATION PERMISSION: $allowed",
      );

    } catch (e, stackTrace) {

      debugPrint(
        "❌ DRIVER Awesome Notification initialization error: $e",
      );

      debugPrint(
        stackTrace.toString(),
      );

      rethrow;
    }
  }


  /// =============================================================
  /// DEVICE ID
  /// =============================================================

  static Future<void> _printDeviceId() async {

    try {

      final deviceInfo =
      DeviceInfoPlugin();

      final prefs =
      await SharedPreferences.getInstance();


      if (Platform.isAndroid) {

        final androidInfo =
        await deviceInfo.androidInfo;

        final deviceId =
            androidInfo.id;


        await prefs.setString(
          "deviceId",
          deviceId,
        );

        await prefs.setString(
          "deviceType",
          "ANDROID",
        );


        debugPrint(
          "DRIVER DEVICE ID : $deviceId",
        );

        debugPrint(
          "DRIVER DEVICE TYPE : ANDROID",
        );
      }


      if (Platform.isIOS) {

        final iosInfo =
        await deviceInfo.iosInfo;

        final deviceId =
            iosInfo.identifierForVendor ??
                '';


        await prefs.setString(
          "deviceId",
          deviceId,
        );

        await prefs.setString(
          "deviceType",
          "IOS",
        );


        debugPrint(
          "DRIVER DEVICE ID : $deviceId",
        );

        debugPrint(
          "DRIVER DEVICE TYPE : IOS",
        );
      }

    } catch (e) {

      debugPrint(
        "❌ DRIVER Device ID error: $e",
      );
    }
  }


  /// =============================================================
  /// FCM TOKEN
  /// =============================================================

  static Future<void> _getFcmToken() async {

    try {

      if (Platform.isIOS) {

        String? apnsToken;

        int retry = 0;


        while (
        apnsToken == null &&
            retry < 5
        ) {

          apnsToken =
          await _messaging.getAPNSToken();


          if (apnsToken == null) {

            await Future.delayed(
              const Duration(
                seconds: 1,
              ),
            );
          }

          retry++;
        }


        debugPrint(
          "DRIVER APNS TOKEN : $apnsToken",
        );
      }


      final token =
      await _messaging.getToken();


      if (token != null &&
          token.isNotEmpty) {

        final prefs =
        await SharedPreferences
            .getInstance();


        await prefs.setString(
          "deviceToken",
          token,
        );


        debugPrint(
          "DRIVER FCM TOKEN : $token",
        );
      }

    } catch (e) {

      debugPrint(
        "❌ DRIVER FCM Token error: $e",
      );
    }
  }


  /// =============================================================
  /// TOKEN REFRESH
  /// =============================================================

  static void _listenTokenRefresh() {

    _messaging.onTokenRefresh.listen(
          (token) async {

        try {

          final prefs =
          await SharedPreferences
              .getInstance();


          await prefs.setString(
            "deviceToken",
            token,
          );


          debugPrint(
            "🔄 DRIVER FCM TOKEN REFRESHED: $token",
          );

        } catch (e) {

          debugPrint(
            "❌ DRIVER token refresh error: $e",
          );
        }
      },
    );
  }


  /// =============================================================
  /// FOREGROUND FCM
  /// =============================================================

  static void _listenForegroundNotification() {

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) async {

        try {

          debugPrint(
            "========================================",
          );

          debugPrint(
            "📩 DRIVER FOREGROUND FCM RECEIVED",
          );

          debugPrint(
            "TITLE: ${message.notification?.title}",
          );

          debugPrint(
            "BODY: ${message.notification?.body}",
          );

          debugPrint(
            "DATA: ${message.data}",
          );

          debugPrint(
            "========================================",
          );


          final data =
          <String, dynamic>{};


          message.data.forEach(
                (key, value) {

              data[key] =
                  value.toString();
            },
          );


          final isIncomingVoiceCall =
              data['type']?.toString() ==
                  'voiceCall' &&
                  data['notificationType']
                      ?.toString() ==
                      'incomingVoiceCall';


          /// =====================================================
          /// INCOMING CALL
          /// =====================================================

          if (isIncomingVoiceCall) {

            debugPrint(
              "📞 DRIVER: Incoming call in foreground",
            );


            final notificationId =
            DateTime.now()
                .millisecondsSinceEpoch
                .remainder(100000);


            data['notificationId'] =
                notificationId.toString();


            /// Save

            await saveIncomingCall(
              data,
            );


            /// Notification

            await AwesomeNotifications()
                .createNotification(

              content:
              NotificationContent(

                id:
                notificationId,

                channelKey:
                'incoming_call',

                title:
                message.notification?.title ??
                    'Incoming Voice Call',

                body:
                message.notification?.body ??
                    '${data['callerName'] ?? 'Someone'} is calling you',

                category:
                NotificationCategory.Call,

                wakeUpScreen:
                true,

                fullScreenIntent:
                true,

                autoDismissible:
                false,

                locked:
                true,

                notificationLayout:
                NotificationLayout.Default,

                payload:
                data.map(
                      (key, value) =>
                      MapEntry(
                        key,
                        value.toString(),
                      ),
                ),
              ),
            );


            /// ---------------------------------------------------
            /// Foreground = directly open
            /// ---------------------------------------------------

            await openIncomingCallScreen(
              data,
            );


            return;
          }


          /// =====================================================
          /// NORMAL NOTIFICATION
          /// =====================================================

          final notificationId =
          DateTime.now()
              .millisecondsSinceEpoch
              .remainder(100000);


          await AwesomeNotifications()
              .createNotification(

            content:
            NotificationContent(

              id:
              notificationId,

              channelKey:
              'basic_channel',

              title:
              message.notification?.title ??
                  message.data['title']
                      ?.toString() ??
                  '',

              body:
              message.notification?.body ??
                  message.data['body']
                      ?.toString() ??
                  '',

              payload:
              data.map(
                    (key, value) =>
                    MapEntry(
                      key,
                      value.toString(),
                    ),
              ),
            ),
          );

        } catch (e, stackTrace) {

          debugPrint(
            "❌ DRIVER Foreground notification error: $e",
          );

          debugPrint(
            stackTrace.toString(),
          );
        }
      },
    );
  }


  /// =============================================================
  /// SAVE INCOMING CALL
  /// =============================================================

  static Future<void> saveIncomingCall(
      Map<String, dynamic> data,
      ) async {

    try {

      final prefs =
      await SharedPreferences
          .getInstance();


      final cleanData =
      <String, dynamic>{};


      data.forEach(
            (key, value) {

          cleanData[key] =
              value.toString();
        },
      );


      await prefs.setString(
        'incoming_voice_call',
        jsonEncode(cleanData),
      );


      await prefs.setBool(
        'has_incoming_voice_call',
        true,
      );


      debugPrint(
        "📞 DRIVER Incoming call saved: $cleanData",
      );

    } catch (e) {

      debugPrint(
        "❌ DRIVER Save incoming call error: $e",
      );
    }
  }


  /// =============================================================
  /// GET INCOMING CALL
  /// =============================================================

  static Future<Map<String, dynamic>?>
  getIncomingCall() async {

    try {

      final prefs =
      await SharedPreferences
          .getInstance();


      final hasCall =
          prefs.getBool(
            'has_incoming_voice_call',
          ) ??
              false;


      if (!hasCall) {
        return null;
      }


      final value =
      prefs.getString(
        'incoming_voice_call',
      );


      if (value == null ||
          value.isEmpty) {

        return null;
      }


      final decoded =
      jsonDecode(value);


      if (decoded
      is Map<String, dynamic>) {

        return decoded;
      }


      return null;

    } catch (e) {

      debugPrint(
        "❌ DRIVER Get incoming call error: $e",
      );

      return null;
    }
  }


  /// =============================================================
  /// CLEAR INCOMING CALL
  /// =============================================================

  static Future<void>
  clearIncomingCall() async {

    try {

      final prefs =
      await SharedPreferences
          .getInstance();


      await prefs.remove(
        'incoming_voice_call',
      );


      await prefs.setBool(
        'has_incoming_voice_call',
        false,
      );


      /// ---------------------------------------------------------
      /// VERY IMPORTANT
      /// Stop notification/ringtone
      /// ---------------------------------------------------------

      await AwesomeNotifications()
          .cancelAll();


      debugPrint(
        "🔕 DRIVER Incoming call cleared + notification cancelled",
      );

    } catch (e) {

      debugPrint(
        "❌ DRIVER Clear incoming call error: $e",
      );
    }
  }


  /// =============================================================
  /// OPEN INCOMING CALL SCREEN
  /// =============================================================

  static Future<void>
  openIncomingCallScreen(
      Map<String, dynamic> data,
      ) async {

    try {

      if (_isOpeningIncomingCall) {

        debugPrint(
          "⚠️ DRIVER Incoming call screen already opening",
        );

        return;
      }


      final navigator =
          navigatorKey.currentState;


      /// ---------------------------------------------------------
      /// Navigator not ready
      /// ---------------------------------------------------------

      if (navigator == null) {

        debugPrint(
          "⏳ DRIVER Navigator not ready, retrying...",
        );


        Future.delayed(
          const Duration(
            milliseconds: 700,
          ),
              () {

            openIncomingCallScreen(
              data,
            );
          },
        );


        return;
      }


      /// ---------------------------------------------------------
      /// Extract data
      /// ---------------------------------------------------------

      final token =
          data['token']?.toString() ??
              '';

      final channelName =
          data['channelName']?.toString() ??
              '';

      final callerName =
          data['callerName']?.toString() ??
              '';

      final callerProfileImage =
          data['callerProfileImage']
              ?.toString() ??
              '';

      final uid =
          int.tryParse(
            data['uid']?.toString() ??
                '',
          ) ??
              0;

      final bookingId =
          data['bookingId']?.toString() ??
              '';

      final initiatedBy =
          data['initiatedBy']?.toString() ??
              '';


      /// ---------------------------------------------------------
      /// Validate
      /// ---------------------------------------------------------

      if (token.isEmpty ||
          channelName.isEmpty ||
          uid == 0 ||
          bookingId.isEmpty) {

        debugPrint(
          "❌ DRIVER Invalid incoming call data",
        );

        debugPrint(
          "Token: $token",
        );

        debugPrint(
          "Channel: $channelName",
        );

        debugPrint(
          "UID: $uid",
        );

        debugPrint(
          "Booking ID: $bookingId",
        );

        return;
      }


      /// ---------------------------------------------------------
      /// Prevent duplicate
      /// ---------------------------------------------------------

      _isOpeningIncomingCall =
      true;


      debugPrint(
        "========================================",
      );

      debugPrint(
        "📞 DRIVER OPENING INCOMING VOICE CALL",
      );

      debugPrint(
        "Caller: $callerName",
      );

      debugPrint(
        "Channel: $channelName",
      );

      debugPrint(
        "UID: $uid",
      );

      debugPrint(
        "Booking ID: $bookingId",
      );

      debugPrint(
        "Initiated By: $initiatedBy",
      );

      debugPrint(
        "========================================",
      );


      /// ---------------------------------------------------------
      /// Open screen
      /// ---------------------------------------------------------

      await navigator.push(
        MaterialPageRoute(
          builder: (_) =>
              IncomingVoiceCallScreen(

                callerName:
                callerName,

                callerProfileImage:
                callerProfileImage,

                token:
                token,

                channelName:
                channelName,

                uid:
                uid,

                bookingId:
                bookingId,

                initiatedBy:
                initiatedBy,
              ),
        ),
      );


      _isOpeningIncomingCall =
      false;

    } catch (e, stackTrace) {

      _isOpeningIncomingCall =
      false;


      debugPrint(
        "❌ DRIVER Open incoming call screen error: $e",
      );

      debugPrint(
        stackTrace.toString(),
      );
    }
  }


  /// =============================================================
  /// CHECK PENDING CALL
  /// =============================================================

  static Future<void>
  checkAndOpenIncomingCall() async {

    try {

      if (_isOpeningIncomingCall) {
        return;
      }


      final data =
      await getIncomingCall();


      if (data == null) {

        debugPrint(
          "📞 DRIVER No pending incoming call",
        );

        return;
      }


      debugPrint(
        "📞 DRIVER Pending incoming call found",
      );

      debugPrint(
        "$data",
      );


      await openIncomingCallScreen(
        data,
      );

    } catch (e) {

      debugPrint(
        "❌ DRIVER Check incoming call error: $e",
      );
    }
  }


  /// =============================================================
  /// CHECK INITIAL FCM
  /// =============================================================

  static Future<void>
  _checkInitialNotification() async {

    try {

      final message =
      await FirebaseMessaging.instance
          .getInitialMessage();


      if (message == null) {

        debugPrint(
          "DRIVER: No initial FCM notification",
        );

        return;
      }


      debugPrint(
        "🚀 DRIVER APP OPENED FROM FCM",
      );


      debugPrint(
        "Initial Data: ${message.data}",
      );


      final data =
      <String, dynamic>{};


      message.data.forEach(
            (key, value) {

          data[key] =
              value.toString();
        },
      );


      final isIncomingVoiceCall =
          data['type']?.toString() ==
              'voiceCall' &&
              data['notificationType']
                  ?.toString() ==
                  'incomingVoiceCall';


      if (isIncomingVoiceCall) {

        await saveIncomingCall(
          data,
        );
      }

    } catch (e, stackTrace) {

      debugPrint(
        "❌ DRIVER Initial notification error: $e",
      );

      debugPrint(
        stackTrace.toString(),
      );
    }
  }


  /// =============================================================
  /// HAS INCOMING CALL
  /// =============================================================

  static Future<bool>
  hasIncomingCall() async {

    final prefs =
    await SharedPreferences
        .getInstance();


    return prefs.getBool(
      'has_incoming_voice_call',
    ) ??
        false;
  }
}