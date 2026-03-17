
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';

import '../../../widget/showLoaderFunction.dart';
import '../provider/editVehicalDetailPro.dart';
import '../provider/vehicle_details_provider.dart';

class EditVehicleDetailsScreen extends StatefulWidget {
  const EditVehicleDetailsScreen({super.key});

  @override
  State<EditVehicleDetailsScreen> createState() => _EditVehicleDetailsScreenState();
}

class _EditVehicleDetailsScreenState extends State<EditVehicleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditVehicleDetailsPro>().getSegmentApi(context: context);
      context.read<EditVehicleDetailsPro>().getVehicleApi(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditVehicleDetailsPro>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CommonAppBar(title: "Edit Vehicle Details"),
          body: provider.isLoading && provider.getSegmentsModel == null
              ? const Center(child: CircularProgressIndicator())
              : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Segment Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Segment",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    const SizedBox(height: 5),

                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xffDBDBDB),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedSegmentId,
                          hint: const Text(
                            "Select Vehicle Segment",
                            style: TextStyle(color: Color(0xff6B7280)),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),

                          items: provider.getSegmentsModel?.data
                              ?.map((seg) => DropdownMenuItem(
                            value: seg.sId,
                            child: Text(
                              seg.name ?? "Unknown",
                              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                            ),
                          ))
                              .toList() ??
                              [],

                          onChanged: (value) {
                            provider.selectedSegmentId = value;
                            provider.notifyListeners();
                          },
                        ),
                      ),
                    ),

                    /// ERROR TEXT (same style)
                    if (provider.selectedSegmentId == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "Select segment",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                // DropdownButtonFormField<String>(
                //   value: provider.selectedSegmentId,
                //   decoration: const InputDecoration(
                //     labelText: "Vehicle Segment",
                //     border: OutlineInputBorder(),
                //   ),
                //   items: provider.getSegmentsModel?.data
                //       ?.map((seg) => DropdownMenuItem(
                //     value: seg.sId,
                //     child: Text(seg.name ?? "Unknown"),
                //   ))
                //       .toList() ??
                //       [],
                //   onChanged: (value) {
                //     provider.selectedSegmentId = value;
                //     provider.notifyListeners();
                //   },
                //   validator: (v) => v == null ? "Select segment" : null,
                // ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.brandController,
                  labelText: "Brand",
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.modelController,
                  labelText: "Model",
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fuel Type",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    const SizedBox(height: 5),

                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: provider.selectedFuelType == null
                              ? const Color(0xffDBDBDB)
                              : const Color(0xffDBDBDB),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedFuelType,
                          hint: const Text(
                            "Select Fuel Type",
                            style: TextStyle(color: Color(0xff6B7280)),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),

                          items: VehicleDetailsProvider.fuelTypes
                              .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type[0].toUpperCase() + type.substring(1),
                              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),
                            ),
                          ))
                              .toList(),

                          onChanged: (value) {
                            provider.selectedFuelType = value;
                            provider.notifyListeners();
                          },
                        ),
                      ),
                    ),

                    /// ERROR TEXT (same as CommonTextFormField)
                    if (provider.selectedFuelType == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "Select fuel type",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                // DropdownButtonFormField<String>(
                //   value: provider.selectedFuelType,
                //   decoration: const InputDecoration(
                //     labelText: "Fuel Type",
                //     border: OutlineInputBorder(),
                //   ),
                //   items: VehicleDetailsProvider.fuelTypes
                //       .map((type) => DropdownMenuItem(
                //     value: type,
                //     child: Text(type.toUpperCase()),
                //   ))
                //       .toList(),
                //   onChanged: (value) {
                //     provider.selectedFuelType = value;
                //     provider.notifyListeners();
                //   },
                //   validator: (v) => v == null ? "Select fuel type" : null,
                // ),

                // CommonTextFormField(
                //   controller: provider.fuelTypeController,
                //   labelText: "Fuel Type (Petrol/Diesel/CNG/Electric)",
                //   validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                // ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.yearController,
                  labelText: "Year",
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v?.trim().isEmpty ?? true) return "Required";
                    if (int.tryParse(v!) == null || v.length != 4) return "Invalid year";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.colorController,
                  labelText: "Color",
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.carNumberController,
                  labelText: "Car Number (e.g. DL4CAB1234)",
                  // textCapitalization: TextCapitalization.characters,
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.bootSpaceController,
                  labelText: "Boot Space (liters)",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                CommonTextFormField(
                  controller: provider.capacityController,
                  labelText: "Seating Capacity",
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 24),

                // ───────────────────────────────────────
                //          Images Section
                // ───────────────────────────────────────
                // _buildImagePickerSection(
                //   title: "Car Images (up to 6)",
                //   images: provider.carImages,
                //   maxCount: 6,
                //   onPick: provider.pickCarImages,
                // ),
                _buildImagePickerSection(
                  title: "Car Images (up to 6)",
                  images: provider.carImages,
                  networkImages: provider.networkCarImages, // 👈 ADD THIS
                  maxCount: 6,
                  onPick: provider.pickCarImages,
                ),
                const SizedBox(height: 24),

                _buildImagePickerSection(
                  title: "Supporting Documents (up to 10)",
                  networkImages: provider.networkDocumentImages,
                  images: provider.documentImages,
                  maxCount: 10,
                  onPick: provider.pickDocumentImages,
                ),
                const SizedBox(height: 24),

                _buildSingleImagePicker(
                  title: "Fitness / Pollution Certificate",
                  image: provider.certificatePhoto,
                  networkImage: provider.networkCertificatePhoto,
                  onPick: provider.pickCertificatePhoto,
                ),
                const SizedBox(height: 24),

                _buildSingleImagePicker(
                  title: "Fitness / Pollution Certificate",
                  image: provider.certificatePhoto,
                  networkImage: provider.networkCertificatePhoto,
                  onPick: provider.pickCertificatePhoto,
                ),
                const SizedBox(height: 24),

                _buildSingleImagePicker(
                  title: "RC Back Photo",
                  image: provider.rcBackPhoto,
                  networkImage: provider.networkRcBackPhoto,
                  onPick: provider.pickRcBack,
                ),
                const SizedBox(height: 24),

                // Certificate Number & Expiry dates
                CommonTextFormField(
                  controller: provider.certificateNumberController,
                  labelText: "Certificate Number",
                ),
                const SizedBox(height: 16),

                _buildDateField(
                  label: "Certificate Expiry",
                  controller: provider.certificateExpiryController,
                  // initialDate: provider.certificateExpiry,
                ),
                const SizedBox(height: 16),

                _buildDateField(
                  label: "Insurance Expiry",
                  controller: provider.insuranceExpiryController,
                  // initialDate: provider.insuranceExpiry,
                ),
                const SizedBox(height: 16),

                _buildDateField(
                  label: "Pollution Expiry",
                  controller: provider.pollutionExpiryController,
                  // initialDate: provider.pollutionExpiry,
                ),
                const SizedBox(height: 16),

                _buildDateField(
                  label: "RC Expiry",
                  controller: provider.rcExpiryController,
                  // initialDate: provider.rcExpiry,
                ),
                const SizedBox(height: 32),

                CommonAppButton(
                  text: "Update",
                 // text: provider.isLoading ? "Saving..." : "Save Vehicle",
                  // isLoading: provider.isLoading,
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                    if (!_formKey.currentState!.validate()) return;

                    // if (provider.carImages.isEmpty) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text("At least 1 car image is required")),
                    //   );
                    //   return;
                    // }
                    showLoader(context);
                    await provider.saveVehicle(context);
                    Navigator.pop(context); // loader close
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildImagePickerSection({
    required String title,
    required List<File> images,
    required List<String> networkImages, // 👈 ADD
    required int maxCount,
    required VoidCallback onPick,
  }) {
    final totalImages = networkImages.length + images.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),

        if (totalImages > 0)
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [

                /// 🔥 NETWORK IMAGES (API)
                ...networkImages.map((url) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          height: 100,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<EditVehicleDetailsPro>(context, listen: false)
                                .networkCarImages.remove(url);
                            Provider.of<EditVehicleDetailsPro>(context, listen: false)
                                .notifyListeners();
                          },
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

                /// 🔥 LOCAL IMAGES (picked)
                ...images.map((file) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, height: 100, width: 140, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<EditVehicleDetailsPro>(context, listen: false)
                                .removeImage(file);
                          },
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

        const SizedBox(height: 12),

        if (totalImages < maxCount)
          OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.add_photo_alternate, color: ColorResource.primaryColor),
            label: Text(
              "Add ${totalImages == 0 ? 'Photo' : 'More'}",
              style: const TextStyle(color: ColorResource.primaryColor),
            ),
          ),
      ],
    );
  }

  Widget _buildSingleImagePicker({
    required String title,
    File? image,
    String? networkImage, // 👈 ADD
    required VoidCallback onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffDBDBDB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(image, fit: BoxFit.cover),
            )
                : networkImage != null && networkImage.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(networkImage, fit: BoxFit.cover),
            )
                : const Center(
              child: Text("Tap to upload", style: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    DateTime? initialDate,   // ← keep it optional
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime(2000),
          lastDate: DateTime(2035),
        );
        if (picked != null) {
          final formatted = DateFormat('yyyy-MM-dd').format(picked);
          controller.text = formatted;
          // No need for provider.notifyListeners() here in most cases
        }
      },
      child: AbsorbPointer(
        child: CommonTextFormField(
          controller: controller,
          labelText: label,
          validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
          suffixIcon: Icon(Icons.calendar_month),
        ),
      ),
    );
  }
}