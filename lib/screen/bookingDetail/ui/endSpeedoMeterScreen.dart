import 'dart:io';
import 'dart:ui' as BorderType;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:provider/provider.dart';
import '../../../widget/commonTextFormField.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/navigator_method.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../home_screen/provider/newBookingProvider.dart';

class UploadSpeedoMeterImageScreen extends StatelessWidget {
  final String id;

  const UploadSpeedoMeterImageScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewBookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(title: "Upload Speedometer image"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            _speedometerCard(provider),

            const SizedBox(height: 10),
            CommonTextFormField(
              labelText: 'Odometer Reading',
              isRequired: true,
              controller: provider.speedoMetervalue,
              keyboardType: TextInputType.number,
              hintText: 'Enter KM',
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final provider = context.read<NewBookingProvider>();

                /// ✅ Validation
                if (provider.speedometerEndImage == null) {
                  ToastHelper.show(
                    context,
                    message: "Upload Speedometer image",
                    type: ToastType.error,
                  );
                  return;
                }

                showLoader(context);

                /// ✅ API HIT
                await provider.speedometerVerification(
                  context: context,
                  id: id,
                );

                navPop(context: context); // loader close

                ToastHelper.show(
                  context,
                  message: "Upload Speedo Meter Image Success ✅",
                  type: ToastType.success,
                );

                /// ✅ Back with result
                Navigator.pop(context, true);
              },
              child: const Text("Next"),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _speedometerCard(NewBookingProvider provider) {
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
                provider.speedometerEndImage == null
                    ? const Icon(Icons.speed, size: 60, color: Colors.grey)
                    : Image.file(
                      provider.speedometerEndImage!,
                      fit: BoxFit.cover,
                    ),
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
              onPressed: () => provider.pickImage("speedometerEndImage"),
              child: const Text(
                "Retake Reading",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
