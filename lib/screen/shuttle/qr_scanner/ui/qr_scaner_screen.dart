


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/shuttle/qr_scanner/ui/qrScannerOverlayShape.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../../widget/motionToastHelper.dart';
import '../../../bottomBar/bottomBar.dart';
import '../model/qrScanSucessModel.dart';
import '../provider/qrScanPro.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  bool isScanned = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onDetect(BarcodeCapture capture) async {
    if (isScanned) return;

    final barcode = capture.barcodes.first;
    final String? data = barcode.rawValue;

    if (data != null) {
      isScanned = true;

      try {
        final jsonData = jsonDecode(data);
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>${jsonData}");

        String qrToken = jsonData['qrToken'] ?? '';
        String travelDirection = jsonData['travelDirection'] ?? '';
        String currentStopName = jsonData['source'] ?? ''; // ya destination bhi use kar sakte ho
        String shiftId = jsonData['shiftId'] ?? ''; // 👉 yeh tum apni app se dynamic lo

        print("QR TOKEN: $qrToken");

        /// ✅ Provider Call
        final provider =
        Provider.of<QrScanProvider>(context, listen: false);

        await provider.postQrApi(
          context: context,
          qrToken: qrToken,
          currentStopName: currentStopName,
          shiftId: shiftId,
          travelDirection: travelDirection,
        );

        /// ✅ Success → BottomSheet open
        if (provider.qrScanSuccessModel != null &&
            provider.qrScanSuccessModel!.status == true) {
          _openBottomSheet(context);
        } else {
          ToastHelper.show(context, message:  provider.errorMessage ??
              "QR verification failed",type: ToastType.error);

        }
      } catch (e) {
        print("Error parsing QR: $e");
      }

      Future.delayed(const Duration(seconds: 3), () {
        isScanned = false;
      });
    }
  }

  // void onDetect(BarcodeCapture capture) {
  //   if (isScanned) return;
  //
  //   final barcode = capture.barcodes.first;
  //   final String? data = barcode.rawValue;
  //
  //   if (data != null) {
  //     isScanned = true;
  //
  //     print("====== QR RESULT ======");
  //     print(data);
  //
  //     try {
  //       final jsonData = jsonDecode(data);
  //       print("JSON Data: $jsonData");
  //     } catch (e) {
  //       print("Normal Text: $data");
  //     }
  //     print("Scanned: $data");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Scanned: $data")),
  //     );
  //
  //     Future.delayed(const Duration(seconds: 3), () {
  //       isScanned = false;
  //     });
  //   }
  // }
  void _openBottomSheet(BuildContext context) {
    final provider = Provider.of<QrScanProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return  TicketBottomSheet(qrScanSuccessModel: provider.qrScanSuccessModel,);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan QR Code Shuttle"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          /// 📷 Camera
          MobileScanner(
            onDetect: onDetect,
          ),

          /// 🔳 Overlay
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 12,
                borderLength: 30,
                borderWidth: 5,
                cutOutSize: 250,
              ),
            ),
          ),

          /// 🔴 Animated Line
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(0, _controller.value * 2 - 1),
                    child: Container(
                      height: 2,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ),

          /// 📝 Instruction Text
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code inside the box",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketBottomSheet extends StatelessWidget {
  QrScanSuccessModel? qrScanSuccessModel;
   TicketBottomSheet({super.key, this.qrScanSuccessModel});

  @override
  Widget build(BuildContext context) {
    final data = qrScanSuccessModel?.data;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// drag handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// check icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 10),

                /// title
                Text(
                  data?.passStatus == "ACTIVE"
                      ? "Ticket Verified"
                      : "Invalid Pass",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "${data?.journey?.from ?? '-'} → ${data?.journey?.to ?? '-'}",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),
                const Divider(),

                const SizedBox(height: 5),

                /// info rows
                _infoRow("Passenger", data?.user?.name ?? '-'),

                _infoRow(
                  "Route",
                  "${data?.journey?.from ?? '-'} → ${data?.journey?.to ?? '-'}",
                ),

                _infoRow(
                  "Direction",
                  data?.journey?.direction ?? '-',
                ),

                _infoRow(
                  "Shift",
                  data?.shiftInfo?.shiftName ?? '-',
                ),

                _infoRow(
                  "Ride",
                  "${data?.rideInfo?.rideNumber ?? 0}/${data?.rideInfo?.totalRides ?? 0}",
                ),

                _infoRow(
                  "Remaining",
                  "${data?.rideInfo?.remainingRides ?? 0}",
                ),

                _infoRow(
                  "Pass Status",
                  data?.passStatus ?? '-',
                ),

                const SizedBox(height: 20),

                /// button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF283E71),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (data?.passStatus == "ACTIVE") {
                        navPushBottomRemove(context: context, action: MainScreen(), duration: 3);
                        // Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Confirm Boarding",
                      style: TextStyle(fontSize: 16, color: Colors.white),

                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Scan Another",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey,fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,fontSize: 13
            ),
          ),
        ],
      ),
    );
  }
}