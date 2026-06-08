import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentQrScreen extends StatelessWidget {
  const PaymentQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan & Pay')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://api.qrserver.com/v1/create-qr-code/?size=400x400&margin=10&data=https%3A%2F%2Frzp.io%2Frzp%2FtuyrvGd",
              height: 260,
              width: 260,
            ),

            const SizedBox(height: 20),

            Text(
              '₹${6772 / 100}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Extra distance: +17.3 km, Extra time: +30 mins",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                final url = "https://rzp.io/rzp/tuyrvGd";

                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Open Payment Link'),
            ),
          ],
        ),
      ),
    );
  }
}
