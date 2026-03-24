import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

import '../../../widget/commonAppBar.dart';
import '../../home_screen/provider/newBookingProvider.dart';
import '../../pickup/ui/pickUpScreen.dart';

import 'package:provider/provider.dart';

class BookingDetailScreen extends StatefulWidget {
  final String id;
  const BookingDetailScreen({super.key,required this.id});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NewBookingProvider>()
          .getNewBookingDetail(context: context, id: widget.id);
    });}

  Future<void> _onRefresh() async {
    await context.read<NewBookingProvider>().getNewBookingDetail(
      context: context,
      id: widget.id,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<NewBookingProvider>(
      builder: (context, provider, child) {

        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = provider.bookingDetailModel?.data;

        /// 🔥 FALLBACKS
        final date = "4 Sep 2024";
        final time = "08:30 PM";
        final bookingId = data?.bookingNumber ?? "B0045681021";
        final tripType = data?.bookingType ?? "One Way Trip";

        final pickup = data?.pickup?.address ?? "Sector- 63, Noida";
        final drop = data?.dropoff?.address ?? "Nainital, Uttarakhand";

        final totalKm = data?.estimatedFare?.toInt() ?? 10;
        final extraKm = data?.pricingSnapshot?.perKmRate?.toInt() ?? 2;

        final cabType =  "CNG CAB";
        // final cabType = data?.vehicle?.fuelType ?? "CNG CAB";
        final carInfo =
            "${data?.vehicle?.model ?? "Dzire"} , ${data?.vehicle?.color ?? "White"}";

        return Scaffold(
          backgroundColor: const Color(0xffF3F5F7),
          appBar: CommonAppBar(title: "Booking Detail",),
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   leading: const Icon(Icons.arrow_back, color: Colors.black),
          //   centerTitle: true,
          //   title: const Text("My Booking",
          //       style: TextStyle(color: Colors.black)),
          // ),

          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// 🔹 DATE + BOOKING ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 6),
                                Text(date),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 6),
                                Text(time),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("🕘 : $bookingId",
                                style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                            Text(tripType),
                          ],
                        )
                      ],
                    ),

                    const Divider(height: 30),

                    /// 🔹 PICKUP & DROP
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// timeline
                        Column(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.orange, shape: BoxShape.circle),
                            ),
                            Container(height: 35, width: 2, color: Colors.grey),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                            ),
                          ],
                        ),

                        const SizedBox(width: 10),

                        /// address
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pickup,
                                  style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 20),
                              Text(drop,
                                  style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 PARKING / TOLL / TAX
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          _infoBox("Parking", "Extra"),
                          _divider(),
                          _infoBox("Toll",
                              data?.pricingSnapshot != null ? "Included" : "Included"),
                          _divider(),
                          _infoBox("Tax",
                              data?.pricingSnapshot != null ? "Included" : "Included"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 KM
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("$totalKm",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Total KM"),
                          ],
                        ),
                        Column(
                          children: [
                            Text("$extraKm",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Per Km Rate"),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 CAB
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(cabType,
                              style: const TextStyle(color: Colors.green)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(carInfo)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// 🔹 BUTTON
                    buildMainButton(
                      status: data?.driverResponse?.status ?? "",

                      tripStatus: data?.tripStatus ?? "",
                      isStartOtpVerified: data?.tripStartOtpVerify ?? false,
                      isEndOtpVerified: data?.tripEndOtpVerify ?? false,
                      // pickupDone: data?.pickupVerified ?? false, // 👈 backend flag
                      // isStartOtpVerified: true,
                      // isEndOtpVerified:true,
                      // tripStatus: "arrived",

                      pickupDone:  data?.pickupVerification ?? false, // 👈 backend flag

                    ),
                    // CommonAppButton(
                    //   text: "Reporting to client",
                    //   backgroundColor: Colors.blue.shade200,
                    //   textColor: Colors.black,
                    //   onPressed: () {
                    //     navPush(context: context, action: PickupScreen());
                    //   },
                    // ),
                    //
                    const SizedBox(height: 25), CommonAppButton(
                      text: "End the trip",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget buildMainButton({
    required String status,
    required String tripStatus,
    required bool isStartOtpVerified,
    required bool isEndOtpVerified,
    required bool pickupDone,
  }) {
    print(">>>>>>>status>>>>>>>>>>>>>>>>>${status}");
    print(">>>>>>>tripStatus>>>>>>>>>>>>>>>>>${tripStatus}");
    print(">>>>>>>isStartOtpVerified>>>>>>>>>>>>>>>>>${isStartOtpVerified}");
    print(">>>>>>>isEndOtpVerified>>>>>>>>>>>>>>>>>${isEndOtpVerified}");
    print(">>>>>>>pickupDone>>>>>>>>>>>>>>>>>${pickupDone}");

    /// 🔹 1. Pickup Pending
    if (status == "accepted" && !pickupDone) {
      return CommonAppButton(
        text: "Reporting to Client",
        onPressed: () {
          navPush(
            context: context,
            action: PickupScreen(id: widget.id),
          );
        },
      );
    }

    /// 🔹 2. Start OTP
    if (pickupDone && !isStartOtpVerified) {
      return CommonAppButton(
        text: "Verify Start OTP",
        onPressed: () => showOtpDialog(widget.id, "start"),
      );
    }

    /// 🔹 3. Start Ride
    if (tripStatus == "arrived" && isStartOtpVerified) {
      return CommonAppButton(
        text: "Start Ride",
        onPressed: () async {
          bool success = await context
              .read<NewBookingProvider>()
              .startTripApi(
            context: context,
            id: widget.id,
          );

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Trip Started 🚗")),
            );
          }
        },
      );
    }

    /// 🔹 4. End OTP
    if (tripStatus == "in_progress" && !isEndOtpVerified) {
      return CommonAppButton(
        text: "Verify End OTP",
        onPressed: () => showOtpDialog(widget.id, "end"),
      );
    }

    /// 🔹 5. Completed
    if (tripStatus == "completed" || isEndOtpVerified) {
      return const Text("Trip Completed ✅");
    }

    /// 🔹 6. Cancelled
    if (tripStatus == "cancelled") {
      return const Text("Trip Cancelled ❌");
    }

    return const SizedBox();
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
  void showOtpDialog(String bookingId, String type) {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Enter OTP ($type)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              hintText: "Enter 4-digit OTP",
              border: OutlineInputBorder(),
              counterText: "",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await context
                    .read<NewBookingProvider>()
                    .verifyBookingOtpApi(
                  context: context,
                  id: bookingId,
                  otp: otpController.text,
                  type: type, // 🔥 important
                );

                Navigator.pop(context);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("OTP Verified ($type) ✅")),
                  );
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }
}