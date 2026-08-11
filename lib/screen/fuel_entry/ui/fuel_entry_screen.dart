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
import '../model/fetchedFuelLogModel.dart';
import '../pro/fuelEntryPro.dart';
import 'package:intl/intl.dart';
class FuelEntryScreen extends StatefulWidget {
  const FuelEntryScreen({super.key});

  @override
  State<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends State<FuelEntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditVehicleDetailsPro>().getVehicleApi(context: context);
      context.read<FuelEntryProvider>().getFuelLogApi( context);
      context.read<FuelEntryProvider>().getCurrentLocation();
      context.read<FuelEntryProvider>().setVehicleNumber(context);
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
                  title: "Odometer Image",
                  file: provider.odometerImage,
                  onTap: () => _pick(context, provider, "odometer"),
                ),
                _imageCard(
                  title: "Start Meter",
                  file: provider.startImage,
                  onTap: () => _pick(context, provider, "start"),
                ),

                _imageCard(
                  title: "End Meter",
                  file: provider.endImage,
                  onTap: () => _pick(context, provider, "end"),
                ),
                _imageCard(
                  title: "Upload Bill",
                  file: provider.billImage,
                  onTap: () => _pick(context, provider, "bill"),
                ),

                const SizedBox(height: 15),

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
                  readOnly: true,
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
                  readOnly: true,
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
                  readOnly: true,
                  // onChanged: (_) => provider.calculateAmount(),
                ),

                const SizedBox(height: 10),
                CommonTextFormField(
                  labelText: 'Invoice Number',
                  isRequired: true,
                  controller: provider.invoiceNumberController,
                  keyboardType: TextInputType.number,
                  hintText: 'Invoice Number',
                  readOnly: true,
                ),
                const SizedBox(height: 10),

                /// TOTAL
                // _label('Total Amount'),
                CommonTextFormField(
                  controller: provider.fuelAmountController,

                  keyboardType: TextInputType.number,
                  hintText: 'Total Amount',
                  labelText: 'Total Amount',
                  isRequired: true,
                  // readOnly: true,
                ),

                const SizedBox(height: 10),const SizedBox(height: 10),

                /// PAYMENT SOURCE
                CustomText(
                  'Payment Source',
                  size: 13,
                  weight: FontWeight.w600,
                  color: ColorResource.grayText,
                ),

                const SizedBox(height: 6),

                DropdownButtonFormField<String>(
                  value: provider.paymentSource,
                  style: TextStyle(color: Color(0xff6B7280),fontWeight: FontWeight.w400),
                  decoration: InputDecoration(

                    hintText: 'Select Payment Source',
                    hintStyle: TextStyle(color: Color(0xff6B7280),fontWeight: FontWeight.w400),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xffDBDBDB))
                    ) ,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),       borderSide: BorderSide(color: Color(0xffDBDBDB))
                    ) ,
                    focusedErrorBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),       borderSide: BorderSide(color: Color(0xffDBDBDB))
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),       borderSide: BorderSide(color: Color(0xffDBDBDB))
                    ),disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),       borderSide: BorderSide(color: Color(0xffDBDBDB))
                  ) ,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),       borderSide: BorderSide(color: Color(0xffDBDBDB))
                    ),
                  ),
                  items: provider.paymentSources.map((source) {
                    return DropdownMenuItem<String>(
                      value: source,
                      child: Text(source),
                    );
                  }).toList(),
                  onChanged: provider.setPaymentSource,
                ),

                const SizedBox(height: 15),

                /// TANK FULL
                CustomText(
                  'Is Tank Full?',
                  size: 13,
                  weight: FontWeight.w600,
                  color: ColorResource.grayText,
                ),

                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        activeColor: ColorResource.primaryColor,
                        title: const Text('Yes'),
                        value: true,
                        groupValue: provider.isTankFull,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setTankFull(value);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        contentPadding: EdgeInsets.zero,
                        activeColor: ColorResource.primaryColor,
                        title: const Text('No'),
                        value: false,
                        groupValue: provider.isTankFull,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setTankFull(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              Divider(),
                const SizedBox(height: 20),

                CustomText(
                  'Fueling History',
                  size: 20,
                  weight: FontWeight.w700,
                  color: ColorResource.black,
                ),

                const SizedBox(height: 12),

                if (provider.isLoading2)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.fetchedFuelLogModel?.data == null ||
                    provider.fetchedFuelLogModel!.data!.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffE5E7EB),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "No Fuel Log Found",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.fetchedFuelLogModel!.data!.length,
                    itemBuilder: (context, index) {
                      final log = provider.fetchedFuelLogModel!.data![index];

                      return _fuelLogCard(log);
                    },
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";

    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
  Widget _fuelLogCard(FuelLogData log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// VEHICLE + DATE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${log.carNumber ?? "-"}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Text(formatDate(log.date?.toString()),
                // "${log.date ?? "-"}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// FUEL TYPE
          _logRow(
            "Fuel Type",
            "${log.fuelType ?? "-"}",
          ),

          _logRow(
            "Quantity",
            "${log.fuelQuantity ?? "-"} L",
          ),

          _logRow(
            "Price / Liter",
            "₹ ${log.fuelPrice ?? "-"}",
          ),

          _logRow(
            "Total Amount",
            "₹ ${log.fuelAmount ?? "-"}",
          ),

          _logRow(
            "Payment Source",
            "${log.paymentSource ?? "-"}",
          ),

          _logRow(
            "Tank Full",
            log.isTankFull == true ? "Yes" : "No",
          ),

          _logRow(
            "Odometer",
            "${log.odometerReading ?? "-"} KM",
          ),

          const SizedBox(height: 8),

          /// LOCATION
          Text(
            "${log.locationAddress ?? "-"}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
                    provider.pickImage(type, ImageSource.camera, context);
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
