import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/showLoaderFunction.dart';
import '../repo/profileRepo.dart';
class ComplianceProvider extends ChangeNotifier {

  File? adhaarFront;
  File? adhaarBack;
  File? panFront;
  File? panBack;
  File? policeVerification;
  TextEditingController adhaarNumber = TextEditingController();
  TextEditingController panNumber = TextEditingController();
  TextEditingController policeExpiry = TextEditingController();
  final picker = ImagePicker();
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
  Future pickAdhaarFront() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      adhaarFront = File(picked.path);
      notifyListeners();
    }
  }

  Future pickAdhaarBack() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      adhaarBack = File(picked.path);
      notifyListeners();
    }
  }

  Future pickPanFront() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      panFront = File(picked.path);
      notifyListeners();
    }
  }

  Future pickPanBack() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      panBack = File(picked.path);
      notifyListeners();
    }
  }

  Future pickPolice() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      policeVerification = File(picked.path);
      notifyListeners();
    }
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("KYC Updated ✅")),
        );
      }

    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}