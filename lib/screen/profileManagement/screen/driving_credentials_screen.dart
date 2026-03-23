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
      backgroundColor: Colors.grey.shade100,
      appBar: const CommonAppBar(title: "Driving Credentials"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Driving License Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.dlNumber,
              labelText: "DL Number",
            ),

            const SizedBox(height: 12),

            CommonTextFormField(
              controller: provider.dlExpiry,
              labelText: "Expiry Date",
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_month),
              onTap: () => provider.pickExpiryDate(context),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: provider.pickLicense,
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: provider.licensePhoto == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload, size: 30),
                    SizedBox(height: 5),
                    Text("Upload License Photo"),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    provider.licensePhoto!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            CommonAppButton(
              text: "Save",
              onPressed: () async {

                if (provider.dlNumber.text.isEmpty) {
                  _showError(context, "Enter DL Number");
                  return;
                }

                if (provider.dlExpiry.text.isEmpty) {
                  _showError(context, "Select Expiry Date");
                  return;
                }

                if (provider.licensePhoto == null) {
                  _showError(context, "Upload License Photo");
                  return;
                }

                await provider.submitDrivingDetails(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}