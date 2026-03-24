import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';

class PenaltyScreen extends StatelessWidget {
  const PenaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> penalties = [
      {
        "title": "Late Pickup",
        "amount": 50,
        "date": "12 Mar 2026",
        "status": "Pending"
      },
      {
        "title": "Ride Cancelled",
        "amount": 100,
        "date": "10 Mar 2026",
        "status": "Paid"
      },
      {
        "title": "Customer Complaint",
        "amount": 200,
        "date": "08 Mar 2026",
        "status": "Pending"
      },
    ];

    int totalPenalty = penalties
        .where((e) => e['status'] == "Pending")
        .fold<int>(0, (sum, item) => sum + (item['amount'] as int));

    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.grey.shade100,
      appBar: CommonAppBar(title: "Penalty Details"),
      // appBar: AppBar(
      //   title: const Text("Penalty Details"),
      //   backgroundColor: Colors.green,
      // ),

      body: Column(
        children: [

          /// 🔥 TOP CARD (TOTAL PENALTY)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.orange],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Pending Penalty",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "₹$totalPenalty",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// 📋 LIST
          Expanded(
            child: ListView.builder(
              itemCount: penalties.length,
              itemBuilder: (context, index) {
                final item = penalties[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      /// ICON
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: item['status'] == "Pending"
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: item['status'] == "Pending"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['date'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// AMOUNT + STATUS
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${item['amount']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['status'],
                            style: TextStyle(
                              color: item['status'] == "Pending"
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      /// 🔥 PAY BUTTON
      bottomNavigationBar: totalPenalty > 0
          ? Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorResource.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Redirect to Payment")),
            );
          },
          child: Text(
            "Pay ₹$totalPenalty Now",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      )
          : null,
    );
  }
}