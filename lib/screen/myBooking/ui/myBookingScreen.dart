import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "My Booking",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/744/744465.png",
              height: 40,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: const Color(0xFFF1F5F9),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// DATE + BOOKING ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 6),
                          Text("4 Sep 2024",  style: TextStyle(
                            color:  Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18),
                          SizedBox(width: 6),
                          Text("08:30 PM",  style: TextStyle(
                            color:  Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "🕘 : B0045681021",
                        style: TextStyle(
                          color: const Color(0xFF1E293B),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "One Way Trip"
                          ,  style: TextStyle(
                          color:  Color(0xFF64748B),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                      )
                    ],
                  )
                ],
              ),

              const Divider(height: 30),

              /// PICKUP + DROP
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Timeline
                  Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 35,
                        color: Colors.grey.shade300,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  /// Locations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Sector- 63, Noida",
                          style: TextStyle(
                            color: const Color(0xFF1E293B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Nainital, Uttarakhand",
                          style: TextStyle(
                            color: const Color(0xFF1E293B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: const [
                      Icon(Icons.phone, color: Colors.grey),
                      SizedBox(width: 10),
                      Icon(Icons.share, color: Colors.grey),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// PARKING TOLL TAX
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _infoBox("Parking", "Extra"),
                    _divider(),
                    _infoBox("Toll", "Included"),
                    _divider(),
                    _infoBox("Tax", "Included"),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// NOTE
              const Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.red),
                  SizedBox(width: 6),
                  Text(
                    "There should be carrier.",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// KM SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Text(
                        "10",
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.56,
                          letterSpacing: 0.90,
                        ),
                      ),
                      Text("Total KM",style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),)
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "2",
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.56,
                          letterSpacing: 0.90,
                        ),
                      ),
                      Text("Extra per Km",
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),)
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// CAB DETAILS
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "CNG CAB",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Dzire, Etios, Aura, Glanza Similar [AC] 4+1 "
                          "[Included 4-Pax 2 Trolly+2 Hand Bags]",
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 25),

              /// REPORT BUTTON
              Container(
                height: 50,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Reporting to client",
                  style: TextStyle(
                    color: const Color(0xFF475569),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
              ),

              const SizedBox(height: 15),
              CommonAppButton(text:  "End the trip", onPressed: (){})

              /// END TRIP BUTTON

            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 45,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _infoBox(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(title,  style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),),
            const SizedBox(height: 4),
            Text(value,      style: TextStyle(
              color: const Color(0xFF334155),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),)
          ],
        ),
      ),
    );
  }
}