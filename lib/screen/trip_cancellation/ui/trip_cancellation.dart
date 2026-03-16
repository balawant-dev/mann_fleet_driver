import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';

class TripCancellationScreen extends StatefulWidget {
  const TripCancellationScreen({super.key});

  @override
  State<TripCancellationScreen> createState() => _TripCancellationScreenState();
}

class _TripCancellationScreenState extends State<TripCancellationScreen> {

  String? selectedReason;
  TextEditingController reviewController = TextEditingController();

  List<String> reasons = [
    "Vehicle Issue / Breakdown",
    "Personal Emergency",
    "Passenger Not around / No Show",
    "Heavy Traffic / Road Closure",
    "Other"
  ];

  Widget reasonTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        color: Colors.white,
      ),
      child: RadioListTile(
        value: title,
        groupValue: selectedReason,
        onChanged: (value) {
          setState(() {
            selectedReason = value.toString();
          });
        },
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        activeColor: Colors.blue,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: const CommonAppBar(
        title: 'Trip Cancellation',
        isBack: true,
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: CommonAppButton(
          text: 'Confirm Cancellation',
          onPressed: () {
            print(selectedReason);
            print(reviewController.text);
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Column(
                children: [

                  /// BOOKING ID + DATE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("BOOKING ID",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text("#BO045681021",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorResource.indigo,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("DATE & TIME",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text("04 Sep 2024, 08:30 PM",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// PICKUP
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// DOTS
                      Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle),
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle),
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      /// LOCATION
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PICKUP",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("Sector- 63, Noida",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),

                            SizedBox(height: 14),

                            Text("DROPOFF",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("Nainital, Uttarakhand",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )
                    ],
                  ),

                  const Divider(height: 30),

                  /// PASSENGER + FARE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [

                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 20, color: ColorResource.indigo),
                          SizedBox(width: 6),
                          Text("4-Pax, 2 Bags",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("FARE ESTIMATE",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey)),
                          SizedBox(height: 4),
                          Text("₹4,250",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Reason for Cancellation",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  /// RADIO OPTIONS
                  ...reasons.map((e) => reasonTile(e)).toList(),

                  const SizedBox(height: 10),

                  /// REVIEW BOX
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: reviewController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Write Review",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// WARNING BOX
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFFFF7ED),
                      border: Border.all(color: const Color(0xFFFCD34D)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orange),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            "Cancelling frequently may affect your driver rating and eligibility for future premium bookings.\n\n"
                                "बार-बार बुकिंग रद्द करने से आपकी ड्राइवर रेटिंग प्रभावित हो सकती है और भविष्य में प्रीमियम बुकिंग के लिए आपकी पात्रता भी प्रभावित हो सकती है",
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}