import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
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
  final invoiceNumberController = TextEditingController();

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
      File file = File(picked.path);

      /// ✂️ CROP IMAGE
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        uiSettings: [
          AndroidUiSettings(toolbarTitle: "Crop Image"),
          IOSUiSettings(title: "Crop Image"),
        ],
      );

      if (cropped != null) {
        file = File(cropped.path);
      }

      /// SET IMAGE
      if (type == "odometer") odometerImage = file;
      if (type == "start") startImage = file;
      if (type == "end") endImage = file;

      /// 🧾 BILL IMAGE (MAIN LOGIC 🔥)
      if (type == "bill") {
        billImage = file;

        await scanBillOCR(file); // 🔥 AUTO SCAN
      }

      notifyListeners();
    }
  }
  Future<void> scanBillOCR(File file) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final textRecognizer = TextRecognizer();

      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      textRecognizer.close();

      extractDataAdvanced(recognizedText.text);
    } catch (e) {
      debugPrint("OCR Error: $e");
    }
  }
  void extractDataAdvanced(String text) {
    List<String> invoiceKeys = [
      "invoice no",
      "invoice number",
      "invoice",
      "bill no",
      "bill number",
      "receipt no",
      "receipt",
      "txn no",
      "transaction no",
      "inv no",
      "inv",
      "invoice#",
      "bill#",
      "receipt#"
    ];

    List<String> amountKeys = [
      "total amount",
      "total amt",
      "total",
      "sale",
      "amount",
      "amt",
      "net amount",
      "sale amount",
      "grand total",
      "payable amount",
      "rs",
      "rs.",
      "inr",
      "₹"
    ];

    /// 🔥 FUEL QUANTITY KEYS
    List<String> fuelQuantityKeys = [
      "volume",
      "qty",
      "quantity",
      "litre",
      "liter",
      "ltr",
      "ltrs",
      "liters",
      "litres",
    ];

    // List<String> amountKeys = [
    //   "total amt",
    //   "total amount",
    //   "net amt",
    //   "payable",
    // ];

    String foundInvoice = "";
    String foundAmount = "";
    String foundFuelQty = "";

    List<String> lines = text.split('\n');

    /// 🔍 INVOICE
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String l = line.toLowerCase();

      for (String key in invoiceKeys) {
        if (l.contains(key) && foundInvoice.isEmpty) {

          int index = l.indexOf(key);
          String after = line.substring(index + key.length);

          RegExp reg = RegExp(r'[:\-\s]*([A-Z0-9\-]{4,})');
          final match = reg.firstMatch(after);

          if (match != null) {
            String val = match.group(1)!;

            if (!RegExp(r'^\d+$').hasMatch(val)) {
              foundInvoice = val;
              break;
            }
          }

          /// next line fallback
          if (i + 1 < lines.length) {
            final nextMatch =
            RegExp(r'([A-Z0-9\-]{4,})').firstMatch(lines[i + 1]);

            if (nextMatch != null) {
              foundInvoice = nextMatch.group(1)!;
              break;
            }
          }
        }
      }
    }

    /// 💰 AMOUNT
    List<double> amounts = [];

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String l = line.toLowerCase();

      for (String key in amountKeys) {
        if (l.contains(key)) {
          RegExp reg = RegExp(r'(\d+\.?\d{0,2})');

          Iterable<Match> matches = reg.allMatches(line);

          for (var m in matches) {
            double val = double.tryParse(m.group(0)!) ?? 0;

            if (val > 100 && val < 10000) {
              amounts.add(val);
            }
          }
        }
      }
    }

    if (amounts.isNotEmpty) {
      amounts.sort();
      foundAmount = amounts.last.toStringAsFixed(2);
    }
    /// ⛽ FUEL QUANTITY
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String l = line.toLowerCase();

      for (String key in fuelQuantityKeys) {

        if (l.contains(key) && foundFuelQty.isEmpty) {

          /// Example:
          /// Volume : 30.00L
          /// Qty : 15.5
          /// Volume 30.00

          RegExp reg = RegExp(r'(\d+\.?\d{0,2})');

          final match = reg.firstMatch(line);

          if (match != null) {
            foundFuelQty = match.group(1)!;
            break;
          }

          /// next line fallback
          if (i + 1 < lines.length) {

            final nextMatch =
            RegExp(r'(\d+\.?\d{0,2})').firstMatch(lines[i + 1]);

            if (nextMatch != null) {
              foundFuelQty = nextMatch.group(1)!;
              break;
            }
          }
        }
      }
    }

    debugPrint("🧾 INVOICE: $foundInvoice");
    debugPrint("💰 AMOUNT: $foundAmount");
    debugPrint("⛽ QTY: $foundFuelQty");
    /// ✅ AUTO FILL (IMPORTANT 🔥)
    if (foundInvoice.isNotEmpty) {
      invoiceNumberController.text = foundInvoice;
    }

    if (foundAmount.isNotEmpty) {
      fuelAmountController.text = foundAmount;
    }
    /// 🔥 AUTO FILL FUEL QUANTITY
    if (foundFuelQty.isNotEmpty) {
      fuelQtyController.text = foundFuelQty;
    }
    notifyListeners();
  }
  // Future<void> pickImage(String type, ImageSource source) async {
  //   final picked = await picker.pickImage(source: source);
  //   if (picked != null) {
  //     final file = File(picked.path);
  //
  //     if (type == "odometer") odometerImage = file;
  //     if (type == "start") startImage = file;
  //     if (type == "end") endImage = file;
  //     if (type == "bill") billImage = file;
  //
  //     notifyListeners();
  //   }
  // }

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
        invoiceNumber:invoiceNumberController.text,//ye bhi
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