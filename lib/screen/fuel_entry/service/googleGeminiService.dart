import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../apiservice/services/secure_storage_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File?> compressImageForOcr(File file) async {
  final filePath = file.absolute.path;

  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 80,
    minWidth: 1920,
    minHeight: 1080,
  );

  return result != null ? File(result.path) : null;
}

Future<double> getOdometerReadingFromImage(File imageFile) async {
  try {
    print("START ODOMETER OCR");
    final apiKey = await SecureStorageService.getGeminiToken();
    final modelVersion = await SecureStorageService.getGeminiVersion();

    if ((apiKey?.isEmpty ?? true) || (modelVersion?.isEmpty ?? true)) {
      throw Exception("Missing API configuration credentials.");
    }
    final compressedImage = await compressImageForOcr(imageFile);

    if (compressedImage == null || compressedImage.path.isEmpty) {
      throw Exception("Image compression failed.");
    }
    final bytes = await compressedImage.readAsBytes();

    final model = GenerativeModel(
      model: modelVersion!,
      apiKey: apiKey!,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'success': Schema.boolean(
              description: 'True if a valid odometer is detected.',
            ),
            'km_reading': Schema.integer(
              description: 'The extracted numerical odometer reading.',
            ),
            'error': Schema.string(
              description: 'Error message if success is false.',
            ),
          },
          requiredProperties: ['success'],
        ),
      ),
    );

    //     const prompt = """
    // You are an odometer OCR validator.
    // - Extract odometer reading if visible.
    // - Accept dashboard photos, meter photos, and dashboard screenshots.
    // - If the image is unrelated or no odometer is visible, set success to false and provide an error message.
    // - If digits are partially visible, return the best possible integer reading.
    // """;
    const prompt = """
    You are an expert automotive instrument cluster analyst and precise odometer OCR validator.

    Your task is to locate and extract the main cumulative odometer reading from the image.

    CRITICAL INSTRUCTIONS FOR DIFFERENT ODOMETER TYPES:
    1. DIGITAL DISPLAYS (Modern Cars & Electric Vehicles):
       - Look for numeric values accompanied by unit labels like "km", "kilometers", "mi", or "miles".
       - Accurately read segmented LCD/LED digits, even if the backlight causes slight reflections or low contrast.
       - Ignore other surrounding digital metrics such as "Trip A/B", "Range/Distance to Empty", "Average Fuel Economy" (e.g., L/100km or mpg), current speed (km/h), or outside temperature.

    2. ANALOG / MECHANICAL DIALS (Older & Classic Cars):
       - Look for the physical rolling counter wheel slot, usually located near the bottom center of the speedometer.
       - If a digit wheel is halfway between numbers (partially rolled), use context to determine the most logical number that has been reached.
       - Ignore the tenths-of-a-kilometer/mile wheel if it is present (often a different color, like white digits on a black background, or vice versa, at the far right). Only extract whole units.

    GENERAL VALIDATION RULES:
    - The odometer must represent the total lifelong distance the vehicle has traveled.
    - If the image is a dashboard screenshot, a close-up meter photo, or a wide cabin photo, zoom in mentally on the cluster to extract the reading.
    - If digits are partially obscured by steering wheel blockages, glare, or motion blur, return your absolute best mathematical/logical estimate of the integer reading. Do not include commas, spaces, or decimals in the 'km_reading' output.

    ERROR HANDLING:
    - If the image does not show a vehicle dashboard, gauge cluster, or screen capable of displaying an odometer, set success to false.
    - If the dashboard is visible but the odometer section is completely unreadable, cut off, or entirely missing, set success to false.
    """;

    final content = [
      Content.multi([TextPart(prompt), DataPart('image/jpeg', bytes)]),
    ];

    int retry = 0;
    GenerateContentResponse? response;

    while (retry < 3) {
      try {
        response = await model.generateContent(content);
        break;
      } on GenerativeAIException catch (e) {
        retry++;
        print("Gemini API Retry Attempt => $retry due to: $e");
        if (retry >= 3) rethrow;
        await Future.delayed(Duration(seconds: 2 * retry));
      }
    }

    final responseText = response?.text;
    if (responseText == null) {
      throw Exception("Received empty response from Gemini API.");
    }

    print("RAW JSON RESPONSE => $responseText");

    final Map<String, dynamic> jsonData = jsonDecode(responseText);
    final bool success = jsonData["success"] == true;

    if (!success) {
      final errorMessage =
          jsonData["error"] ?? "Only clear odometer images are allowed.";
      throw Exception(errorMessage);
    }

    final double kmReading =
        double.tryParse(jsonData["km_reading"].toString()) ?? 0;

    if (kmReading <= 0) {
      throw Exception("Odometer reading could not be accurately detected.");
    }

    return kmReading;
  } catch (e) {
    print("OCR CORE ERROR => $e");
    final cleanMessage = e.toString().replaceFirst("Exception: ", "");
    throw Exception(cleanMessage);
  }
}

