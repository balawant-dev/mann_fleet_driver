import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../model/getSegmentsModel.dart';

import '../model/getVehicleModel.dart';
import '../repo/vehicalDetailRepo.dart';

class VehicleDetailsProvider extends ChangeNotifier {
  final VehicalDetailRepo _repo = VehicalDetailRepo();
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  // Segment
  GetSegmentsModel? getSegmentsModel;
  String? selectedSegmentId;

  // Controllers
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final carNumberController = TextEditingController();
  final bootSpaceController = TextEditingController();
  final capacityController = TextEditingController();

  final certificateNumberController = TextEditingController();
  final certificateExpiryController = TextEditingController();
  final insuranceExpiryController = TextEditingController();
  final pollutionExpiryController = TextEditingController();
  final rcExpiryController = TextEditingController();

  // Images
  List<File> carImages = [];
  List<File> documentImages = [];
  File? certificatePhoto;
  File? rcFrontPhoto;
  File? rcBackPhoto;
  GetVehicleModel?getVehicleModel;
  Future<void> getSegmentApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await _repo.getSegmentApi(context: context);
      getSegmentsModel = res;
    } catch (e) {
      debugPrint("Error fetching segments: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }  Future<void> getVehicleApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await _repo.getVehicleApi(context: context);
      getVehicleModel = res;
    } catch (e) {
      debugPrint("Error fetching getVehicleApi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ───────────── Image Pickers ─────────────

  Future<void> pickCarImages() async {
    if (carImages.length >= 6) return;

    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      for (var xfile in picked) {
        if (carImages.length < 6) {
          carImages.add(File(xfile.path));
        }
      }
      notifyListeners();
    }
  }

  Future<void> pickDocumentImages() async {
    if (documentImages.length >= 10) return;

    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null) {
      for (var xfile in picked) {
        if (documentImages.length < 10) {
          documentImages.add(File(xfile.path));
        }
      }
      notifyListeners();
    }
  }

  Future<void> pickCertificatePhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      certificatePhoto = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickRcFront() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      rcFrontPhoto = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickRcBack() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      rcBackPhoto = File(picked.path);
      notifyListeners();
    }
  }

  void removeImage(File image) {
    carImages.remove(image);
    documentImages.remove(image);
    notifyListeners();
  }
  String? selectedFuelType;

  // List of valid options (you can make this const)
  static const List<String> fuelTypes = [
    "petrol",
    "diesel",
    "electric",
    "hybrid",
  ];

  Future<void> saveVehicle(BuildContext context) async {
    if (selectedSegmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select segment")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await _repo.vehicleAddApi(
        context: context,
        segment: selectedSegmentId!,
        brand: brandController.text.trim(),
        model: modelController.text.trim(),
        fuelType: selectedFuelType ?? "", // ✅ FIX
        // fuelType: fuelTypeController.text.trim(),
        year: yearController.text.trim(),
        color: colorController.text.trim(),
        carNumber: carNumberController.text.trim(),
        bootSpace: bootSpaceController.text.trim(),
        capacity: capacityController.text.trim(),
        certificateNumber: certificateNumberController.text.trim(),
        certificateExpiry: certificateExpiryController.text.trim(),
        insuranceExpiry: insuranceExpiryController.text.trim(),
        pollutionExpiry: pollutionExpiryController.text.trim(),
        rcExpeiry: rcExpiryController.text.trim(),

        // Images – send paths (repo will convert to MultipartFile)
        carImage: carImages.isNotEmpty ? carImages.first.path : "", // first one or handle multiple in repo
        documentImage: documentImages.isNotEmpty ? documentImages.first.path : "",
        certificatePhoto: certificatePhoto?.path ?? "",
        rcFrontPhoto: rcFrontPhoto?.path ?? "",
        rcBackPhoto: rcBackPhoto?.path ?? "",
      );

      if (response.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehicle added successfully!")),
        );
        // Navigator.pop(context); or navigate
      }
    } catch (e) {
      debugPrint("Vehicle save error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save vehicle: $e")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    // ... dispose all controllers
    super.dispose();
  }
}