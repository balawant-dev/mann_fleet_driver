import 'package:flutter/material.dart';

import '../ui/addAddressScreen.dart';
import 'trip_context.dart';

/// "Garage Address *" label + tappable field. Writes into [garage].
class GarageAddressPicker extends StatelessWidget {
  const GarageAddressPicker({super.key, required this.garage});

  final GarageLocation garage;

  Future<void> _pickAddress(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressScreen()),
    );

    if (result is Map<String, dynamic>) {
      garage.select(
        lat: (result['lat'] as num?)?.toDouble(),
        lng: (result['lng'] as num?)?.toDouble(),
        address: result['address'] as String?,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: garage,
      builder: (context, _) {
        final address = garage.address;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Garage Address *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickAddress(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.red,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        address ?? 'Select Garage Address',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              address == null
                                  ? Colors.grey.shade500
                                  : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
