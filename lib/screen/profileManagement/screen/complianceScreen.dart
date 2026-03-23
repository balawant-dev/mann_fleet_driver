import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../provider/compliance_provider.dart';

class ComplianceScreen extends StatelessWidget {
  const ComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ComplianceProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "KYC Documents"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Aadhaar Section
            _sectionTitle("Aadhaar Card"),
            const SizedBox(height: 10),
            CommonTextFormField(
              controller: provider.adhaarNumber,
              labelText: "Aadhaar Number",
              hintText: "Enter 12-digit Aadhaar",
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _uploadCard(
                    title: "Front",
                    image: provider.adhaarFront,
                    onTap: provider.pickAdhaarFront,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _uploadCard(
                    title: "Back",
                    image: provider.adhaarBack,
                    onTap: provider.pickAdhaarBack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PAN Section
            _sectionTitle("PAN Card"),
            const SizedBox(height: 10),
            CommonTextFormField(
              controller: provider.panNumber,
              labelText: "PAN Number",
              hintText: "ABCDE1234F",
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _uploadCard(
                    title: "Front",
                    image: provider.panFront,
                    onTap: provider.pickPanFront,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _uploadCard(
                    title: "Back",
                    image: provider.panBack,
                    onTap: provider.pickPanBack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 Police Verification
            _sectionTitle("Police Verification"),
            const SizedBox(height: 10),
            CommonTextFormField(
              controller: provider.policeExpiry,
              labelText: "Expiry Date",
              readOnly: true,
              suffixIcon: Icon(Icons.calendar_month),
              onTap: () => provider.pickPoliceExpiryDate(context),
            ),
            const SizedBox(height: 10),

            _uploadCard(
              title: "Upload Document",
              image: provider.policeVerification,
              onTap: provider.pickPolice,
              fullWidth: true,
            ),

            const SizedBox(height: 40),

            /// 🔹 Submit Button
            CommonAppButton(
              text: "Submit KYC",
              onPressed: () {
                // if (provider.adhaarNumber.text.length != 12) {
                //   showSnackBar("Invalid Aadhaar Number");
                //   return;
                // }
                //
                // if (provider.panNumber.text.length != 10) {
                //   showSnackBar("Invalid PAN Number");
                //   return;
                // }
                provider.submitCompliance(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  /// 🔹 Upload Card (Improved UI)
  Widget _uploadCard({
    required String title,
    required File? image,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child:
            image == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload, size: 30, color: Colors.grey),
                    const SizedBox(height: 6),
                    Text(title, style: const TextStyle(fontSize: 12)),
                  ],
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image, fit: BoxFit.cover),
                ),
      ),
    );
  }
}
