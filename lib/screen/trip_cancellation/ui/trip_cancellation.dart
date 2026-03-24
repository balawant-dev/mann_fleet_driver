import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';

class TripCancellationScreen extends StatefulWidget {
  final String bookingId;
  final String? pickupAddress;
  final String? dropoffAddress;
  final String? bookingDateTime;
  final String? fareEstimate;
  final String? passengerInfo;

  const TripCancellationScreen({
    super.key,
    required this.bookingId,
    this.pickupAddress,
    this.dropoffAddress,
    this.bookingDateTime,
    this.fareEstimate,
    this.passengerInfo,
  });

  @override
  State<TripCancellationScreen> createState() => _TripCancellationScreenState();
}

class _TripCancellationScreenState extends State<TripCancellationScreen> {
  String? selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  final List<String> reasons = [
    "Vehicle Issue / Breakdown",
    "Personal Emergency",
    "Passenger Not around / No Show",
    "Heavy Traffic / Road Closure",
    "Other",
  ];

  bool get _canSubmit => selectedReason != null;

  @override
  void dispose() {
    _otherReasonController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Widget _reasonTile(String title) {
    final isSelected = selectedReason == title;
    final isOther = title == "Other";

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReason = title;
          if (!isOther) _otherReasonController.clear();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorResource.indigo : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
          color: Colors.white,
        ),
        child: RadioListTile<String>(
          value: title,
          groupValue: selectedReason,
          onChanged: null, // Handled by GestureDetector
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? ColorResource.indigo : Colors.black87,
            ),
          ),
          activeColor: ColorResource.indigo,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CommonAppBar(
        title: 'Cancel Trip',
        isBack: true,
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: CommonAppButton(
          text: 'Confirm Cancellation',
          // enabled: _canSubmit,
          onPressed: _canSubmit
              ? () {
            final reason = selectedReason == "Other"
                ? _otherReasonController.text.trim()
                : selectedReason;

            if (reason == null || reason.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select or enter a reason")),
              );
              return;
            }

            // TODO: Call cancel API here
            // Example:
            // context.read<NewBookingProvider>().driverCancelApi(
            //   context: context,
            //   id: widget.bookingId,
            //   reason: reason + (review.isNotEmpty ? " - $review" : ""),
            // );

            print("Cancelling booking ${widget.bookingId}");
            print("Reason: $reason");
            print("Additional note: ${_reviewController.text.trim()}");

            // For demo: pop with success
            Navigator.pop(context, true);
          }
              : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0C000000), blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("BOOKING ID", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              "#${widget.bookingId}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorResource.indigo,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("DATE & TIME", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              widget.bookingDateTime ?? "—",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children:  [
                            Icon(Icons.circle, size: 12, color: Colors.orange),
                            SizedBox(height: 28, child: VerticalDivider(color: Colors.grey.shade300, thickness: 2)),
                            Icon(Icons.circle, size: 12, color: Colors.red),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("PICKUP", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(widget.pickupAddress ?? "—", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 16),
                              const Text("DROPOFF", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(widget.dropoffAddress ?? "—", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people_alt_outlined, size: 20, color: ColorResource.indigo),
                            const SizedBox(width: 8),
                            Text(widget.passengerInfo ?? "—", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("EST. FARE", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                              widget.fareEstimate ?? "—",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text("Reason for Cancellation", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              ...reasons.map(_reasonTile),

              if (selectedReason == "Other") ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otherReasonController,
                  decoration: InputDecoration(
                    hintText: "Please specify the reason...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              TextField(
                controller: _reviewController,
                maxLines: 4,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: "Additional comments (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Frequent cancellations may lower your driver rating and affect eligibility for premium/priority rides in the future.\n\n"
                            "बार-बार रद्द करने से आपकी रेटिंग कम हो सकती है और प्रीमियम बुकिंग्स में प्राथमिकता प्रभावित हो सकती है।",
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }
}