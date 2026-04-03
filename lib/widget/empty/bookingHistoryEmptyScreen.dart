import 'package:flutter/material.dart';

class BookingHistoryEmptyScreen extends StatelessWidget {
  final VoidCallback? onRefresh;

  const BookingHistoryEmptyScreen({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🚗 Gradient Icon
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF050660),
                    Color(0xFF0A0F8A),
                  ],
                ),
              ),
              child: const Icon(
                Icons.local_taxi_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            /// 📌 Title
            const Text(
              "No Trips Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF050660),
              ),
            ),

            const SizedBox(height: 8),

            /// 📄 Subtitle
            Text(
              "You haven't completed any rides yet.\nStart accepting bookings to see your trip history here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            /// 🔘 Buttons Row
            Row(
              children: [

                /// Refresh Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRefresh,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF050660)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(
                        color: Color(0xFF050660),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // const SizedBox(width: 12),

                /// Go Online Button

              ],
            )
          ],
        ),
      ),
    );
  }
}