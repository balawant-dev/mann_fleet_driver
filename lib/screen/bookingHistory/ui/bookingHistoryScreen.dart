// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mann_fleet_driver/widget/commonAppBar.dart';
// import 'package:provider/provider.dart';
//
// import '../../../widget/empty/bookingHistoryEmptyScreen.dart';
// import '../provider/bookingHistoryPro.dart';
//
// // ================= SCREEN =================
// class BookingHistoryScreen extends StatefulWidget {
//   const BookingHistoryScreen({super.key});
//
//   @override
//   State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
// }
//
// class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<BookingHistoryProvider>(
//         context,
//         listen: false,
//       ).fetchBookings(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(title: "Booking History"),
//       // appBar: AppBar(title: const Text("Booking History")),
//       body: Consumer<BookingHistoryProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final list = provider.bookingModel?.data ?? [];
//
//           if (list.isEmpty) {
//             return BookingHistoryEmptyScreen(
//               onRefresh: () {
//                 Provider.of<BookingHistoryProvider>(
//                   context,
//                   listen: false,
//                 ).fetchBookings(context);
//               },
//             );
//             // return const Center(child: Text("No bookings found"));
//           }
//
//           return RefreshIndicator(
//             onRefresh: () async {
//               Provider.of<BookingHistoryProvider>(
//                 context,
//                 listen: false,
//               ).fetchBookings(context);
//             },
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: list.length,
//               itemBuilder: (context, index) {
//                 final item = list[index];
//
//                 final rawDate = item.scheduledAtIST;
//
//                 String formattedDate = "4 Sep 2024";
//                 String formattedTime = "08:30 PM";
//
//                 DateTime? parsedDate;
//
//                 if (rawDate != null && rawDate.isNotEmpty) {
//                   try {
//                     parsedDate = DateFormat(
//                       'yyyy-MM-dd HH:mm:ss',
//                     ).parse(rawDate);
//
//                     formattedDate = DateFormat('d MMM yyyy').format(parsedDate);
//
//                     formattedTime = DateFormat('hh:mm a').format(parsedDate);
//                   } catch (e) {
//                     debugPrint("Date parsing error: $e");
//                   }
//                 }
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: Colors.grey.shade200),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Booking Number + Status
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             item.bookingNumber ?? "-",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               item.tripStatus ?? "",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.green.shade700,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       // Pickup
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.radio_button_checked,
//                             size: 14,
//                             color: Colors.green,
//                           ),
//                           const SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               item.pickup?.address ?? "",
//                               style: const TextStyle(fontSize: 13),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 6),
//
//                       // Drop
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             size: 14,
//                             color: Colors.red,
//                           ),
//                           const SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               item.dropoff?.address ?? "",
//                               style: const TextStyle(fontSize: 13),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const Divider(height: 20),
//
//                       // Bottom Info
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           // Text(
//                           //   "₹ ${item.estimatedFare ?? 0}",
//                           //   style: const TextStyle(
//                           //     fontWeight: FontWeight.w600,
//                           //   ),
//                           // ),
//                           Text(
//                             "$formattedDate $formattedTime",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // ================= MAIN USAGE =================
// // Wrap with provider
//
// /*
// ChangeNotifierProvider(
//   create: (_) => BookingHistoryProvider(),
//   child: BookingHistoryScreen(),
// )
// */










import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:provider/provider.dart';

import '../../../widget/empty/bookingHistoryEmptyScreen.dart';
import '../../corporateBookings/model/corporate_booking_history_model.dart';
import '../../corporateBookings/pro/corporate_booking_history_provider.dart';
import '../../corporateBookings/ui/corporate_booking_detail_screen.dart';
import '../provider/bookingHistoryPro.dart';


