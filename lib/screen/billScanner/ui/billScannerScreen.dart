


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class BillScannerScreen extends StatefulWidget {
  @override
  _BillScannerScreenState createState() => _BillScannerScreenState();
}

class _BillScannerScreenState extends State<BillScannerScreen> {

  final picker = ImagePicker();

  File? billImage;
  File? speedoImage;

  String invoiceNumber = "Not Found";
  String amount = "Not Found";
  String speedReading = "Not Found";

  TextEditingController speedController = TextEditingController();

  /// 📸 PICK IMAGE (Camera / Gallery)
  Future<void> pickImage(bool isBill) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Camera"),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            title: Text("Gallery"),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) return;

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File? cropped = await cropImage(File(pickedFile.path));

      if (cropped != null) {
        if (isBill) {
          billImage = cropped;
          await scanBill();
        } else {
          speedoImage = cropped;
          await scanSpeedometer();
        }
        setState(() {});
      }
    }
  }

  /// ✂️ CROP IMAGE
  Future<File?> cropImage(File file) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: "Crop Image"),
      ],
    );

    return cropped != null ? File(cropped.path) : null;
  }

  /// 🔍 OCR COMMON
  Future<String> processOCR(File file) async {
    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer();

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    textRecognizer.close();

    return recognizedText.text;
  }

  /// 🧾 BILL SCAN
  Future<void> scanBill() async {
    if (billImage == null) return;

    String text = await processOCR(billImage!);

    extractDataAdvanced(text);
  }

  /// 🧠 SMART DATA EXTRACTION
  void extractDataAdvanced(String text) {

    /// ✅ ONLY STRONG KEYS (ENGLISH ONLY)
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

    String foundInvoice = "Not Found";
    String foundAmount = "Not Found";

    List<String> lines = text.split('\n');

    /// =========================
    /// 🔍 INVOICE (STRICT)
    /// =========================
    /// =========================
    /// 🔍 INVOICE (FIXED + SMART)
    /// =========================
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String l = line.toLowerCase();

      for (String key in invoiceKeys) {
        if (l.contains(key) && foundInvoice == "Not Found") {

          /// 🔥 KEY ke baad ka part nikaalo
          String afterKey = line.toLowerCase().split(key).last;

          /// original line ka same part
          int index = line.toLowerCase().indexOf(key);
          String originalAfterKey = line.substring(index + key.length);

          /// 🔹 extract candidate
          RegExp reg = RegExp(r'[:\-\s]*([A-Z0-9\-]{4,})');
          final match = reg.firstMatch(originalAfterKey);

          if (match != null) {
            String val = match.group(1)!;

            /// 🎯 FILTER (important)
            if (!RegExp(r'^\d+$').hasMatch(val) && val.length >= 4) {
              foundInvoice = val;
              break;
            }
          }

          /// 🔹 NEXT LINE (common case)
          if (i + 1 < lines.length) {
            String nextLine = lines[i + 1];

            final nextMatch =
            RegExp(r'([A-Z0-9\-]{4,})').firstMatch(nextLine);

            if (nextMatch != null) {
              String val = nextMatch.group(1)!;

              if (!RegExp(r'^\d+$').hasMatch(val)) {
                foundInvoice = val;
                break;
              }
            }
          }
        }
      }
    }

    /// =========================
    /// 💰 AMOUNT (STRICT FIX)
    /// =========================
    List<double> amounts = [];

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String l = line.toLowerCase();

      for (String key in amountKeys) {
        if (l.contains(key)) {

          /// Extract only number after keyword
          RegExp reg = RegExp(r'(\d+\.?\d{0,2})');
          Iterable<Match> matches = reg.allMatches(line);

          for (var m in matches) {
            double val = double.tryParse(m.group(0)!) ?? 0;

            /// 🎯 STRICT FILTER
            if (val > 100 && val < 10000) {
              amounts.add(val);
            }
          }
        }
      }
    }

    /// 🔥 FINAL AMOUNT PICK
    if (amounts.isNotEmpty) {
      amounts.sort();
      foundAmount = amounts.last.toStringAsFixed(2);
    }

    /// =========================
    /// ❌ NO FALLBACK (important)
    /// =========================
    /// fallback hata diya → random number nahi aayega

    setState(() {
      invoiceNumber = foundInvoice;
      amount = foundAmount;
    });
  }

  /// 🚗 SPEEDOMETER SCAN
  Future<void> scanSpeedometer() async {
    if (speedoImage == null) return;

    String text = await processOCR(speedoImage!);

    RegExp numberRegex = RegExp(r'\d{3,7}');
    Iterable<Match> matches = numberRegex.allMatches(text);

    String best = "Not Found";
    int max = 0;

    for (var m in matches) {
      int val = int.tryParse(m.group(0)!) ?? 0;

      if (val > max) {
        max = val;
        best = m.group(0)!;
      }
    }

    setState(() {
      speedReading = best;
      speedController.text = best;
    });
  }

  /// 📊 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanner App")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🧾 BILL SECTION
            sectionTitle("Petrol Bill Scanner"),

            ElevatedButton(
              onPressed: () => pickImage(true),
              child: Text("Scan Bill"),
            ),

            if (billImage != null)
              Image.file(billImage!, height: 150),

            buildRow("Invoice No:", invoiceNumber),
            buildRow("Amount:", amount),

            Divider(height: 40),

            /// 🚗 SPEEDO SECTION
            sectionTitle("Speedometer Scanner"),

            ElevatedButton(
              onPressed: () => pickImage(false),
              child: Text("Scan Speedometer"),
            ),

            if (speedoImage != null)
              Image.file(speedoImage!, height: 150),

            SizedBox(height: 10),

            TextField(
              controller: speedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Speedometer Reading",
                border: OutlineInputBorder(),
              ),
            ),

            buildRow("Detected Speed:", speedReading),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$title ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}