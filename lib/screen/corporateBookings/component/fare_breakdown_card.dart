// import 'package:flutter/material.dart';
//
// import '../pro/corporate_booking_provider.dart';
// import 'detail_widgets.dart';
//
// /// Final fare breakdown. Requires `provider.selfFareData != null`.
// class FareBreakdownCard extends StatelessWidget {
//   const FareBreakdownCard({super.key, required this.provider});
//
//   final CorporateBookingProvider provider;
//
//   @override
//   Widget build(BuildContext context) {
//     final data = provider.selfFareData!;
//     final fare = data.fare;
//
//     return SectionCard(
//       title: 'Final Fare Breakdown',
//       children: [
//         DetailRow('Trip Type', data.tripType ?? '-'),
//         DetailRow(
//           'Distance',
//           '${data.distanceKm ?? fare?.totalDistance ?? 0} km',
//         ),
//         DetailRow(
//           'Duration',
//           '${data.durationMins ?? fare?.totalDurationMins ?? 0} mins',
//         ),
//         const Divider(height: 20),
//         _amount('Base Charge', fare?.baseCharge),
//         _amount('Driver Charge', fare?.driverCharge),
//         _amount('Extra Distance Charge', fare?.extraCharge),
//         _amount('Extra Time Charge', fare?.extraTimeCharge),
//         _amount('Night Fare', fare?.nightFare),
//         const Divider(height: 20),
//         _amount('Parking', fare?.parkingCharge),
//         _amount('Toll', fare?.tollAmount),
//         _amount('State Charge', fare?.stateCharge),
//         _amount('Other Charges', fare?.otherCharges),
//         if (fare?.otherChargesDetail.isNotEmpty == true)
//           ...fare!.otherChargesDetail.map(
//             (item) => _amount(item.name, item.amount),
//           ),
//         const Divider(height: 20),
//         _amount(
//           'GST (${formatAmount(fare?.gstPercent)}%)',
//           fare?.gstCharge,
//         ),
//         const SizedBox(height: 10),
//         _PayableAmountBox(
//           amountText: '₹${formatAmount(data.payableAmount ?? fare?.totalAmount)}',
//         ),
//       ],
//     );
//   }
//
//   static Widget _amount(String label, num? value) =>
//       DetailRow(label, '₹${formatAmount(value)}');
// }
//
// class _PayableAmountBox extends StatelessWidget {
//   const _PayableAmountBox({required this.amountText});
//
//   final String amountText;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.green.shade300),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Payable Amount',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//             ),
//           ),
//           Text(
//             amountText,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w800,
//               color: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

import '../pro/corporate_booking_provider.dart';
import 'detail_widgets.dart';

/// Final fare breakdown. Requires `provider.selfFareData != null`.
/// Rows with null / 0 / empty values are hidden.
class FareBreakdownCard extends StatelessWidget {
  const FareBreakdownCard({super.key, required this.provider});

  final CorporateBookingProvider provider;

  @override
  Widget build(BuildContext context) {
    final data = provider.selfFareData!;
    final fare = data.fare;

    // Each section = rows that belong together. Hidden rows are null.
    final List<List<Widget?>> sections = [
      [
        _text('Trip Type', data.tripType),
        _measure('Distance', data.distanceKm ?? fare?.totalDistance, 'km'),
        _measure(
          'Duration',
          data.durationMins ?? fare?.totalDurationMins,
          'mins',
        ),
      ],
      [
        _amount('Base Charge', fare?.baseCharge),
        _amount('Driver Charge', fare?.driverCharge),
        _amount('Extra Distance Charge', fare?.extraCharge),
        _amount('Extra Time Charge', fare?.extraTimeCharge),
        _amount('Night Fare', fare?.nightFare),
      ],
      [
        _amount('Parking', fare?.parkingCharge),
        _amount('Toll', fare?.tollAmount),
        _amount('State Charge', fare?.stateCharge),
        _amount('Other Charges', fare?.otherCharges),
        ...?fare?.otherChargesDetail.map(
              (item) => _amount(item.name, item.amount),
        ),
      ],
      [
        _amount('GST (${formatAmount(fare?.gstPercent)}%)', fare?.gstCharge),
      ],
    ];

    return SectionCard(
      title: 'Final Fare Breakdown',
      children: [
        ..._withDividers(sections),
        const SizedBox(height: 10),
        _PayableAmountBox(
          amountText: '₹${formatAmount(data.payableAmount ?? fare?.totalAmount)}',
        ),
      ],
    );
  }

  /// Removes hidden rows, skips empty sections and puts a divider only
  /// between sections that still have rows.
  static List<Widget> _withDividers(List<List<Widget?>> sections) {
    final result = <Widget>[];
    for (final section in sections) {
      final rows = section.whereType<Widget>().toList();
      if (rows.isEmpty) continue;
      if (result.isNotEmpty) result.add(const Divider(height: 20));
      result.addAll(rows);
    }
    return result;
  }

  /// Hidden (null) when value is null or blank.
  static Widget? _text(String label, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DetailRow(label, value);
  }

  /// "12 km" style row. Hidden when value is null, blank or 0.
  static Widget? _measure(String label, Object? value, String unit) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || num.tryParse(text) == 0) return null;
    return DetailRow(label, '$text $unit');
  }

  /// "₹120" style row. Hidden when value is null or 0.
  static Widget? _amount(String label, num? value) {
    if (value == null || value == 0 || label.trim().isEmpty) return null;
    return DetailRow(label, '₹${formatAmount(value)}');
  }
}

class _PayableAmountBox extends StatelessWidget {
  const _PayableAmountBox({required this.amountText});

  final String amountText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Payable Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(
            amountText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}