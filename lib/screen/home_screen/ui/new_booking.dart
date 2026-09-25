// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:mann_fleet_driver/screen/home_screen/ui/payment_qr_screen.dart';
// import 'package:mann_fleet_driver/widget/customImageView.dart';
//
// import 'package:mann_fleet_driver/util/color/app_colors.dart';
// import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
//
// import 'package:mann_fleet_driver/widget/custom_text.dart';
// import 'package:mann_fleet_driver/widget/navigator_method.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../main.dart';
// import '../../../widget/empty/noAssignedBookingScreen.dart';
// import '../../../widget/motionToastHelper.dart';
// import '../../bookingDetail/ui/bookingDetailScreen.dart';
//
// import '../../sqlite_local_location/showdata.dart';
// import '../../trip_cancellation/ui/trip_cancellation.dart';
// import '../component/bookingCard.dart';
// import '../provider/newBookingProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class NewBookingScreen extends StatefulWidget {
//   const NewBookingScreen({super.key});
//
//   @override
//   State<NewBookingScreen> createState() => _NewBookingScreenState();
// }
//
// class _NewBookingScreenState extends State<NewBookingScreen> {
//   int currentIndex = 0;
//   double? currentLat;
//   double? currentLng;
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     Future.microtask(() {
//       context.read<NewBookingProvider>().getBannerApi(context: context);
//       context.read<NewBookingProvider>().getNewBooking(context: context);
//     });
//   }
//
//   Future<bool> _getCurrentLocation() async {
//     try {
//       // Check permission
//       LocationPermission permission = await Geolocator.checkPermission();
//
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         ToastHelper.show(
//           context,
//           message:
//               "Location permission permanently denied. Please enable from settings.",
//           type: ToastType.error,
//         );
//         return false;
//       }
//
//       if (permission == LocationPermission.denied) {
//         ToastHelper.show(
//           context,
//           message: "Location permission denied",
//           type: ToastType.error,
//         );
//         return false;
//       }
//
//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       currentLat = position.latitude;
//       currentLng = position.longitude;
//
//       debugPrint("📍 Current Location Home: $currentLat, $currentLng");
//       return true;
//     } catch (e) {
//       debugPrint("Location error: $e");
//       ToastHelper.show(
//         context,
//         message: "Failed to get location: ${e.toString()}",
//         type: ToastType.error,
//       );
//       return false;
//     }
//   }
//
//   Timer? locationTimer;
//
//   void startLocationUpdates({
//     required BuildContext context,
//     required String bookingId,
//   }) {
//     _getCurrentLocation();
//
//     /// every 10 seconds
//     locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
//       await context.read<NewBookingProvider>().updateDriverLocationApi(
//         id: bookingId,
//         lng: currentLng ?? 0.0,
//         lat: currentLat ?? 0.0,
//         context: context,
//       );
//     });
//   }
//
//   void stopLocationUpdates() {
//     locationTimer?.cancel();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     stopLocationUpdates();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NewBookingProvider>(
//       builder: (context, provider, child) {
//         if (provider.newBookingModel == null ||
//             provider.newBookingModel!.data == null) {
//           return SizedBox(
//             height: MediaQuery.of(context).size.height * 0.7,
//             width: MediaQuery.of(context).size.width,
//             child: Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.asset("assets/images/upcommingBooking.gif"),
//               ),
//             ),
//           );
//         }
//         // if (provider.isLoading) {
//         //   return const Center(child: CircularProgressIndicator());
//         // }
//
//         final bookings = provider.newBookingModel?.data ?? [];
//
//         if (bookings.isEmpty) {
//           return NoAssignedBookingScreen(
//             onRefresh: () {
//               context.read<NewBookingProvider>().getBannerApi(context: context);
//               context.read<NewBookingProvider>().getNewBooking(
//                 context: context,
//               );
//             },
//           );
//           //return const Center(child: Text("No bookings available"));
//         }
//         final banners = provider.getBannerModel?.data ?? [];
//
//         return Stack(
//           children: [
//             RefreshIndicator(
//               onRefresh: () async {
//                 context.read<NewBookingProvider>().getBannerApi(
//                   context: context,
//                 );
//                 context.read<NewBookingProvider>().getNewBooking(
//                   context: context,
//                 );
//               },
//               child: SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Column(
//                   children: [
//                     if (provider.getBannerModel != null &&
//                         provider.getBannerModel!.data!.isNotEmpty)
//                       Column(
//                         children: [
//                           GestureDetector(
//                             onDoubleTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const LocationLogsPage(),
//                                 ),
//                               );
//                             },
//                             child: CarouselSlider(
//                               options: CarouselOptions(
//                                 height: 150,
//                                 autoPlay: true,
//                                 enlargeCenterPage: true,
//                                 viewportFraction: 0.95,
//                                 onPageChanged: (index, reason) {
//                                   setState(() {
//                                     currentIndex = index;
//                                   });
//                                 },
//                               ),
//                               items:
//                                   provider.getBannerModel!.data!.map((item) {
//                                     return ClipRRect(
//                                       borderRadius: BorderRadius.circular(12),
//                                       child: CustomImageView(
//                                         imagePath: item.image,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         fit: BoxFit.cover,
//                                         imageType: ImageType.network,
//                                       ),
//                                     );
//                                   }).toList(),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: List.generate(banners.length, (index) {
//                               bool isActive = index == currentIndex;
//                               return AnimatedContainer(
//                                 duration: const Duration(milliseconds: 300),
//                                 margin: const EdgeInsets.symmetric(
//                                   horizontal: 4,
//                                 ),
//                                 height: 8,
//                                 width: isActive ? 20 : 8,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       isActive
//                                           ? ColorResource.primaryColor
//                                           : Colors.grey.shade300,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ],
//                       ),
//                     const SizedBox(height: 10),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: bookings.length,
//                       itemBuilder: (context, index) {
//                         final booking = bookings[index];
//
//                         final rawDate = booking.scheduledAtIST;
//
//                         String formattedDate = "4 Sep 2024";
//                         String formattedTime = "08:30 PM";
//
//                         if (rawDate != null && rawDate.isNotEmpty) {
//                           try {
//                             DateTime dateTime = DateFormat(
//                               'yyyy-MM-dd HH:mm:ss',
//                             ).parse(rawDate);
//
//                             formattedDate = DateFormat(
//                               'd MMM yyyy',
//                             ).format(dateTime);
//
//                             formattedTime = DateFormat(
//                               'hh:mm a',
//                             ).format(dateTime);
//                           } catch (e) {
//                             debugPrint("Date parsing error: $e");
//                           }
//                         }
//                         final bookingId = booking.id ?? "";
//                         final driverStatus =
//                             booking.driverResponse?.status ?? "pending";
//
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5.0),
//                           child: BookingCard(
//                             title:
//                                 booking.segment?.name ??
//                                 "Airport Taxi – Terminal 3",
//                             dateTime: "$formattedDate $formattedTime",
//                             price: booking.estimatedFare.toString(),
//                             bookingType: booking.bookingType ?? "One Way",
//                             vehicleNo: booking.vehicle?.carNumber ?? "",
//                             vehicleModel:
//                                 booking.vehicle?.model ?? "Mercedes E-Class",
//                             color: booking.vehicle?.color ?? "White",
//                             bookingId: booking.id?.toString() ?? "",
//                             driverStatus:
//                                 booking.driverResponse?.status ?? "pending",
//                             tripStatus: booking.tripStatus ?? "Not Started",
//                             pickupAddress:
//                                 booking.pickup?.address ?? "Noida Sector 63",
//                             dropAddress:
//                                 booking.dropoff?.address ?? "Delhi Airport",
//
//                             onCardTap: () {
//                               navPush(
//                                 context: context,
//                                 action: BookingDetailScreen(
//                                   id: booking.id.toString(),
//                                 ),
//                               );
//                             },
//                             button: buildActionButtons(
//                               status: driverStatus,
//                               tripStatus: booking.tripStatus ?? "",
//                               bookingId: bookingId,
//                               provider: provider,
//                               isStartOtpVerified:
//                                   booking.tripStartOtpVerify ?? false,
//                               isEndOtpVerified:
//                                   booking.tripEndOtpVerify ?? false,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (provider.isLoading)
//               const Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: LinearProgressIndicator(minHeight: 3),
//               ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget button({
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 145,
//         height: 45,
//         decoration: ShapeDecoration(
//           color: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(43),
//           ),
//         ),
//         child: Center(
//           child: CustomText(
//             title,
//             size: 14,
//             weight: FontWeight.w700,
//             color: ColorResource.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget activeCard({required String title, required double price}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomText(
//           title,
//           size: 14,
//           weight: FontWeight.w400,
//           color: ColorResource.grayText,
//         ),
//         CustomText(
//           "₹${price.toString()}",
//           size: 14,
//           weight: FontWeight.w500,
//           color: ColorResource.black,
//         ),
//       ],
//     );
//   }
//
//   Widget buildActionButtons({
//     required String status, // driverStatus
//     required String tripStatus,
//     required String bookingId,
//     required NewBookingProvider provider,
//     required bool isStartOtpVerified,
//     required bool isEndOtpVerified,
//   }) {
//     /// 🔹 1. PENDING → CANCEL + ACCEPT
//     if (status == "pending") {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           button(
//             title: "Cancel",
//             color: Colors.red,
//             onTap: () {
//               navPush(
//                 context: context,
//                 action: TripCancellationScreen(
//                   bookingNumber:
//                       provider.newBookingModel?.data
//                           ?.firstWhere((e) => e.id.toString() == bookingId)
//                           .bookingNumber,
//                   bookingId: bookingId,
//                   pickupAddress:
//                       provider.newBookingModel?.data
//                           ?.firstWhere((e) => e.id.toString() == bookingId)
//                           .pickup
//                           ?.address,
//                   dropoffAddress:
//                       provider.newBookingModel?.data
//                           ?.firstWhere((e) => e.id.toString() == bookingId)
//                           .dropoff
//                           ?.address,
//                   bookingDateTime:
//                       provider.newBookingModel?.data
//                           ?.firstWhere((e) => e.id.toString() == bookingId)
//                           .scheduledAtIST,
//                   fareEstimate:
//                       provider.newBookingModel?.data
//                           ?.firstWhere((e) => e.id.toString() == bookingId)
//                           .estimatedFare
//                           ?.toString(),
//                   passengerInfo:
//                       provider.newBookingModel?.data
//                           ?.firstWhere((e) => e.id.toString() == bookingId)
//                           .user
//                           ?.name,
//                 ),
//               );
//             },
//           ),
//           // button(
//           //   title: "Cancel",
//           //   color: Colors.red,
//           //   onTap: () => showCancelDialog(bookingId),
//           // ),
//           button(
//             title: "Accept",
//             color: Colors.green,
//             onTap: () async {
//               final prefs = await SharedPreferences.getInstance();
//
//               await prefs.setString("tracking_booking_id", bookingId);
//               bool success = await provider.acceptBookingApi(
//                 context: context,
//                 id: bookingId,
//                 currentLng: currentLng ?? 0.0,
//                 currentLat: currentLat ?? 0.0,
//               );
//
//               await FlutterForegroundTask.startService(
//                 serviceId: 100,
//                 notificationTitle: 'Driver Tracking',
//                 notificationText: 'Location tracking active',
//                 callback: startCallback,
//               );
//
//               if (success) {
//                 ToastHelper.show(
//                   context,
//                   message: "Booking Accepted ✅",
//                   type: ToastType.success,
//                 );
//                 // ScaffoldMessenger.of(context).showSnackBar(
//                 //   const SnackBar(content: Text("Booking Accepted ✅")),
//                 // );
//               }
//             },
//           ),
//         ],
//       );
//     }
//
//     /// 🔹 2. ACCEPTED → START OTP
//     if (status == "accepted") {
//       return Center(
//         child: button(
//           title: "Go to Detail",
//           color: Colors.blue,
//           onTap: () async {
//             final prefs = await SharedPreferences.getInstance();
//
//             await prefs.setString("tracking_booking_id", bookingId);
//             navPush(
//               context: context,
//               action: BookingDetailScreen(id: bookingId),
//             );
//             provider.updateDriverLocationApi(
//               id: bookingId,
//               lng: currentLng ?? 0.0,
//               lat: currentLat ?? 0.0,
//               context: context,
//             );
//           },
//         ),
//       );
//     }
//     // if (status == "accepted" && !isStartOtpVerified) {
//     //   return Center(
//     //     child: button(
//     //       title: "Verify Start OTP",
//     //       color: Colors.orange,
//     //       onTap: () => showOtpDialog(bookingId, "start"),
//     //     ),
//     //   );
//     // }
//
//     /// 🔹 3. DRIVER ARRIVED → START RIDE
//     if (tripStatus == "arrived" && isStartOtpVerified) {
//       return Center(
//         child: button(
//           title: "Start Ride",
//           color: Colors.green,
//           onTap: () async {
//             bool success = await provider.startTripApi(
//               context: context,
//               id: bookingId,
//             );
//
//             if (success) {
//               ToastHelper.show(
//                 context,
//                 message: "Trip Started 🚗",
//                 type: ToastType.success,
//               );
//             }
//           },
//         ),
//       );
//     }
//
//     /// 🔹 4. TRIP IN PROGRESS → END OTP
//     if (tripStatus == "in_progress" && !isEndOtpVerified) {
//       return Center(
//         child: button(
//           title: "Verify End OTP",
//           color: Colors.blue,
//           onTap: () => showOtpDialog(bookingId, "end"),
//         ),
//       );
//     }
//
//     /// 🔹 5. COMPLETED
//     if (tripStatus == "completed" || isEndOtpVerified) {
//       return Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.green.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: const Center(
//           child: Text(
//             "Trip Completed ✅",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       );
//     }
//
//     /// 🔹 6. CANCELLED
//     if (tripStatus == "cancelled") {
//       return const Center(
//         child: Text(
//           "Trip Cancelled ❌",
//           style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//         ),
//       );
//     }
//
//     return const SizedBox();
//   }
//
//   void showCancelDialog(String bookingId) {
//     TextEditingController reasonController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text(
//             "Cancel Booking",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           content: TextField(
//             controller: reasonController,
//             decoration: const InputDecoration(hintText: "Enter reason"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await context.read<NewBookingProvider>().driverCancelApi(
//                   context: context,
//                   id: bookingId,
//                   reason: reasonController.text,
//                 );
//
//                 Navigator.pop(context);
//
//                 context.read<NewBookingProvider>().getNewBooking(
//                   context: context,
//                 );
//               },
//               child: const Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   /// 🔢 OTP DIALOG
//   void showOtpDialog(String bookingId, String type) {
//     TextEditingController otpController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: Text(
//             "Enter OTP ($type)",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           content: TextField(
//             controller: otpController,
//             keyboardType: TextInputType.number,
//             maxLength: 4,
//             decoration: const InputDecoration(
//               hintText: "Enter 4-digit OTP",
//               border: OutlineInputBorder(),
//               counterText: "",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 bool success = await context
//                     .read<NewBookingProvider>()
//                     .verifyBookingOtpApi(
//                       context: context,
//                       id: bookingId,
//                       otp: otpController.text,
//                       type: type, // 🔥 important
//                     );
//
//                 Navigator.pop(context);
//
//                 if (success) {
//                   ToastHelper.show(
//                     context,
//                     message: "OTP Verified ($type) ✅",
//                     type: ToastType.success,
//                   );
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(content: Text("OTP Verified ($type) ✅")),
//                   // );
//                 }
//               },
//               child: const Text("Verify"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mann_fleet_driver/screen/home_screen/ui/payment_qr_screen.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';

import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';

import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../widget/empty/noAssignedBookingScreen.dart';
import '../../../widget/motionToastHelper.dart';
import '../../bookingDetail/ui/bookingDetailScreen.dart';

import '../../corporateBookings/pro/corporate_booking_provider.dart';
import '../../corporateBookings/ui/corporate_booking_detail_screen.dart';
import '../../sqlite_local_location/showdata.dart';
import '../../trip_cancellation/ui/trip_cancellation.dart';
import '../component/bookingCard.dart';
import '../provider/newBookingProvider.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Corporate imports
// import '../pro/corporate_booking_provider.dart';
// import 'corporate_booking_detail_screen.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  int currentIndex = 0;
  double? currentLat;
  double? currentLng;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Future.microtask(() {
      // Normal bookings
      context.read<NewBookingProvider>().getBannerApi(context: context);
      context.read<NewBookingProvider>().getNewBooking(context: context);

      // Corporate bookings (same as pehle)
      context.read<CorporateBookingProvider>().fetchBookings(context);
    });
  }

  Future<bool> _getCurrentLocation() async {
    try {
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLng = position.longitude;

      debugPrint("📍 Current Location Home: $currentLat, $currentLng");
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

  // Location for Corporate Accept (same logic as CorporateBookingListScreen)
  Future<Position?> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable GPS / Location Services.'),
          ),
        );
      }
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied. Please enable them from settings.',
            ),
          ),
        );
      }
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Timer? locationTimer;

  void startLocationUpdates({
    required BuildContext context,
    required String bookingId,
  }) {
    _getCurrentLocation();

    locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await context.read<NewBookingProvider>().updateDriverLocationApi(
        id: bookingId,
        lng: currentLng ?? 0.0,
        lat: currentLat ?? 0.0,
        context: context,
      );
    });
  }

  void stopLocationUpdates() {
    locationTimer?.cancel();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }

  // Helper: parse date for sorting (latest first)
  DateTime _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime(2000);
    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(raw);
    } catch (_) {
      return DateTime(2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NewBookingProvider, CorporateBookingProvider>(
      builder: (context, newProvider, corporateProvider, child) {
        // ---------- Loading / Empty states ----------
        final isNewLoading =
            newProvider.newBookingModel == null ||
            newProvider.newBookingModel!.data == null;

        final isCorporateLoading = corporateProvider.isLoading;

        if (isNewLoading && isCorporateLoading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/images/upcommingBooking.gif"),
              ),
            ),
          );
        }

        final normalBookings = newProvider.newBookingModel?.data ?? [];
        final corporateBookings = corporateProvider.bookings;

        // ---------- Combined + Date-wise sorted (Latest first) ----------
        // final List<Map<String, dynamic>> combined = [];

        // Normal bookings
        // ---------- Combined + Date-wise sorted (Soonest upcoming first) ----------
        final List<Map<String, dynamic>> combined = [];

        // Normal bookings
        for (var b in normalBookings) {
          combined.add({
            'type': 'normal',
            'booking': b,
            'date': _parseDate(b.scheduledAtIST),
          });
        }

        // Corporate bookings
        for (var b in corporateBookings) {
          combined.add({
            'type': 'corporate',
            'booking': b,
            'date': _parseDate(b.scheduledAtIST),
          });
        }

        // Soonest upcoming first
        combined.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
        );

        final banners = newProvider.getBannerModel?.data ?? [];

        // Agar dono empty hain
        if (combined.isEmpty && !isNewLoading && !isCorporateLoading) {
          return NoAssignedBookingScreen(
            onRefresh: () {
              newProvider.getBannerApi(context: context);
              newProvider.getNewBooking(context: context);
              corporateProvider.fetchBookings(context);
            },
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                newProvider.getBannerApi(context: context);
                newProvider.getNewBooking(context: context);
                corporateProvider.fetchBookings(context);
              },
              child: SingleChildScrollView(
                // physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // ---------- Banner (same as pehle) ----------
                    if (newProvider.getBannerModel != null &&
                        newProvider.getBannerModel!.data!.isNotEmpty)
                      Column(
                        children: [
                          GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LocationLogsPage(),
                                ),
                              );
                            },
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 150,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.95,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                              items:
                                  newProvider.getBannerModel!.data!.map((item) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CustomImageView(
                                        imagePath: item.image,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        imageType: ImageType.network,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(banners.length, (index) {
                              bool isActive = index == currentIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 8,
                                width: isActive ? 20 : 8,
                                decoration: BoxDecoration(
                                  color:
                                      isActive
                                          ? ColorResource.primaryColor
                                          : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),

                    // ---------- Combined List (Latest first) ----------
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: combined.length,
                      itemBuilder: (context, index) {
                        final item = combined[index];
                        final type = item['type'] as String;

                        // ===================== CORPORATE BOOKING CARD =====================
                        if (type == 'corporate') {
                          final booking = item['booking'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: _CorporateBookingCard(
                              booking: booking,  isAccepting: corporateProvider.isAccepting,
                              isRejecting: corporateProvider.isRejecting,
                              // isResponding: corporateProvider.isResponding,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CorporateBookingDetailScreen(
                                          bookingId: booking.id,
                                        ),
                                  ),
                                );
                              },
                              onAccept: () async {
                                final position = await _determinePosition(
                                  context,
                                );
                                if (position == null) return;
                                if (!context.mounted) return;

                                final success = await corporateProvider
                                    .acceptBooking(
                                      context: context,
                                      bookingId: booking.id,
                                      currentLat: position.latitude,
                                      currentLng: position.longitude,
                                    );

                                if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Booking Accepted Successfully',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              onReject: () async {
                                final success = await corporateProvider
                                    .rejectBooking(context, booking.id);

                                if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Booking Rejected'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }

                        // ===================== NORMAL BOOKING CARD =====================
                        final booking = item['booking'];
                        final rawDate = booking.scheduledAtIST;

                        String formattedDate = "4 Sep 2024";
                        String formattedTime = "08:30 PM";

                        if (rawDate != null && rawDate.isNotEmpty) {
                          try {
                            DateTime dateTime = DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).parse(rawDate);

                            formattedDate = DateFormat(
                              'd MMM yyyy',
                            ).format(dateTime);
                            formattedTime = DateFormat(
                              'hh:mm a',
                            ).format(dateTime);
                          } catch (e) {
                            debugPrint("Date parsing error: $e");
                          }
                        }

                        final bookingId = booking.id ?? "";
                        final driverStatus =
                            booking.driverResponse?.status ?? "pending";

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: BookingCard(
                            title:
                                booking.segment?.name ??
                                "Airport Taxi – Terminal 3",
                            dateTime: "$formattedDate $formattedTime",
                            price: booking.estimatedFare.toString(),
                            bookingType: booking.bookingType ?? "One Way",
                            vehicleNo: booking.vehicle?.carNumber ?? "",
                            vehicleModel:
                                booking.vehicle?.model ?? "Mercedes E-Class",
                            color: booking.vehicle?.color ?? "White",
                            bookingId: booking.bookingNumber?.toString() ?? "",
                            driverStatus:
                                booking.driverResponse?.status ?? "pending",
                            tripStatus: booking.tripStatus ?? "Not Started",
                            pickupAddress:
                                booking.pickup?.address ?? "Noida Sector 63",
                            dropAddress:
                                booking.dropoff?.address ?? "Delhi Airport",
                            onCardTap: () {
                              navPush(
                                context: context,
                                action: BookingDetailScreen(
                                  id: booking.id.toString(),
                                ),
                              );
                            },
                            button: buildActionButtons(
                              status: driverStatus,
                              tripStatus: booking.tripStatus ?? "",
                              bookingId: bookingId,
                              provider: newProvider,
                              isStartOtpVerified:
                                  booking.tripStartOtpVerify ?? false,
                              isEndOtpVerified:
                                  booking.tripEndOtpVerify ?? false,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            if (newProvider.isLoading || corporateProvider.isLoading)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(minHeight: 3),
              ),
          ],
        );
      },
    );
  }

  // ===================== Existing helpers (unchanged) =====================
  Widget button({
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 145,
        height: 45,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(43),
          ),
        ),
        child: Center(
          child: CustomText(
            title,
            size: 14,
            weight: FontWeight.w700,
            color: ColorResource.white,
          ),
        ),
      ),
    );
  }

  Widget activeCard({required String title, required double price}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title,
          size: 14,
          weight: FontWeight.w400,
          color: ColorResource.grayText,
        ),
        CustomText(
          "₹${price.toString()}",
          size: 14,
          weight: FontWeight.w500,
          color: ColorResource.black,
        ),
      ],
    );
  }

  Widget buildActionButtons({
    required String status,
    required String tripStatus,
    required String bookingId,
    required NewBookingProvider provider,
    required bool isStartOtpVerified,
    required bool isEndOtpVerified,
  }) {
    if (status == "pending") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button(
            title: "Reject",
            color: Colors.red,
            onTap: () {
              navPush(
                context: context,
                action: TripCancellationScreen(
                  bookingNumber:
                      provider.newBookingModel?.data
                          ?.firstWhere((e) => e.id.toString() == bookingId)
                          .bookingNumber,
                  bookingId: bookingId,
                  pickupAddress:
                      provider.newBookingModel?.data
                          ?.firstWhere((e) => e.id.toString() == bookingId)
                          .pickup
                          ?.address,
                  dropoffAddress:
                      provider.newBookingModel?.data
                          ?.firstWhere((e) => e.id.toString() == bookingId)
                          .dropoff
                          ?.address,
                  bookingDateTime:
                      provider.newBookingModel?.data
                          ?.firstWhere((e) => e.id.toString() == bookingId)
                          .scheduledAtIST,
                  fareEstimate:
                      provider.newBookingModel?.data
                          ?.firstWhere((e) => e.id.toString() == bookingId)
                          .estimatedFare
                          ?.toString(),
                  passengerInfo:
                      provider.newBookingModel?.data
                          ?.firstWhere((e) => e.id.toString() == bookingId)
                          .user
                          ?.name,
                ),
              );
            },
          ),
          button(
            title: "Accept",
            color: Colors.green,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();

              await prefs.setString("tracking_booking_id", bookingId);
              bool success = await provider.acceptBookingApi(
                context: context,
                id: bookingId,
                currentLng: currentLng ?? 0.0,
                currentLat: currentLat ?? 0.0,
              );

              await FlutterForegroundTask.startService(
                serviceId: 100,
                notificationTitle: 'Driver Tracking',
                notificationText: 'Location tracking active',
                callback: startCallback,
              );

              if (success) {
                ToastHelper.show(
                  context,
                  message: "Booking Accepted ✅",
                  type: ToastType.success,
                );
              }
            },
          ),
        ],
      );
    }

    if (status == "accepted") {
      return Center(
        child: button(
          title: "Go to Detail",
          color: Colors.blue,
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();

            await prefs.setString("tracking_booking_id", bookingId);
            navPush(
              context: context,
              action: BookingDetailScreen(id: bookingId),
            );
            provider.updateDriverLocationApi(
              id: bookingId,
              lng: currentLng ?? 0.0,
              lat: currentLat ?? 0.0,
              context: context,
            );
          },
        ),
      );
    }

    if (tripStatus == "arrived" && isStartOtpVerified) {
      return Center(
        child: button(
          title: "Start Ride",
          color: Colors.green,
          onTap: () async {
            bool success = await provider.startTripApi(
              context: context,
              id: bookingId,
            );

            if (success) {
              ToastHelper.show(
                context,
                message: "Trip Started 🚗",
                type: ToastType.success,
              );
            }
          },
        ),
      );
    }

    if (tripStatus == "in_progress" && !isEndOtpVerified) {
      return Center(
        child: button(
          title: "Verify End OTP",
          color: Colors.blue,
          onTap: () => showOtpDialog(bookingId, "end"),
        ),
      );
    }

    if (tripStatus == "completed" || isEndOtpVerified) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Trip Completed ✅",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (tripStatus == "cancelled") {
      return const Center(
        child: Text(
          "Trip Cancelled ❌",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      );
    }

    return const SizedBox();
  }

  void showCancelDialog(String bookingId) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Cancel Booking",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(hintText: "Enter reason"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<NewBookingProvider>().driverCancelApi(
                  context: context,
                  id: bookingId,
                  reason: reasonController.text,
                );

                Navigator.pop(context);

                context.read<NewBookingProvider>().getNewBooking(
                  context: context,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

// ===================== Corporate Card (copied from CorporateBookingListScreen) =====================
// ===================== Corporate Card (Similar layout to BookingCard) =====================
// ===================== Corporate Card (Exact same style as BookingCard) =====================
class _CorporateBookingCard extends StatelessWidget {
  final dynamic booking;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  // final bool isResponding;

  final bool isAccepting;
  final bool isRejecting;

  const _CorporateBookingCard({
    required this.booking,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
    // required this.isResponding,
    required this.isAccepting,
    required this.isRejecting,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = booking.driverResponse?.status == 'pending';

    // Safe field extraction
    final bookingNumber = booking.bookingNumber?.toString() ?? '';
    // final scheduledAt = booking.scheduledAtIST?.toString() ?? '';
    final rawDate = booking.scheduledAtIST?.toString() ?? '';
    final companyName =
        booking.corporate?.companyName?.toString() ?? 'Corporate';
    final guestName =
        (booking.guestDetail != null && booking.guestDetail.isNotEmpty)
            ? booking.guestDetail.first.name?.toString() ?? ''
            : '';
    final tripType = booking.tripType?.toString() ?? 'Corporate';
    final overallStatus = booking.overallStatus?.toString() ?? 'pending';
    final driverStatus =
        booking.driverResponse?.status?.toString() ?? 'pending';
    final pickupAddress = booking.pickup?.address?.toString() ?? '';
    final dropAddress = booking.dropoff?.address?.toString() ?? '';
    final vehicleModel =
        '${booking.vehicle?.brand ?? ''} ${booking.vehicle?.model ?? ''}'
            .trim();
    final vehicleNo = booking.vehicle?.carNumber?.toString() ?? '';
    // final vehicleColor = booking.vehicle?.color?.toString() ?? '';

    // ---------- Date Formatting (same as normal booking) ----------
    String formattedDateTime = rawDate;
    if (rawDate.isNotEmpty) {
      try {
        DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(rawDate);
        final formattedDate = DateFormat('d MMM yyyy').format(dateTime);
        final formattedTime = DateFormat('hh:mm a').format(dateTime);
        formattedDateTime = '$formattedDate $formattedTime';
      } catch (e) {
        debugPrint("Corporate date parsing error: $e");
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        // margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Corporate #$bookingNumber',
                        size: 18,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        formattedDateTime,   // ←
                        size: 14,
                        weight: FontWeight.w500,
                        color: ColorResource.grayText,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Divider(),

            /// Booking Info
            const SizedBox(height: 10),
            CustomText(
              "BOOKING INFO",
              size: 16,
              weight: FontWeight.bold,
              color: ColorResource.black,
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "BOOKING TYPE",
                      size: 12,
                      weight: FontWeight.w500,
                      color: ColorResource.grayText,
                    ),
                    CustomText(
                      tripType.toUpperCase(),
                      size: 14,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      "STATUS",
                      size: 12,
                      weight: FontWeight.w500,
                      color: ColorResource.grayText,
                    ),
                    CustomText(
                      overallStatus.replaceAll('_', ' ').toUpperCase(),
                      size: 14,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "VEHICLE NO",
                      size: 12,
                      weight: FontWeight.w500,
                      color: ColorResource.grayText,
                    ),
                    CustomText(
                      vehicleNo.isEmpty ? '-' : vehicleNo,
                      size: 14,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      "DRIVER STATUS",
                      size: 12,
                      weight: FontWeight.w500,
                      color: ColorResource.grayText,
                    ),
                    CustomText(
                      driverStatus.toUpperCase(),
                      size: 14,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                  ],
                ),
              ],
            ),

            // Company & Guest (extra info for corporate)
            if (companyName.isNotEmpty || guestName.isNotEmpty) ...[
              const SizedBox(height: 12),
              if (companyName.isNotEmpty)
                Row(
                  children: [
                    CustomText(
                      "Company: ",
                      size: 13,
                      weight: FontWeight.w600,
                      color: ColorResource.grayText,
                    ),
                    Expanded(
                      child: CustomText(
                        companyName,
                        size: 13,
                        weight: FontWeight.w500,
                        color: ColorResource.black,
                      ),
                    ),
                  ],
                ),
              if (guestName.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    CustomText(
                      "Guest: ",
                      size: 13,
                      weight: FontWeight.w600,
                      color: ColorResource.grayText,
                    ),
                    Expanded(
                      child: CustomText(
                        guestName,
                        size: 13,
                        weight: FontWeight.w500,
                        color: ColorResource.black,
                      ),
                    ),
                  ],
                ),
              ],
            ],

            const SizedBox(height: 15),
            const Divider(),

            /// Route
            const SizedBox(height: 10),
            CustomText(
              "ROUTE",
              size: 14,
              weight: FontWeight.w400,
              color: ColorResource.grayText,
            ),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () {
                if (booking.pickup?.lat != null &&
                    booking.pickup?.lng != null) {
                  _openMapsNavigation(
                    destLat: booking.pickup!.lat!.toDouble(),
                    destLng: booking.pickup!.lng!.toDouble(),
                  );
                }
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Pickup: ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ColorResource.grayText,
                      ),
                    ),
                    TextSpan(
                      text: pickupAddress.isEmpty ? '-' : pickupAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorResource.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {
                if (booking.dropoff?.lat != null &&
                    booking.dropoff?.lng != null) {
                  _openMapsNavigation(
                    destLat: booking.dropoff!.lat!.toDouble(),
                    destLng: booking.dropoff!.lng!.toDouble(),
                  );
                }
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Drop: ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ColorResource.grayText,
                      ),
                    ),
                    TextSpan(
                      text: dropAddress.isEmpty ? '-' : dropAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorResource.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Divider(),

            /// Vehicle Model
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText("Model", size: 14, color: ColorResource.grayText),
                CustomText(
                  vehicleModel.isEmpty ? '-' : vehicleModel,
                  size: 14,
                  color: ColorResource.black,
                ),
              ],
            ),
            // if (vehicleColor.isNotEmpty)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CustomText("Color", size: 14, color: ColorResource.grayText),
            //       CustomText(vehicleColor, size: 14, color: ColorResource.black),
            //     ],
            //   ),

            /// Accept / Reject Buttons
            /// Accept / Reject  OR  Go Detail Button (same style as normal booking)
            if (isPending) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reject Button
                  GestureDetector(
                    onTap:  (isAccepting || isRejecting)
    ? null : onReject,
                    child: Container(
                      width: 145,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(43),
                        ),
                      ),
                      child: Center(
                        child: isRejecting
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const CustomText(
                          "Reject",
                          size: 14,
                          weight: FontWeight.w700,
                          color: ColorResource.white,
                        ),
                      ),
                    ),
                  ),

                  // Accept Button
                  GestureDetector(
                    onTap: (isAccepting || isRejecting) ? null : onAccept,
                    child: Container(
                      width: 145,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(43),
                        ),
                      ),
                      child: Center(
                        child: isAccepting
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const CustomText(
                          "Accept",
                          size: 14,
                          weight: FontWeight.w700,
                          color: ColorResource.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Go Detail Button (Blue)
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 145,
                    height: 45,
                    decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(43),
                      ),
                    ),
                    child: const Center(
                      child: CustomText(
                        "Go Detail",
                        size: 14,
                        weight: FontWeight.w700,
                        color: ColorResource.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openMapsNavigation({
    required double destLat,
    required double destLng,
  }) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$destLat,$destLng'
      '&travelmode=driving',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final fallback = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destLat,$destLng',
      );
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }
}

