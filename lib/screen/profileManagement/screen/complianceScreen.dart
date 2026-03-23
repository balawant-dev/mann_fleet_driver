import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../provider/compliance_provider.dart';
import '../provider/profileDetailProvider.dart';
//
// class ComplianceScreen extends StatefulWidget {
//   const ComplianceScreen({super.key});
//
//   @override
//   State<ComplianceScreen> createState() => _ComplianceScreenState();
// }
//
// class _ComplianceScreenState extends State<ComplianceScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     final profile = context.read<ProfileDetailProvider>();
//     final driver = profile.getProfileModel?.data?.driver;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ComplianceProvider>().setInitialData(driver);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ComplianceProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const CommonAppBar(title: "KYC Documents"),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔹 Aadhaar Section
//             _sectionTitle("Aadhaar Card"),
//             const SizedBox(height: 10),
//             CommonTextFormField(
//               controller: provider.adhaarNumber,
//               labelText: "Aadhaar Number",
//               hintText: "Enter 12-digit Aadhaar",
//             ),
//
//             const SizedBox(height: 10),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: _uploadCard(
//                     title: "Front",
//                     image: provider.adhaarFront,
//                     onTap: provider.pickAdhaarFront,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: _uploadCard(
//                     title: "Back",
//                     image: provider.adhaarBack,
//                     onTap: provider.pickAdhaarBack,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             /// 🔹 PAN Section
//             _sectionTitle("PAN Card"),
//             const SizedBox(height: 10),
//             CommonTextFormField(
//               controller: provider.panNumber,
//               labelText: "PAN Number",
//               hintText: "ABCDE1234F",
//             ),
//
//             const SizedBox(height: 10),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: _uploadCard(
//                     title: "Front",
//                     image: provider.panFront,
//                     onTap: provider.pickPanFront,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: _uploadCard(
//                     title: "Back",
//                     image: provider.panBack,
//                     onTap: provider.pickPanBack,
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             /// 🔹 Police Verification
//             _sectionTitle("Police Verification"),
//             const SizedBox(height: 10),
//             CommonTextFormField(
//               controller: provider.policeExpiry,
//               labelText: "Expiry Date",
//               hintText:  "12-12-2026",
//               readOnly: true,
//               suffixIcon: Icon(Icons.calendar_month),
//               onTap: () => provider.pickPoliceExpiryDate(context),
//             ),
//             const SizedBox(height: 10),
//
//             _uploadCard(
//               title: "Upload Document",
//
//               image: provider.policeVerification,
//               onTap: provider.pickPolice,
//               fullWidth: true,
//             ),
//
//             const SizedBox(height: 40),
//
//             /// 🔹 Submit Button
//             CommonAppButton(
//               text: "Submit KYC",
//               onPressed: () {
//                 // if (provider.adhaarNumber.text.length != 12) {
//                 //   showSnackBar("Invalid Aadhaar Number");
//                 //   return;
//                 // }
//                 //
//                 // if (provider.panNumber.text.length != 10) {
//                 //   showSnackBar("Invalid PAN Number");
//                 //   return;
//                 // }
//                 provider.submitCompliance(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Section Title
//   Widget _sectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }
//
//   /// 🔹 Upload Card (Improved UI)
//   Widget _uploadCard({
//     required String title,
//     required File? image,
//     required VoidCallback onTap,
//     bool fullWidth = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 130,
//         width: fullWidth ? double.infinity : null,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child:
//             image == null
//                 ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.upload, size: 30, color: Colors.grey),
//                     const SizedBox(height: 6),
//                     Text(title, style: const TextStyle(fontSize: 12)),
//                   ],
//                 )
//                 : ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(image, fit: BoxFit.cover),
//                 ),
//       ),
//     );
//   }
// }
class ComplianceScreen extends StatefulWidget {
  const ComplianceScreen({super.key});

  @override
  State<ComplianceScreen> createState() => _ComplianceScreenState();
}

class _ComplianceScreenState extends State<ComplianceScreen> {

  @override
  void initState() {
    super.initState();

    final profile = context.read<ProfileDetailProvider>();
    final driver = profile.getProfileModel?.data?.driver;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplianceProvider>().setInitialData(driver);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplianceProvider>();
    final driver =
        context.read<ProfileDetailProvider>().getProfileModel?.data?.driver;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "KYC Documents"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Aadhaar
            _title("Aadhaar Card"),
            const SizedBox(height: 10),

            CommonTextFormField(
              controller: provider.adhaarNumber,
              labelText: "Aadhaar Number",
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _upload(
                    title: "Front",
                    file: provider.adhaarFront,
                    network: driver?.adhaarFrontPhoto,
                    onTap: provider.pickAdhaarFront,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _upload(
                    title: "Back",
                    file: provider.adhaarBack,
                    network: driver?.adhaarBackPhoto,
                    onTap: provider.pickAdhaarBack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PAN
            _title("PAN Card"),
            const SizedBox(height: 10),

            CommonTextFormField(
              controller: provider.panNumber,
              labelText: "PAN Number",
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _upload(
                    title: "Front",
                    file: provider.panFront,
                    network: driver?.panFrontPhoto,
                    onTap: provider.pickPanFront,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _upload(
                    title: "Back",
                    file: provider.panBack,
                    network: driver?.panBackPhoto,
                    onTap: provider.pickPanBack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 Police
            _title("Police Verification"),
            const SizedBox(height: 10),

            CommonTextFormField(
              controller: provider.policeExpiry,
              labelText: "Expiry Date",
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_month),
              onTap: () => provider.pickPoliceExpiryDate(context),
            ),

            const SizedBox(height: 10),

            _upload(
              title: "Upload Document",
              file: provider.policeVerification,
              network: driver?.policeVerificationPhoto,
              onTap: provider.pickPolice,
              full: true,
            ),

            const SizedBox(height: 40),

            CommonAppButton(
              text: "Submit KYC",
              onPressed: () {
                provider.submitCompliance(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _upload({
    required String title,
    File? file,
    String? network,
    required VoidCallback onTap,
    bool full = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: full ? double.infinity : null,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: file != null
            ? Image.file(file, fit: BoxFit.contain)
            : (network != null && network.isNotEmpty)
            ? Image.network(network, fit: BoxFit.contain,errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image_not_supported_outlined,size:60,);
            },)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload, size: 30),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}