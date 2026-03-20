import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

import '../../bottomBar/bottomBar.dart';
import '../../myBooking/ui/myBookingScreen.dart';
import '../../start_ride/ui/start_ride_screen.dart';
import '../../trip_cancellation/ui/trip_cancellation.dart';
import '../provider/newBookingProvider.dart';
import 'package:provider/provider.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NewBookingProvider>().getNewBooking(context: context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<NewBookingProvider>(
      builder: (context, provider, child) {

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final booking = provider.newBookingModel?.data?.isNotEmpty == true
            ? provider.newBookingModel!.data!.first
            : null;

        /// 🔥 Fallback values
        final title = booking?.segment?.name ?? "Airport Taxi – Terminal 3";
        final dateTime = booking?.scheduledAtIST ?? "Oct 24, 2023 • 10:30 AM";
        final price = booking?.estimatedFare ?? 850;
        final bookingType = booking?.bookingType ?? "One Way";
        final vehicleNo = booking?.vehicle?.carNumber ?? "DL 1C AB 1234";
        final vehicleModel = booking?.vehicle?.model ?? "Mercedes E-Class";

        return Column(
          children: [
            CustomImageView(
              imagePath: AppImages.banner,
              height: 150,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: (){
                navPush(context: context, action: MyBookingScreen(id:booking!.sId.toString() ,));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                        //    margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorResource.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔹 Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(title,
                                size: 18,
                                weight: FontWeight.w700,
                                color: ColorResource.black),

                            const SizedBox(height: 8),

                            CustomText(dateTime,
                                size: 14,
                                weight: FontWeight.w500,
                                color: ColorResource.grayText),
                          ],
                        ),

                        CustomText("₹$price",
                            size: 22,
                            weight: FontWeight.w700,
                            color: ColorResource.green),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const Divider(),

                    /// 🔹 Booking Info
                    const SizedBox(height: 10),
                    CustomText("BOOKING INFO",
                        size: 14,
                        weight: FontWeight.w400,
                        color: ColorResource.grayText),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// LEFT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText("BOOKING TYPE",
                                size: 12,
                                weight: FontWeight.w700,
                                color: ColorResource.grayText),

                            CustomText(bookingType,
                                size: 16,
                                weight: FontWeight.w700,
                                color: ColorResource.black),

                            const SizedBox(height: 10),

                            CustomText("OTP",
                                size: 12,
                                weight: FontWeight.w700,
                                color: ColorResource.grayText),

                            CustomText(
                              booking?.otp ?? "1234",
                              size: 16,
                              weight: FontWeight.w700,
                              color: ColorResource.black,
                            ),
                          ],
                        ),

                        /// RIGHT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText("Vehicle No",
                                size: 12,
                                weight: FontWeight.w700,
                                color: ColorResource.grayText),

                            CustomText(vehicleNo,
                                size: 16,
                                weight: FontWeight.w700,
                                color: ColorResource.black),

                            const SizedBox(height: 10),

                            CustomText("STATUS",
                                size: 12,
                                weight: FontWeight.w700,
                                color: ColorResource.grayText),

                            CustomText(
                              booking?.tripStatus ?? "Pending",
                              size: 16,
                              weight: FontWeight.w700,
                              color: ColorResource.black,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const Divider(),

                    /// 🔹 Pickup & Drop
                    const SizedBox(height: 10),

                    CustomText("ROUTE",
                        size: 14,
                        weight: FontWeight.w400,
                        color: ColorResource.grayText),

                    const SizedBox(height: 8),

                    CustomText(
                      "Pickup: ${booking?.pickup?.address ?? "Noida Sector 63"}",
                      size: 14,
                      weight: FontWeight.w500,
                      color: ColorResource.black,
                    ),

                    CustomText(
                      "Drop: ${booking?.dropoff?.address ?? "Delhi Airport"}",
                      size: 14,
                      weight: FontWeight.w500,
                      color: ColorResource.black,
                    ),

                    const SizedBox(height: 15),
                    const Divider(),

                    /// 🔹 Vehicle
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Vehicle Model",
                            size: 14,
                            color: ColorResource.grayText),

                        CustomText(vehicleModel,
                            size: 14,
                            color: ColorResource.black),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        button(
                          title: "Cancel",
                          color: ColorResource.red,
                          onTap: () {
                          //   navPush(
                          //       context: context,
                          //       action: TripCancellationScreen());
                          },
                        ),
                        button(
                          title: "Accept",
                          color: ColorResource.green,
                          onTap: () {
                            // navPush(
                            //     context: context,
                            //     action: StartRideScreen());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
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
}
