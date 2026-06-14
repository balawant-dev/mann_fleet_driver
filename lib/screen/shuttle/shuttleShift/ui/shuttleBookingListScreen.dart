import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widget/commonAppBar.dart';
import '../provider/shuttleShiftPro.dart';

class ShuttleBookingListScreen extends StatefulWidget {
  final String shiftId;

  const ShuttleBookingListScreen({super.key, required this.shiftId});

  static const primaryColor = Color(0xff0A2472);

  @override
  State<ShuttleBookingListScreen> createState() =>
      _ShuttleBookingListScreenState();
}

class _ShuttleBookingListScreenState extends State<ShuttleBookingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShuttleShiftProvider>(
        context,
        listen: false,
      ).fetchedShiftBookingsApi(context: context, shiftID: widget.shiftId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShuttleShiftProvider>();

    final bookings = provider.fetchedShiftBookingsModel?.data ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Passenger Bookings"),

      body: Consumer<ShuttleShiftProvider>(
        builder: (context, provider, child) {
          /// Loading
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ShuttleBookingListScreen.primaryColor,
              ),
            );
          }

          final bookings = provider.fetchedShiftBookingsModel?.data ?? [];

          /// Empty State
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "No Bookings Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    provider.fetchedShiftBookingsModel?.message ??
                        "No passengers available for this shift.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          /// Data Found
          return RefreshIndicator(
            color: ShuttleBookingListScreen.primaryColor,
            onRefresh: () async {
              await provider.fetchedShiftBookingsApi(
                context: context,
                shiftID: widget.shiftId,
              );
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        /// User Info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: ShuttleBookingListScreen
                                  .primaryColor
                                  .withOpacity(.1),
                              backgroundImage:
                                  booking.user?.profilePic != null &&
                                          booking.user!.profilePic!.isNotEmpty
                                      ? NetworkImage(booking.user!.profilePic!)
                                      : null,
                              child:
                                  booking.user?.profilePic == null
                                      ? const Icon(
                                        Icons.person,
                                        color:
                                            ShuttleBookingListScreen
                                                .primaryColor,
                                      )
                                      : null,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.user?.name ?? "Unknown User",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    booking.shuttlePass?.name ?? "",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    booking.tripStatus == "Completed"
                                        ? Colors.green.withOpacity(.1)
                                        : Colors.orange.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                booking.tripStatus ?? "Pending",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      booking.tripStatus == "Completed"
                                          ? Colors.green
                                          : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Divider(color: Colors.grey.shade200),

                        const SizedBox(height: 10),

                        /// Route
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: ShuttleBookingListScreen.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                "${booking.source ?? ""} ➜ ${booking.destination ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _infoCard(
                                title: "Rides Left",
                                value: "${booking.remainingRides ?? 0}",
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _infoCard(
                                title: "Total Rides",
                                value: "${booking.totalRides ?? 0}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _infoCard(
                                title: "Amount",
                                value: "₹${booking.totalAmount ?? 0}",
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _infoCard(
                                title: "Scans",
                                value: "${booking.scanCount ?? 0}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Payment",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      booking.paymentStatus ?? "",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Booking Date",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      booking.bookingDate ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 45,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor:
                        //           ShuttleBookingListScreen.primaryColor,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       /// Booking Detail Screen
                        //     },
                        //     child: const Text(
                        //       "View Details",
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: ShuttleBookingListScreen.primaryColor.withOpacity(.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: ShuttleBookingListScreen.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
