import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/showLoaderFunction.dart';
import '../model/getProfileModel.dart';
import '../repo/profileRepo.dart';

class DrivingCredentialsProvider extends ChangeNotifier {

  TextEditingController dlNumber = TextEditingController();
  TextEditingController dlExpiry = TextEditingController();

  File? licensePhoto;
  bool submitted = false;          // to show errors only after submit attempt
  DriverProfile? driver;           // store reference for showing existing images
  final picker = ImagePicker();
  final api = ProfileRepo();

  bool isLoading = false;
  void setInitialData(DriverProfile? driver) {
    if (driver == null) return;

    dlNumber.text = driver.licenseNumber ?? "";

    if (driver.licenseExpiry != null) {
      dlExpiry.text = driver.licenseExpiry!.split("T").first;
    }

    notifyListeners();
  }
  /// 📸 PICK IMAGE
  Future pickLicense() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      licensePhoto = File(picked.path);
      notifyListeners();
    }
  }

  /// 📅 DATE PICKER
  Future<void> pickExpiryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      dlExpiry.text = formattedDate;
      notifyListeners();
    }
  }

  /// 🚀 SUBMIT
  Future<void> submitDrivingDetails(BuildContext context) async {
    try {
      showLoader(context);

      debugPrint("==== API BODY ====");
      debugPrint("licenseNumber: ${dlNumber.text}");
      debugPrint("licenseExpiry: ${dlExpiry.text}");
      debugPrint("licensePhoto: ${licensePhoto?.path}");

      final res = await api.updateDrivingCredentials(
        context: context,
        licenseNumber: dlNumber.text.trim(),
        licenseExpiry: dlExpiry.text.trim(),
        licensePhoto: licensePhoto,
      );

      Navigator.pop(context);

      if (res.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Updated Successfully ✅")),
        );
      }

    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error: $e");
    }
  }
}