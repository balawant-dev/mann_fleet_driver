import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

import '../../../util/color/app_colors.dart';
import '../../../widget/commonAppBar.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../home_screen/provider/newBookingProvider.dart';
import '../../pickup/ui/pickUpScreen.dart';

import 'package:provider/provider.dart';

import 'mapRedirection.dart';

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
    });
    _getCurrentLocation();}

  Future<void> _onRefresh() async {
    await context.read<NewBookingProvider>().getNewBookingDetail(
      context: context,
      id: widget.id,
    );
  }
  double currentLat = 0.0;
  double currentLng = 0.0;
  Future<void> _completeTripAfterEndOtp(String bookingId) async {
    final provider = context.read<NewBookingProvider>();

    // Get current location
    bool hasLocation = await _getCurrentLocation();

    if (!hasLocation) {
      ToastHelper.show(context,
          message: "Unable to get current location",
          type: ToastType.error);
      return;
    }

    bool tripCompleted = await provider.completeTripApi(
      context: context,
      id: bookingId,
      currentLat: currentLat.toString(),
      currentLng: currentLng.toString(),
    );

    if (tripCompleted) {
      ToastHelper.show(
        context,
        message: "Trip Completed Successfully 🎉",
        type: ToastType.success,
      );

      // Refresh detail
      await provider.getNewBookingDetail(context: context, id: bookingId);
    }
  }
  Future<bool> _getCurrentLocation() async {
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        ToastHelper.show(
          context,
          message: "Location permission permanently denied. Please enable from settings.",
          type: ToastType.error,
        );
        return false;
      }

      if (permission == LocationPermission.denied) {
        ToastHelper.show(
          context,
          message: "Location permission denied",
          type: ToastType.error,
        );
        return false;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLng = position.longitude;

      debugPrint("📍 Current Location: $currentLat, $currentLng");
      return true;
    } catch (e) {
      debugPrint("Location error: $e");
      ToastHelper.show(
        context,
        message: "Failed to get location: ${e.toString()}",
        type: ToastType.error,
      );
      return false;
    }
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

        final rawDate = data?.createdAt; // "2026-05-15T09:44:03.278Z"

        String formattedDate = "4 Sep 2024"; // Default fallback
        String formattedTime = "08:30 PM";   // Default fallback

        if (rawDate != null) {
          try {
            // String ko DateTime object mein convert karna
            DateTime dateTime = DateTime.parse(rawDate).toLocal();

            // Date alag variable mein: "15 May 2026"
            formattedDate = DateFormat('d MMM yyyy').format(dateTime);

            // Time alag variable mein: "09:44 AM" (ya PM)
            formattedTime = DateFormat('hh:mm a').format(dateTime);
          } catch (e) {
            debugPrint("Date parsing error: $e");
          }
        }
        final bookingId = data?.bookingNumber ?? "B0045681021";
        final tripType = data?.bookingType ?? "One Way Trip";

        final pickup = data?.pickup?.address ?? "Sector- 63, Noida";
        final drop = data?.dropoff?.address ?? "Nainital, Uttarakhand";
        print("pickup lat${data?.pickup?.lat} pickup lng${data?.pickup?.lng} drop lat${data?.dropoff?.lat} dropoff lng${data?.dropoff?.lng}");


        final totalKm = data?.estimatedKm?? 0;
        final extraKm = data?.pricingSnapshot?.perKmRate?.toInt() ?? 2;

        final cabType =  "CNG CAB";
        // final cabType = data?.vehicle?.fuelType ?? "CNG CAB";
        final model =
            "${data?.vehicle?.model ?? "Dzire"} "; final color =
            "${data?.vehicle?.color ?? "White"}";

        return Scaffold(
          backgroundColor:  Colors.white,
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
                  color: const Color(0xFFF8FAFC),        // ← Changed: Soft elegant background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),      // ← Changed: Cleaner border
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),           // ← Softer shadow
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
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
                                Text(formattedDate),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 6),
                                Text(formattedTime),
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
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),

                            Container(
                              height: 60,
                              width: 2,
                              color: Colors.grey,
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

                        /// address section
                        Expanded(
                          child: Column(
                            children: [

                              /// pickup row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    child: Text(
                                      pickup,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  GestureDetector(
                                    onTap: () async {
                                      final pLat = data?.pickup?.lat;
                                      final pLng = data?.pickup?.lng;

                                      if (pLat != null && pLng != null) {
                                        await openMapNavigation(
                                          destLat: double.parse(pLat.toString()),
                                          destLng: double.parse(pLng.toString()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Pickup location missing!"),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        "assets/icon/directions.png",
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              /// drop row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    child: Text(
                                      drop,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  GestureDetector(
                                    onTap: () async {
                                      final dLat = data?.dropoff?.lat;
                                      final dLng = data?.dropoff?.lng;

                                      if (dLat != null && dLng != null) {
                                        await openMapNavigation(
                                          destLat: double.parse(dLat.toString()),
                                          destLng: double.parse(dLng.toString()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Drop location missing!"),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        "assets/icon/directions.png",
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //
                    //     /// timeline
                    //     Column(
                    //       children: [
                    //         Container(
                    //           width: 10,
                    //           height: 10,
                    //           decoration: const BoxDecoration(
                    //               color: Colors.orange, shape: BoxShape.circle),
                    //         ),
                    //         Container(height: 60, width: 2, color: Colors.grey),
                    //         Container(
                    //           width: 10,
                    //           height: 10,
                    //           decoration: const BoxDecoration(
                    //               color: Colors.red, shape: BoxShape.circle),
                    //         ),
                    //       ],
                    //     ),
                    //
                    //     const SizedBox(width: 10),
                    //
                    //
                    //
                    //     /// address
                    //     Expanded(
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           final pLat = data?.pickup?.lat;
                    //           final pLng = data?.pickup?.lng;
                    //           final dLat = data?.dropoff?.lat;
                    //           final dLng = data?.dropoff?.lng;
                    //
                    //           print("Redirecting to Map: $pLat, $pLng to $dLat, $dLng");
                    //
                    //           if (pLat != null && pLng != null && dLat != null && dLng != null) {
                    //             openMap(
                    //                 double.parse(pLat.toString()),
                    //                 double.parse(pLng.toString()),
                    //                 double.parse(dLat.toString()),
                    //                 double.parse(dLng.toString())
                    //             );
                    //           } else {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(content: Text("Location coordinates missing!")),
                    //             );
                    //           }
                    //         },
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(pickup,
                    //                 style:
                    //                 const TextStyle(fontWeight: FontWeight.w500)),
                    //             const SizedBox(height: 20),
                    //             Text(drop,
                    //                 style:
                    //                 const TextStyle(fontWeight: FontWeight.w500)),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //         onTap: () {
                    //           final pLat = data?.pickup?.lat;
                    //           final pLng = data?.pickup?.lng;
                    //           final dLat = data?.dropoff?.lat;
                    //           final dLng = data?.dropoff?.lng;
                    //
                    //           print("Redirecting to Map: $pLat, $pLng to $dLat, $dLng");
                    //
                    //           if (pLat != null && pLng != null && dLat != null && dLng != null) {
                    //             openMap(
                    //                 double.parse(pLat.toString()),
                    //                 double.parse(pLng.toString()),
                    //                 double.parse(dLat.toString()),
                    //                 double.parse(dLng.toString())
                    //             );
                    //           } else {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(content: Text("Location coordinates missing!")),
                    //             );
                    //           }
                    //         },
                    //         child: Image.asset("assets/icon/directions.png",height: 30,)),
                    //   ],
                    // ),

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
                    const Divider(),

                    /// Vehicle Model
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Vehicle Model", size: 14, color: ColorResource.grayText),
                        CustomText(model, size: 14, color: ColorResource.black),
                      ],
                    ),    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Color", size: 14, color: ColorResource.grayText),
                        CustomText(color, size: 14, color: ColorResource.black),
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
                    const SizedBox(height: 25),
                    // CommonAppButton(
                    //   text: "End the trip",
                    //   onPressed: ()async {
                    //     await _completeTripAfterEndOtp(bookingId);
                    //   },
                    // ),
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
            ToastHelper.show(
              context,
              message:"Trip Started 🚗",
              type: ToastType.success,
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Trip Started 🚗")),
            // );
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
    if (tripStatus == "in_progress" && isEndOtpVerified) {
      print("Booking complte Kro ab ok");
      print(tripStatus);
      return CommonAppButton(
        text: "Complete Trip",
          onPressed: ()async {
            showLoader(context);
            await _completeTripAfterEndOtp(widget.id);
            navPop(context: context);
          },
        // onPressed: () => showOtpDialog(widget.id, "end"),
      );
    }
    if (tripStatus == "completed" && isEndOtpVerified) {
      print("Booking complte ho gya");
      print(tripStatus);
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
                  ToastHelper.show(
                    context,
                    message:"OTP Verified ($type) ✅",
                    type: ToastType.success,
                  );
                  // 🔥🔥🔥 MAIN CHANGE - End OTP ke baad Complete Trip API call
                  // if (type == "end") {
                  //   await _completeTripAfterEndOtp(bookingId);
                  // }
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("OTP Verified ($type) ✅")),
                  // );
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