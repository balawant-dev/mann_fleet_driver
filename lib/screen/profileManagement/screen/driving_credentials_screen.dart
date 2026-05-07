import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../../../widget/motionToastHelper.dart';
import '../provider/driving_credentials_provider.dart';
import '../provider/profileDetailProvider.dart';
//
// class DrivingCredentialsScreen extends StatefulWidget {
//   const DrivingCredentialsScreen({super.key});
//
//   @override
//   State<DrivingCredentialsScreen> createState() => _DrivingCredentialsScreenState();
// }
//
// class _DrivingCredentialsScreenState extends State<DrivingCredentialsScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     final profile = context.read<ProfileDetailProvider>();
//     final driver = profile.getProfileModel?.data?.driver;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<DrivingCredentialsProvider>().setInitialData(driver);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<DrivingCredentialsProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: const CommonAppBar(title: "Driving Credentials"),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             const Text(
//               "Driving License Details",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//
//             const SizedBox(height: 15),
//
//             CommonTextFormField(
//               controller: provider.dlNumber,
//               labelText: "DL Number",
//               hintText: " DL01 20230000001",
//             ),
//
//             const SizedBox(height: 12),
//
//             CommonTextFormField(
//               controller: provider.dlExpiry,
//               labelText: "Expiry Date",
//               hintText: "12-12-2026",
//               readOnly: true,
//               suffixIcon: const Icon(Icons.calendar_month),
//               onTap: () => provider.pickExpiryDate(context),
//             ),
//
//             const SizedBox(height: 15),
//
//             GestureDetector(
//               onTap: provider.pickLicense,
//               child: Container(
//                 height: 130,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: provider.licensePhoto == null
//                     ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.cloud_upload, size: 30),
//                     SizedBox(height: 5),
//                     Text("Upload License Photo"),
//                   ],
//                 )
//                     : ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     provider.licensePhoto!,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             CommonAppButton(
//               text: "Save",
//               onPressed: () async {
//
//                 if (provider.dlNumber.text.isEmpty) {
//                   _showError(context, "Enter DL Number");
//                   return;
//                 }
//
//                 if (provider.dlExpiry.text.isEmpty) {
//                   _showError(context, "Select Expiry Date");
//                   return;
//                 }
//
//                 if (provider.licensePhoto == null) {
//                   _showError(context, "Upload License Photo");
//                   return;
//                 }
//
//                 await provider.submitDrivingDetails(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showError(BuildContext context, String msg) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }
// }



class DrivingCredentialsScreen extends StatefulWidget {
  const DrivingCredentialsScreen({super.key});

  @override
  State<DrivingCredentialsScreen> createState() =>
      _DrivingCredentialsScreenState();
}

class _DrivingCredentialsScreenState
    extends State<DrivingCredentialsScreen> {

  @override
  void initState() {
    super.initState();

    final profile = context.read<ProfileDetailProvider>();
    final driver = profile.getProfileModel?.data?.driver;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DrivingCredentialsProvider>().setInitialData(driver);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrivingCredentialsProvider>();
    final driver =
        context.read<ProfileDetailProvider>().getProfileModel?.data?.driver;

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
              keyboardType: TextInputType.number,
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
              onTap: () => provider.pickLicense(context),
              // onTap: provider.pickLicense,
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: provider.licensePhoto != null
                    ? Image.file(provider.licensePhoto!, fit: BoxFit.contain)
                    : (driver?.licensePhoto != null &&
                    driver!.licensePhoto!.isNotEmpty)
                    ? Image.network(
                  driver.licensePhoto!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported_outlined,size: 60,);
                  },
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload, size: 30),
                    SizedBox(height: 5),
                    Text("Upload License Photo"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            CommonAppButton(
              text: "Save",
              onPressed: () async {
                if (provider.dlNumber.text.isEmpty) {
                  ToastHelper.show(
                    context,
                    message: "Enter DL Number",
                    type: ToastType.warning,
                  );
                  // _error(context, "Enter DL Number");
                  return;
                }
                if (provider.dlExpiry.text.isEmpty) {
                  ToastHelper.show(
                    context,
                    message: "Select Expiry Date",
                    type: ToastType.warning,
                  );
                  // _error(context, "Select Expiry Date");
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

  void _error(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}