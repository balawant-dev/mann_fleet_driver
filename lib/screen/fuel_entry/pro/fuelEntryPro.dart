import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../repo/fuelEntryRepo.dart';

class FuelEntryProvider extends ChangeNotifier {
  final FuelEntryRepo repo = FuelEntryRepo();

  // Controllers
  final vehicleController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final addressController = TextEditingController();
  final odometerController = TextEditingController();
  final fuelQtyController = TextEditingController();
  final fuelPriceController = TextEditingController();
  final fuelAmountController = TextEditingController();

  // Location
  String lat = "";
  String lng = "";

  // Images
  File? odometerImage;
  File? startImage;
  File? endImage;
  File? billImage;

  final picker = ImagePicker();

  bool isLoading = false;
  /// 🔥 GET CURRENT LOCATION
  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude.toString();
      lng = position.longitude.toString();

      /// Convert lat/lng → Address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks.first;

      addressController.text =
      "${place.name}, ${place.locality}, ${place.administrativeArea}";

      debugPrint("📍 CURRENT LAT: $lat");
      debugPrint("📍 CURRENT LNG: $lng");
      debugPrint("📍 ADDRESS: ${addressController.text}");

      notifyListeners();
    } catch (e) {
      debugPrint("Location Error: $e");
    }
  }

  /// Pick Image
  Future<void> pickImage(String type, ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);

      if (type == "odometer") odometerImage = file;
      if (type == "start") startImage = file;
      if (type == "end") endImage = file;
      if (type == "bill") billImage = file;

      notifyListeners();
    }
  }

  /// Auto Calculate Amount
  void calculateAmount() {
    double qty = double.tryParse(fuelQtyController.text) ?? 0;
    double price = double.tryParse(fuelPriceController.text) ?? 0;

    double total = qty * price;
    fuelAmountController.text = total.toStringAsFixed(2);

    notifyListeners();
  }

  /// Submit API
  Future<void> submit(BuildContext context) async {
    if (vehicleController.text.isEmpty ||
        fuelTypeController.text.isEmpty ||
        fuelQtyController.text.isEmpty ||
        fuelAmountController.text.isEmpty) {
      ToastHelper.show(context, message: "Please fill all required fields");
      return;
    }

    try {
      debugPrint("=========== FUEL ENTRY REQUEST ===========");
      debugPrint("📦 LAT: $lat | LNG: $lng");
      debugPrint("📍 ADDRESS: ${addressController.text}");

      debugPrint("🚗 Car Number: ${vehicleController.text}");
      debugPrint("⛽ Fuel Type: ${fuelTypeController.text}");
      debugPrint("📍 Address: ${addressController.text}");
      debugPrint("🌍 Latitude: $lat");
      debugPrint("🌍 Longitude: $lng");

      debugPrint("📊 Odometer Reading: ${odometerController.text}");
      debugPrint("⛽ Fuel Quantity: ${fuelQtyController.text}");
      debugPrint("💰 Fuel Price: ${fuelPriceController.text}");
      debugPrint("💵 Total Amount: ${fuelAmountController.text}");

      debugPrint("🖼 Odometer Image: ${odometerImage?.path}");
      debugPrint("🖼 Start Meter Image: ${startImage?.path}");
      debugPrint("🖼 End Meter Image: ${endImage?.path}");
      debugPrint("🧾 Bill Image: ${billImage?.path}");

      debugPrint("=========== END REQUEST ===========");
      showLoader(context);
      isLoading = true;
      notifyListeners();

      final res = await repo.fuelEntryAPi(
        context: context,
        carNumber: vehicleController.text,
        fuelType: fuelTypeController.text,
        locationAddress: addressController.text,
        locationLat: lat,
        locationLng: lng,
        odometerReading: odometerController.text,
        fuelQuantity: fuelQtyController.text,
        fuelAmount: fuelAmountController.text,
        fuelPrice: fuelPriceController.text,
        odometerMeterImage: odometerImage?.path ?? "",
        startFuelMeterImage: startImage?.path ?? "",
        endFuelMeterImage: endImage?.path ?? "",
        billImage: billImage?.path ?? "",
      );

      Navigator.pop(context);

      if (res.status == true) {
        ToastHelper.show(context,
            message: "Fuel Entry Added ✅", type: ToastType.success);
        clear();
      }
    } catch (e) {
      Navigator.pop(context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    vehicleController.clear();
    fuelTypeController.clear();
    addressController.clear();
    odometerController.clear();
    fuelQtyController.clear();
    fuelPriceController.clear();
    fuelAmountController.clear();

    odometerImage = null;
    startImage = null;
    endImage = null;
    billImage = null;

    notifyListeners();
  }
}