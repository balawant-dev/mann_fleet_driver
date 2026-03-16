import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../provider/vehicle_details_provider.dart';


class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<VehicleDetailsProvider>(context);

    return Scaffold(

      appBar: const CommonAppBar(title: "Vehicle Details"),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            CommonTextFormField(
              controller: provider.carModel,
              labelText: "Car Make / Model",
            ),

            const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.numberPlate,
              labelText: "Number Plate",
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: provider.pickRC,
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: provider.rcImage == null
                    ? const Center(child: Text("Upload RC"))
                    : Image.file(provider.rcImage!,fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 30),

            CommonAppButton(
              text: "Save",
              onPressed: () {},
            )

          ],
        ),
      ),
    );
  }
}