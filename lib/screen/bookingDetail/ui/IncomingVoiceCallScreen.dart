import 'package:flutter/material.dart';

import '../../../apiservice/services/firebaseService.dart';
import 'voiceCallScreen.dart';


class IncomingVoiceCallScreen
    extends StatefulWidget {

  final String callerName;
  final String callerProfileImage;
  final String token;
  final String channelName;
  final int uid;
  final String bookingId;
  final String initiatedBy;


  const IncomingVoiceCallScreen({
    super.key,

    required this.callerName,
    required this.callerProfileImage,
    required this.token,
    required this.channelName,
    required this.uid,
    required this.bookingId,
    required this.initiatedBy,
  });


  @override
  State<IncomingVoiceCallScreen>
  createState() =>
      _IncomingVoiceCallScreenState();
}


class _IncomingVoiceCallScreenState
    extends State<IncomingVoiceCallScreen> {

  bool accepting = false;
  bool rejecting = false;


  @override
  Widget build(BuildContext context) {

    return PopScope(

      canPop: false,

      child: Scaffold(

        backgroundColor:
        Colors.black,

        body: SafeArea(

          child: Column(

            children: [

              const Spacer(),


              /// -------------------------------------------------
              /// PROFILE
              /// -------------------------------------------------

              CircleAvatar(

                radius: 65,

                backgroundImage:
                widget.callerProfileImage
                    .isNotEmpty
                    ? NetworkImage(
                  widget
                      .callerProfileImage,
                )
                    : null,

                child:
                widget.callerProfileImage
                    .isEmpty
                    ? const Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.white,
                )
                    : null,
              ),


              const SizedBox(
                height: 25,
              ),


              /// -------------------------------------------------
              /// CALLER NAME
              /// -------------------------------------------------

              Text(

                widget.callerName,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontSize:
                  25,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),


              const SizedBox(
                height: 8,
              ),


              const Text(

                "Incoming Voice Call",

                style:
                TextStyle(

                  color:
                  Colors.white70,

                  fontSize:
                  17,
                ),
              ),


              const Spacer(),


              /// -------------------------------------------------
              /// BUTTONS
              /// -------------------------------------------------

              Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,

                children: [

                  /// ===========================================
                  /// REJECT
                  /// ===========================================

                  GestureDetector(

                    onTap:
                    rejecting ||
                        accepting
                        ? null
                        : _reject,

                    child:
                    Container(

                      width: 68,
                      height: 68,

                      decoration:
                      const BoxDecoration(
                        color:
                        Colors.red,
                        shape:
                        BoxShape.circle,
                      ),

                      child:
                      rejecting
                          ? const Padding(
                        padding:
                        EdgeInsets.all(18),
                        child:
                        CircularProgressIndicator(
                          color:
                          Colors.white,
                          strokeWidth:
                          3,
                        ),
                      )
                          : const Icon(
                        Icons.call_end,
                        color:
                        Colors.white,
                        size:
                        32,
                      ),
                    ),
                  ),


                  /// ===========================================
                  /// ACCEPT
                  /// ===========================================

                  GestureDetector(

                    onTap:
                    accepting ||
                        rejecting
                        ? null
                        : _accept,

                    child:
                    Container(

                      width: 68,
                      height: 68,

                      decoration:
                      const BoxDecoration(
                        color:
                        Colors.green,
                        shape:
                        BoxShape.circle,
                      ),

                      child:
                      accepting
                          ? const Padding(
                        padding:
                        EdgeInsets.all(18),
                        child:
                        CircularProgressIndicator(
                          color:
                          Colors.white,
                          strokeWidth:
                          3,
                        ),
                      )
                          : const Icon(
                        Icons.call,
                        color:
                        Colors.white,
                        size:
                        32,
                      ),
                    ),
                  ),
                ],
              ),


              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// =============================================================
  /// ACCEPT
  /// =============================================================

  Future<void> _accept() async {

    setState(() {
      accepting = true;
    });


    debugPrint(
      "📞 DRIVER ACCEPTING CALL",
    );


    /// -----------------------------------------------------------
    /// VERY IMPORTANT
    /// Clear saved call + cancel ringtone notification
    /// -----------------------------------------------------------

    await FirebaseService
        .clearIncomingCall();


    if (!mounted) {
      return;
    }


    /// -----------------------------------------------------------
    /// Open Agora call screen
    /// -----------------------------------------------------------

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            VoiceCallScreen(

              appId:
              "b2ec8d246fb3407f8bf76884a32d7a47",

              token:
              widget.token,

              channelName:
              widget.channelName,

              uid:
              widget.uid,

              bookingId:
              widget.bookingId,
            ),
      ),
    );
  }


  /// =============================================================
  /// REJECT
  /// =============================================================

  Future<void> _reject() async {

    setState(() {
      rejecting = true;
    });


    debugPrint(
      "📞 DRIVER REJECTING CALL",
    );


    /// -----------------------------------------------------------
    /// Clear call + stop ringtone
    /// -----------------------------------------------------------

    await FirebaseService
        .clearIncomingCall();


    if (!mounted) {
      return;
    }


    Navigator.pop(
      context,
    );
  }
}