class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  int selectedTab = 0; // 0 = Normal, 1 = Corporate

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Normal bookings
      Provider.of<BookingHistoryProvider>(context, listen: false)
          .fetchBookings(context);

      // Corporate bookings
      context.read<CorporateBookingHistoryProvider>().fetchBookingsHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Booking History"),
      body: Column(
        children: [
          // ================= CUSTOM TAB BAR =================
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ColorResource.primaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTab == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selectedTab == 0
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Normal Booking",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: selectedTab == 0
                                ? Colors.black87
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTab == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selectedTab == 1
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Corporate",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: selectedTab == 1
                                ? Colors.black87
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= TAB CONTENT =================
          Expanded(
            child: selectedTab == 0
                ? _buildNormalBookingTab()
                : _buildCorporateBookingTab(),
          ),
        ],
      ),
    );
  }

  // ================= NORMAL BOOKING TAB =================
  Widget _buildNormalBookingTab() {
    return Consumer<BookingHistoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = provider.bookingModel?.data ?? [];

        if (list.isEmpty) {
          return BookingHistoryEmptyScreen(
            onRefresh: () {
              Provider.of<BookingHistoryProvider>(context, listen: false)
                  .fetchBookings(context);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            Provider.of<BookingHistoryProvider>(context, listen: false)
                .fetchBookings(context);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              final rawDate = item.scheduledAtIST;

              String formattedDate = "4 Sep 2024";
              String formattedTime = "08:30 PM";

              DateTime? parsedDate;

              if (rawDate != null && rawDate.isNotEmpty) {
                try {
                  parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(rawDate);
                  formattedDate = DateFormat('d MMM yyyy').format(parsedDate);
                  formattedTime = DateFormat('hh:mm a').format(parsedDate);
                } catch (e) {
                  debugPrint("Date parsing error: $e");
                }
              }

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
                            horizontal: 10,
                            vertical: 4,
                          ),
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
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Pickup
                    Row(
                      children: [
                        const Icon(
                          Icons.radio_button_checked,
                          size: 14,
                          color: Colors.green,
                        ),
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
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.red,
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$formattedDate $formattedTime",
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
          ),
        );
      },
    );
  }

  // ================= CORPORATE BOOKING TAB =================
  Widget _buildCorporateBookingTab() {
    return Consumer<CorporateBookingHistoryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final response = provider.corporateBookingHistoryResponse;
        final bookings = response?.data ?? [];

        // Error + empty
        if (provider.errorMessage != null && bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchBookingsHistory(context),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (bookings.isEmpty) {
          return const Center(
            child: Text(
              'No corporate bookings found',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          );
        }

        // List
        return RefreshIndicator(
          onRefresh: () => provider.fetchBookingsHistory(context),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildCorporateBookingCard(booking);
            },
          ),
        );
      },
    );
  }

  Widget _buildCorporateBookingCard(CorporateBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.02),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CorporateBookingDetailScreen(
                bookingId: booking.id ?? '',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #${booking.bookingNumber ?? ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(booking.overallStatus ?? '').withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (booking.overallStatus ?? '')
                          .replaceAll('_', ' ')
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(booking.overallStatus ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Guest
              if (booking.guestDetail?.name != null)
                _infoRow(Icons.person, booking.guestDetail!.name!),

              // Corporate
              if (booking.corporate?.companyName != null)
                _infoRow(Icons.business, booking.corporate!.companyName!),

              // Scheduled Date
              if (booking.scheduledAtIST != null)
                _infoRow(Icons.calendar_today, booking.scheduledAtIST!),

              // Pickup
              if (booking.pickup?.address != null)
                _infoRow(Icons.my_location, booking.pickup!.address!, maxLines: 1),

              // Dropoff
              if (booking.dropoff?.address != null)
                _infoRow(Icons.location_on, booking.dropoff!.address!, maxLines: 1),

              // Vehicle
              if (booking.vehicle != null)
                _infoRow(
                  Icons.directions_car,
                  '${booking.vehicle!.brand ?? ''} (${booking.vehicle!.carNumber ?? ''})',
                ),

              // Trip Type + Distance
              if (booking.tripType != null || booking.actual?.distanceKm != null)
                _infoRow(
                  Icons.route,
                  [
                    if (booking.tripType != null) booking.tripType!,
                    if (booking.actual?.distanceKm != null)
                      '${booking.actual!.distanceKm} km',
                  ].join(' • '),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {int maxLines = 2}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'driver_assigned':
      case 'assigned':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.teal;
      case 'ongoing':
      case 'started':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}