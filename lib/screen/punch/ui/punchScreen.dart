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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),        // ← Changed: Soft elegant background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),      // ← Changed: Cleaner border
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),           // ← Softer shadow
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
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
                // Replace this entire block:
                // if (provider.getPunchHistoryModel?.data?.isNotEmpty ?? false)
                //   Container(
                //     height: 300,
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey.shade300),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Center(child: Text("History will appear here")),
                //   )
                // else
                //   const Center(child: Text("No punch history yet")),

// WITH THIS CLEAN & PROFESSIONAL CODE:
                const SizedBox(height: 12),

                if (provider.getPunchHistoryModel?.data?.isEmpty ?? true)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(Icons.history, size: 60, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "No punch history yet",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.getPunchHistoryModel!.data!.length,
                    itemBuilder: (context, index) {
                      final item = provider.getPunchHistoryModel!.data![index];

                      final punchInTime = item.punchInAtIST ?? item.punchInAt ?? "N/A";
                      final punchOutTime = item.punchOutAtIST ?? item.punchOutAt ?? "Not Punched Out";
                      final totalHours = item.totalMinutes != null
                          ? "${(item.totalMinutes! / 60).toStringAsFixed(1)} hrs"
                          : "Ongoing";

                      final isValid = (item.punchInValid ?? false) && (item.punchOutValid ?? true);

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),        // ← Changed: Soft elegant background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),      // ← Changed: Cleaner border
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),           // ← Softer shadow
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        // elevation: 2,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date & Status Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDate(item.punchInAt ?? item.createdAt ?? ""),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isValid ? Colors.green.shade50 : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item.status?.toUpperCase() ?? "COMPLETED",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isValid ? Colors.green : Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 20),

                              // Punch In
                              _buildPunchRow(
                                icon: Icons.login,
                                title: "Punch In",
                                time: punchInTime,
                                distance: item.punchInDistanceFromZone,
                                valid: item.punchInValid ?? false,
                              ),

                              const SizedBox(height: 12),

                              // Punch Out
                              _buildPunchRow(
                                icon: Icons.logout,
                                title: "Punch Out",
                                time: punchOutTime,
                                distance: item.punchOutDistanceFromZone,
                                valid: item.punchOutValid ?? true,
                              ),

                              if (item.totalMinutes != null) ...[
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Time:", style: TextStyle(fontWeight: FontWeight.w500)),
                                    Text(
                                      totalHours,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: ColorResource.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                // if (provider.getPunchHistoryModel?.data?.isNotEmpty ?? false)
                // // Add ListView.builder for history here
                //   Container(
                //     height: 300,
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey.shade300),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Center(child: Text("History will appear here")),
                //   )
                // else
                //   const Center(child: Text("No punch history yet")),
              ],
            ),
          );
        },
      ),
    );
  }
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateString.split('T').first; // fallback
    }
  }

  Widget _buildPunchRow({
    required IconData icon,
    required String title,
    required String time,
    int? distance,
    required bool valid,
  }) {
    return Row(
      children: [
        Icon(icon, color: ColorResource.primaryColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        if (distance != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${distance}m",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        const SizedBox(width: 8),
        Icon(
          valid ? Icons.check_circle : Icons.error_outline,
          color: valid ? Colors.green : Colors.red,
          size: 20,
        ),
      ],
    );
  }
}