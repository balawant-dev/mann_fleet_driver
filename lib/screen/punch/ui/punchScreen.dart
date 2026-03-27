import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../util/color/app_colors.dart';
import '../../../widget/commonAppBar.dart';
import '../provider/punchProvider.dart';


class PunchScreen extends StatefulWidget {
  const PunchScreen({super.key});

  @override
  State<PunchScreen> createState() => _PunchScreenState();
}

class _PunchScreenState extends State<PunchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PunchProvider>(context, listen: false);
      provider.loadAllData(context: context);
    });
  }

  Future<void> _handlePunchAction(PunchProvider provider) async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (provider.isCurrentlyPunchedIn) {
      await provider.postPunchOutApi(
        context: context,
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
      );
    } else {
      await provider.postPunchInApi(
        context: context,
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
      );
    }
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission is permanently denied")),
      );
      return false;
    }
    return permission != LocationPermission.denied;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Attendance Punch"),
      backgroundColor: Colors.white,
      body: Consumer<PunchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final hasRegion = provider.hasAssignedRegion;
          final isPunchedIn = provider.isCurrentlyPunchedIn;
          final regionName = provider.getPunchRegionsModel?.data?.punchRegion?.name ?? "No Region Assigned";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          isPunchedIn ? Icons.check_circle : Icons.access_time,
                          size: 80,
                          color: isPunchedIn ? Colors.green : ColorResource.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isPunchedIn ? "You are Punched In" : "Ready to Punch In",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Region: $regionName",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: hasRegion
                        ? () => _handlePunchAction(provider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResource.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      isPunchedIn ? "Punch Out" : "Punch In",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                if (!hasRegion) ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      "No punch region assigned. Contact Admin.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // History Section
                const Text(
                  "Punch History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (provider.getPunchHistoryModel?.data?.isNotEmpty ?? false)
                // Add ListView.builder for history here
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text("History will appear here")),
                  )
                else
                  const Center(child: Text("No punch history yet")),
              ],
            ),
          );
        },
      ),
    );
  }
}