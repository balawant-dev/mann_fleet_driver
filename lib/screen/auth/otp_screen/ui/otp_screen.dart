import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:pinput/pinput.dart';
import '../../../../util/color/app_colors.dart';
import '../../../../widget/commonAppButton.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../bottomBar/bottomBar.dart';
import '../../../home_screen/ui/home_screen.dart';

import '../../register/ui/registerScreen.dart';
import '../otpProvider/otpProvider.dart';
import 'package:provider/provider.dart';


class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final TextEditingController otpController = TextEditingController();

  int secondsRemaining = 59;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }
  bool get isOtpValid => otpController.text.length == 4;
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

  void resendOtp() async {
    final provider = context.read<OtpProvider>();

    showLoader(context);

    await provider.resendOtpApi(
      context: context,
      phone: widget.mobileNumber,
    );

    Navigator.pop(context);

    if (provider.resendOtpModel != null &&
        provider.resendOtpModel!.status == true) {

      setState(() {
        secondsRemaining = 24;
      });

      startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Resent Successfully")),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to resend OTP")),
      );
    }
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
      height: 60,
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

                        // imagePath: "assets/images/editImage.png",

                        imagePath: AppImages.editImage,

                      fit: BoxFit.cover,
                      height: 14,
                      width: 14,
                    )
                  ],
                ),

                const SizedBox(height: 15),
                Pinput(
                  controller: otpController,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  onChanged: (value) {
                    setState(() {}); // 👈 IMPORTANT
                  },
                ),
                const SizedBox(height: 25),
                //
           // navPush(context: context, action: RegisterScreen());
                CommonAppButton(
                  text: 'Verify Now',
                  backgroundColor: isOtpValid ? ColorResource.primaryColor : Colors.grey,
                  onPressed: isOtpValid
                      ? () async {
                    showLoader(context);

                    final provider = context.read<OtpProvider>();

                    await provider.verifyOtp(
                        context: context,
                        phone: widget.mobileNumber,
                        otp: otpController.text,
                        fcmToken: "Jab Firebase par kaam karenge tab dunga ok",
                      deviceID: "Bhai Abhi Device ID Static use ho rha hai ok Jab tumko jarurat padega to bta dena dynamic kar dunga"
                    );
                    Navigator.pop(context);

                    if (provider.verifyOtpModel != null &&
                        provider.verifyOtpModel!.status == true) {

                      navPushReplace(
                        context: context,
                        action:  RegisterScreen(mobileNumber:  widget.mobileNumber,),
                      );
                      // navPushReplace(
                      //   context: context,
                      //   action: const MainScreen(),
                      // );

                    } else {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid OTP"),
                        ),
                      );

                    }
                  }
                      : null,
                ),
//                 CommonAppButton(
//                   text: 'Get Started',
//                   onPressed: () {
//
//
//                navPush(context: context, action: RegisterScreen());
// // =======
// //                     navPush(context: context, action: HomeScreen());
// // >>>>>>> dev
//                     if (otpController.text.length != 4) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Enter valid OTP")),
//                       );
//                     }
//                   },
//                 ),

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