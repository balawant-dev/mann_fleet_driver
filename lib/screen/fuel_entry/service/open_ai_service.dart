import 'dart:convert';
import 'dart:io';
import '../../../apiservice/services/secure_storage_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import 'googleGeminiService.dart';

Future<File?> compressImageForOcr(File file) async {
  final filePath = file.absolute.path;

  final extIndex = filePath.lastIndexOf('.');
  final outPath =
      "${filePath.substring(0, extIndex)}_out${filePath.substring(extIndex)}";

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 80,
    minWidth: 1920,
    minHeight: 1080,
  );

  return result != null ? File(result.path) : null;
}

Future<double> getOdometerReadingFromImageOpenAi(File imageFile) async {
  try {
    final apiKey = await SecureStorageService.getOpenAiToken();
    final apiVersion = await SecureStorageService.getOpenAiVersion();

    if (apiKey == null ||
        apiKey.isEmpty ||
        apiVersion == null ||
        apiVersion.isEmpty) {
      throw Exception("Missing OpenAI configuration.");
    }

    final compressedImage = await compressImageForOcr(imageFile);

    if (compressedImage == null || compressedImage.path.isEmpty) {
      throw Exception("Image compression failed.");
    }

    final bytes = await compressedImage.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await postWithRetry(
      url: Uri.parse('https://api.openai.com/v1/responses'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": apiVersion,
        "input": [
          {
            "role": "user",
            "content": [
              {
                "type": "input_text",
                "text": """
Extract the vehicle odometer reading.

Rules:
- Return valid JSON only.
- If odometer found:
{
  "success": true,
  "km_reading": 12345
}

- If not found:
{
  "success": false,
  "error": "reason"
}
""",
              },
              {
                "type": "input_image",
                "image_url": "data:image/jpeg;base64,$base64Image",
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final data = jsonDecode(response.body);

    final outputText = data["output"][0]["content"][0]["text"] as String;

    final result = jsonDecode(outputText);

    if (result["success"] != true) {
      throw Exception(result["error"] ?? "Could not detect odometer");
    }

    return (result["km_reading"] as num).toDouble();
  } catch (e) {
    throw Exception(e.toString().replaceFirst("Exception: ", ""));
  }
}

Future<FuelScanResult> getFuelDetailsFromImageOpenAi(File imageFile) async {
  try {
    print("START FUEL OCR CORE");

    final apiKey = await SecureStorageService.getOpenAiToken();
    final apiVersion = await SecureStorageService.getOpenAiVersion();

    if (apiKey == null ||
        apiKey.isEmpty ||
        apiVersion == null ||
        apiVersion.isEmpty) {
      throw Exception("Missing OpenAI configuration.");
    }

    final compressedImage = await compressImageForOcr(imageFile);

    if (compressedImage == null || compressedImage.path.isEmpty) {
      throw Exception("Image compression failed.");
    }

    final bytes = await compressedImage.readAsBytes();
    final base64Image = base64Encode(bytes);

    const prompt = """
You are an expert fuel station receipt and dispenser display analyst.

Return ONLY valid JSON.

Success format:
{
  "success": true,
  "liters": 25.4,
  "price_per_liter": 106.9,
  "total_amount": 2715.26
}

Failure format:
{
  "success": false,
  "error": "reason"
}

Rules:
- Extract liters, price_per_liter and total_amount.
- Ignore currency symbols and units.
- Validate that:
  total_amount ≈ liters × price_per_liter
- If image is not a fuel pump display, return success=false.
""";

    final response = await postWithRetry(
      url: Uri.parse('https://api.openai.com/v1/responses'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": apiVersion,
        "input": [
          {
            "role": "user",
            "content": [
              {"type": "input_text", "text": prompt},
              {
                "type": "input_image",
                "image_url": "data:image/jpeg;base64,$base64Image",
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final data = jsonDecode(response.body);

    final responseText = data["output"][0]["content"][0]["text"];

    print("RAW FUEL JSON RESPONSE => $responseText");

    final jsonData = jsonDecode(responseText);

    final bool success = jsonData["success"] == true;

    if (!success) {
      throw Exception(
        jsonData["error"] ?? "Only fuel machine display images are allowed.",
      );
    }

    final liters = double.tryParse(jsonData["liters"].toString()) ?? 0;

    final price = double.tryParse(jsonData["price_per_liter"].toString()) ?? 0;

    final total = double.tryParse(jsonData["total_amount"].toString()) ?? 0;

    if (liters <= 0 || price <= 0 || total <= 0) {
      throw Exception("Fuel data metrics could not be detected completely.");
    }

    return FuelScanResult(
      liters: liters,
      pricePerLiter: price,
      totalAmount: total,
    );
  } catch (e) {
    print("FUEL OCR CORE ERROR => $e");

    final cleanMessage = e.toString().replaceFirst("Exception: ", "");

    throw Exception(cleanMessage);
  }
}

Future<FuelInvoiceResult> getFuelInvoiceFromImageOpenAi(File imageFile) async {
  try {
    const prompt = """
Read this fuel/petrol pump bill and return ONLY valid JSON.

Success:
{
  "success": true,
  "invoice_no": "123456",
  "total_amount": 2500.50,
  "fuel_rate": 106.90,
  "fuel_quantity": 23.39
}

Failure:
{
  "success": false,
  "error": "reason"
}

Rules:
- Extract invoice number.
- Extract total amount.
- Extract fuel rate per litre.
- Extract fuel quantity/litres.
- Ignore currency symbols and units.
- Return JSON only.
""";

    final jsonData = await extractJsonFromImageOpenAi(
      imageFile: imageFile,
      prompt: prompt,
    );

    if (jsonData["success"] != true) {
      throw Exception(
        jsonData["error"] ?? "Could not extract invoice details.",
      );
    }

    return FuelInvoiceResult(
      invoiceNo: jsonData["invoice_no"]?.toString() ?? "",
      totalAmount: double.tryParse(jsonData["total_amount"].toString()) ?? 0,
      fuelRate: double.tryParse(jsonData["fuel_rate"].toString()) ?? 0,
      fuelQuantity: double.tryParse(jsonData["fuel_quantity"].toString()) ?? 0,
    );
  } catch (e) {
    throw Exception(e.toString().replaceFirst("Exception: ", ""));
  }
}

Future<Map<String, dynamic>> extractJsonFromImageOpenAi({
  required File imageFile,
  required String prompt,
}) async {
  try {
    final apiKey = await SecureStorageService.getOpenAiToken();
    final apiVersion = await SecureStorageService.getOpenAiVersion();

    if (apiKey == null ||
        apiKey.isEmpty ||
        apiVersion == null ||
        apiVersion.isEmpty) {
      throw Exception("Missing OpenAI configuration.");
    }

    final compressedImage = await compressImageForOcr(imageFile);

    if (compressedImage == null || compressedImage.path.isEmpty) {
      throw Exception("Image compression failed.");
    }

    final bytes = await compressedImage.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await postWithRetry(
      url: Uri.parse('https://api.openai.com/v1/responses'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": apiVersion,
        "input": [
          {
            "role": "user",
            "content": [
              {"type": "input_text", "text": prompt},
              {
                "type": "input_image",
                "image_url": "data:image/jpeg;base64,$base64Image",
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final data = jsonDecode(response.body);

    final responseText = data["output"][0]["content"][0]["text"].toString();

    return jsonDecode(responseText);
  } catch (e) {
    throw Exception(e.toString().replaceFirst("Exception: ", ""));
  }
}

Future<http.Response> postWithRetry({
  required Uri url,
  required Map<String, String> headers,
  required String body,
}) async {
  final stopwatch = Stopwatch()..start();

  int retry = 0;

  while (retry < 3) {
    try {
      final response = await http.post(url, headers: headers, body: body);

      stopwatch.stop();

      print('OpenAI Response Time: ${stopwatch.elapsedMilliseconds} ms');

      if (response.statusCode == 200) {
        return response;
      }

      throw Exception(response.body);
    } catch (e) {
      retry++;

      if (retry >= 3) {
        stopwatch.stop();

        print('OpenAI Failed After: ${stopwatch.elapsedMilliseconds} ms');

        rethrow;
      }

      await Future.delayed(Duration(seconds: retry * 2));
    }
  }

  throw Exception("Request failed.");
}