// class _CorporateBookingCard extends StatelessWidget {
//   final dynamic booking;
//   final VoidCallback onTap;
//   final VoidCallback onAccept;
//   final VoidCallback onReject;
//   final bool isResponding;
//
//   const _CorporateBookingCard({
//     required this.booking,
//     required this.onTap,
//     required this.onAccept,
//     required this.onReject,
//     required this.isResponding,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isPending = booking.driverResponse?.status == 'pending';
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.grey.shade100,
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF0D1B2A).withOpacity(0.06),
//             blurRadius: 20,
//             spreadRadius: 0,
//             offset: const Offset(0, 10),
//           ),
//           BoxShadow(
//             color: const Color(0xFF000000).withOpacity(0.02),
//             blurRadius: 6,
//             spreadRadius: -2,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Corporate #${booking.bookingNumber ?? ''}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _statusColor(booking.overallStatus ?? '')
//                           .withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       (booking.overallStatus ?? '')
//                           .replaceAll('_', ' ')
//                           .toUpperCase(),
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: _statusColor(booking.overallStatus ?? ''),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(height: 20),
//
//               if (booking.guestDetail != null &&
//                   booking.guestDetail.isNotEmpty)
//                 _infoRow(Icons.person, booking.guestDetail.first.name),
//               if (booking.corporate?.companyName != null)
//                 _infoRow(Icons.business, booking.corporate.companyName),
//               if (booking.tripType != null)
//                 _infoRow(Icons.business, booking.tripType),
//               if (booking.scheduledAtIST != null)
//                 _infoRow(Icons.calendar_today, booking.scheduledAtIST),
//               if (booking.pickup?.lat != null && booking.pickup?.lng != null)
//                 GestureDetector(
//                   onTap: () {
//                     _openMapsNavigation(
//                       destLat: booking.pickup!.lat!.toDouble(),
//                       destLng: booking.pickup!.lng!.toDouble(),
//                       label: booking.pickup?.address,
//                     );
//                   },
//                   child: _infoRow(
//                     Icons.my_location,
//                     booking.pickup.address ?? '',
//                     maxLines: 1,
//                   ),
//                 ),
//               if (booking.dropoff?.lat != null && booking.dropoff?.lng != null)
//                 GestureDetector(
//                   onTap: () {
//                     _openMapsNavigation(
//                       destLat: booking.dropoff!.lat!.toDouble(),
//                       destLng: booking.dropoff!.lng!.toDouble(),
//                       label: booking.dropoff?.address,
//                     );
//                   },
//                   child: _infoRow(
//                     Icons.location_on,
//                     booking.dropoff.address ?? '',
//                     maxLines: 1,
//                   ),
//                 ),
//               if (booking.vehicle != null)
//                 _infoRow(
//                   Icons.directions_car,
//                   '${booking.vehicle.brand ?? ''} ${booking.vehicle.model ?? ''} (${booking.vehicle.carNumber ?? ''})',
//                 ),
//
//               // Accept / Reject
//               if (isPending) ...[
//                 const SizedBox(height: 14),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: isResponding ? null : onAccept,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: isResponding
//                             ? const SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                             : const Text(
//                           'Accept',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: isResponding ? null : onReject,
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.red,
//                           side: const BorderSide(color: Colors.red),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           'Reject',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _openMapsNavigation({
//     required double destLat,
//     required double destLng,
//     String? label,
//   }) async {
//     final uri = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1'
//           '&destination=$destLat,$destLng'
//           '&travelmode=driving',
//     );
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       final fallback = Uri.parse(
//         'https://www.google.com/maps/search/?api=1&query=$destLat,$destLng',
//       );
//       await launchUrl(fallback, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   Widget _infoRow(IconData icon, String text, {int maxLines = 2}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               maxLines: maxLines,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 13, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _statusColor(String status) {
//     switch (status) {
//       case 'driver_assigned':
//         return Colors.blue;
//       case 'accepted':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       case 'completed':
//         return Colors.teal;
//       default:
//         return Colors.orange;
//     }
//   }
// }
