// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import '../pro/corporate_booking_provider.dart';
//
// import 'corporate_booking_detail_screen.dart';
//
// class CorporateBookingListScreen extends StatefulWidget {
//   const CorporateBookingListScreen({super.key});
//
//   @override
//   State<CorporateBookingListScreen> createState() =>
//       _CorporateBookingListScreenState();
// }
//
// class _CorporateBookingListScreenState
//     extends State<CorporateBookingListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<CorporateBookingProvider>().fetchBookings(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Corporate Bookings'),
//         centerTitle: true,
//       ),
//       body: Consumer<CorporateBookingProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.errorMessage != null && provider.bookings.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(provider.errorMessage!),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => provider.fetchBookings(context),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (provider.bookings.isEmpty) {
//             return const Center(child: Text('No corporate bookings found'));
//           }
//
//           return RefreshIndicator(
//             onRefresh: () => provider.fetchBookings(context),
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: provider.bookings.length,
//               itemBuilder: (context, index) {
//                 final booking = provider.bookings[index];
//                 return _BookingCard(
//                   booking: booking,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => CorporateBookingDetailScreen(
//                           bookingId: booking.id,
//                         ),
//                       ),
//                     );
//                   },
//                   onAccept: () async {
//                     // Inside onAccept / Accept button
//                     final position = await Geolocator.getCurrentPosition(
//                       desiredAccuracy: LocationAccuracy.high,
//                     );
//
//                     final success = await provider.acceptBooking(
//                       context: context,
//                       bookingId: booking.id,
//                       currentLat: position.latitude,
//                       currentLng: position.longitude,
//                     );
//
//                     if (success && context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Booking Accepted')),
//                       );
//                     }
//                   //   final success =
//                   //   await provider.acceptBooking(context, booking.id);
//                   //   if (success && context.mounted) {
//                   //     ScaffoldMessenger.of(context).showSnackBar(
//                   //       const SnackBar(content: Text('Booking Accepted')),
//                   //     );
//                   //   }
//                   },
//                   onReject: () async {
//                     final success =
//                     await provider.rejectBooking(context, booking.id);
//                     if (success && context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Booking Rejected')),
//                       );
//                     }
//                   },
//                   isResponding: provider.isResponding,
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
// class _BookingCard extends StatelessWidget {
//   final dynamic booking;
//   final VoidCallback onTap;
//   final VoidCallback onAccept;
//   final VoidCallback onReject;
//   final bool isResponding;
//
//   const _BookingCard({
//     required this.booking,
//     required this.onTap,
//     required this.onAccept,
//     required this.onReject,
//     required this.isResponding,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isPending = booking.driverResponse.status == 'pending';
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Booking #${booking.bookingNumber}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _statusColor(booking.overallStatus)
//                           .withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       booking.overallStatus.replaceAll('_', ' ').toUpperCase(),
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: _statusColor(booking.overallStatus),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//
//               // Guest
//               _infoRow(Icons.person, booking.guestDetail.name),
//               _infoRow(Icons.business, booking.corporate.companyName),
//               _infoRow(Icons.calendar_today, booking.scheduledAtIST),
//               _infoRow(Icons.location_on, booking.pickup.address,
//                   maxLines: 1),
//               _infoRow(Icons.flag, booking.dropoff.address, maxLines: 1),
//               _infoRow(
//                 Icons.directions_car,
//                 '${booking.vehicle.brand} ${booking.vehicle.model} (${booking.vehicle.carNumber})',
//               ),
//
//               if (isPending) ...[
//                 const SizedBox(height: 14),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: isResponding ? null : onAccept,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: isResponding
//                             ? const SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Text('Accept'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: isResponding ? null : onReject,
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.red,
//                           side: const BorderSide(color: Colors.red),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('Reject'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(IconData icon, String text, {int maxLines = 2}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               maxLines: maxLines,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 13),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _statusColor(String status) {
//     switch (status) {
//       case 'driver_assigned':
//         return Colors.blue;
//       case 'accepted':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       case 'completed':
//         return Colors.teal;
//       default:
//         return Colors.orange;
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widget/commonAppBar.dart';
import '../pro/corporate_booking_provider.dart';
import 'corporate_booking_detail_screen.dart';

class CorporateBookingListScreen extends StatefulWidget {
  const CorporateBookingListScreen({super.key});

