import 'dart:io';
import 'dart:ui' as BorderType;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:provider/provider.dart';
import '../../../widget/commonTextFormField.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../home_screen/provider/newBookingProvider.dart';
import '../provider/pickup_provider.dart';

class PickupScreen extends StatelessWidget {
  final String id;

  const PickupScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewBookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(title: "Pick Up"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Odometer Verification",
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: -0.60,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Take clear photos of all four sides of your vehicle and the speedometer to proceed.",
              style: TextStyle(
                color: const Color(0xFF475569),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),

            const SizedBox(height: 20),

            // const Text(
            //   "EXTERIOR SHOTS",
            //   style: TextStyle(
            //     color: const Color(0xFF0F172A),
            //     fontSize: 14,
            //     fontFamily: 'Inter',
            //     fontWeight: FontWeight.w700,
            //     height: 1.43,
            //     letterSpacing: 0.70,
            //   ),
            // ),
            //
            // const SizedBox(height: 16),

            // GridView(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 12,
            //     mainAxisSpacing: 12,
            //     childAspectRatio: .7,
            //     // childAspectRatio: .85,
            //   ),
            //   children: [
            //     _photoCard(
            //       "Front View",
            //       provider.front,
            //       () => provider.pickImage("front"),
            //     ),
            //
            //     _photoCard(
            //       "Back View",
            //       provider.back,
            //       () => provider.pickImage("back"),
            //     ),
            //
            //     _photoCard(
            //       "Left Side",
            //       provider.left,
            //       () => provider.pickImage("left"),
            //     ),
            //
            //     _photoCard(
            //       "Right Side",
            //       provider.right,
            //       () => provider.pickImage("right"),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 20),
            //
            // _interiorCard(provider),
            //
            // const SizedBox(height: 30),
            const Text(
              "MILEAGE READING",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _speedometerCard(provider, context),
            const SizedBox(height: 10),
            CommonTextFormField(
              labelText: 'Odometer Reading',
              isRequired: true,
              controller: provider.speedoMetervalue,
              keyboardType: TextInputType.number,
              hintText: 'Enter KM',
              readOnly: false,
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final provider = context.read<NewBookingProvider>();

                // ✅ Validation
                if ( /*provider.front == null ||
                    provider.back == null ||
                    provider.left == null ||
                    provider.right == null ||
                    provider.interior == null ||*/ provider.speedometer ==
                    null) {
                  ToastHelper.show(
                    context,
                    message: "Upload image",
                    type: ToastType.error,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Upload all images")),
                  // );
                  return;
                }
                showLoader(context);

                await provider.pickupVerificationApi(context: context, id: id);
                ToastHelper.show(
                  context,
                  message: "Pickup Verified ✅",
                  type: ToastType.success,
                );

                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text("Pickup Verified ✅")),
                // );

                Navigator.pop(context); // back to detail
              },
              child: const Text("Submit Verification"),
            ),
            const SizedBox(height: 30),

            // Container(
            //   height: 50,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade300,
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   alignment: Alignment.center,
            //   child: const Text(
            //     "Enter OTP to start the trip",
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
            //
            // const SizedBox(height: 10),
            //
            // const Center(
            //   child: Text(
            //     "3 VERIFICATION STEPS REMAINING",
            //     style: TextStyle(fontSize: 12,color: Colors.grey),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _photoCard(String title, File? image, VoidCallback onTap) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(48),
        dashPattern: const [6, 3],
        strokeWidth: 1.5,
        color: const Color(0xFFE2E8F0),
      ),

      // borderType: BorderType.RRect,
      // radius: const Radius.circular(16),
      // dashPattern: const [6,3],
      child: Container(
        // padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: const Color(0xFFF8FAFC),
          shape: RoundedRectangleBorder(
            // side: BorderSide(
            //   width: 2,
            //   color: const Color(0xFFE2E8F0),
            // ),
            borderRadius: BorderRadius.circular(48),
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  image == null
                      ? const Center(
                        child: Icon(Icons.camera_alt, color: Colors.grey),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: BorderType.Radius.circular(48),
                          topLeft: BorderType.Radius.circular(48),
                        ),
                        child: Image.file(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
            ),

            const SizedBox(height: 8),

            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: ShapeDecoration(
                  color: const Color(0xFF03055E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    image == null ? "Take Photo" : "Retake",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _interiorCard(NewBookingProvider provider, BuildContext context) {
    final image = provider.interior;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(24),
        dashPattern: const [6, 3],
        strokeWidth: 1.5,
        color: const Color(0xFFF1F5F9),
      ),
      // borderType: BorderType.RRect,
      // radius: const Radius.circular(16),
      // dashPattern: const [6,3],
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Interior View",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              "Take clear photo of Seats and dashboard",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Image Display Area
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  image == null
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "No Image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(image, fit: BoxFit.cover),
                      ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => provider.pickImage("interior", context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF03055E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    image == null
                        ? "Take Interior Photo"
                        : "Retake Interior Photo",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _speedometerCard(NewBookingProvider provider, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        children: [
          Container(
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: const Color(0xFFF1F5F9),
            ),
            child:
                provider.speedometer == null
                    ? const Icon(Icons.speed, size: 60, color: Colors.grey)
                    : Image.file(provider.speedometer!, fit: BoxFit.cover),
          ),

          const Divider(),

          ListTile(
            title: const Text("Speedometer Reading"),
            subtitle: const Text("Odometer must be clearly visible"),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => provider.pickImage("speedometer", context),
              child: const Text(
                "Capture Odometer",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
