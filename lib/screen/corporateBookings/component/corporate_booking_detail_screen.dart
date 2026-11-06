import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/corporateBookings/component/trip_context.dart';
import 'package:mann_fleet_driver/screen/corporateBookings/component/trip_flow_factory.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../pro/corporate_booking_provider.dart';
import 'booking_info_sections.dart';
import 'booking_response_actions.dart';


class CorporateBookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const CorporateBookingDetailScreen({super.key, required this.bookingId});

  @override
  State<CorporateBookingDetailScreen> createState() =>
      _CorporateBookingDetailScreenState();
}

class _CorporateBookingDetailScreenState
    extends State<CorporateBookingDetailScreen> {
  /// Garage address selected by the driver (self billing flows).
  final GarageLocation _garage = GarageLocation();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CorporateBookingProvider>();
      provider.fetchBookingDetail(context, widget.bookingId);
      provider.checkSelfPaymentStatus(
        context: context,
        bookingId: widget.bookingId,
      );
    });
  }

  @override
  void dispose() {
    _garage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CommonAppBar(title: 'Booking Detail'),
      body: Consumer<CorporateBookingProvider>(
        builder: (context, provider, _) {
          if (provider.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.bookingDetail == null) {
            return _LoadErrorView(
              message: provider.errorMessage ?? 'Failed to load details',
              onRetry:
                  () => provider.fetchBookingDetail(context, widget.bookingId),
            );
          }
          return _buildContent(context, provider);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CorporateBookingProvider provider) {
    final d = provider.bookingDetail!;

    final trip = TripContext(
      context: context,
      provider: provider,
      garage: _garage,
      routeBookingId: widget.bookingId,
      bookingId: d.id,
      tripType: d.tripType.toLowerCase(),
      billingType: d.billingType.toLowerCase(),
      status: d.tripStatus,
      startOtpVerified: d.tripStartOtpVerify == true,
      endOtpVerified: d.tripEndOtpVerify == true,
    );
    final flow = TripFlowFactory.forTripType(trip.tripType);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingInfoSections(provider: provider),
          const SizedBox(height: 8),
          if (d.driverResponse.status == 'pending')
            BookingResponseActions(
              hostContext: context,
              provider: provider,
              bookingId: widget.bookingId,
            ),
          if (flow != null) ...flow.build(trip),
        ],
      ),
    );
  }
}

class _LoadErrorView extends StatelessWidget {
  const _LoadErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
