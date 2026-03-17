import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/profileManagement/screen/profileManagementScreen.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Widget drawerItem({
    required IconData icon,
    required VoidCallback onTap,
    required String title,
    Color? color, // optional - only for special cases like logout
  }) {
    final textColor = color ?? Colors.black87;
    final iconColor = color ?? Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
            const SizedBox(width: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        children: [
          // ── Profile Header ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 24),
            color: Colors.black,
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
                ),
                SizedBox(height: 12),
                Text(
                  "Rohit Kumar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "rohitkumar54@gmail.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "+91 9876543210",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ── Menu Items ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawerItem(
                      icon: Icons.person_outline,
                      title: "Profile Management",
                      onTap: () {
                        navPush(context: context, action: ProfileManagementScreen());
                        // TODO: Navigate to profile
                      },
                    ),
                    drawerItem(
                      icon: Icons.gavel_outlined,
                      title: "Penalty",
                      onTap: () {
                        // TODO: Navigate to penalty screen
                      },
                    ),
                    drawerItem(
                      icon: Icons.payment_outlined,
                      title: "Payment Method",
                      onTap: () {},
                    ),
                    drawerItem(
                      icon: Icons.currency_rupee,
                      title: "Refund Policy",
                      onTap: () {},
                    ),
                    drawerItem(
                      icon: Icons.support_agent,
                      title: "Help & Support",
                      onTap: () {},
                    ),
                    drawerItem(
                      icon: Icons.info_outline,
                      title: "About us",
                      onTap: () {},
                    ),
                    drawerItem(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      onTap: () {},
                    ),
                    drawerItem(
                      icon: Icons.description_outlined,
                      title: "Terms & Conditions",
                      onTap: () {},
                    ),

                    const Divider(height: 32, thickness: 1),

                    drawerItem(
                      icon: Icons.logout,
                      title: "Log Out",
                      onTap: () {
                        // TODO: Handle logout (show dialog, clear storage, etc.)
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}