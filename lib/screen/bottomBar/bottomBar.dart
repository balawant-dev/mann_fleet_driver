import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/profileManagement/screen/profileManagementScreen.dart';
import 'package:mann_fleet_driver/screen/punch/provider/punchProvider.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';

import '../../util/color/app_colors.dart';
import '../../util/image_resource/image_resource.dart';

import '../billScanner/ui/billScannerScreen.dart';
import '../bookingHistory/ui/bookingHistoryScreen.dart';
import '../fuel_entry/ui/fuel_entry_screen.dart';
import '../home_screen/ui/home_screen.dart';

import '../performance/ui/performanceScreen.dart';
import '../pickup/ui/pickUpScreen.dart';
import '../profile/ui/profile_screen.dart';
import '../punch/ui/punchScreen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    // BillScannerScreen(),
    const BookingHistoryScreen(),
    const PunchScreen(),
    const FuelEntryScreen(),
    // const PerformanceScreen(),
    //const PickupScreen(),
    // const ProfileReviewScreen(),
    // ProfileManagementScreen()

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

            // bottomItem(
            //   index: 2,
            //   label: "Performance",
            //   selectedIcon: "assets/icon/bottom_s_4.png",
            //   unSelectedIcon: "assets/icon/bottom_u_4.png",
            // ),

            bottomItem(
              index: 2,
              label: "Punch",
              selectedIcon: "assets/icon/punchS.png",
              unSelectedIcon: "assets/icon/punchU.png",
            ),bottomItem(
              index: 3,
              label: "Fuel Entry",
              selectedIcon: "assets/icon/feulS.png",
              unSelectedIcon: "assets/icon/feulU.png",
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
class MyBookingScreenss extends StatefulWidget {
  const MyBookingScreenss({super.key});

  @override
  State<MyBookingScreenss> createState() => _MyBookingScreenssState();
}

class _MyBookingScreenssState extends State<MyBookingScreenss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title:"Trip History",
        // isBack: true,

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const Text(
                "Trip History Coming Soon",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We are working on this feature.\nSoon you will be able to see all your past trips here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Stay Tuned 🚀",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
