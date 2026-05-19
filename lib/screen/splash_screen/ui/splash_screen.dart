import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../apiservice/services/secure_storage_service.dart';
import '../../../util/color/app_colors.dart';
import '../../../util/image_resource/image_resource.dart';
import '../../../widget/customImageView.dart';
import '../../../widget/navigator_method.dart';
import '../../auth/login_screen/ui/login_screen.dart';
import '../../auth/register/ui/registerScreen.dart';
import '../../bottomBar/bottomBar.dart';
import '../../profileManagement/provider/profileDetailProvider.dart';
import '../../profileManagement/screen/profileManagementScreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    loadInitialData();
    checkSession();
  }
  void loadInitialData() {
    // final vm = Provider.of<VehicleDetailsProvider>(context, listen: false);
    final vmProfile = Provider.of<ProfileDetailProvider>(context, listen: false);
    // vm.getVehicleApi(context: context);
    vmProfile.getProfileApi(context: context);
  }

  Future<void> checkSession() async {
    final token = await SecureStorageService.getToken();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    /// ❌ NO TOKEN
    if (token == null || token.isEmpty) {
      navPushReplace(context: context, action: LoginScreen());
      return;
    }

    // loadInitialData();

    /// 🔹 GET LOCAL FLAGS
    final isFirstUser = await SecureStorageService.getFirstUser();
    final isProfileComplete = await SecureStorageService.getProfileComplete();
    final isVerified = await SecureStorageService.getVerified();
print(" Spalsh isFirstUser ${isFirstUser}");
print("Spalsh isProfileComplete ${isProfileComplete}");
print("Spalsh isVerified ${isVerified}");
    /// 🔥 SAME LOGIC AS OTP
    if (isFirstUser == true) {
      navPushReplace(
        context: context,
        action: ProfileManagementScreen(),
      );
    }
    else if (isProfileComplete == false) {
      navPushReplace(
        context: context,
        action: const ProfileManagementScreen(),
      );
    }
    else if (isVerified == false) {
      navPushReplace(
        context: context,
        action: const ProfileManagementScreen(),
      );
    }
    else if(isVerified==true) {
      navPushReplace(
        context: context,
        action: const MainScreen(),
      );
    }    else  {
      navPushReplace(
        context: context,
        action: const MainScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/spalshBackround.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}