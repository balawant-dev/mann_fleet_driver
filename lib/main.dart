import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:mann_fleet_driver/screen/auth/login_screen/provider/loginProvider.dart';
import 'package:mann_fleet_driver/screen/auth/otp_screen/otpProvider/otpProvider.dart';
import 'package:mann_fleet_driver/screen/auth/register/provider/registerProvider.dart';
import 'package:mann_fleet_driver/screen/bookingDetail/services/location_tracking_service.dart';
import 'package:mann_fleet_driver/screen/bookingHistory/provider/bookingHistoryPro.dart';
import 'package:mann_fleet_driver/screen/cms/viewModel/cmsPro.dart';
import 'package:mann_fleet_driver/screen/fuel_entry/pro/fuelEntryPro.dart';
import 'package:mann_fleet_driver/screen/home_screen/provider/newBookingProvider.dart';
import 'package:mann_fleet_driver/screen/notification/provider/notificationPro.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/compliance_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/driving_credentials_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/personal_profile_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/profileDetailProvider.dart';
import 'package:mann_fleet_driver/screen/punch/provider/punchProvider.dart';
import 'package:mann_fleet_driver/screen/shuttle/qr_scanner/provider/qrScanPro.dart';
import 'package:mann_fleet_driver/screen/shuttle/shuttleShift/provider/shuttleShiftPro.dart';
import 'package:mann_fleet_driver/screen/vehicle/provider/editVehicalDetailPro.dart';
import 'package:mann_fleet_driver/screen/vehicle/provider/vehicle_details_provider.dart';
import 'package:mann_fleet_driver/screen/splash_screen/ui/splash_screen.dart';
import 'package:mann_fleet_driver/util/theame/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiservice/services/firebaseService.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTrackingService());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initialize Firebase Service
  await FirebaseService.init();
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'driver_tracking',
      channelName: 'Driver Tracking',
      channelDescription: 'Location Tracking Service',
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: false,
      autoRunOnMyPackageReplaced: false,
      allowWakeLock: true,
      allowWifiLock: true,
      allowAutoRestart: true,
    ),
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => ComplianceProvider()),
        ChangeNotifierProvider(create: (_) => DrivingCredentialsProvider()),
        ChangeNotifierProvider(create: (_) => PersonalProfileProvider()),
        ChangeNotifierProvider(create: (_) => VehicleDetailsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => PunchProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDetailProvider()),
        ChangeNotifierProvider(create: (_) => EditVehicleDetailsPro()),
        ChangeNotifierProvider(create: (_) => CMSProvider()),
        ChangeNotifierProvider(create: (_) => NewBookingProvider()),
        ChangeNotifierProvider(create: (_) => FuelEntryProvider()),
        ChangeNotifierProvider(create: (_) => BookingHistoryProvider()),
        ChangeNotifierProvider(create: (_) => QrScanProvider()),
        ChangeNotifierProvider(create: (_) => ShuttleShiftProvider()),
      ],

      child: MaterialApp(
        title: 'Fleet Pilot',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        //  home: const RegisterScreen(),
        //home: const PickupScreen(),
        home: const SplashScreen(),

        //home: const PerformanceScreen(),
        // home: const MyBookingScreen(),
        //      );

        //     return MaterialApp(
        //       title: 'Mann Fleet Driver',
        //       debugShowCheckedModeBanner: false,
        //      // home: const SplashScreen(),
        //       home: const FuelEntryScreen(),
      ),
    );
  }
}
