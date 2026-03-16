import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
            imagePath: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUROt6zXvozhyE-Dce7de5SMrEekKnrvqT8uufZFrDMoyY8uDZ1Oy-IiM&s',
          height: 100,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        )
      ],
    );
  }
}
