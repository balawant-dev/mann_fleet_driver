import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../apiservice/services/firebaseService.dart';
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
import 'package:video_player/video_player.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/images/spalshVideo.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
    loadInitialData();
  }

  bool isUpdateRequired(String currentVersion, String apiVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> api = apiVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < api.length; i++) {
      if (current.length <= i) return true;

      if (api[i] > current[i]) {
        return true;
      } else if (api[i] < current[i]) {
        return false;
      }
    }
    return false;
  }

  void loadInitialData() async {
    // final vm = Provider.of<VehicleDetailsProvider>(context, listen: false);

    final vmProfile = Provider.of<ProfileDetailProvider>(
      context,
      listen: false,
    );
    await vmProfile.getPlatformDependenciesApi(context: context);
    final data = vmProfile.platformDependenciesModel?.data;
    vmProfile.getProfileApi(context: context);

    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    print("Print current version >>>>>>>>>>${currentVersion}");

    if (data != null && data.isNotEmpty) {
      final apiData = data[0].name;
      final apiVersion = data[0].name?.driverAppVersion ?? "0.0.0";

      /// 🔥 Compare versions
      bool updateRequired = isUpdateRequired(currentVersion, apiVersion);

      if (updateRequired && Platform.isAndroid) {
        showUpdateDialog(
          "A new version ($apiVersion) is available. Please update your app.",
        );
        return;
      } else {
        checkSession();
      }
    }
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
      navPushReplace(context: context, action: ProfileManagementScreen());
    } else if (isProfileComplete == false) {
      navPushReplace(context: context, action: const ProfileManagementScreen());
    } else if (isVerified == false) {
      navPushReplace(context: context, action: const ProfileManagementScreen());
    } else if (isVerified == true) {
      navPushReplace(context: context, action: const MainScreen());
    } else {
      navPushReplace(context: context, action: const MainScreen());
    }
  }

  /// 🔥 FORCE UPDATE DIALOG
  void showUpdateDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔥 ICON
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.system_update_alt,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 TITLE
                Text(
                  "Update Available",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// 🔥 MESSAGE
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 25),

                /// 🔥 BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.pilot.mannfleet",
                      );

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: ColorResource.green,
                    ),
                    child: Text(
                      "Update Now",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    _videoController.pause();
    _videoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// Background Video
          Positioned.fill(


            child: _videoController.value.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
                : Container(color: Colors.black),
          ),

          /// Optional Dark Overlay
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withOpacity(0.2),
          //   ),
          // ),

          /// Logo Center
          // Center(
          //   child: CustomImageView(
          //     imagePath: AppImages.logo,
          //     height: MediaQuery.of(context).size.height * 0.115,
          //     width: MediaQuery.of(context).size.width * 0.786,
          //     fit: BoxFit.contain,
          //   ),
          // ),
        ],
      ),
      // body: Container(
      //   width: double.infinity,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assets/images/splash.jpeg"),
      //       // image: AssetImage("assets/images/spalshBackround.jpeg"),
      //       fit: BoxFit.fill,
      //     ),
      //   ),
      // ),
    );
  }
}
