import 'package:flutter/material.dart';

import '../pro/corporate_booking_provider.dart';
import 'detail_widgets.dart';
import 'map_launcher.dart';

/// Read-only cards shown at the top of the booking detail screen.
class BookingInfoSections extends StatelessWidget {
  const BookingInfoSections({super.key, required this.provider});

  final CorporateBookingProvider provider;

  @override
  Widget build(BuildContext context) {
    final d = provider.bookingDetail!;
    final package = d.agreement.packageSnapshot;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionCard(
          title: 'Status',
          children: [
            DetailRow('Overall', d.overallStatus),
            DetailRow('Trip Status', d.tripStatus),
            DetailRow('Billing Type', d.billingType),
            DetailRow('Assignment', d.assignmentStatus),
            DetailRow('Driver Response', d.driverResponse.status),
          ],
        ),
        SectionCard(
          title: 'Booking Info',
          children: [
            DetailRow('Booking No', d.bookingNumber),
            DetailRow('Corporate Booking No', d.corporateBookingNumber),
            DetailRow('Agreement Code', d.agreementCode),
            DetailRow('Trip Type', d.tripType),
            DetailRow('Scheduled At', d.scheduledAtIST),
            DetailRow('Passengers', '${d.numberofPassangers}'),
            DetailRow('Remark', d.bookingRemark.isEmpty ? '-' : d.bookingRemark),
          ],
        ),
        if (d.guestDetail != null)
          SectionCard(
            title: 'Guest Details',
            children: [
              DetailRow('Name', d.guestDetail?.name ?? '-'),
              DetailRow('Email', d.guestDetail?.email ?? '-'),
              DetailRow('Phone', '${d.guestDetail?.phone ?? '-'}'),
            ],
          ),
        if (d.user != null)
          SectionCard(
            title: 'User Details',
            children: [
              DetailRow('Name', d.user?.name ?? '-'),
              DetailRow('Email', d.user?.email ?? '-'),
              DetailRow('Phone', '${d.user?.mobile ?? '-'}'),
            ],
          ),
        SectionCard(
          title: 'Corporate',
          children: [
            DetailRow('Company', d.corporate.companyName),
            DetailRow('Code', d.corporate.companyCode),
            DetailRow('Booker', d.booker.name),
            DetailRow('Booker Mobile', d.booker.mobile),
          ],
        ),
        SectionCard(
          title: 'Vehicle',
          children: [
            DetailRow('Brand', d.vehicle.brand),
            DetailRow('Model', d.vehicle.model),
            DetailRow('Car Number', d.vehicle.carNumber),
          ],
        ),
        SectionCard(
          title: 'Locations',
          children: [
            _locationRow('Pickup', d.pickup?.lat, d.pickup?.lng, d.pickup?.address),
            _locationRow(
              'Dropoff',
              d.dropoff?.lat,
              d.dropoff?.lng,
              d.dropoff?.address,
            ),
          ],
        ),
        if (package.packageName.isNotEmpty)
          SectionCard(
            title: 'Package',
            children: [
              DetailRow('Package Name', package.packageName),
              DetailRow('Hours', '${package.hours}'),
              DetailRow('Included KMs', '${package.includedKms}'),
              DetailRow('Base Fare', '₹${package.baseFare}'),
              DetailRow('Fix Amount', '₹${package.fixAmount}'),
              DetailRow('Extra / Km', '₹${package.extraPerKm}'),
              DetailRow('Driver Charge', '₹${package.driverCharge}'),
            ],
          ),
      ],
    );
  }

  /// Tappable row that opens navigation. Hidden when coordinates are missing.
  Widget _locationRow(String label, num? lat, num? lng, String? address) {
    if (lat == null || lng == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap:
          () => openMapsNavigation(
            destLat: lat.toDouble(),
            destLng: lng.toDouble(),
          ),
      child: DetailRow(label, address ?? 'N/A'),
    );
  }
}
