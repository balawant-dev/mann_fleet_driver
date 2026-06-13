import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/shuttle/shuttleShift/ui/shuttleShiftDetailScreen.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:provider/provider.dart';

import '../../../bookingHistory/provider/bookingHistoryPro.dart';
import '../provider/shuttleShiftPro.dart';

class ShuttleShiftListScreen extends StatefulWidget {
  const ShuttleShiftListScreen({super.key});

  @override
  State<ShuttleShiftListScreen> createState() => _ShuttleShiftListScreenState();
}

class _ShuttleShiftListScreenState extends State<ShuttleShiftListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShuttleShiftProvider>(
        context,
        listen: false,
      ).shuttleShiftApi(context:context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Shuttle Shifts"),
      // appBar: AppBar(
      //   title: const Text("Shuttle Shifts"),
      //   backgroundColor: const Color(0xff0A2472),
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Consumer<ShuttleShiftProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final shifts = provider.shuttleShiftModel?.data ?? [];

          if (shifts.isEmpty) {
            return const Center(
              child: Text("No Shuttle Shift Found"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shifts.length,
            itemBuilder: (_, index) {
              final item = shifts[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShuttleShiftDetailScreen(
                        shiftId: item.sId ?? "",
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xff0A2472)
                              .withOpacity(.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_bus,
                          color: Color(0xff0A2472),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.shuttleRoute?.name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              item.shuttleRouteShift?.shiftName ??
                                  "",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              item.vehicle?.carNumber ?? "",
                              style: const TextStyle(
                                color: Color(0xff0A2472),
                                fontWeight: FontWeight.w500,
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Color(0xff0A2472),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}