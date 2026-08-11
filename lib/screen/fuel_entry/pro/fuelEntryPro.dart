import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mann_fleet_driver/apiservice/services/secure_storage_service.dart';
import 'package:mann_fleet_driver/screen/bottomBar/bottomBar.dart';
import 'package:mann_fleet_driver/screen/fuel_entry/service/open_ai_service.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/navigator_method.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../profileManagement/provider/profileDetailProvider.dart';
import '../model/fetchedFuelLogModel.dart';
import '../repo/fuelEntryRepo.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../service/googleGeminiService.dart';

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
  String foundRate = "";
  String foundFuelType = "";
  // Location
  String lat = "";
  String lng = "";

  // Images
  File? odometerImage;
  File? startImage;
  File? endImage;
  File? billImage;

  final picker = ImagePicker();
  FetchedFuelLogModel?fetchedFuelLogModel;
  bool isLoading = false;
  bool isLoading2 = false;

  void setVehicleNumber(BuildContext context) {
    final profileProvider = context.read<ProfileDetailProvider>();

    vehicleController.text =
        profileProvider
            .getProfileModel
            ?.data
            ?.driver
            ?.vehicles
            ?.first
            .carNumber ??
        "";
    fuelTypeController.text =
        profileProvider
            .getProfileModel
            ?.data
            ?.driver
            ?.vehicles
            ?.first
            .fuelType ??
        "";

    notifyListeners();
  }

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
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

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

  Future<void> pickImage(
    String type,
    ImageSource source,
    BuildContext context,
  ) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      File image = File(pickedFile.path);

      /// SET IMAGE
      switch (type) {
        case "bill":
          billImage = image;
          await scanInvoiceBillDisplayWithGemini(image, context);
          break;

        case "odometer":
          odometerImage = image;
          await scanOdometerDisplayWithGemini(image, context);
          break;

        case "start":
          startImage = image;
          break;

        case "end":
          endImage = image;
          await handleFuelDisplayScan(image, context);
          break;
      }

      notifyListeners();

      print("IMAGE SELECTED => ${image.path}");
    } catch (e) {
      print("IMAGE PICK ERROR => $e");
    }
  }

  Future<void> scanFuelDisplayOCR(File file) async {
    try {
      final inputImage = InputImage.fromFile(file);

      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      await textRecognizer.close();

      extractFuelDisplayData(recognizedText.text);
    } catch (e) {
      debugPrint("OCR ERROR: $e");
    }
  }

  double? smartParseNumber(String raw) {
    raw = raw.replaceAll(RegExp(r'[^0-9]'), '');

    if (raw.isEmpty) return null;

    /// NORMAL
    double? direct = double.tryParse(raw);

    /// TRY DECIMAL INSERTIONS
    List<double> candidates = [];

    if (raw.length >= 2) {
      /// 9234 -> 92.34
      candidates.add(
        double.parse(
          "${raw.substring(0, raw.length - 2)}.${raw.substring(raw.length - 2)}",
        ),
      );
    }

    if (raw.length >= 3) {
      /// 9234 -> 9.234
      candidates.add(
        double.parse(
          raw.substring(0, raw.length - 3) +
              "." +
              raw.substring(raw.length - 3),
        ),
      );
    }

    /// ALSO KEEP ORIGINAL
    if (direct != null) {
      candidates.add(direct);
    }

    debugPrint("CANDIDATES: $candidates");

    /// RETURN BEST RANGE MATCH

    for (double n in candidates) {
      /// RATE RANGE
      if (n >= 60 && n <= 150) {
        return n;
      }

      /// LITER RANGE
      if (n >= 1 && n <= 500) {
        return n;
      }

      /// AMOUNT RANGE
      if (n >= 50 && n <= 50000) {
        return n;
      }
    }

    return null;
  }

  void extractFuelDisplayData(String rawText) {
    debugPrint("=== PUMP DISPENSER OCR START ===");
    debugPrint(rawText);

    String text = rawText.replaceAll(RegExp(r'[^\d\.\s]'), ' '); // Clean karo
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    final RegExp numberRegex = RegExp(r'\d+\.?\d*');
    List<String> numberStrings =
        numberRegex.allMatches(text).map((m) => m.group(0)!).toList();

    List<double> numbers = [];
    for (String numStr in numberStrings) {
      double? val = double.tryParse(numStr);
      if (val != null && val > 0) numbers.add(val);
    }

    debugPrint("Detected Numbers: $numbers");

    double? litres;
    double? rate;
    double? amount;

    // === Smart Assignment Logic for Petrol Pumps ===
    for (double num in numbers) {
      // Litres (Volume) → Generally 5 to 100 litres
      if (litres == null && num >= 1 && num <= 150) {
        litres = num;
      }

      // Rate per Litre → 70 to 150 rupees
      if (rate == null && num >= 70 && num <= 150) {
        rate = num;
      }

      // Total Amount → Usually 300 se 8000 tak
      if (amount == null && num >= 200 && num <= 15000) {
        amount = num;
      }
    }

    // === Cross Verification (Sabse Powerful Part) ===
    if (litres != null && rate != null) {
      double calculated = litres * rate;

      if (amount == null) {
        amount = calculated;
      } else {
        // Agar amount mila hai to check karo kitna close hai
        if ((calculated - amount).abs() > 30) {
          amount = calculated; // Better assume calculated hi sahi hai
        }
      }
    }

    // === Final Auto Fill ===
    if (litres != null) {
      fuelQtyController.text = litres.toStringAsFixed(2);
    }
    if (rate != null) {
      fuelPriceController.text = rate.toStringAsFixed(2);
    }
    if (amount != null) {
      fuelAmountController.text = amount.toStringAsFixed(2);
    }

    // Agar rate aur qty hai to amount auto calculate (backup)
    if (fuelQtyController.text.isNotEmpty &&
        fuelPriceController.text.isNotEmpty) {
      calculateAmount();
    }

    notifyListeners();

    debugPrint("✅ AUTO FILL DONE");
    debugPrint("Litres: ${fuelQtyController.text}");
    debugPrint("Rate  : ${fuelPriceController.text}");
    debugPrint("Amount: ${fuelAmountController.text}");
  }

  Future<void> scanBillOCR(File file) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final textRecognizer = TextRecognizer();

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

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
      "txn no",
      "transaction no",
      "inv no",
      "inv",
      "invoice#",
      "bill#",
    ];
    List<String> rateKeys = ["rate", "price", "rs/ltr", "rs.\/ltr"];

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
      "₹",
    ];
    List<String> fuelTypeKeys = ["petrol", "diesel", "cng"];

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

    String foundInvoice = "";
    String foundAmount = "";
    String foundFuelQty = "";

    List<String> lines = text.split('\n');

    /// 🔍 INVOICE NUMBER (HP BILL PERFECT)
    RegExp invoiceReg = RegExp(r'([A-Za-z]{2,5}-\d{3,}-[A-Za-z0-9]+)');

    final invoiceMatch = invoiceReg.firstMatch(text);

    if (invoiceMatch != null) {
      foundInvoice = invoiceMatch.group(1)!;
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
            final nextMatch = RegExp(
              r'(\d+\.?\d{0,2})',
            ).firstMatch(lines[i + 1]);

            if (nextMatch != null) {
              foundFuelQty = nextMatch.group(1)!;
              break;
            }
          }
        }
      }
    }

    /// ⛽ RATE
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String l = line.toLowerCase();

      for (String key in rateKeys) {
        if (l.contains(key) && foundRate.isEmpty) {
          RegExp reg = RegExp(r'(\d+\.?\d{0,2})');

          final match = reg.firstMatch(line);

          if (match != null) {
            foundRate = match.group(1)!;
            break;
          }
        }
      }
    }

    /// ⛽ FUEL TYPE
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].toLowerCase();

      for (String type in fuelTypeKeys) {
        if (line.contains(type)) {
          foundFuelType = type.toUpperCase();
          break;
        }
      }
      if (foundFuelType.isNotEmpty) break;
    }
    debugPrint("🧾 INVOICE: $foundInvoice");
    debugPrint("💰 AMOUNT: $foundAmount");
    debugPrint("⛽ QTY: $foundFuelQty");
    debugPrint("⛽ foundRate: $foundRate");
    debugPrint("⛽ foundFuelType: $foundFuelType");
    if (foundFuelType.isNotEmpty) {
      fuelTypeController.text = foundFuelType;
    }
    if (foundRate.isNotEmpty) {
      fuelPriceController.text = foundRate;
    }

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

  /// Auto Calculate Amount
  void calculateAmount() {
    double qty = double.tryParse(fuelQtyController.text) ?? 0;
    double price = double.tryParse(fuelPriceController.text) ?? 0;

    double total = qty * price;
    fuelAmountController.text = total.toStringAsFixed(2);

    notifyListeners();
  }

  // Payment Source
  String? paymentSource;

  final List<String> paymentSources = [
    "CASH",
    "HPCL CARD",
    "BPCL CARD",
    "IOCL CARD",
    "OWN KAPASEHRA PETROL PUMP",
    "AHUJA PETROL PUMP OKHLA",
  ];

