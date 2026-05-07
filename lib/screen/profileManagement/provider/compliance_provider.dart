import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../model/getProfileModel.dart';
import '../repo/profileRepo.dart';
class ComplianceProvider extends ChangeNotifier {
  bool submitted = false;          // to show errors only after submit attempt
  DriverProfile? driver;           // store reference for showing existing images
  File? adhaarFront;
  File? adhaarBack;
  File? panFront;
  File? panBack;
  File? policeVerification;
  TextEditingController adhaarNumber = TextEditingController();
  TextEditingController panNumber = TextEditingController();
  TextEditingController policeExpiry = TextEditingController();
  final picker = ImagePicker();
  void setInitialData(DriverProfile? driver) {
    if (driver == null) return;

    adhaarNumber.text = driver.adhaarNumber ?? "";
    panNumber.text = driver.panNumber ?? "";

    if (driver.policeVerificationExpiry != null) {
      policeExpiry.text =
          driver.policeVerificationExpiry!.split("T").first;
    }

    notifyListeners();
  }
  Future<void> pickPoliceExpiryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      policeExpiry.text =
      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      notifyListeners();
    }
  }
  Future pickAdhaarFront(BuildContext context) async {
    await pickImageOption(
      context: context,
      onImagePicked: (file) {
        adhaarFront = file;
      },
    );
  }

  Future pickAdhaarBack(BuildContext context) async {
    await pickImageOption(
      context: context,
      onImagePicked: (file) {
        adhaarBack = file;
      },
    );
  }

  Future pickPanFront(BuildContext context) async {
    await pickImageOption(
      context: context,
      onImagePicked: (file) {
        panFront = file;
      },
    );
  }

  Future pickPanBack(BuildContext context) async {
    await pickImageOption(
      context: context,
      onImagePicked: (file) {
        panBack = file;
      },
    );
  }

  Future pickPolice(BuildContext context) async {
    await pickImageOption(
      context: context,
      onImagePicked: (file) {
        policeVerification = file;
      },
    );
  }
  // Future pickAdhaarFront() async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     adhaarFront = File(picked.path);
  //     notifyListeners();
  //   }
  // }
  //
  // Future pickAdhaarBack() async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     adhaarBack = File(picked.path);
  //     notifyListeners();
  //   }
  // }
  //
  // Future pickPanFront() async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     panFront = File(picked.path);
  //     notifyListeners();
  //   }
  // }
  //
  // Future pickPanBack() async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     panBack = File(picked.path);
  //     notifyListeners();
  //   }
  // }
  //
  // Future pickPolice() async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     policeVerification = File(picked.path);
  //     notifyListeners();
  //   }
  // }

  final api = ProfileRepo();
  bool isLoading = false;

  Future<void> submitCompliance(BuildContext context) async {
    try {
      showLoader(context);

      isLoading = true;
      notifyListeners();

      /// 🔥 DEBUG
      debugPrint("==== KYC API BODY ====");
      debugPrint("adhaarFront: ${adhaarFront?.path}");
      debugPrint("adhaarBack: ${adhaarBack?.path}");
      debugPrint("panFront: ${panFront?.path}");
      debugPrint("panBack: ${panBack?.path}");
      debugPrint("police: ${policeVerification?.path}");

      final res = await api.updateComplianceFull(
        context: context,
        adhaarFront: adhaarFront,
        adhaarBack: adhaarBack,
        panFront: panFront,
        panBack: panBack,
        policeVerification: policeVerification,
        panNumber: panNumber.text,
        adhaarNumber: adhaarNumber.text,
        policeExpiry: policeExpiry.text
      );

      Navigator.pop(context);

      if (res.status == true) {
        ToastHelper.show(
          context,
          message: "KYC Updated ✅",
          type: ToastType.success,
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("KYC Updated ✅")),
        // );
      }

    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImageOption({
    required BuildContext context,
    required Function(File file) onImagePicked,
  }) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: [

                /// Camera
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () async {
                    Navigator.pop(context);

                    final picked = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                    );

                    if (picked != null) {
                      onImagePicked(File(picked.path));
                      notifyListeners();
                    }
                  },
                ),

                /// Gallery
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Gallery"),
                  onTap: () async {
                    Navigator.pop(context);

                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    );

                    if (picked != null) {
                      onImagePicked(File(picked.path));
                      notifyListeners();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}