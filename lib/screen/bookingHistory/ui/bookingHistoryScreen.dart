import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:provider/provider.dart';

import '../provider/bookingHistoryPro.dart';



// ================= SCREEN =================
class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingHistoryProvider>(context, listen: false)
          .fetchBookings(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Booking History"),
      // appBar: AppBar(title: const Text("Booking History")),
      body: Consumer<BookingHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = provider.bookingModel?.data ?? [];

          if (list.isEmpty) {
            return const Center(child: Text("No bookings found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Number + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.bookingNumber ?? "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.tripStatus ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Pickup
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked,
                            size: 14, color: Colors.green),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.pickup?.address ?? "",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Drop
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.dropoff?.address ?? "",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 20),

                    // Bottom Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹ ${item.estimatedFare ?? 0}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          item.scheduledAtIST ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ================= MAIN USAGE =================
// Wrap with provider

/*
ChangeNotifierProvider(
  create: (_) => BookingHistoryProvider(),
  child: BookingHistoryScreen(),
)
*/
