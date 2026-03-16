// import 'package:flutter/material.dart';
// import 'package:mann_fleet_driver/util/color/app_colors.dart';
// import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
// import 'package:mann_fleet_driver/widget/commonAppBar.dart';
// import 'package:mann_fleet_driver/widget/commonAppButton.dart';
// import 'package:mann_fleet_driver/widget/commonTextFormField.dart';
// import 'package:mann_fleet_driver/widget/customImageView.dart';
// import 'package:mann_fleet_driver/widget/custom_text.dart';
// import 'package:dotted_border/dotted_border.dart';
// class FuelEntryScreen extends StatefulWidget {
//   const FuelEntryScreen({super.key});
//
//   @override
//   State<FuelEntryScreen> createState() => _FuelEntryScreenState();
// }
//
// class _FuelEntryScreenState extends State<FuelEntryScreen> {
//   TextEditingController dateTimeController = TextEditingController();
//
//   Future<void> selectDateTime(BuildContext context) async {
//
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//         builder: (context, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(
//               alwaysUse24HourFormat: false, // shows AM / PM
//             ),
//             child: child!,
//           );
//         },
//       );
//
//       if (pickedTime != null) {
//
//         DateTime finalDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         dateTimeController.text =
//         "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}  ${pickedTime.format(context)}";
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(title: 'Fuel Entry'),
//       backgroundColor: ColorResource.white,
//       bottomSheet: Padding(
//           padding: EdgeInsets.all(15),
//         child: CommonAppButton(text: 'Submit Entry', onPressed: (){}),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//             padding: EdgeInsets.all(15),
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
//               SizedBox(height: 20,),
//               CustomText(
//                 'Vehicle Information',
//                 size: 14,
//                 weight: FontWeight.w700,
//                 color: ColorResource.black,
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Vehicle No.',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.grayText,
//               ),
//               CommonTextFormField(
//                 hintText: 'Enter Vehical Number',
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Fuel Type',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.grayText,
//               ),
//               CommonTextFormField(
//                 hintText: 'Enter Flue Type',
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Date / Time',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                 controller: dateTimeController,
//                 hintText: 'Enter Date / Time',
//                 suffixIcon: Icon(Icons.calendar_today),
//                 readOnly: true,
//                 onTap: () {
//                   selectDateTime(context);
//                 },
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Location',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               SizedBox(height: 10,),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
//                     SizedBox(height: 10,),
//                     CommonAppButton(text: 'View On Google Map', onPressed: (){})
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Meter Reading (Odometer)',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                 hintText: 'Meter Reading (Odometer)',
//                 suffixIcon: Padding(
//                     padding: EdgeInsets.all(10),
//                   child: CustomImageView(
//                       imagePath: AppImages.odoMetar,
//                     height: 18,
//                     width: 18,
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Fuel Amount (Liters)',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                   hintText: 'Fuel Amount (Liters)',
//                   suffixIcon: Padding(
//                     padding: EdgeInsets.all(10),
//                     child: CustomImageView(
//                       imagePath: AppImages.fuelImage,
//                       height: 18,
//                       width: 18,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//               ),
//               SizedBox(height: 10,),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Start Meter Reading',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               SizedBox(height: 10,),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: ColorResource.inputBoxColor,
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         CustomText(
//                           '0.00',
//                           size: 24,
//                           weight: FontWeight.w400,
//                           color: ColorResource.grayText,
//                         ),
//                         SizedBox(width: 15,),
//                         Expanded(
//                           child: CustomText(
//                             'Take photo of odometer at trip start',
//                             size: 14,
//                             maxLines: 1,
//                             weight: FontWeight.w400,
//                             color: ColorResource.grayText,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                     CommonAppButton(text: 'Upload Odometer Image', onPressed: (){})
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'End Meter Reading',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               SizedBox(height: 10,),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: ColorResource.inputBoxColor,
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(Icons.camera_alt_outlined,size: 24,color: ColorResource.grayText,),
//                     CustomText(
//                       'Take photo of odometer at trip completion',
//                       size: 14,
//                       maxLines: 1,
//                       weight: FontWeight.w400,
//                       color: ColorResource.grayText,
//                     ),
//                     SizedBox(height: 10,),
//                     CommonAppButton(text: 'Upload Odometer Image', onPressed: (){})
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Total Cost (₹)',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               CommonTextFormField(
//                   hintText: '0.00',
//                   suffixIcon: Padding(
//                     padding: EdgeInsets.all(10),
//                     child: CustomImageView(
//                       imagePath: AppImages.costIcon,
//                       height: 18,
//                       width: 18,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//               ),
//               SizedBox(height: 10,),
//               CustomText(
//                 'Upload Receipt / Bill',
//                 size: 12,
//                 weight: FontWeight.w500,
//                 color: ColorResource.black,
//               ),
//               SizedBox(height: 10,),
//               SizedBox(height: 10),
//
//               DottedBorder(
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: ColorResource.white,
//                   ),
//                   child: Column(
//                     children: [
//
//                       Icon(
//                         Icons.receipt_long_outlined,
//                         size: 40,
//                         color: ColorResource.grayText,
//                       ),
//
//                       SizedBox(height: 10),
//
//                       CustomText(
//                         'Click to upload or drag and drop',
//                         size: 14,
//                         weight: FontWeight.w500,
//                         color: ColorResource.grayText,
//                       ),
//
//                       SizedBox(height: 5),
//
//                       CustomText(
//                         'SVG, PNG, JPG (MAX. 5MB)',
//                         size: 12,
//                         weight: FontWeight.w400,
//                         color: ColorResource.grayText,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 100),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'dart:io';

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

class FuelEntryScreen extends StatefulWidget {
  const FuelEntryScreen({super.key});

  @override
  State<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends State<FuelEntryScreen> {
  // Controllers
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _odometerController = TextEditingController();
  final TextEditingController _fuelLitersController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();

  // Images
  File? _startOdometerImage;
  File? _endOdometerImage;
  File? _receiptImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _fuelTypeController.dispose();
    _dateTimeController.dispose();
    _odometerController.dispose();
    _fuelLitersController.dispose();
    _totalCostController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final formattedDate = DateFormat('dd-MM-yyyy').format(finalDateTime);
    final formattedTime = DateFormat('h:mm a').format(finalDateTime);

    setState(() {
      _dateTimeController.text = "$formattedDate  $formattedTime";
    });
  }

  Future<void> _showImageSourceDialog(String type) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(type, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(type, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(String type, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        setState(() {
          if (type == 'start') {
            _startOdometerImage = imageFile;
          } else if (type == 'end') {
            _endOdometerImage = imageFile;
          } else if (type == 'receipt') {
            _receiptImage = imageFile;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> _openGoogleMaps() async {
    const String place = "Terminal 2 Fuel Station, Delhi Airport";
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(place)}",
    );

    // Try to open in app first (geo: or comgooglemaps:)
    final Uri appUrl = Uri.parse("geo:0,0?q=${Uri.encodeComponent(place)}");

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open Google Maps")),
      );
    }
  }

  bool _validateForm() {
    if (_vehicleNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter vehicle number")),
      );
      return false;
    }
    if (_fuelTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter fuel type")),
      );
      return false;
    }
    if (_dateTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date & time")),
      );
      return false;
    }
    if (_fuelLitersController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter fuel amount in liters")),
      );
      return false;
    }
    if (_totalCostController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter total cost")),
      );
      return false;
    }
    // Optional: require images
    // if (_receiptImage == null) { ... }
    return true;
  }

  void _submitEntry() {
    if (!_validateForm()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fuel entry submitted successfully!")),
    );

    // TODO: Send to backend / API here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Fuel Entry'),
      backgroundColor: ColorResource.white,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: CommonAppButton(
          text: 'Submit Entry',
          onPressed: _submitEntry,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Log Fuel Expense',
                size: 24,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              CustomText(
                'Enter the details of your latest fuel refill',
                size: 14,
                weight: FontWeight.w400,
                color: ColorResource.grayText,
              ),
              const SizedBox(height: 20),
              CustomText(
                'Vehicle Information',
                size: 14,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              const SizedBox(height: 10),
              CustomText(
                'Vehicle No.',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.grayText,
              ),
              CommonTextFormField(
                controller: _vehicleNumberController,
                hintText: 'Enter Vehicle Number',
              ),
              const SizedBox(height: 10),
              CustomText(
                'Fuel Type',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.grayText,
              ),
              CommonTextFormField(
                controller: _fuelTypeController,
                hintText: 'Enter Fuel Type',
              ),
              const SizedBox(height: 10),
              CustomText(
                'Date / Time',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              CommonTextFormField(
                controller: _dateTimeController,
                hintText: 'Select Date / Time',
                suffixIcon: const Icon(Icons.calendar_today),
                readOnly: true,
                onTap: () => _selectDateTime(context),
              ),
              const SizedBox(height: 10),
              CustomText(
                'Location',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ColorResource.inputBoxColor,
                ),
                child: Column(
                  children: [
                    CustomText(
                      'Terminal 2 Fuel Station, Delhi Airport',
                      size: 14,
                      weight: FontWeight.w400,
                      color: ColorResource.grayText,
                    ),
                    const SizedBox(height: 10),
                    CommonAppButton(
                      text: 'View On Google Map',
                      onPressed: _openGoogleMaps, // ← FIXED
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomText(
                'Meter Reading (Odometer)',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              CommonTextFormField(
                controller: _odometerController,
                hintText: 'Meter Reading (Odometer)',
                keyboardType: TextInputType.number,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomImageView(
                    imagePath: AppImages.odoMetar,
                    height: 18,
                    width: 18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomText(
                'Fuel Amount (Liters)',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              CommonTextFormField(
                controller: _fuelLitersController,
                hintText: 'Fuel Amount (Liters)',
                keyboardType: TextInputType.number,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomImageView(
                    imagePath: AppImages.fuelImage,
                    height: 18,
                    width: 18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomText(
                'Start Meter Reading',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ColorResource.inputBoxColor,
                ),
                child: Column(
                  children: [
                    if (_startOdometerImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _startOdometerImage!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Row(
                        children: [
                          CustomText(
                            '0.00',
                            size: 24,
                            weight: FontWeight.w400,
                            color: ColorResource.grayText,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: CustomText(
                              'Take photo of odometer at trip start',
                              size: 14,
                              maxLines: 2,
                              weight: FontWeight.w400,
                              color: ColorResource.grayText,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    CommonAppButton(
                      text: _startOdometerImage == null
                          ? 'Upload Odometer Image'
                          : 'Change Image',
                      onPressed: () => _showImageSourceDialog('start'), // ← shows camera/gallery
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomText(
                'End Meter Reading',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ColorResource.inputBoxColor,
                ),
                child: Column(
                  children: [
                    if (_endOdometerImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _endOdometerImage!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: ColorResource.grayText,
                      ),
                    CustomText(
                      'Take photo of odometer at trip completion',
                      size: 14,
                      maxLines: 2,
                      weight: FontWeight.w400,
                      color: ColorResource.grayText,
                    ),
                    const SizedBox(height: 10),
                    CommonAppButton(
                      text: _endOdometerImage == null
                          ? 'Upload Odometer Image'
                          : 'Change Image',
                      onPressed: () => _showImageSourceDialog('end'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomText(
                'Total Cost (₹)',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              CommonTextFormField(
                controller: _totalCostController,
                hintText: '0.00',
                keyboardType: TextInputType.number,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomImageView(
                    imagePath: AppImages.costIcon,
                    height: 18,
                    width: 18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomText(
                'Upload Receipt / Bill',
                size: 12,
                weight: FontWeight.w500,
                color: ColorResource.black,
              ),
              const SizedBox(height: 10),
              DottedBorder(

                child: InkWell(
                  onTap: () => _showImageSourceDialog('receipt'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ColorResource.white,
                    ),
                    child: Column(
                      children: [
                        if (_receiptImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _receiptImage!,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else ...[
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 50,
                            color: ColorResource.grayText,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            'Click to upload or drag and drop',
                            size: 14,
                            weight: FontWeight.w500,
                            color: ColorResource.grayText,
                          ),
                          const SizedBox(height: 5),
                          CustomText(
                            'SVG, PNG, JPG (MAX. 5MB)',
                            size: 12,
                            weight: FontWeight.w400,
                            color: ColorResource.grayText,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
