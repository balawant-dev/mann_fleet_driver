import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/services/firebaseService.dart';

class VoiceCallScreen extends StatefulWidget {
  final String appId;
  final String token;
  final String channelName;
  final int uid;
  final String bookingId;

  const VoiceCallScreen({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
    required this.uid,
    required this.bookingId,
  });

  @override
  State<VoiceCallScreen> createState() =>
      _VoiceCallScreenState();
}

class _VoiceCallScreenState
    extends State<VoiceCallScreen> {
  Timer? _callTimer;
  int _callSeconds = 0;

  RtcEngine? _engine;

  bool joined = false;
  bool remoteJoined = false;
  bool muted = false;
  bool initializing = true;
  bool ending = false;

  @override
  void initState() {
    super.initState();

    _initialize();
  }
  void _startCallTimer() {
    if (_callTimer != null) return;

    _callSeconds = 0;

    _callTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        setState(() {
          _callSeconds++;
        });
      },
    );
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
  }

  String _formatCallDuration() {
    final hours = _callSeconds ~/ 3600;
    final minutes = (_callSeconds % 3600) ~/ 60;
    final seconds = _callSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
  Future<void> _initialize() async {
    try {

      final permission =
      await Permission.microphone.request();

      if (!permission.isGranted) {
        throw Exception(
          "Microphone permission denied",
        );
      }

      final engine =
      createAgoraRtcEngine();

      _engine = engine;

      await engine.initialize(
        RtcEngineContext(
          appId: widget.appId,
        ),
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(

          onJoinChannelSuccess:
              (connection, elapsed) {

            debugPrint(
              "AGORA JOIN SUCCESS "
                  "${connection.localUid}",
            );

            if (!mounted) return;

            setState(() {
              joined = true;
              initializing = false;
            });
          },

          onUserJoined:
              (connection, remoteUid, elapsed) {

            debugPrint(
              "REMOTE JOINED: $remoteUid",
            );

            if (!mounted) return;

            setState(() {
              remoteJoined = true;
            });

            // Remote user connected = actual call started
            _startCallTimer();
          },

          onUserOffline:
              (
              connection,
              remoteUid,
              reason,
              ) {

            debugPrint(
              "REMOTE LEFT: $remoteUid",
            );

            if (!mounted) return;

            setState(() {
              remoteJoined = false;
            });

            _endCall();
          },

          onError: (error, message) {
            debugPrint(
              "AGORA ERROR: $error $message",
            );
          },

          onConnectionStateChanged:
              (
              connection,
              state,
              reason,
              ) {

            debugPrint(
              "CONNECTION: $state / $reason",
            );
          },
        ),
      );

      await engine.setClientRole(
        role:
        ClientRoleType
            .clientRoleBroadcaster,
      );

      await engine.enableAudio();

      await engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid,
        options:
        const ChannelMediaOptions(
          channelProfile:
          ChannelProfileType
              .channelProfileCommunication,

          clientRoleType:
          ClientRoleType
              .clientRoleBroadcaster,

          publishMicrophoneTrack: true,

          autoSubscribeAudio: true,
        ),
      );

      await engine.enableLocalAudio(true);

    } catch (e, stackTrace) {

      debugPrint(
        "❌ Agora error: $e",
      );

      debugPrint(
        stackTrace.toString(),
      );

      if (!mounted) return;

      setState(() {
        initializing = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text("Unable to start call: $e"),
        ),
      );
    }
  }

  Future<void> _mute() async {

    final engine = _engine;

    if (engine == null) return;

    final value = !muted;

    await engine.muteLocalAudioStream(
      value,
    );

    if (!mounted) return;

    setState(() {
      muted = value;
    });
  }

  Future<void> _endCall() async {

    if (ending) return;

    ending = true;

    debugPrint(
      "📞 ENDING VOICE CALL",
    );

    _stopCallTimer();

    /// ---------------------------------------------------------
    /// CLEAR PENDING CALL
    /// ---------------------------------------------------------

    await FirebaseService.clearIncomingCall();

    /// ---------------------------------------------------------
    /// CLEAR ACCEPTED CALL
    /// ---------------------------------------------------------
//Balawant kumar done code ok
    // await FirebaseService.clearAcceptedCall();
    // await FirebaseService.clearCallState();

    /// ---------------------------------------------------------
    /// END CALLKIT CALL
    /// ---------------------------------------------------------

    try {

      final prefs =
      await SharedPreferences.getInstance();

      final acceptedJson =
      prefs.getString(
        'accepted_voice_call',
      );

      if (acceptedJson != null &&
          acceptedJson.isNotEmpty) {

        final data =
        jsonDecode(acceptedJson);

        final callId =
            data['callId']?.toString() ?? '';

        if (callId.isNotEmpty) {

          await FlutterCallkitIncoming.endCall(
            callId,
          );

          debugPrint(
            "✅ CallKit ended from VoiceCallScreen",
          );
        }
      }

    } catch (e) {

      debugPrint(
        "⚠️ CallKit cleanup error: $e",
      );
    }

    /// ---------------------------------------------------------
    /// CANCEL AWESOME NOTIFICATIONS
    /// ---------------------------------------------------------

    try {

      await AwesomeNotifications()
          .cancelAll();

      debugPrint(
        "🔕 Notifications cancelled",
      );

    } catch (e) {

      debugPrint(
        "⚠️ Notification cancel error: $e",
      );
    }

    /// ---------------------------------------------------------
    /// LEAVE AGORA
    /// ---------------------------------------------------------

    try {

      final engine =
          _engine;

      if (engine != null) {

        await engine.leaveChannel();

        await engine.release();

        _engine = null;

        debugPrint(
          "✅ Agora released",
        );
      }

    } catch (e) {

      debugPrint(
        "⚠️ Agora end error: $e",
      );
    }

    /// ---------------------------------------------------------
    /// CLOSE SCREEN
    /// ---------------------------------------------------------

    if (mounted) {

      Navigator.of(context)
          .pop();
    }
  }

  @override
  void dispose() {
    _stopCallTimer();

    final engine = _engine;

    if (engine != null) {
      engine.leaveChannel();
      engine.release();
      _engine = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult:
          (didPop, result) {

        if (!didPop) {
          _endCall();
        }
      },

      child: Scaffold(
        backgroundColor: Colors.black,

        body: SafeArea(
          child: Column(
            children: [

              const Spacer(),

              const CircleAvatar(
                radius: 60,
                child: Icon(
                  Icons.person,
                  size: 60,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                initializing
                    ? "Connecting..."
                    : remoteJoined
                    ? "Connected"
                    : joined
                    ? "Ringing..."
                    : "Connecting...",
                style:
                const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                remoteJoined
                    ? _formatCallDuration()
                    : "Waiting for response...",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                    Colors.white12,
                    child: IconButton(
                      onPressed:
                      initializing
                          ? null
                          : _mute,
                      icon: Icon(
                        muted
                            ? Icons.mic_off
                            : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 35),

                  CircleAvatar(
                    radius: 33,
                    backgroundColor:
                    Colors.red,
                    child: IconButton(
                      onPressed: _endCall,
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}