import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/profileDetailProvider.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:provider/provider.dart';


import '../../../widget/navigator_method.dart';
import '../../drawer/ui/custom_drawer.dart';

import '../../profileManagement/screen/personal_profile_screen.dart';
import 'active_booking.dart';
import 'new_booking.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final vm = Provider.of<ProfileDetailProvider>(context, listen: false);
    vm.getProfileApi(context: context);
  }
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailProvider>(builder: (context, profilePro, child) {
      // if (profilePro.getProfileModel==null||profilePro.getProfileModel!.data==null) {
      //   return const Center(child: CircularProgressIndicator());
      // }
      return Scaffold(
        backgroundColor: Colors.white,

        key: _scaffoldKey,
        drawer: const CustomDrawer(),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [

              GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: CustomImageView(
                    imagePath: AppImages.menuImage,
                    width: 26,
                    height: 19,
                    // fit: BoxFit.cover,
                  )),

              // CustomImageView(
              //     imagePath: AppImages.menuImage,
              //   width: 26,
              //   height: 19,
              //   fit: BoxFit.cover,
              //
              // ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: (){
                  navPush(context: context, action: PersonalProfileScreen());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      _getGreeting(),
                      size: 16,
                      weight: FontWeight.w400,
                    ),
                    CustomText(
                      profilePro.getProfileModel?.data?.driver?.name??"Update Profile",
                      size: 12,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    )
                  ],
                ),
              ),
              Spacer(),
              CustomImageView(
                imagePath: AppIcons.bellIcon,
                fit: BoxFit.cover,
                width: 17,
                height: 20,
              ),
              SizedBox(width: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                decoration: BoxDecoration(
                  color: ColorResource.yellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star,size: 18,color: ColorResource.grayColor,),
                    CustomText(
                      profilePro.getProfileModel?.data?.driver?.rating.toString()??"5.0",
                      size: 15,
                      weight: FontWeight.w500,
                      color: ColorResource.grayColor,
                    )
                  ],
                ),
              ),
              SizedBox(width: 25,),
              CustomImageView(
                imagePath: AppIcons.callIcon,
                fit: BoxFit.cover,
                width: 20,
                height: 20,
              )

            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [

                    /// New Booking
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 0;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedTab == 0
                                    ? ColorResource.indigo
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: CustomText(
                            "New Booking",
                            size: 14,
                            weight: FontWeight.w600,
                            color: selectedTab == 0
                                ? ColorResource.indigo
                                : ColorResource.grayColor1,
                          ),
                        ),
                      ),
                    ),

                    /// Active Booking
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 1;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedTab == 1
                                    ? ColorResource.indigo
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: CustomText(
                            "Active Booking",
                            size: 14,
                            weight: FontWeight.w600,
                            color: selectedTab == 1
                                ? ColorResource.indigo
                                : ColorResource.grayColor1,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20),

                selectedTab == 0
                    ? NewBookingScreen()
                    : ActiveBookingScreen()
              ],
            ),
          ),
        ),
      );
    },);
  }
}
