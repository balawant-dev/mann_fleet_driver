import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mann_fleet_driver/screen/home_screen/ui/payment_qr_screen.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import '../../../main.dart';
import '../../../util/color/app_colors.dart';
import '../../../util/theame/app_theme.dart';
import '../../../widget/commonAppBar.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../bottomBar/bottomBar.dart';
import '../../home_screen/model/final_fare_preview_model.dart';
import '../../home_screen/provider/newBookingProvider.dart';
import '../../pickup/ui/pickUpScreen.dart';
import 'package:provider/provider.dart';
import '../../sqlite_local_location/local_db_service.dart';
import 'endSpeedoMeterScreen.dart';
import 'mapRedirection.dart';

class BookingDetailScreen extends StatefulWidget {
  final String id;
  const BookingDetailScreen({super.key, required this.id});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read<NewBookingProvider>().getNewBookingDetail(
        context: context,
        id: widget.id,
      );

      await FlutterForegroundTask.startService(
        serviceId: 100,
        notificationTitle: 'Driver Tracking',
        notificationText: 'Location tracking active',
        callback: startCallback,
      );
      //  startLocationUpdates(context: context, bookingId: widget.id);
    });
    _getCurrentLocation();
  }

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
      ToastHelper.show(
        context,
        message: "Unable to get current location",
        type: ToastType.error,
      );
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

      await provider.getNewBookingDetail(context: context, id: bookingId);
      await FlutterForegroundTask.stopService();
    }
  }

  Future<void> _checkFinalFareAfterEndOtp(String bookingId) async {
    final provider = context.read<NewBookingProvider>();
    showLoader(context);
    // Get current location
    bool hasLocation = await _getCurrentLocation();

    if (!hasLocation) {
      ToastHelper.show(
        context,
        message: "Unable to get current location",
        type: ToastType.error,
      );
      return;
    }

    final status = await provider.checkFinalFare(
      context: context,
      id: bookingId,
      currentLat: currentLat.toString(),
      currentLng: currentLng.toString(),
      // currentLat: "28.5292049",
      // currentLng: "77.2747464",
      durationMins: "",
    );
    if (status != null && status.fare.adjustmentType.toLowerCase() == "none") {
      Navigator.pop(context);
      showBookingCompletionDialog(context, false, status);
    } else if (status != null &&
        status.fare.adjustmentType.toLowerCase() != "none") {
      Navigator.pop(context);
      if (!status.isExtraPaymentPending &&
          status.extraPaymentCompleted != null &&
          status.extraPaymentCompleted == true) {
        showOtpDialog(bookingId, "end");
      } else {
        showBookingCompletionDialog(context, true, status);
      }
      // await provider.payFinalFare(
      //   context: context,
      //   id: bookingId,
      //   currentLat: currentLat.toString(),
      //   currentLng: currentLng.toString(),
      //   durationMins: "",
      // );
    }

    // if (tripCompleted) {
    //   ToastHelper.show(
    //     context,
    //     message: "Trip Completed Successfully 🎉",
    //     type: ToastType.success,
    //   );
    //
    //   // Refresh detail
    //   await provider.getNewBookingDetail(context: context, id: bookingId);
    // }
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
          message:
              "Location permission permanently denied. Please enable from settings.",
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

      setState(() {});
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

  Timer? locationTimer;
  StreamSubscription<Position>? _positionStream;
  void startLocationUpdates({
    required BuildContext context,
    required String bookingId,
  }) {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      currentLat = position.latitude;
      currentLng = position.longitude;

      debugPrint("Location Changed => $currentLat, $currentLng");

      await context.read<NewBookingProvider>().updateDriverLocationApi(
        id: bookingId,
        lat: currentLat,
        lng: currentLng,
        context: context,
      );
    });
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
  // void startLocationUpdates({
  //   required BuildContext context,
  //   required String bookingId,
  // }) {
  //   _getCurrentLocation();
  //   String pickupTime= context.read<NewBookingProvider>().bookingDetailModel!.data!.scheduledAtIST.toString();//"2026-06-09 12:11:00",
  //   /// every 10 seconds
  //   locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
  //     await context.read<NewBookingProvider>().updateDriverLocationApi(
  //       id: bookingId,
  //       lng: currentLng ?? 0.0,
  //       lat: currentLat ?? 0.0,
  //       context: context,
  //     );
  //   });
  // }

  // void stopLocationUpdates() {
  //   locationTimer?.cancel();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   stopLocationUpdates();
  // }

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

        final rawDate = data?.scheduledAt; // "2026-05-15T09:44:03.278Z"

        String formattedDate = "4 Sep 2024"; // Default fallback
        String formattedTime = "08:30 PM"; // Default fallback

        if (rawDate != null) {
          try {
            // String ko DateTime object mein convert karna
            DateTime dateTime =
                DateTime.parse(rawDate.toIso8601String()).toLocal();

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
        print(
          "pickup lat${data?.pickup?.lat} pickup lng${data?.pickup?.lng} drop lat${data?.dropoff?.lat} dropoff lng${data?.dropoff?.lng}",
        );

        final totalKm = data?.estimatedKm ?? 0;
        final extraKm = data?.pricingSnapshot?.perKmRate?.toInt() ?? 2;

        final cabType = "CNG CAB";
        // final cabType = data?.vehicle?.fuelType ?? "CNG CAB";
        final model = "${data?.vehicle?.model ?? "Dzire"} ";
        final color = "${data?.vehicle?.color ?? "White"}";

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(title: "Booking Detail"),

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
                  color: const Color(
                    0xFFF8FAFC,
                  ), // ← Changed: Soft elegant background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0), // ← Changed: Cleaner border
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000), // ← Softer shadow
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
                            Text(
                              "🕘 : $bookingId",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(tripType),
                          ],
                        ),
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

                            Container(height: 60, width: 2, color: Colors.grey),

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
                                          destLat: double.parse(
                                            pLat.toString(),
                                          ),
                                          destLng: double.parse(
                                            pLng.toString(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Pickup location missing!",
                                            ),
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
                                          destLat: double.parse(
                                            dLat.toString(),
                                          ),
                                          destLng: double.parse(
                                            dLng.toString(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Drop location missing!",
                                            ),
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
                          _infoBox(
                            "Toll",
                            data?.pricingSnapshot != null
                                ? "Included"
                                : "Included",
                          ),
                          _divider(),
                          _infoBox(
                            "Tax",
                            data?.pricingSnapshot != null
                                ? "Included"
                                : "Included",
                          ),
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
                            Text(
                              "$totalKm",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("Total KM"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "$extraKm",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                        CustomText(
                          "Vehicle Model",
                          size: 14,
                          color: ColorResource.grayText,
                        ),
                        CustomText(model, size: 14, color: ColorResource.black),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Color",
                          size: 14,
                          color: ColorResource.grayText,
                        ),
                        CustomText(color, size: 14, color: ColorResource.black),
                      ],
                    ),
                    if (data?.driverResponse?.status == "accepted" &&
                        data?.travellerName != null &&
                        data?.travellerPhone != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          "Traveller Information",
                          size: 16,
                          align: TextAlign.start,
                          weight: FontWeight.bold,
                          color: ColorResource.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "Traveller Name",
                            size: 14,
                            color: ColorResource.grayText,
                          ),
                          CustomText(
                            data?.travellerName ?? "",
                            size: 14,
                            color: ColorResource.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "Traveller Mobile",
                            size: 14,
                            color: ColorResource.grayText,
                          ),
                          CustomText(
                            data?.travellerPhone ?? "",
                            size: 14,
                            color: ColorResource.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            "Traveller E-mail",
                            size: 14,
                            color: ColorResource.grayText,
                          ),
                          CustomText(
                            data?.travellerEmail ?? "",
                            size: 14,
                            color: ColorResource.black,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 25),

                    /// 🔹 BUTTON
                    buildMainButton(
                      status: data?.driverResponse?.status ?? "",

                      tripStatus: data?.tripStatus ?? "",
                      isStartOtpVerified: data?.tripStartOtpVerify ?? false,
                      isEndOtpVerified: data?.tripEndOtpVerify ?? false,
                      finalImageUploaded: data?.finalImageUploaded ?? false,

                      // pickupDone: data?.pickupVerified ?? false, // 👈 backend flag
                      // isStartOtpVerified: true,
                      // isEndOtpVerified:true,
                      // tripStatus: "arrived",
                      pickupDone:
                          data?.pickupVerification ?? false, // 👈 backend flag
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
    required bool finalImageUploaded,
  }) {
    print(">>>>>>>status>>>>>>>>>>>>>>>>>${status}");
    print(">>>>>>>tripStatus>>>>>>>>>>>>>>>>>${tripStatus}");
    print(">>>>>>>isStartOtpVerified>>>>>>>>>>>>>>>>>${isStartOtpVerified}");
    print(">>>>>>>isEndOtpVerified>>>>>>>>>>>>>>>>>${isEndOtpVerified}");
    print(">>>>>>>pickupDone>>>>>>>>>>>>>>>>>${pickupDone}");
    print(">>>>>>>finalImageUploaded>>>>>>>>>>>>>>>>>${finalImageUploaded}");

    /// 🔹 1. Pickup Pending
    if (status == "accepted" && tripStatus == "driver_enroute" && !pickupDone) {
      return CommonAppButton(
        text: "Reporting to Client",
        onPressed: () async {
          showLoader(context);
          await _getCurrentLocation();
          final status = await context
              .read<NewBookingProvider>()
              .checkDriverPickupRange(
                context: context,
                id: widget.id,
                currentLat: currentLat,
                currentLng: currentLng,
              );

          if (!status) {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Pickup Confirmation"),
                  content: const Text(
                    "Are you sure you want to pick up the user from a different location?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                );
              },
            );

            if (confirm != true) return;
          }

          final success = await context
              .read<NewBookingProvider>()
              .driverArrived(
                context: context,
                id: widget.id,
                currentLat: currentLat,
                currentLng: currentLng,
              );

          if (!success) return;
          Navigator.pop(context);
          navPush(context: context, action: PickupScreen(id: widget.id));
        },
      );
    }

    if (status == "accepted" && tripStatus == "arrived" && !pickupDone) {
      return CommonAppButton(
        text: "Next",
        onPressed: () {
          navPush(context: context, action: PickupScreen(id: widget.id));
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
    // if (tripStatus == "driver_enroute" && isStartOtpVerified) {
    if (tripStatus == "arrived" && isStartOtpVerified) {
      return CommonAppButton(
        text: "Start Ride",
        onPressed: () async {
          bool success = await context.read<NewBookingProvider>().startTripApi(
            context: context,
            id: widget.id,
          );

          if (success) {
            ToastHelper.show(
              context,
              message: "Trip Started 🚗",
              type: ToastType.success,
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Trip Started 🚗")),
            // );
          }
        },
      );
    }
    if (tripStatus == "arrived" && isStartOtpVerified && !isEndOtpVerified) {
      return CommonAppButton(
        text: "Next",
        onPressed: () {
          _checkFinalFareAfterEndOtp(widget.id);
        },
      );
    }

    if (tripStatus == "in_progress" &&
        isStartOtpVerified &&
        !isEndOtpVerified) {
      return CommonAppButton(
        text: "End Trip",
        onPressed: () async {
          final status = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UploadSpeedoMeterImageScreen(id: widget.id),
            ),
          );
          if (status == true) {
            _checkFinalFareAfterEndOtp(widget.id);
          }
        },
      );
    }
    //
    // /// 🔹 4. End OTP
    // if (tripStatus == "in_progress" && !isEndOtpVerified) {
    //   return CommonAppButton(
    //     text: "Verify End OTP",
    //     onPressed: () => showOtpDialog(widget.id, "end"),
    //   );
    // }

    /// 🔹 5. Completed
    if (tripStatus == "in_progress" && isEndOtpVerified) {
      print("Booking complte Kro ab ok");
      // navPush(context: context, action: UploadSpeedoMeterImageScreen(id: widget.id,));
      print(tripStatus);
      return CommonAppButton(
        text: finalImageUploaded == true ? "Complete Trip" : "Next",
        onPressed: () async {
          if (finalImageUploaded == true) {
            showLoader(context);
            await _completeTripAfterEndOtp(widget.id);
            navPop(context: context);
          } else {
            await _completeTripAfterEndOtp(widget.id);
            // navPush(
            //   context: context,
            //   action: UploadSpeedoMeterImageScreen(id: widget.id),
            // );
          }
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
    return Container(height: 45, width: 1, color: Colors.grey.shade200);
  }

  Widget _infoBox(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xFF334155),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
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
          title: Text(
            "Enter OTP ($type)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
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
                      type: type,
                    );

                Navigator.pop(context);

                if (success) {
                  ToastHelper.show(
                    context,
                    message: "OTP Verified ($type) ✅",
                    type: ToastType.success,
                  );
                  if (type.toString() == "start") {
                    bool success = await context
                        .read<NewBookingProvider>()
                        .startTripApi(context: context, id: widget.id);

                    if (success) {
                      ToastHelper.show(
                        context,
                        message: "Trip Started 🚗",
                        type: ToastType.success,
                      );
                    }
                  }
                  if (type == "end") {
                    // final status = await Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder:
                    //         (context) =>
                    //             UploadSpeedoMeterImageScreen(id: widget.id),
                    //   ),
                    // );

                    // if (status == true) {
                    await _completeTripAfterEndOtp(widget.id);
                    // }
                  }
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  void showBookingCompletionDialog(
    BuildContext ctx,
    bool isAdjust,
    FarePreviewData status,
  ) {
    String? selectedPaymentMode = 'select_method';
    final controller = TextEditingController();
    final provider = ctx.read<NewBookingProvider>();
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        final parentCtx = ctx;
        return AlertDialog(
          title: const Text(
            'Booking Information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Time
                    _buildInfoRow(
                      'Start Time',
                      formatDateTime(
                        status.trip.tripStartAt ?? status.tripStartAt!,
                      ),
                    ), // Replace with your variable
                    const Divider(),

                    // End Time
                    _buildInfoRow(
                      'End Time',
                      formatDateTime(
                        status.trip.checkedAt ?? status.checkedAt!,
                      ),
                    ),
                    const Divider(),

                    // Total Amount
                    _buildInfoRow(
                      'Est. Amount',
                      '₹${status.fare.estimatedFare.toString()}',
                    ), // Replace with your variable
                    const Divider(),

                    // Extra Amount
                    _buildInfoRow(
                      'Final Amount',
                      '₹${status.fare.finalFare.toString()}',
                    ),
                    const Divider(),
                    _buildInfoRow(
                      'Amount Needs\nTo Be Collected',
                      highlight: true,
                      '₹${status.fare.adjustmentAmount.toString()}',
                    ), // Replace with your variable
                    const Divider(),

                    // Extra Duration
                    // _buildInfoRow(
                    //   'Extra Duration',
                    //   '45 mins',
                    // ), // Replace with your variable
                    const SizedBox(height: 16),

                    // Dropdown
                    if (isAdjust)
                      const Text(
                        'Payment Mode',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 8),
                    if (isAdjust)
                      DropdownButtonFormField<String>(
                        value: selectedPaymentMode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'select_method',
                            child: Text('Select Method'),
                          ),
                          DropdownMenuItem(value: 'cash', child: Text('Cash')),
                          DropdownMenuItem(
                            value: 'online',
                            child: Text('Online'),
                          ),
                          DropdownMenuItem(
                            value: 'force_complete',
                            child: Text('Force Complete'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMode = newValue;
                          });
                        },
                      ),
                    SizedBox(height: 6),
                    if (isAdjust && selectedPaymentMode == 'force_complete')
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(hint: Text("Enter Reason")),
                      ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await _getCurrentLocation();
                print(isAdjust);
                if (isAdjust) {
                  if (selectedPaymentMode == 'select_method') {
                    ToastHelper.show(
                      context,
                      message: "Please select a payment method",
                      type: ToastType.error,
                    );
                  } else {
                    if (selectedPaymentMode == 'force_complete') {
                      if (controller.text.length > 10) {
                        final success = await provider.waiveExtraPayment(
                          context: context,
                          currentLat: currentLat.toString(),
                          currentLng: currentLng.toString(),
                          id: widget.id,
                          reason: controller.text,
                        );
                        if (success) {
                          Navigator.pop(context);
                          // final status = await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => UploadSpeedoMeterImageScreen(
                          //           id: widget.id,
                          //         ),
                          //   ),
                          // );
                          //
                          // if (status == true) {
                          await provider.forcedCompleteBooking(
                            context: context,
                            id: widget.id,
                          );
                          Navigator.pop(parentCtx);

                          Future.delayed(const Duration(seconds: 1), () {
                            navPushReplace(
                              context: parentCtx,
                              action: const MainScreen(),
                            );
                          });
                          // }
                        }
                      } else {
                        ToastHelper.show(
                          context,
                          message: "Please enter a reason (min 10 char)",
                          type: ToastType.error,
                        );
                      }
                    } else if (selectedPaymentMode == 'cash') {
                      final success = await provider.extraPaymentCash(
                        context: context,
                        id: widget.id,
                        currentLat: currentLat.toString(),
                        currentLng: currentLng.toString(),
                        // currentLat: "28.6659174",
                        // currentLng: "77.3372858",
                      );
                      if (success) {
                        Navigator.pop(context);
                        Future.delayed(const Duration(seconds: 1), () {
                          showOtpDialog(widget.id, "end");
                        });
                      }
                    } else {
                      final data = await provider.payFinalFare(
                        context: context,
                        id: widget.id,
                        currentLat: currentLat.toString(),
                        currentLng: currentLng.toString(),
                        durationMins: "",
                      );
                      if (data != null) {
                        final status = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentQrScreen(data: data.data),
                          ),
                        );

                        print("STATUS => $status");

                        if (status != null && status == true && mounted) {
                          Navigator.pop(context);

                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) {
                              showOtpDialog(widget.id, "end");
                            }
                          });
                        }
                      }
                    }
                  }
                } else {
                  Navigator.pop(context);
                  Future.delayed(const Duration(seconds: 1), () {
                    showOtpDialog(widget.id, "end");
                  });
                }
              },
              child: const Text('Proceed'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  // Helper widget for clean info rows
  Widget _buildInfoRow(String label, String value, {bool? highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: highlight! ? 18 : 16,
              color: highlight ? Colors.teal : Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String formatDateTime(String rawDate) {
    try {
      DateTime dateTime = DateTime.parse(rawDate).toLocal();

      final formattedDate = DateFormat('d MMM yyyy').format(dateTime);
      final formattedTime = DateFormat('hh:mm a').format(dateTime);

      return "$formattedDate $formattedTime";
    } catch (e) {
      debugPrint("Date parsing error: $e");
      return "";
    }
  }
}
