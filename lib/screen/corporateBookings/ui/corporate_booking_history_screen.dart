import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/commonAppBar.dart';
import '../model/corporate_booking_history_model.dart';
import '../pro/corporate_booking_history_provider.dart';
import 'corporate_booking_detail_screen.dart'; // agar detail screen hai to

class CorporateBookingHistoryScreen extends StatefulWidget {
  const CorporateBookingHistoryScreen({super.key});

  @override
  State<CorporateBookingHistoryScreen> createState() =>
      _CorporateBookingHistoryScreenState();
}

class _CorporateBookingHistoryScreenState
    extends State<CorporateBookingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CorporateBookingHistoryProvider>().fetchBookingsHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Corporate Bookings History'),
      body: Consumer<CorporateBookingHistoryProvider>(
        builder: (context, provider, _) {
          // Loading
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
                return _buildBookingCard(booking);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(CorporateBooking booking) {
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
          // Detail screen pe jaana ho to uncomment karo
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CorporateBookingDetailScreen( bookingId: booking.id ?? '',),
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

              // Trip Type + Distance (optional extra)
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