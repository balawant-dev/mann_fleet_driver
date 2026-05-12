import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../provider/compliance_provider.dart';
import '../provider/profileDetailProvider.dart';
import 'digilockerWebView.dart';

class ComplianceScreen extends StatefulWidget {
  const ComplianceScreen({super.key});

  @override
  State<ComplianceScreen> createState() => _ComplianceScreenState();
}

class _ComplianceScreenState extends State<ComplianceScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    final profile = context.read<ProfileDetailProvider>();
    final driver = profile.getProfileModel?.data?.driver;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplianceProvider>().setInitialData(driver);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplianceProvider>();
    final driver =
        context.read<ProfileDetailProvider>().getProfileModel?.data?.driver;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: "KYC Documents"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Aadhaar
            _title("Aadhaar Card"),
            const SizedBox(height: 10),

            /// ================= TEXTFIELD =================
            CommonTextFormField(
              controller: provider.adhaarNumber,
              labelText: "Aadhaar Number",
              keyboardType: TextInputType.number,
              maxLength: 12,

              onChanged: (value) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                _debounce = Timer(const Duration(milliseconds: 600), () async {
                  if (value.length == 12 &&
                      RegExp(r'^\d{12}$').hasMatch(value)) {
                    try {
                      /// 🔥 VERIFY API

                      final data = await provider.verifyAadhaar(
                        adharNumber: value,
                      );

                      if (data == null || data.status != true) {
                        return;
                      }

                      final digilockerUrl = data.data?.digilockerUrl ?? "";

                      final clientId = data.data?.clientId ?? "";

                      /// 🔥 OPEN WEBVIEW

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DigilockerWebView(url: digilockerUrl),
                        ),
                      );

                      /// 🔥 COMPLETE VERIFY

                      if (result != false) {
                        await provider.verifyCompleteAadhaar(
                          adharNumber: value,
                          clientId: clientId,
                        );
                      }
                    } catch (e) {
                      debugPrint("Verification Error: $e");
                    }
                  }
                });
              },

              onTap: () {},
            ),

            if (provider.isAadhaarVerified) ...[
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.green, size: 22),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "Aadhaar verified successfully",
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _upload(
                    title: "Front",
                    file: provider.adhaarFront,
                    network: driver?.adhaarFrontPhoto,
                    onTap: () {
                      provider.pickAdhaarFront(context);
                    },
                    // onTap: provider.pickAdhaarFront,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _upload(
                    title: "Back",
                    file: provider.adhaarBack,
                    network: driver?.adhaarBackPhoto,
                    onTap: () {
                      provider.pickAdhaarBack(context);
                    },
                    // onTap: provider.pickAdhaarBack,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 PAN
            _title("PAN Card"),
            const SizedBox(height: 10),

            CommonTextFormField(
              controller: provider.panNumber,
              labelText: "PAN Number",
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _upload(
                    title: "Front",
                    file: provider.panFront,
                    network: driver?.panFrontPhoto,
                    onTap: () {
                      provider.pickPanFront(context);
                    },
                    // onTap: provider.pickPanFront,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _upload(
                    title: "Back",
                    file: provider.panBack,
                    network: driver?.panBackPhoto,
                    onTap: () {
                      provider.pickPanBack(context);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 Police
            _title("Police Verification"),
            const SizedBox(height: 10),

            CommonTextFormField(
              controller: provider.policeExpiry,
              labelText: "Expiry Date",
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_month),
              onTap: () => provider.pickPoliceExpiryDate(context),
            ),

            const SizedBox(height: 10),

            _upload(
              title: "Upload Document",
              file: provider.policeVerification,
              network: driver?.policeVerificationPhoto,
              // onTap: provider.pickPolice,
              onTap: () {
                provider.pickPolice(context);
              },
              full: true,
            ),

            const SizedBox(height: 40),

            CommonAppButton(
              text: "Submit KYC",
              onPressed: () {
                provider.submitCompliance(context);
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _upload({
    required String title,
    File? file,
    String? network,
    required VoidCallback onTap,
    bool full = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: full ? double.infinity : null,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child:
            file != null
                ? Image.file(file, fit: BoxFit.contain)
                : (network != null && network.isNotEmpty)
                ? Image.network(
                  network,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported_outlined, size: 60);
                  },
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload, size: 30),
                    const SizedBox(height: 6),
                    Text(title),
                  ],
                ),
      ),
    );
  }
}
