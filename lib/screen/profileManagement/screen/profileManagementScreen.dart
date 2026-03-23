import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/vehicle/ui/vehicleDetailsScreen.dart';
import 'package:provider/provider.dart';


import '../../../apiservice/services/secure_storage_service.dart';
import '../../../util/FontResource/FontResource.dart';
import '../../../widget/navigator_method.dart';
import '../../splash_screen/ui/splash_screen.dart';
import '../../vehicle/provider/vehicle_details_provider.dart';
import '../../vehicle/ui/editVehicalScreen.dart';
import '../model/getProfileModel.dart';
import '../provider/profileDetailProvider.dart';
import 'complianceScreen.dart';

import 'driving_credentials_screen.dart';
import 'personal_profile_screen.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/commonAppBar.dart';




class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final vm = Provider.of<VehicleDetailsProvider>(context, listen: false);
    final vmProfile = Provider.of<ProfileDetailProvider>(context, listen: false);
    vm.getVehicleApi(context: context);
    vmProfile.getProfileApi(context: context);
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileDetailProvider>(context);
    final driver = profileProvider.getProfileModel?.data?.driver;

    final isFirstUser = driver?.firstUser ?? false;
    final isProfileComplete = driver?.isProfileComplete ?? false;
    final isVerified = driver?.isVerified ?? false;
    print("isFirstUser : ${isFirstUser}  ,isProfileComplete:${isProfileComplete},isVerified ${isVerified}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Profile Management",
        // backgroundColor: ColorResource.primaryColor, // uncomment if needed
      ),
      body:Consumer<VehicleDetailsProvider>(builder: (context, vehiclePro, child) {
        // if (vehiclePro.getVehicleModel==null) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        return  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [   _buildProfileStatus(driver),

              const SizedBox(height: 8),

              // Title / Greeting (optional)
              const Text(
                "Manage Your Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontResource.plusJakartaSans,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // 2×2 Grid of Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1, // slightly taller than square
                  children: [
                    _buildProfileCard(
                      context,
                      title: "Personal Profile",
                      icon: Icons.person,
                      color: ColorResource.primaryColor,
                      screen: const PersonalProfileScreen(),
                    ),
                    _buildProfileCard(
                      context,
                      title: "Driving Credentials",
                      icon: Icons.badge,
                      color: Colors.teal,
                      screen: const DrivingCredentialsScreen(),
                    ),
                    _buildProfileCard(
                      context,
                      title: "Vehicle Details",
                      icon: Icons.directions_car,
                      color: Colors.orange,
                      screen:vehiclePro.getVehicleModel?.data==null? const VehicleDetailsScreen():EditVehicleDetailsScreen(),
                    ),
                    _buildProfileCard(
                      context,
                      title: "KYC Documents",
                      icon: Icons.verified,
                      color: Colors.purple,
                      screen: const ComplianceScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },),
      bottomSheet: (!isVerified)
          ? SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            onPressed: () async {
              await SecureStorageService.logout(context);
              navPushBottomRemove(
                context: context,
                action: SplashScreen(),
                duration: 1,
              );
            },
            child:  Text(
              isProfileComplete ? "Go To Login" : "Logout & Complete Later",

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildProfileCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Widget screen,
      }) {
    return GestureDetector(
      onTap: () {
        navPush(context: context, action: screen);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProfileStatus(DriverProfile? driver) {
    if (driver == null) return const SizedBox();

    if (driver.firstUser == true || driver.isProfileComplete == false) {
      return _statusCard(
        color: Colors.orange,
        icon: Icons.warning_amber_rounded,
        title: "Complete Your Profile",
        subtitle: "Please fill all details to continue",
      );
    }

    if (driver.isProfileComplete == true && driver.isVerified == false) {
      return _statusCard(
        color: Colors.blue,
        icon: Icons.access_time,
        title: "Verification Pending",
        subtitle: "Your profile is under review",
      );
    }

    /// ✅ VERIFIED → NOTHING
    return const SizedBox();
  }
  Widget _statusCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}