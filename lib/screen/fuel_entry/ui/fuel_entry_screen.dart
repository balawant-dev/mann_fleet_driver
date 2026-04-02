//
//
//
//
//
// import 'dart:io';
//
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/commonTextFormField.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
//
// class FuelEntryScreen extends StatefulWidget {
//   const FuelEntryScreen({super.key});
//
//   @override
//   State<FuelEntryScreen> createState() => _FuelEntryScreenState();
// }
//
// class _FuelEntryScreenState extends State<FuelEntryScreen> {
//   // Controllers
//   final TextEditingController _vehicleNumberController = TextEditingController();
//   final TextEditingController _fuelTypeController = TextEditingController();
//   final TextEditingController _dateTimeController = TextEditingController();
//   final TextEditingController _odometerController = TextEditingController();
//   final TextEditingController _fuelLitersController = TextEditingController();
//   final TextEditingController _totalCostController = TextEditingController();
//
//   // Images
//   File? _startOdometerImage;
//   File? _endOdometerImage;
//   File? _receiptImage;
//
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void dispose() {
//     _vehicleNumberController.dispose();
//     _fuelTypeController.dispose();
//     _dateTimeController.dispose();
//     _odometerController.dispose();
//     _fuelLitersController.dispose();
//     _totalCostController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate == null) return;
//
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedTime == null) return;
//
//     final DateTime finalDateTime = DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//       pickedTime.hour,
//       pickedTime.minute,
//     );
//
//     final formattedDate = DateFormat('dd-MM-yyyy').format(finalDateTime);
//     final formattedTime = DateFormat('h:mm a').format(finalDateTime);
//
//     setState(() {
//       _dateTimeController.text = "$formattedDate  $formattedTime";
//     });
//   }
//
//   Future<void> _showImageSourceDialog(String type) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.blue),
//                 title: const Text('Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(type, ImageSource.gallery);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.green),
//                 title: const Text('Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(type, ImageSource.camera);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _pickImage(String type, ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         final File imageFile = File(pickedFile.path);
//         setState(() {
//           if (type == 'start') {
//             _startOdometerImage = imageFile;
//           } else if (type == 'end') {
//             _endOdometerImage = imageFile;
//           } else if (type == 'receipt') {
//             _receiptImage = imageFile;
//           }
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking image: $e")),
//       );
//     }
//   }
//
//   Future<void> _openGoogleMaps() async {
//     const String place = "Terminal 2 Fuel Station, Delhi Airport";
//     final Uri googleMapsUrl = Uri.parse(
//       "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place)}",
//     );
//
//     // Try to open in app first (geo: or comgooglemaps:)
//     final Uri appUrl = Uri.parse("geo:0,0?q=${Uri.encodeComponent(place)}");
//
//     if (await canLaunchUrl(appUrl)) {
//       await launchUrl(appUrl, mode: LaunchMode.externalApplication);
//     } else if (await canLaunchUrl(googleMapsUrl)) {
//       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not open Google Maps")),
//       );
//     }
//   }
//
//   bool _validateForm() {
//     if (_vehicleNumberController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter vehicle number")),
//       );
//       return false;
//     }
//     if (_fuelTypeController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter fuel type")),
//       );
//       return false;
//     }
//     if (_dateTimeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select date & time")),
//       );
//       return false;
//     }
//     if (_fuelLitersController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter fuel amount in liters")),
//       );
//       return false;
//     }
//     if (_totalCostController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter total cost")),
//       );
//       return false;
//     }
//     // Optional: require images
//     // if (_receiptImage == null) { ... }
//     return true;
//   }
//
//   void _submitEntry() {
//     if (!_validateForm()) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Fuel entry submitted successfully!")),
//     );
//
//     // TODO: Send to backend / API here
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(title: 'Fuel Entry'),
//       backgroundColor: ColorResource.white,
//       bottomSheet: Padding(
//         padding: const EdgeInsets.all(15),
//         child: CommonAppButton(
//           text: 'Submit Entry',
//           onPressed: _submitEntry,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 'Log Fuel Expense',
//                 size: 24,
//                 weight: FontWeight.w700,
//                 color: ColorResource.black,
//               ),
//               CustomText(
//                 'Enter the details of your latest fuel refill',
//                 size: 14,
//                 weight: FontWeight.w400,
//                 color: ColorResource.grayText,
//               ),
//               const SizedBox(height: 20),
//               CustomText(
//                 'Vehicle Information',
//                 size: 14,
//                 weight: FontWeight.w700,
//                 color: ColorResource.black,
//               ),
//               const SizedBox(height: 10),
//               CustomText(
//                 'Vehicle No.',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.grayText,
//               ),
//               CommonTextFormField(
//                 controller: _vehicleNumberController,
//                 hintText: 'Enter Vehicle Number',
//               ),
//               const SizedBox(height: 10),
//               CustomText(
//                 'Fuel Type',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.grayText,
//               ),
//               CommonTextFormField(
//                 controller: _fuelTypeController,
//                 hintText: 'Enter Fuel Type',
//               ),
//               const SizedBox(height: 10),
//               CustomText(
//                 'Date / Time',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                 controller: _dateTimeController,
//                 hintText: 'Select Date / Time',
//                 suffixIcon: const Icon(Icons.calendar_today),
//                 readOnly: true,
//                 onTap: () => _selectDateTime(context),
//               ),
//               const SizedBox(height: 10),
//               CustomText(
//                 'Location',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: ColorResource.inputBoxColor,
//                 ),
//                 child: Column(
//                   children: [
//                     CustomText(
//                       'Terminal 2 Fuel Station, Delhi Airport',
//                       size: 14,
//                       weight: FontWeight.w400,
//                       color: ColorResource.grayText,
//                     ),
//                     const SizedBox(height: 10),
//                     CommonAppButton(
//                       text: 'View On Google Map',
//                       onPressed: _openGoogleMaps, // ← FIXED
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               CustomText(
//                 'Meter Reading (Odometer)',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                 controller: _odometerController,
//                 hintText: 'Meter Reading (Odometer)',
//                 keyboardType: TextInputType.number,
//                 suffixIcon: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: CustomImageView(
//                     imagePath: AppImages.odoMetar,
//                     height: 18,
//                     width: 18,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               CustomText(
//                 'Fuel Amount (Liters)',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                 controller: _fuelLitersController,
//                 hintText: 'Fuel Amount (Liters)',
//                 keyboardType: TextInputType.number,
//                 suffixIcon: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: CustomImageView(
//                     imagePath: AppImages.fuelImage,
//                     height: 18,
//                     width: 18,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomText(
//                 'Start Meter Reading',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: ColorResource.inputBoxColor,
//                 ),
//                 child: Column(
//                   children: [
//                     if (_startOdometerImage != null)
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           _startOdometerImage!,
//                           height: 100,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     else
//                       const Row(
//                         children: [
//                           CustomText(
//                             '0.00',
//                             size: 24,
//                             weight: FontWeight.w400,
//                             color: ColorResource.grayText,
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: CustomText(
//                               'Take photo of odometer at trip start',
//                               size: 14,
//                               maxLines: 2,
//                               weight: FontWeight.w400,
//                               color: ColorResource.grayText,
//                             ),
//                           ),
//                         ],
//                       ),
//                     const SizedBox(height: 10),
//                     CommonAppButton(
//                       text: _startOdometerImage == null
//                           ? 'Upload Odometer Image'
//                           : 'Change Image',
//                       onPressed: () => _showImageSourceDialog('start'), // ← shows camera/gallery
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomText(
//                 'End Meter Reading',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: ColorResource.inputBoxColor,
//                 ),
//                 child: Column(
//                   children: [
//                     if (_endOdometerImage != null)
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           _endOdometerImage!,
//                           height: 100,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     else
//                       const Icon(
//                         Icons.camera_alt_outlined,
//                         size: 40,
//                         color: ColorResource.grayText,
//                       ),
//                     CustomText(
//                       'Take photo of odometer at trip completion',
//                       size: 14,
//                       maxLines: 2,
//                       weight: FontWeight.w400,
//                       color: ColorResource.grayText,
//                     ),
//                     const SizedBox(height: 10),
//                     CommonAppButton(
//                       text: _endOdometerImage == null
//                           ? 'Upload Odometer Image'
//                           : 'Change Image',
//                       onPressed: () => _showImageSourceDialog('end'),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomText(
//                 'Total Cost (₹)',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                 controller: _totalCostController,
//                 hintText: '0.00',
//                 keyboardType: TextInputType.number,
//                 suffixIcon: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: CustomImageView(
//                     imagePath: AppImages.costIcon,
//                     height: 18,
//                     width: 18,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomText(
//                 'Upload Receipt / Bill',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               const SizedBox(height: 10),
//               DottedBorder(
//
//                 child: InkWell(
//                   onTap: () => _showImageSourceDialog('receipt'),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: ColorResource.white,
//                     ),
//                     child: Column(
//                       children: [
//                         if (_receiptImage != null)
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.file(
//                               _receiptImage!,
//                               height: 140,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           )
//                         else ...[
//                           const Icon(
//                             Icons.receipt_long_outlined,
//                             size: 50,
//                             color: ColorResource.grayText,
//                           ),
//                           const SizedBox(height: 10),
//                           CustomText(
//                             'Click to upload or drag and drop',
//                             size: 14,
//                             weight: FontWeight.w500,
//                             color: ColorResource.grayText,
//                           ),
//                           const SizedBox(height: 5),
//                           CustomText(
//                             'SVG, PNG, JPG (MAX. 5MB)',
//                             size: 12,
//                             weight: FontWeight.w400,
//                             color: ColorResource.grayText,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 100),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:io';

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
      context.read<FuelEntryProvider>().getCurrentLocation();
    });
  }
  // in
  @override
  Widget build(BuildContext context) {

    return  Consumer<FuelEntryProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: CommonAppBar(title: 'Fuel Entry'),
            backgroundColor: ColorResource.white,

            bottomSheet: Padding(
              padding: const EdgeInsets.all(15),
              child: CommonAppButton(
                text: 'Submit Entry',
                onPressed: () => provider.submit(context),
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
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

                  const SizedBox(height: 20),

                  /// VEHICLE
                  // _label('Vehicle No.'),
                  CommonTextFormField(
                    labelText:"Vehicle No.",
                    isRequired: true,
                    controller: provider.vehicleController,
                    hintText: 'Enter Vehicle Number',
                  ),

                  const SizedBox(height: 10),

                  /// FUEL TYPE
                  // _label('Fuel Type'),
                  CommonTextFormField(
                    labelText:'Fuel Type',
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
                    onChanged: (_) => provider.calculateAmount(),
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
                    onChanged: (_) => provider.calculateAmount(),
                  ),

                  const SizedBox(height: 10),

                  /// TOTAL
                  // _label('Total Amount'),
                  CommonTextFormField(
                    controller: provider.fuelAmountController,
                    readOnly: true,
                    hintText: 'Auto calculated',
                    labelText: 'Total Amount',
                    isRequired: true,
                  ),

                  const SizedBox(height: 20),

                  /// IMAGE SECTION
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

                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      )
    ;
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
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
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
          //  borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                child: file != null
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
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              provider.pickImage(type, ImageSource.camera);
            },
          ),
          ListTile(
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              provider.pickImage(type, ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}