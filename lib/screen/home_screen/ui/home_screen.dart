import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/profileDetailProvider.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:provider/provider.dart';
import '../../../widget/navigator_method.dart';
import '../../drawer/ui/custom_drawer.dart';
import '../../notification/ui/notificationScreen.dart';
import '../../profileManagement/screen/personal_profile_screen.dart';
import '../provider/newBookingProvider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  void loadInitialData() async {
    final vm = Provider.of<ProfileDetailProvider>(context, listen: false);
    vm.getProfileApi(context: context);
    await vm.getPlatformDependenciesApi(context: context);
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
    return Consumer2<ProfileDetailProvider, NewBookingProvider>(
      builder: (context, profilePro, provider, child) {
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
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: CustomImageView(
                    imagePath: AppImages.menuImage,
                    width: 26,
                    height: 19,
                    // fit: BoxFit.cover,
                  ),
                ),

                // CustomImageView(
                //     imagePath: AppImages.menuImage,
                //   width: 26,
                //   height: 19,
                //   fit: BoxFit.cover,
                //
                // ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
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
                        profilePro.getProfileModel?.data?.driver?.name ??
                            "Update Profile",
                        size: 12,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    navPush(context: context, action: NotificationScreen());
                  },
                  child: CustomImageView(
                    imagePath: AppIcons.bellIcon,
                    fit: BoxFit.cover,
                    width: 17,
                    height: 20,
                  ),
                ),

                // SizedBox(width: 20,),

                // CustomImageView(
                //   imagePath: AppIcons.callIcon,
                //   fit: BoxFit.cover,
                //   width: 20,
                //   height: 20,
                // )
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await provider.getNewBooking(context: context);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [NewBookingScreen()],
              ),
            ),
          ),
        );
      },
    );
  }
}
