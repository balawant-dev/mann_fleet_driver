// booking_card.dart

import 'package:flutter/material.dart';
import '../../../util/color/app_colors.dart';
import '../../../widget/custom_text.dart';

class BookingCard extends StatelessWidget {
  // All data passed from parent
  final String title;
  final String dateTime;
  final String price;
  final String bookingType;
  final String vehicleNo;
  final String vehicleModel;
  final String bookingId;
  final String driverStatus;
  final String pickupAddress;
  final String dropAddress;
  final String tripStatus;
  final String color;
  final VoidCallback onCardTap;
  final Widget button;

  const BookingCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.price,
    required this.bookingType,
    required this.vehicleNo,
    required this.vehicleModel,
    required this.bookingId,
    required this.color,
    required this.driverStatus,
    required this.tripStatus,
    required this.pickupAddress,
    required this.dropAddress,
    required this.onCardTap,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // ← Changed: Soft elegant background
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
                        title,
                        size: 18,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        dateTime,
                        size: 14,
                        weight: FontWeight.w500,
                        color: ColorResource.grayText,
                      ),
                    ],
                  ),
                ),
                // CustomText(
                //   "₹$price",
                //   size: 22,
                //   weight: FontWeight.w700,
                //   color: ColorResource.green,
                // ),
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
                      bookingType.toUpperCase(),
                      size: 14,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                    const SizedBox(height: 10),
                    //tripStatus
                    CustomText(
                      "TRIP STATUS",
                      size: 12,
                      weight: FontWeight.w500,
                      color: ColorResource.grayText,
                    ),
                    CustomText(
                      tripStatus.toUpperCase(),
                      size: 14,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Vehicle
                    CustomText(
                      "VEHICLE NO",
                      size: 12,
                      weight: FontWeight.w500,
                      color: ColorResource.grayText,
                    ),
                    CustomText(
                      vehicleNo,
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

            RichText(
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
                    text: pickupAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorResource.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            RichText(
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
                    text: dropAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorResource.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
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
                CustomText(vehicleModel, size: 14, color: ColorResource.black),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText("Color", size: 14, color: ColorResource.grayText),
                CustomText(color, size: 14, color: ColorResource.black),
              ],
            ),

            const SizedBox(height: 20),
            button,

            // Action Buttons will be added from parent screen
            // We will leave space here or you can pass a child widget if needed
          ],
        ),
      ),
    );
  }
}