// Tank Full
  bool? isTankFull;

  void setPaymentSource(String? value) {
    paymentSource = value;
    notifyListeners();
  }

  void setTankFull(bool value) {
    isTankFull = value;
    notifyListeners();
  }

  /// Submit API
  Future<void> submit(BuildContext context) async {
    if (vehicleController.text.isEmpty ||
        fuelTypeController.text.isEmpty ||
        fuelQtyController.text.isEmpty ||
        fuelAmountController.text.isEmpty||    paymentSource == null ||
        isTankFull == null) {
      ToastHelper.show(context, message: "Please fill all required fields");
      return;
    }

    try {
      debugPrint("=========== FUEL ENTRY REQUEST ===========");
      debugPrint("📦 LAT: $lat | LNG: $lng");
      debugPrint("📦 paymentSource: $paymentSource | isTankFull: $isTankFull");
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
        isTankFull: isTankFull!,
        paymentSource: paymentSource!,
        carNumber: vehicleController.text,
        fuelType: fuelTypeController.text,
        locationAddress: addressController.text,
        invoiceNumber: invoiceNumberController.text, //ye bhi
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
        ToastHelper.show(
          context,
          message: res.message??"Fuel Entry Added ✅",
          type: ToastType.success,
        );
        navPushReplace(context: context, action: MainScreen());
        await getFuelLogApi(context);
        clear();
      }else{
        ToastHelper.show(
          context,
          message:res.message?? "failed to add",
          type: ToastType.error,
        );
      }
    } catch (e) {
      Navigator.pop(context);
    } finally {
      isLoading = false;
      notifyListeners();
    } //9161470607
  }

  Future<void> getFuelLogApi(BuildContext context) async {
    try {
      isLoading2 = true;
      notifyListeners();

      final res = await repo.getFuelLogApi(
        context: context,
      );

      if (res.status == true) {
        fetchedFuelLogModel = res;

        debugPrint(
          "Fuel Logs Count: ${fetchedFuelLogModel?.data?.length}",
        );
      } else {
        fetchedFuelLogModel = null;

        ToastHelper.show(
          context,
          message: res.message ?? "Failed to fetch Fuel Log",
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint("GET FUEL LOG ERROR: $e");

      ToastHelper.show(
        context,
        message: "Something went wrong",
        type: ToastType.error,
      );
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
  }




  Future<void> handleFuelDisplayScan(
    File imageFile,
    BuildContext context,
  ) async {
    showLoader(context);

    try {
      final FuelScanResult results = await getFuelDetailsFromImageOpenAi(
        imageFile,
      );

      fuelQtyController.text = results.liters.toStringAsFixed(2);
      fuelPriceController.text = results.pricePerLiter.toStringAsFixed(2);
      fuelAmountController.text = results.totalAmount.toStringAsFixed(2);

      print("FUEL AUTO FILL COMPLETE");
      notifyListeners();
    } catch (error) {
      if (context.mounted) {
        _clearFuelFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst("Exception: ", "")),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _clearFuelFields() {
    fuelQtyController.clear();
    fuelPriceController.clear();
    fuelAmountController.clear();
  }

  Future<void> scanOdometerDisplayWithGemini(
    File imageFile,
    BuildContext context,
  ) async {
    showLoader(context);

    try {
      double reading = await getOdometerReadingFromImageOpenAi(imageFile);

      odometerController.text = reading.toStringAsFixed(0);
      notifyListeners();

      print("Odometer reading auto-filled successfully!");
    } catch (error) {
      if (context.mounted) {
        odometerController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst("Exception: ", "")),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        navPop(context: context);
      }
    }
  }

  Future<void> scanInvoiceBillDisplayWithGemini(
    File imageFile,
    BuildContext context,
  ) async {
    showLoader(context);

    try {
      final FuelInvoiceResult reading = await getFuelInvoiceFromImageOpenAi(
        imageFile,
      );

      invoiceNumberController.text = reading.invoiceNo;

      notifyListeners();

      print("Invoice Bill reading auto-filled successfully!");
    } catch (error) {
      if (context.mounted) {
        invoiceNumberController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst("Exception: ", "")),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        navPop(context: context);
      }
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







    notifyListeners();
  }
}
