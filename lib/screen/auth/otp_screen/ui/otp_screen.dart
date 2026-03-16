import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:pinput/pinput.dart';
import '../../../../widget/commonAppButton.dart';
import '../../../home_screen/ui/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController otpController = TextEditingController();

  int secondsRemaining = 24;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    setState(() {
      secondsRemaining = 24;
    });
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0,3),
          )
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                const SizedBox(height: 310),

                const Text(
                  "Verify your number",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff4A4F58),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'We have sent a verification code to',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF3E4959),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '+91 ${widget.mobileNumber}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF3E4959),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10,),
                    CustomImageView(
                        imagePath: AppImages.editImage,
                      fit: BoxFit.cover,
                      height: 14,
                      width: 14,
                    )
                  ],
                ),

                const SizedBox(height: 10),
                Pinput(
                  controller: otpController,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                ),
                const SizedBox(height: 15),
                CommonAppButton(
                  text: 'Get Started',
                  onPressed: () {
                    navPush(context: context, action: HomeScreen());
                    if (otpController.text.length != 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter valid OTP")),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  'Didn’t receive the OTP SMS?',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.90),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                secondsRemaining > 0
                    ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Send OTP again in ',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.90),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '0:$secondsRemaining',
                        style: const TextStyle(
                          color: Color(0xFF00A642),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ' sec',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.90),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
                    : GestureDetector(
                  onTap: resendOtp,
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Color(0xFF00A642),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}