import 'package:flutter/material.dart';

class NoAssignedBookingScreen extends StatelessWidget {
  final VoidCallback? onRefresh;
  // final VoidCallback? onGoOnline;

  const NoAssignedBookingScreen({
    super.key,
    this.onRefresh,
    // this.onGoOnline,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🚘 Icon (Assignment Style)
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
                  Icons.assignment_turned_in_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              /// 📌 Title
              const Text(
                "No Booking Assigned",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF050660),
                ),
              ),

              const SizedBox(height: 8),

              /// 📄 Subtitle
              Text(
                "You don’t have any active bookings right now.\nStay online to receive new ride requests.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 25),

              /// 🔘 Buttons
              Row(
                children: [

                  /// Refresh
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
                  //
                  // /// Go Online
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: onGoOnline,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF050660),
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "Go Online",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}