  @override
  State<CorporateBookingListScreen> createState() =>
      _CorporateBookingListScreenState();
}

class _CorporateBookingListScreenState
    extends State<CorporateBookingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CorporateBookingProvider>().fetchBookings(context);
    });
  }

  // Location Permissions Handling Method
  Future<Position?> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable GPS / Location Services.'),
          ),
        );
      }
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied. Please enable them from settings.',
            ),
          ),
        );
      }
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: 'Corporate Bookings'),
      // appBar: AppBar(
      //   title: const Text('Corporate Bookings'),
      //   centerTitle: true,
      // ),
      body: Consumer<CorporateBookingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchBookings(context),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.bookings.isEmpty) {
            return const Center(
              child: Text(
                'No corporate bookings found',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchBookings(context),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: provider.bookings.length,
              itemBuilder: (context, index) {
                final booking = provider.bookings[index];
                return _BookingCard(
                  booking: booking,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CorporateBookingDetailScreen(
                          bookingId: booking.id,
                        ),
                      ),
                    );
                  },
                  onAccept: () async {
                    final position = await _determinePosition(context);
                    if (position == null) return;

                    if (!context.mounted) return;

                    final success = await provider.acceptBooking(
                      context: context,
                      bookingId: booking.id,
                      currentLat: position.latitude,
                      currentLng: position.longitude,
                    );

                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking Accepted Successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  onReject: () async {
                    final success = await provider.rejectBooking(
                      context,
                      booking.id,
                    );

                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking Rejected'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  isResponding: provider.isResponding,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final dynamic booking;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isResponding;

  const _BookingCard({
    required this.booking,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
    required this.isResponding,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = booking.driverResponse?.status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Pure white background
        borderRadius: BorderRadius.circular(16), // Smooth rounded corners
        border: Border.all(
          color: Colors.grey.shade100, // Very subtle border for crisp depth
          width: 1,
        ),
        boxShadow: [
          // 1. Primary ambient soft blur shadow
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10), // Downward soft glow
          ),
          // 2. Secondary subtle directional shadow
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.02),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(booking.overallStatus ?? '')
                          .withOpacity(0.15),
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

              // Booking Info Rows
              if (booking.guestDetail?.name != null)
                _infoRow(Icons.person, booking.guestDetail.name),
              if (booking.corporate?.companyName != null)
                _infoRow(Icons.business, booking.corporate.companyName),
              if (booking.scheduledAtIST != null)
                _infoRow(Icons.calendar_today, booking.scheduledAtIST),
              if (booking.pickup?.lat != null && booking.pickup?.lng != null)
                GestureDetector(
                  onTap: () {
                    _openMapsNavigation(
                      destLat: booking.pickup!.lat!.toDouble(),
                      destLng: booking.pickup!.lng!.toDouble(),
                      label: booking.pickup?.address,
                    );
                  },
                  child: _infoRow(Icons.my_location, booking.pickup.address,
                      maxLines: 1),
                ),

              if (booking.dropoff?.lat != null && booking.dropoff?.lng != null)
                GestureDetector(
                  onTap: () {
                    _openMapsNavigation(
                      destLat: booking.dropoff!.lat!.toDouble(),
                      destLng: booking.dropoff!.lng!.toDouble(),
                      label: booking.dropoff?.address,
                    );
                  },
                  child: _infoRow(Icons.location_on, booking.dropoff.address,
                      maxLines: 1),
                ),
              if (booking.vehicle != null)
                _infoRow(
                  Icons.directions_car,
                  '${booking.vehicle.brand ?? ''} ${booking.vehicle.model ?? ''} (${booking.vehicle.carNumber ?? ''})',
                ),

              // Action Buttons
              if (isPending) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isResponding ? null : onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isResponding
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Accept',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isResponding ? null : onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _openMapsNavigation({
    required double destLat,
    required double destLng,
    String? label,
  }) async {
    // Google Maps navigation URL (from current location → destination)
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
          '&destination=$destLat,$destLng'
          '${label != null ? '&destination_place_id=&travelmode=driving' : ''}'
          '&travelmode=driving',
    );

    // Alternative (works well on both Android & iOS):
    // final uri = Uri.parse('google.navigation:q=$destLat,$destLng&mode=d');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback
      final fallback = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destLat,$destLng',
      );
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
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
    switch (status) {
      case 'driver_assigned':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.teal;
      default:
        return Colors.orange;
    }
  }
}