import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/splash_screen/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mann Fleet Driver',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

