import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/auth/register/provider/registerProvider.dart';
import 'package:mann_fleet_driver/screen/auth/register/ui/registerScreen.dart';
import 'package:mann_fleet_driver/screen/myBooking/ui/myBookingScreen.dart';
import 'package:mann_fleet_driver/screen/performance/ui/performanceScreen.dart';
import 'package:mann_fleet_driver/screen/pickup/provider/pickup_provider.dart';
import 'package:mann_fleet_driver/screen/pickup/ui/pickUpScreen.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/compliance_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/driving_credentials_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/personal_profile_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/vehicle_details_provider.dart';
import 'package:mann_fleet_driver/screen/splash_screen/ui/splash_screen.dart';
import 'package:mann_fleet_driver/util/theame/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => ComplianceProvider()),
        ChangeNotifierProvider(create: (_) => DrivingCredentialsProvider()),
        ChangeNotifierProvider(create: (_) => PersonalProfileProvider()),
        ChangeNotifierProvider(create: (_) => VehicleDetailsProvider()),
        ChangeNotifierProvider(create: (_) => PickupProvider()),
      ],

      child: MaterialApp(
        title: 'Mann Fleet Driver',
        debugShowCheckedModeBanner: false,
      //  theme: AppTheme.lightTheme,
      //  home: const RegisterScreen(),
     //home: const PickupScreen(),
     home: const SplashScreen(),
  //home: const PerformanceScreen(),
 // home: const MyBookingScreen(),
      ),
    );
  }
}

