import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Widget drawerItem(IconData icon, String title,{Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon,size: 22,color: color ?? Colors.black54),
          const SizedBox(width: 18),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        children: [

          /// Top Profile Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50,bottom: 20),
            color: Colors.black,
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3"),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Rohit Kumar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                const Text(
                  "rohitkumar54@gmail.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "+91 9876543210",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          /// Menu Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                drawerItem(Icons.person_outline,"Profile"),
                drawerItem(Icons.gavel_outlined,"Penalty"),
                drawerItem(Icons.payment_outlined,"Payment Method"),
                drawerItem(Icons.currency_rupee,"Refund Policy"),
                drawerItem(Icons.support_agent,"Help & Support"),
                drawerItem(Icons.info_outline,"About us"),
                drawerItem(Icons.privacy_tip_outlined,"Privacy Policy"),
                drawerItem(Icons.description_outlined,"Terms & Conditions"),

                const SizedBox(height: 20),

                drawerItem(Icons.logout,"Log Out",color: Colors.red),
              ],
            ),
          )

        ],
      ),
    );
  }
}