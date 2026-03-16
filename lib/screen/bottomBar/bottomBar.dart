import 'package:flutter/material.dart';

import '../../util/color/app_colors.dart';
import '../../util/image_resource/image_resource.dart';

import '../home_screen/ui/home_screen.dart';

import '../performance/ui/performanceScreen.dart';
import '../pickup/ui/pickUpScreen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const MyBookingScreen(),
    const PerformanceScreen(),
    const PickupScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            bottomItem(
              index: 0,
              label: "HOME",
              selectedIcon: "assets/icon/bottom_s_0.png",
              // selectedIcon: AppIcons.bellIcon,
              unSelectedIcon: "assets/icon/bottom_u_0.png",
              // unSelectedIcon: AppIcons.callIcon,
            ),

            bottomItem(
              index: 1,
              label: "Trip",
              // selectedIcon: AppIcons.bellIcon,
              // unSelectedIcon: AppIcons.callIcon,
              selectedIcon: "assets/icon/bottom_s_1.png",
              unSelectedIcon: "assets/icon/bottom_u_1.png",
            ),

            bottomItem(
              index: 2,
              label: "Performance",
              selectedIcon: "assets/icon/bottom_s_4.png",
              unSelectedIcon: "assets/icon/bottom_u_4.png",
            ),

            bottomItem(
              index: 3,
              label: "Profile",
              selectedIcon: "assets/icon/bottom_s_5.png",
              unSelectedIcon: "assets/icon/bottom_u_5.png",
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomItem({
    required int index,
    required String label,
    required String selectedIcon,
    required String unSelectedIcon,
  }) {

    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            isSelected ? selectedIcon : unSelectedIcon,
            height: 20,
          ),

          const SizedBox(height: 5),
          Text(
            label,
           style: TextStyle(
             fontSize: 10,
             fontWeight: FontWeight.w500,
             color:  isSelected ? ColorResource.primaryColor : ColorResource.black,
           ),
          )
        ],
      ),
    );
  }
}
class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("My Booking Screen"),
      ),
    );
  }
}
