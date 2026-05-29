import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';

import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';

import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

import '../../../widget/empty/noAssignedBookingScreen.dart';
import '../../../widget/motionToastHelper.dart';
import '../../bookingDetail/ui/bookingDetailScreen.dart';


import '../../trip_cancellation/ui/trip_cancellation.dart';
import '../component/bookingCard.dart';
import '../provider/newBookingProvider.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  int currentIndex = 0;
  double?currentLat;
  double?currentLng;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Future.microtask(() {
      context.read<NewBookingProvider>().getBannerApi(context: context);
      context.read<NewBookingProvider>().getNewBooking(context: context);
    });
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
  @override
  Widget build(BuildContext context) {

    return Consumer<NewBookingProvider>(
      builder: (context, provider, child) {
        if (provider.newBookingModel==null||provider.newBookingModel!.data==null) {
          return  SizedBox(
            height:MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width,
            child: Center(child:     ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/upcommingBooking.gif",
              ),
            ),),
          );
        }
        // if (provider.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final bookings = provider.newBookingModel?.data ?? [];

        if (bookings.isEmpty) {
          return NoAssignedBookingScreen(onRefresh: (){
            context.read<NewBookingProvider>().getBannerApi(context: context);
            context.read<NewBookingProvider>().getNewBooking(context: context);
          },);
          //return const Center(child: Text("No bookings available"));
        }
        final banners = provider.getBannerModel?.data ?? [];

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (provider.getBannerModel != null &&
                      provider.getBannerModel!.data!.isNotEmpty)
                    Column(
                      children: [
                        CarouselSlider(
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
                          items: provider.getBannerModel!.data!.map((item) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CustomImageView(
                                imagePath: item.image,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                imageType: ImageType.network,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(banners.length, (index) {
                            bool isActive = index == currentIndex;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: isActive ? 20 : 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? ColorResource.primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }),
                        ),

                        // AnimatedSmoothIndicator(
                        //   activeIndex: currentIndex,
                        //   count: provider.getBannerModel!.data!.length,
                        //   effect: ExpandingDotsEffect(
                        //     dotHeight: 8,
                        //     dotWidth: 8,
                        //     expansionFactor: 3,
                        //     spacing: 6,
                        //     radius: 20,
                        //     dotColor: Colors.grey.shade300,
                        //     activeDotColor: ColorResource.indigo,
                        //   ),
                        // ),
                      ],
                    ),

                  // const SizedBox(height: 10),

                //   CustomImageView(
                //   //                  imagePath: AppImages.banner,
                //   imagePath: provider.getBannerModel!.data!.first.image,
                //   height: 150,
                //   width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.cover,
                // ),

                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                            // final booking = bookings[index];

                            final title = booking.segment?.name ?? "Airport Taxi – Terminal 3";
                            final dateTime = booking.scheduledAtIST ?? "Oct 24, 2023 • 10:30 AM";
                            final price = booking.estimatedFare ?? 850;
                            final bookingType = booking.bookingType ?? "One Way";
                            final vehicleNo = "DL 1C AB 1234";
                            final vehicleModel = booking.vehicle?.model ?? "Mercedes E-Class";
                            final bookingId = booking.id ?? "";
                            final driverStatus = booking.driverResponse?.status ?? "pending";
                            print(bookings[index].tripEndOtpVerify);//ye bool value hai
                            print(bookings[index].tripStartOtpVerify);//ye bool value hai ok
                            print(bookings[index].tripStatus); // if trip status arrived hoga tab start ride wal botton hit hoga  jaise in progress hoga to type end otp wala hit hoga ok//enum: ["not_started","driver_enroute","arrived","in_progress","completed","cancelled",],

                      //

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: BookingCard(
                          title: booking.segment?.name ?? "Airport Taxi – Terminal 3",
                          dateTime: booking.scheduledAtIST ?? "Oct 24, 2023 • 10:30 AM",
                          price: booking.estimatedFare.toString() ,
                          bookingType: booking.bookingType ?? "One Way",
                          vehicleNo: "DL 1C AB 1234",
                          vehicleModel: booking.vehicle?.model ?? "Mercedes E-Class",
                          color: booking.vehicle?.color ?? "White",
                          bookingId: booking.id?.toString() ?? "",
                          driverStatus: booking.driverResponse?.status ?? "pending",
                          tripStatus:  booking.tripStatus ??  "Not Started",
                          pickupAddress: booking.pickup?.address ?? "Noida Sector 63",
                          dropAddress: booking.dropoff?.address ?? "Delhi Airport",


                          onCardTap: () {
                            navPush(
                              context: context,
                              action: BookingDetailScreen(id: booking.id.toString()),
                            );
                          },
                          button:                      buildActionButtons(
                                                status: driverStatus,
                                                tripStatus: booking.tripStatus ?? "",
                                                bookingId: bookingId,
                                                provider: provider,
                                                isStartOtpVerified: booking.tripStartOtpVerify ?? false,
                                                isEndOtpVerified: booking.tripEndOtpVerify ?? false,
                                              ),
                        ),
                      );
                    },
                  )

                ],
              ),
            ),
            if (provider.isLoading)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  minHeight: 3,
                ),
              ),
          ],
        );
      },
    );
  }
  Widget button({
    required String title,
    required VoidCallback onTap,
    Color? color,
  }){
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
  Widget activeCard({
    required String title,
    required double price,
  }){
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
        )
      ],
    );
  }

  Widget buildActionButtons({
    required String status, // driverStatus
    required String tripStatus,
    required String bookingId,
    required NewBookingProvider provider,
    required bool isStartOtpVerified,
    required bool isEndOtpVerified,
  }) {

    /// 🔹 1. PENDING → CANCEL + ACCEPT
    if (status == "pending") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button(
            title: "Cancel",
            color: Colors.red,
            onTap: () {
              navPush(
                context: context,
                action: TripCancellationScreen(
                  bookingNumber: provider.newBookingModel?.data
                      ?.firstWhere((e) => e.id.toString() == bookingId)
                      .bookingNumber,
                  bookingId: bookingId,
                  pickupAddress: provider.newBookingModel?.data
                      ?.firstWhere((e) => e.id.toString() == bookingId)
                      .pickup?.address,
                  dropoffAddress: provider.newBookingModel?.data
                      ?.firstWhere((e) => e.id.toString() == bookingId)
                      .dropoff?.address,
                  bookingDateTime: provider.newBookingModel?.data
                      ?.firstWhere((e) => e.id.toString() == bookingId)
                      .scheduledAtIST,
                  fareEstimate: provider.newBookingModel?.data
                      ?.firstWhere((e) => e.id.toString() == bookingId)
                      .estimatedFare
                      ?.toString(),
                  passengerInfo: provider.newBookingModel?.data
                      ?.firstWhere((e) => e.id.toString() == bookingId)
                      .user?.name,
                ),
              );
            },
          ),
          // button(
          //   title: "Cancel",
          //   color: Colors.red,
          //   onTap: () => showCancelDialog(bookingId),
          // ),
          button(
            title: "Accept",
            color: Colors.green,
            onTap: () async {
              bool success = await provider.acceptBookingApi(
                context: context,
                id: bookingId,
                currentLng:currentLng??0.0 ,currentLat: currentLat??0.0,
              );

              if (success) {
                ToastHelper.show(
                  context,
                  message:"Booking Accepted ✅",
                  type: ToastType.success,
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text("Booking Accepted ✅")),
                // );
              }
            },
          ),
        ],
      );
    }

    /// 🔹 2. ACCEPTED → START OTP
  if (status == "accepted") {
      return Center(
        child: button(
          title: "Go to Detail",
          color: Colors.blue,
          onTap: () {

            navPush(
              context: context,
              action: BookingDetailScreen(id: bookingId),
            );
            provider.updateDriverLocationApi(id: bookingId,lng: currentLng??0.0,lat: currentLat??0.0,context: context);
          },
        ),
      );
    }
    // if (status == "accepted" && !isStartOtpVerified) {
    //   return Center(
    //     child: button(
    //       title: "Verify Start OTP",
    //       color: Colors.orange,
    //       onTap: () => showOtpDialog(bookingId, "start"),
    //     ),
    //   );
    // }

    /// 🔹 3. DRIVER ARRIVED → START RIDE
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
                message:"Trip Started 🚗",
                type: ToastType.success,
              );
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("Trip Started 🚗")),
              // );
            }
          },
        ),
      );
    }

    /// 🔹 4. TRIP IN PROGRESS → END OTP
    if (tripStatus == "in_progress" && !isEndOtpVerified) {
      return Center(
        child: button(
          title: "Verify End OTP",
          color: Colors.blue,
          onTap: () => showOtpDialog(bookingId, "end"),
        ),
      );
    }

    /// 🔹 5. COMPLETED
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

    /// 🔹 6. CANCELLED
    if (tripStatus == "cancelled") {
      return const Center(
        child: Text(
          "Trip Cancelled ❌",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
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
          title: const Text("Cancel Booking",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: "Enter reason",
            ),
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

                context.read<NewBookingProvider>()
                    .getNewBooking(context: context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }



  /// 🔢 OTP DIALOG
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
