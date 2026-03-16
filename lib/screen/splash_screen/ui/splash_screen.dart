import 'dart:async';
import 'package:flutter/material.dart';
import '../../../util/color/app_colors.dart';
import '../../../util/image_resource/image_resource.dart';
import '../../../widget/customImageView.dart';
import '../../../widget/navigator_method.dart';
import '../../auth/login_screen/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      navPushReplace(context: context, action: LoginScreen());

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorResource.splashBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              CustomImageView(
                  imagePath: AppImages.logo,
                  height: MediaQuery.of(context).size.height * 0.115,
                  width: MediaQuery.of(context).size.width * 0.786,
                  fit: BoxFit.contain
              )
            ],
          ),
        ),
      ),
    );
  }
}