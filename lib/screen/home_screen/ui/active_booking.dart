import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/util/image_resource/image_resource.dart';
import 'package:mann_fleet_driver/widget/customImageView.dart';
import 'package:mann_fleet_driver/widget/custom_text.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

import '../../start_ride/ui/start_ride_screen.dart';
import '../../trip_cancellation/ui/trip_cancellation.dart';
class ActiveBookingScreen extends StatefulWidget {
  const ActiveBookingScreen({super.key});

  @override
  State<ActiveBookingScreen> createState() => _ActiveBookingScreenState();
}

class _ActiveBookingScreenState extends State<ActiveBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImageView(
          imagePath: AppImages.banner,
          height: 150,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10,),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: ColorResource.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Airport Taxi – Terminal 3',
                        size: 18,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          CustomImageView(
                            imagePath: AppImages.calender,
                            height: 12,
                            width: 12,
                          ),
                          SizedBox(width: 5,),
                          CustomText(
                            'Oct 24, 2023 • 10:30 AM',
                            size: 14,
                            weight: FontWeight.w500,
                            color: ColorResource.grayText,
                          )
                        ],
                      )
                    ],
                  ),
                  CustomText(
                    '₹850',
                    size: 22,
                    weight: FontWeight.w700,
                    color: ColorResource.green,
                  )
                ],
              ),
              SizedBox(height: 15,),
              Divider(
                height: 1,
                color: ColorResource.grayText.withOpacity(0.2),
              ),
              SizedBox(height: 15,),
              CustomText(
                'BOOKING INFO',
                size: 14,
                weight: FontWeight.w400,
                color: ColorResource.grayText,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'BOOKING TYPE',
                        size: 12,
                        weight: FontWeight.w700,
                        color: ColorResource.grayText,
                      ),
                      CustomText(
                        'One Way',
                        size: 16,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                        'REMARKS',
                        size: 12,
                        weight: FontWeight.w700,
                        color: ColorResource.grayText,
                      ),
                      SizedBox(height: 5,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: ShapeDecoration(
                          color: ColorResource.greenBackGround,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0x3312C60F),
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: CustomText(
                          'VVIP',
                          size: 10,
                          weight: FontWeight.w700,
                          color: ColorResource.green,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Vehicle No',
                        size: 12,
                        weight: FontWeight.w700,
                        color: ColorResource.grayText,
                      ),
                      CustomText(
                        'DL 1C AB 1234',
                        size: 16,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                        'WAITING TIME',
                        size: 12,
                        weight: FontWeight.w700,
                        color: ColorResource.grayText,
                      ),
                      CustomText(
                        '12 Mins',
                        size: 16,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Divider(
                height: 1,
                color: ColorResource.grayText.withOpacity(0.2),
              ),
              SizedBox(height: 15,),
              CustomText(
                'FARE BREAKDOWN',
                size: 14,
                weight: FontWeight.w400,
                color: ColorResource.grayText,
              ),
              SizedBox(height: 15,),
              activeCard(
                title: 'Base Fare',
                price: 500.00,
              ),
              SizedBox(height: 10,),
              activeCard(
                title: 'Tolls & Parking',
                price: 100.00,
              ),
              SizedBox(height: 10,),
              activeCard(
                title: 'Night Charges',
                price: 5000.0,
              ),
              SizedBox(height: 10,),
              activeCard(
                title: 'GST (5%)',
                price: 0.00,
              ),
              SizedBox(height: 15,),
              Divider(
                height: 1,
                color: ColorResource.grayText.withOpacity(0.2),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'VEHICLE MODEL',
                    size: 14,
                    weight: FontWeight.w400,
                    color: ColorResource.grayText,
                  ),
                  CustomText(
                    'VEHICLE MODEL',
                    size: 14,
                    weight: FontWeight.w400,
                    color: ColorResource.grayText,
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Mercedes E-Class',
                    size: 14,
                    weight: FontWeight.w500,
                    color: ColorResource.grayText,
                  ),
                  CustomText(
                    'DL 1C AB 1234',
                    size: 14,
                    weight: FontWeight.w500,
                    color: ColorResource.grayText,
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  button(
                      title: 'Cancel',
                      onTap: (){
                        navPush(context: context, action: TripCancellationScreen(bookingId: "sdfrsdr",));
                      },
                      color: ColorResource.red
                  ),
                  button(
                      title: 'Accept',
                      onTap: (){
                        navPush(context: context, action: StartRideScreen());
                      },
                      color: ColorResource.green
                  )
                ],
              )
            ],
          ),
        )
      ],
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