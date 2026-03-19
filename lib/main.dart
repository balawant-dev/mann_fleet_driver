import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/auth/login_screen/provider/loginProvider.dart';
import 'package:mann_fleet_driver/screen/auth/otp_screen/otpProvider/otpProvider.dart';
import 'package:mann_fleet_driver/screen/auth/register/provider/registerProvider.dart';
import 'package:mann_fleet_driver/screen/cms/viewModel/cmsPro.dart';
import 'package:mann_fleet_driver/screen/pickup/provider/pickup_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/compliance_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/driving_credentials_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/personal_profile_provider.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/profileDetailProvider.dart';
import 'package:mann_fleet_driver/screen/vehicle/provider/editVehicalDetailPro.dart';
import 'package:mann_fleet_driver/screen/vehicle/provider/vehicle_details_provider.dart';
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
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => ComplianceProvider()),
        ChangeNotifierProvider(create: (_) => DrivingCredentialsProvider()),
        ChangeNotifierProvider(create: (_) => PersonalProfileProvider()),
        ChangeNotifierProvider(create: (_) => VehicleDetailsProvider()),
        ChangeNotifierProvider(create: (_) => PickupProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDetailProvider()),
        ChangeNotifierProvider(create: (_) => EditVehicleDetailsPro()),
        ChangeNotifierProvider(create: (_) => CMSProvider()),
      ],

      child: MaterialApp(
        title: 'Mann Fleet Driver',
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

      )    );
  }
}