Future<FuelScanResult> getFuelDetailsFromImage(File imageFile) async {
  try {
    print("START FUEL OCR CORE");
    final apiKey = await SecureStorageService.getGeminiToken();
    final modelVersion = await SecureStorageService.getGeminiVersion();

    if ((apiKey?.isEmpty ?? true) || (modelVersion?.isEmpty ?? true)) {
      throw Exception("Missing API configuration credentials.");
    }
    final compressedImage = await compressImageForOcr(imageFile);

    if (compressedImage == null || compressedImage.path.isEmpty) {
      throw Exception("Image compression failed.");
    }
    final bytes = await compressedImage.readAsBytes();

    final model = GenerativeModel(
      model: modelVersion!,
      apiKey: apiKey!,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'success': Schema.boolean(
              description: 'True if a valid fuel station display is detected.',
            ),
            'liters': Schema.number(
              description: 'The volume/quantity of fuel dispensed.',
            ),
            'price_per_liter': Schema.number(
              description: 'The unit cost per liter or gallon.',
            ),
            'total_amount': Schema.number(
              description:
                  'The total monetary cost charged for the transaction.',
            ),
            'error': Schema.string(
              description: 'Detailed error message if success is false.',
            ),
          },
          requiredProperties: ['success'],
        ),
      ),
    );

    const prompt = """
You are an expert fuel station receipt and dispenser display analyst. Your task is to extract transaction values with high precision.

CRITICAL INSTRUCTIONS FOR FUEL DISPENSERS:
1. IDENTIFY THE METRICS ACCURATELY:
   - Fuel displays show three key metrics: Total Price, Volume (Liters/Gallons), and Unit Price (Price per Liter).
   - Use positioning rules and semantic logic to avoid mixing these numbers up:
     * Total Price is almost always the largest font or positioned at the very top.
     * Volume (Liters) is typically in the middle or has more decimal digits.
     * Price per Liter is typically the smallest number, often positioned at the bottom or labeled on the side panel.

2. STYLE HANDLING:
   - Modern LED/LCD segment displays can have missing line segments due to refresh rates or camera shutter speeds. Use the surrounding numerical logic (Volume × Unit Price = Total Price) to mathematically infer missing or corrupted digits.
   - Ignore background elements such as fuel pump nozzle handles, advertising screens on the pump, car reflections, or station logos.

GENERAL VALIDATION RULES:
- Extract numbers only. Do not include currency symbols (\$ , €, ₹, £), commas, or unit characters (L, gal) in the final number values.
- Validate the mathematical relationship: total_amount should roughly equal (liters * price_per_liter). If minor deviation exists due to rounding or missing decimal points, prioritize the values explicitly visible on screen.

ERROR HANDLING:
- If the image is a selfie, a vehicle dashboard, an unrelated paper document, or random objects, set success to false and specify the issue in the error field.
- If the display is visible but crucial fields (liters or total amount) are completely unreadable, cut off, or covered by glare, set success to false.
""";

    final content = [
      Content.multi([TextPart(prompt), DataPart('image/jpeg', bytes)]),
    ];

    int retry = 0;
    GenerateContentResponse? response;

    while (retry < 3) {
      try {
        response = await model.generateContent(content);
        break;
      } on GenerativeAIException catch (e) {
        retry++;
        print("Gemini API Fuel Retry Attempt => $retry due to: $e");
        if (retry >= 3) rethrow;
        await Future.delayed(Duration(seconds: 2 * retry));
      }
    }

    final responseText = response?.text;
    if (responseText == null) {
      throw Exception("Received empty response from Gemini API.");
    }

    print("RAW FUEL JSON RESPONSE => $responseText");

    final Map<String, dynamic> jsonData = jsonDecode(responseText);
    final bool success = jsonData["success"] == true;

    if (!success) {
      final errorMessage =
          jsonData["error"] ?? "Only fuel machine display images are allowed.";
      throw Exception(errorMessage);
    }

    final double liters = double.tryParse(jsonData["liters"].toString()) ?? 0;
    final double price =
        double.tryParse(jsonData["price_per_liter"].toString()) ?? 0;
    final double total =
        double.tryParse(jsonData["total_amount"].toString()) ?? 0;

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

class FuelScanResult {
  final double liters;
  final double pricePerLiter;
  final double totalAmount;

  FuelScanResult({
    required this.liters,
    required this.pricePerLiter,
    required this.totalAmount,
  });
}
