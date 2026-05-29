import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> scanFuelDisplayWithGemini(File imageFile) async {

  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);

  final apiKey = "YOUR_GEMINI_API_KEY";

  final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
              "Read this fuel meter image and return only JSON with liters, price_per_liter and total_amount."
            },
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Image
              }
            }
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final text = data['candidates'][0]['content']['parts'][0]['text'];

    print("AI RESPONSE = $text");
  } else {
    print(response.body);
  }
}