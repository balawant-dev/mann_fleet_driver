import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mann_fleet_driver/util/color/app_colors.dart';

import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/commonTextFormField.dart';

import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:provider/provider.dart';

import 'dart:io';

import '../../vehicle/provider/editVehicalDetailPro.dart';
import '../pro/fuelEntryPro.dart';

class FuelEntryScreen extends StatefulWidget {
  const FuelEntryScreen({super.key});

  @override
  State<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends State<FuelEntryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditVehicleDetailsPro>().getVehicleApi(context: context);
      context.read<FuelEntryProvider>().getCurrentLocation();
    });
  }

  // in
  @override
  Widget build(BuildContext context) {
    return Consumer<FuelEntryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: CommonAppBar(title: 'Fuel Entry'),
          backgroundColor: ColorResource.white,

          bottomNavigationBar: ColoredBox(
            color: ColorResource.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: CommonAppButton(
                text: 'Submit Entry',
                onPressed: () => provider.submit(context),
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                CustomText(
                  'Log Fuel Expense',
                  size: 24,
                  weight: FontWeight.w700,
                  color: ColorResource.black,
                ),
                CustomText(
                  'Enter fuel details',
                  size: 14,
                  color: ColorResource.grayText,
                ),

                const SizedBox(height: 15),
                _imageCard(
                  title: "End Meter",
                  file: provider.endImage,
                  onTap: () => _pick(context, provider, "end"),
                ),

                /// IMAGE SECTION
                _imageCard(
                  title: "Odometer Image",
                  file: provider.odometerImage,
                  onTap: () => _pick(context, provider, "odometer"),
                ),
                const SizedBox(height: 20),

                /// VEHICLE
                // _label('Vehicle No.'),
                CommonTextFormField(
                  labelText: "Vehicle No.",
                  isRequired: true,
                  controller: provider.vehicleController,
                  hintText: 'Enter Vehicle Number',
                ),

                const SizedBox(height: 10),

                /// FUEL TYPE
                // _label('Fuel Type'),
                CommonTextFormField(
                  labelText: 'Fuel Type',
                  isRequired: true,
                  controller: provider.fuelTypeController,
                  hintText: 'Petrol / Diesel',
                ),

                const SizedBox(height: 10),

                /// LOCATION
                // _label('Location'),
                CommonTextFormField(
                  labelText: "Location",
                  isRequired: true,

                  controller: provider.addressController,
                  hintText: 'Fetching location...',
                ),

                const SizedBox(height: 10),

                /// ODOMETER
                // _label('Odometer Reading'),

                /// ODOMETER
                // _label('Odometer Reading'),
                CommonTextFormField(
                  labelText: 'Odometer Reading',
                  isRequired: true,
                  controller: provider.odometerController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter KM',
                ),

                const SizedBox(height: 10),

                /// FUEL QTY
                // _label('Fuel Quantity (Liters)'),
                CommonTextFormField(
                  labelText: 'Fuel Quantity (Liters)',
                  isRequired: true,
                  controller: provider.fuelQtyController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter Liters',
                  // onChanged: (_) => provider.calculateAmount(),
                ),

                const SizedBox(height: 10),

                /// PRICE PER LITER
                // _label('Price Per Liter'),
                CommonTextFormField(
                  labelText: 'Price Per Liter',
                  isRequired: true,
                  controller: provider.fuelPriceController,
                  keyboardType: TextInputType.number,
                  hintText: '₹ / Liter',
                  // onChanged: (_) => provider.calculateAmount(),
                ),

                const SizedBox(height: 10),
                CommonTextFormField(
                  labelText: 'Invoice Number',
                  isRequired: true,
                  controller: provider.invoiceNumberController,
                  keyboardType: TextInputType.number,
                  hintText: 'Invoice Number',
                ),
                const SizedBox(height: 10),

                /// TOTAL
                // _label('Total Amount'),
                CommonTextFormField(
                  controller: provider.fuelAmountController,
                  readOnly: false,
                  keyboardType: TextInputType.number,
                  hintText: 'Total Amount',
                  labelText: 'Total Amount',
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                _imageCard(
                  title: "Start Meter",
                  file: provider.startImage,
                  onTap: () => _pick(context, provider, "start"),
                ),

                _imageCard(
                  title: "Upload Bill",
                  file: provider.billImage,
                  onTap: () => _pick(context, provider, "bill"),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  /// LABEL
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorResource.grayText,
          ),
          children: const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// IMAGE CARD (Reusable 🔥)
  Widget _imageCard({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(title),
          // CustomText(title, size: 12, weight: FontWeight.w600),
          const SizedBox(height: 8),
          DottedBorder(
            options: RectDottedBorderOptions(color: Colors.grey),
            //  borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child:
                    file != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            file,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Column(
                          children: const [
                            Icon(Icons.camera_alt_outlined, size: 40),
                            SizedBox(height: 8),
                            Text("Upload Image"),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE PICK
  void _pick(BuildContext context, FuelEntryProvider provider, String type) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),

                ListTile(
                  title: const Text(
                    "Camera",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.camera, size: 55),
                  onTap: () {
                    Navigator.pop(context);
                    provider.pickImage(type, ImageSource.camera);
                  },
                ),
                SizedBox(height: 30),
                // ListTile(
                //   title: const Text("Gallery"),
                //   onTap: () {
                //     Navigator.pop(context);
                //     provider.pickImage(type, ImageSource.gallery);
                //   },
                // ),
              ],
            ),
          ),
    );
  }
}
