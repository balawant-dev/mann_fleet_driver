import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/vehicle/ui/vehicleDetailsScreen.dart';
import 'package:provider/provider.dart';


import '../../../util/FontResource/FontResource.dart';
import '../../../widget/navigator_method.dart';
import '../../vehicle/provider/vehicle_details_provider.dart';
import '../../vehicle/ui/editVehicalScreen.dart';
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
    vm.getVehicleApi(context: context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Profile Management",
        // backgroundColor: ColorResource.primaryColor, // uncomment if needed
      ),
      body:Consumer<VehicleDetailsProvider>(builder: (context, vehiclePro, child) {
        if (vehiclePro.getVehicleModel==null) {
          return const Center(child: CircularProgressIndicator());
        }
        return  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      screen:vehiclePro.getVehicleModel!.data==null? const VehicleDetailsScreen():EditVehicleDetailsScreen(),
                    ),
                    _buildProfileCard(
                      context,
                      title: "Compliance",
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
}