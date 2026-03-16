import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../provider/driving_credentials_provider.dart';


class DrivingCredentialsScreen extends StatelessWidget {
  const DrivingCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<DrivingCredentialsProvider>(context);

    return Scaffold(

      appBar: const CommonAppBar(title: "Driving Credentials"),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            CommonTextFormField(
              controller: provider.dlNumber,
              labelText: "DL Number",
            ),

            const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.dlExpiry,
              labelText: "DL Expiry Date",
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: provider.pickFront,
                    child: Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: provider.dlFront == null
                          ? const Center(child: Text("DL Front"))
                          : Image.file(provider.dlFront!,fit: BoxFit.cover),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: provider.pickBack,
                    child: Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: provider.dlBack == null
                          ? const Center(child: Text("DL Back"))
                          : Image.file(provider.dlBack!,fit: BoxFit.cover),
                    ),
                  ),
                ),

              ],
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