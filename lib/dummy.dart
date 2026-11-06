//
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mann_fleet_driver/screen/corporateBookings/pro/corporate_booking_provider.dart';
// import 'package:mann_fleet_driver/screen/fuel_entry/service/open_ai_service.dart';
// import 'package:mann_fleet_driver/util/color/app_colors.dart';
// import 'package:pinput/pinput.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../widget/commonAppBar.dart';
// import '../../../widget/motionToastHelper.dart';
//
// class CorporateBookingDetailScreen extends StatefulWidget {
//   final String bookingId;
//
//   const CorporateBookingDetailScreen({super.key, required this.bookingId});
//
//   @override
//   State<CorporateBookingDetailScreen> createState() =>
//       _CorporateBookingDetailScreenState();
// }
//
// class _CorporateBookingDetailScreenState
//     extends State<CorporateBookingDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<CorporateBookingProvider>().fetchBookingDetail(
//         context,
//         widget.bookingId,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: CommonAppBar(title: 'Booking Detail'),
//       // appBar: AppBar(
//       //   title: const Text('Booking Detail'),
//       //   centerTitle: true,
//       //   elevation: 0,
//       // ),
//       body: Consumer<CorporateBookingProvider>(
//         builder: (context, provider, _) {
//           if (provider.isDetailLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.bookingDetail == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     provider.errorMessage ?? 'Failed to load details',
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed:
//                         () => provider.fetchBookingDetail(
//                       context,
//                       widget.bookingId,
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final d = provider.bookingDetail!;
//           final tripType = d.tripType.toLowerCase();
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ========== STATUS ==========
//                 _sectionCard(
//                   title: 'Status',
//                   children: [
//                     _detailRow('Overall', d.overallStatus),
//                     _detailRow('Trip Status', d.tripStatus),
//                     _detailRow('Assignment', d.assignmentStatus),
//                     // _detailRow('Billing', d.billingStatus),
//                     _detailRow('Driver Response', d.driverResponse.status),
//                   ],
//                 ),
//
//                 // ========== BOOKING INFO ==========
//                 _sectionCard(
//                   title: 'Booking Info',
//                   children: [
//                     _detailRow('Booking No', d.bookingNumber),
//                     _detailRow(
//                       'Corporate Booking No',
//                       d.corporateBookingNumber,
//                     ),
//                     _detailRow('Agreement Code', d.agreementCode),
//                     _detailRow('Trip Type', d.tripType),
//                     _detailRow('Scheduled At', d.scheduledAtIST),
//                     _detailRow('Passengers', '${d.numberofPassangers}'),
//                     _detailRow(
//                       'Remark',
//                       d.bookingRemark.isEmpty ? '-' : d.bookingRemark,
//                     ),
//                   ],
//                 ),
//
//                 if (d.guestDetail != null)
//                   _sectionCard(
//                     title: 'Guest Details',
//                     children: [
//                       _detailRow('Name', d.guestDetail?.name ?? '-'),
//                       _detailRow('Email', d.guestDetail?.email ?? '-'),
//                       _detailRow('Phone', '${d.guestDetail?.phone ?? '-'}'),
//                     ],
//                   ),
//                 if (d.user != null)
//                   _sectionCard(
//                     title: 'User Details',
//                     children: [
//                       _detailRow('Name', d.user?.name ?? '-'),
//                       _detailRow('Email', d.user?.email ?? '-'),
//                       _detailRow('Phone', '${d.user?.mobile ?? '-'}'),
//                     ],
//                   ),
//
//                 // ========== CORPORATE ==========
//                 _sectionCard(
//                   title: 'Corporate',
//                   children: [
//                     _detailRow('Company', d.corporate.companyName),
//                     _detailRow('Code', d.corporate.companyCode),
//                     _detailRow('Booker', d.booker.name),
//                     _detailRow('Booker Mobile', d.booker.mobile),
//                   ],
//                 ),
//
//                 // ========== VEHICLE ==========
//                 _sectionCard(
//                   title: 'Vehicle',
//                   children: [
//                     _detailRow('Brand', d.vehicle.brand),
//                     _detailRow('Model', d.vehicle.model),
//                     _detailRow('Car Number', d.vehicle.carNumber),
//                   ],
//                 ),
//
//                 // ========== LOCATIONS ==========
//                 _sectionCard(
//                   title: 'Locations',
//                   children: [
//                     // Pickup - only show if not null
//                     if (d.pickup?.lat != null && d.pickup?.lng != null)
//                       GestureDetector(
//                         onTap: () {
//                           _openMapsNavigation(
//                             destLat: d.pickup!.lat!.toDouble(),
//                             destLng: d.pickup!.lng!.toDouble(),
//                             label: d.pickup?.address,
//                           );
//                         },
//                         child: _detailRow('Pickup', d.pickup?.address ?? 'N/A'),
//                       ),
//
//                     // Dropoff - only show if not null
//                     if (d.dropoff?.lat != null && d.dropoff?.lng != null)
//                       GestureDetector(
//                         onTap: () {
//                           _openMapsNavigation(
//                             destLat: d.dropoff!.lat!.toDouble(),
//                             destLng: d.dropoff!.lng!.toDouble(),
//                             label: d.dropoff?.address,
//                           );
//                         },
//                         child: _detailRow('Dropoff', d.dropoff?.address ?? 'N/A'),
//                       ),
//                   ],
//                 ),
//
//                 // ========== PACKAGE ==========
//                 if (d.agreement.packageSnapshot.packageName.isNotEmpty)
//                   _sectionCard(
//                     title: 'Package',
//                     children: [
//                       _detailRow(
//                         'Package Name',
//                         d.agreement.packageSnapshot.packageName,
//                       ),
//                       _detailRow(
//                         'Hours',
//                         '${d.agreement.packageSnapshot.hours}',
//                       ),
//                       _detailRow(
//                         'Included KMs',
//                         '${d.agreement.packageSnapshot.includedKms}',
//                       ),
//                       _detailRow(
//                         'Base Fare',
//                         '₹${d.agreement.packageSnapshot.baseFare}',
//                       ),
//                       _detailRow(
//                         'Fix Amount',
//                         '₹${d.agreement.packageSnapshot.fixAmount}',
//                       ),
//                       _detailRow(
//                         'Extra / Km',
//                         '₹${d.agreement.packageSnapshot.extraPerKm}',
//                       ),
//                       _detailRow(
//                         'Driver Charge',
//                         '₹${d.agreement.packageSnapshot.driverCharge}',
//                       ),
//                     ],
//                   ),
//
//                 // ========== OTP ==========
//                 // _sectionCard(
//                 //   title: 'OTP',
//                 //   children: [
//                 //     _detailRow('Start OTP', d.tripStartOtp),
//                 //     _detailRow('End OTP', d.tripEndOtp),
//                 //     _detailRow(
//                 //       'Start Verified',
//                 //       d.tripStartOtpVerify ? 'Yes' : 'No',
//                 //     ),
//                 //     _detailRow(
//                 //       'End Verified',
//                 //       d.tripEndOtpVerify ? 'Yes' : 'No',
//                 //     ),
//                 //   ],
//                 // ),
//                 const SizedBox(height: 8),
//
//                 // ========== ACCEPT / REJECT ==========
//                 if (d.driverResponse.status == 'pending') ...[
//                   _actionButton(
//                     label: 'Accept Booking',
//                     color: Colors.green,
//                     isLoading: provider.isResponding,
//                     onPressed: () async {
//                       final position = await Geolocator.getCurrentPosition(
//                         desiredAccuracy: LocationAccuracy.high,
//                       );
//
//                       final success = await provider.acceptBooking(
//                         context: context,
//                         bookingId: widget.bookingId,
//                         currentLat: position.latitude,
//                         currentLng: position.longitude,
//                       );
//
//                       if (success && context.mounted) {
//                         ToastHelper.show(
//                           context,
//                           message: "Booking Accepted",
//                           type: ToastType.success,
//                         );
//                         // _showSnack(context, 'Booking Accepted', Colors.green);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   _actionButton(
//                     label: 'Reject Booking',
//                     color: Colors.red,
//                     isOutlined: true,
//                     isLoading: provider.isResponding,
//                     onPressed: () async {
//                       final success = await provider.rejectBooking(
//                         context,
//                         d.id,
//                       );
//                       if (success && context.mounted) {
//                         ToastHelper.show(
//                           context,
//                           message: "Booking Rejected",
//                           type: ToastType.error,
//                         );
//                         // _showSnack(context, 'Booking Rejected', Colors.red);
//                         Navigator.pop(context);
//                       }
//                     },
//                   ),
//                 ],
//
//                 // ========== TRIP ACTION BUTTONS (Garage to Garage) ==========
//                 if (tripType == 'garage to garage') ...[
//                   // 1. Garage Start
//                   if (d.tripStatus == 'driver_enroute')
//                     _actionButton(
//                       label: 'Garage Start',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isGarageStarting,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isGarageStarting,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Garage Start',
//                         submitLabel: 'Submit Garage Start',
//                         successMessage: 'Garage Start successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.garageStart(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   if (d.tripStatus == 'garage_started'&&d.tripStartOtpVerify==false) // ya jo status aapke backend me start OTP ke liye ho
//                     _actionButton(
//                       label: 'Verify Start OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyStartOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify Start OTP',
//                         successMessage: 'Start OTP verified successfully',
//                         isLoading: provider.isVerifyStartOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyStartOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//
//
//
//                   ////Balawant add this
//
//                   // 2. Pickup Checkpoint
//                   if (d.tripStatus == 'garage_started'&&d.tripStartOtpVerify==true)
//                     _actionButton(
//                       label: 'Pickup Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isPickupCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         context: context,
//                         isLoading: provider.isPickupCheckpoint,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Pickup Checkpoint',
//                         submitLabel: 'Submit Pickup Checkpoint',
//                         successMessage: 'Pickup Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.pickupCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 3. Start Ride (after arrived)
//                   if (d.tripStatus == 'arrived')
//                     _actionButton(
//                       label: 'Start Ride',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isStartRide,
//                       onPressed: () async {
//                         final success = await provider.startRide(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Start Ride successful',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Start Ride successful',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: provider.errorMessage ?? 'Failed',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
//
//
//                   // ★ END OTP (Drop se pehle)
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==false)
//                     _actionButton(
//                       label: 'Verify End OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyEndOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify End OTP',
//                         successMessage: 'End OTP verified successfully',
//                         isLoading: provider.isVerifyEndOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyEndOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 4. Drop Checkpoint
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==true)
//                     _actionButton(
//                       label: 'Drop Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isDropCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isDropCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Drop Checkpoint',
//                         submitLabel: 'Submit Drop Checkpoint',
//                         successMessage: 'Drop Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.dropCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 5. Garage End
//                   if (d.tripStatus == 'returning_garage')
//                     _actionButton(
//                       label: 'Garage End',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isGarageEnd,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isGarageEnd,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Garage End',
//                         submitLabel: 'Submit Garage End',
//                         successMessage: 'Garage End successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.garageEndApi(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 6. Extra Charges (after dropped)
//                   if (d.tripStatus == 'dropped')
//                     _actionButton(
//                       label: 'Add Extra Charges',
//                       color: Colors.deepOrange,
//                       isLoading: provider.isGarageEnd,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed:
//                           () => _showExtraChargeSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                       ),
//                     ),
//                   if (d.tripStatus == 'dropped')
//                     _actionButton(
//                       label: 'Complete Trip',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isCompleteTrip,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed: () async {
//                         final success = await provider.completeTripApi(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Complete trip successfully',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Complete trip successfully',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message:
//                             provider.errorMessage ??
//                                 'Failed to complete trip',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed to complete trip',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
//                 ],
//
//                 if (tripType == 'pickup to garage') ...[
//                   if (d.tripStatus == 'driver_enroute'&&d.tripStartOtpVerify==false)
//                     _actionButton(
//                       label: 'Verify Start OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyStartOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify Start OTP',
//                         successMessage: 'Start OTP verified successfully',
//                         isLoading: provider.isVerifyStartOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyStartOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//                   // 1. Garage Start
//                   // if (d.tripStatus == 'driver_enroute')
//                   //   _actionButton(
//                   //     label: 'Garage Start',
//                   //     color: ColorResource.primaryColor,
//                   //     isLoading: provider.isGarageStarting,
//                   //     onPressed: () => _showOdometerSheet(
//                   //       context: context,
//                   //       provider: provider,
//                   //       bookingId: d.id,
//                   //       title: 'Garage Start',
//                   //       submitLabel: 'Submit Garage Start',
//                   //       successMessage: 'Garage Start successful',
//                   //       onSubmit: (odometer, lat, lng, image) {
//                   //         return provider.garageStart(
//                   //           context: context,
//                   //           bookingId: d.id,
//                   //           odometer: odometer,
//                   //           currentLat: lat,
//                   //           currentLng: lng,
//                   //           odometerImage: image,
//                   //         );
//                   //       },
//                   //     ),
//                   //   ),
//
//                   // 2. Pickup Checkpoint
//                   if (d.tripStatus == 'driver_enroute'&&d.tripStartOtpVerify==true)
//                     _actionButton(
//                       label: 'Pickup Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isPickupCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isPickupCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Pickup Checkpoint',
//                         submitLabel: 'Submit Pickup Checkpoint',
//                         successMessage: 'Pickup Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.pickupCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 3. Start Ride (after arrived)
//                   if (d.tripStatus == 'arrived')
//                     _actionButton(
//                       label: 'Start Ride',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isStartRide,
//                       onPressed: () async {
//                         final success = await provider.startRide(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Start Ride successful',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Start Ride successful',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: provider.errorMessage ?? 'Failed',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
//
//
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==false)
//                     _actionButton(
//                       label: 'Verify End OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyEndOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify End OTP',
//                         successMessage: 'End OTP verified successfully',
//                         isLoading: provider.isVerifyEndOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyEndOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 4. Drop Checkpoint
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==true)
//                     _actionButton(
//                       label: 'Drop Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isDropCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isDropCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Drop Checkpoint',
//                         submitLabel: 'Submit Drop Checkpoint',
//                         successMessage: 'Drop Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.dropCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 5. Garage End
//                   if (d.tripStatus == 'returning_garage')
//                     _actionButton(
//                       label: 'Garage End',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isGarageEnd,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isGarageEnd,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Garage End',
//                         submitLabel: 'Submit Garage End',
//                         successMessage: 'Garage End successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.garageEndApi(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 6. Extra Charges (after dropped)
//                   if (d.tripStatus == 'dropped')
//                     _actionButton(
//                       label: 'Add Extra Charges',
//                       color: Colors.deepOrange,
//                       isLoading: provider.isGarageEnd,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed:
//                           () => _showExtraChargeSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                       ),
//                     ),
//                   if (d.tripStatus == 'dropped')
//                     _actionButton(
//                       label: 'Complete Trip',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isCompleteTrip,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed: () async {
//                         final success = await provider.completeTripApi(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Complete trip successfully',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Complete trip successfully',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message:
//                             provider.errorMessage ??
//                                 'Failed to complete trip',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed to complete trip',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
//                 ],
//                 if (tripType == 'pickup to destination') ...[
//                   // ★ START OTP
//                   if (d.tripStatus == 'driver_enroute'&&d.tripStartOtpVerify==false)
//                     _actionButton(
//                       label: 'Verify Start OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyStartOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify Start OTP',
//                         successMessage: 'Start OTP verified successfully',
//                         isLoading: provider.isVerifyStartOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyStartOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//
//                   if (d.tripStatus == 'driver_enroute'&&d.tripStartOtpVerify==true)
//                     _actionButton(
//                       label: 'Pickup Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isPickupCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isPickupCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Pickup Checkpoint',
//                         submitLabel: 'Submit Pickup Checkpoint',
//                         successMessage: 'Pickup Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.pickupCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 3. Start Ride (after arrived)
//                   if (d.tripStatus == 'arrived')
//                     _actionButton(
//                       label: 'Start Ride',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isStartRide,
//                       onPressed: () async {
//                         final success = await provider.startRide(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Start Ride successful',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Start Ride successful',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: provider.errorMessage ?? 'Failed',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
// // ★ END OTP
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==false)
//                     _actionButton(
//                       label: 'Verify End OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyEndOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify End OTP',
//                         successMessage: 'End OTP verified successfully',
//                         isLoading: provider.isVerifyEndOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyEndOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//                   // 4. Drop Checkpoint
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==true)
//                     _actionButton(
//                       label: 'Drop Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isDropCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isDropCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Drop Checkpoint',
//                         submitLabel: 'Submit Drop Checkpoint',
//                         successMessage: 'Drop Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.dropCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 5. Garage End
//                   // if (d.tripStatus == 'returning_garage')
//                   //   _actionButton(
//                   //     label: 'Garage End',
//                   //     color: ColorResource.primaryColor,
//                   //     isLoading: provider.isGarageEnd,
//                   //     onPressed: () => _showOdometerSheet(
//                   //       context: context,
//                   //       provider: provider,
//                   //       bookingId: d.id,
//                   //       title: 'Garage End',
//                   //       submitLabel: 'Submit Garage End',
//                   //       successMessage: 'Garage End successful',
//                   //       onSubmit: (odometer, lat, lng, image) {
//                   //         return provider.garageEndApi(
//                   //           context: context,
//                   //           bookingId: d.id,
//                   //           odometer: odometer,
//                   //           currentLat: lat,
//                   //           currentLng: lng,
//                   //           odometerImage: image,
//                   //         );
//                   //       },
//                   //     ),
//                   //   ),
//
//                   // 6. Extra Charges (after dropped)
//                   if (d.tripStatus == 'dropped')
//                     _actionButton(
//                       label: 'Add Extra Charges',
//                       color: Colors.deepOrange,
//                       isLoading: provider.isGarageEnd,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed:
//                           () => _showExtraChargeSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                       ),
//                     ),
//                   if (d.tripStatus == 'dropped')
//                     _actionButton(
//                       label: 'Complete Trip',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isCompleteTrip,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed: () async {
//                         final success = await provider.completeTripApi(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Complete trip successfully',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Complete trip successfully',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message:
//                             provider.errorMessage ??
//                                 'Failed to complete trip',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed to complete trip',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
//                 ],
//
//                 if (tripType == 'pickup to pickup') ...[
//                   // ★ START OTP
//                   if (d.tripStatus == 'driver_enroute'&&d.tripStartOtpVerify==false)
//
//
//                     _actionButton(
//                       label: 'Verify Start OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyStartOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify Start OTP',
//                         successMessage: 'Start OTP verified successfully',
//                         isLoading: provider.isVerifyStartOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyStartOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//
//                   if (d.tripStatus == 'driver_enroute'&&d.tripStartOtpVerify==true)
//                     _actionButton(
//                       label: 'Pickup Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isPickupCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isPickupCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Pickup Checkpoint',
//                         submitLabel: 'Submit Pickup Checkpoint',
//                         successMessage: 'Pickup Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.pickupCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 3. Start Ride (after arrived)
//                   if (d.tripStatus == 'arrived')
//                     _actionButton(
//                       label: 'Start Ride',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isStartRide,
//                       onPressed: () async {
//                         final success = await provider.startRide(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Start Ride successful',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Start Ride successful',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: provider.errorMessage ?? 'Failed',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),// ★ END OTP
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==false)
//                     _actionButton(
//                       label: 'Verify End OTP',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isVerifyEndOtp,
//                       onPressed: () => _showOtpSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Verify End OTP',
//                         successMessage: 'End OTP verified successfully',
//                         isLoading: provider.isVerifyEndOtp,
//                         onSubmit: (otp) {
//                           return provider.verifyEndOtp(
//                             context: context,
//                             bookingId: d.id,
//                             otp: otp,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 4. Drop Checkpoint
//                   if (d.tripStatus == 'in_progress'&&d.tripEndOtpVerify==true)
//                     _actionButton(
//                       label: 'Drop Checkpoint',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isDropCheckpoint,
//                       onPressed:
//                           () => _showOdometerSheet(
//                         isLoading: provider.isDropCheckpoint,
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                         title: 'Drop Checkpoint',
//                         submitLabel: 'Submit Drop Checkpoint',
//                         successMessage: 'Drop Checkpoint successful',
//                         onSubmit: (odometer, lat, lng, image) {
//                           return provider.dropCheckpoint(
//                             context: context,
//                             bookingId: d.id,
//                             odometer: odometer,
//                             currentLat: lat,
//                             currentLng: lng,
//                             odometerImage: image,
//                           );
//                         },
//                       ),
//                     ),
//
//                   // 5. Garage End
//                   // if (d.tripStatus == 'returning_garage')
//                   //   _actionButton(
//                   //     label: 'Garage End',
//                   //     color: ColorResource.primaryColor,
//                   //     isLoading: provider.isGarageEnd,
//                   //     onPressed: () => _showOdometerSheet(
//                   //       context: context,
//                   //       provider: provider,
//                   //       bookingId: d.id,
//                   //       title: 'Garage End',
//                   //       submitLabel: 'Submit Garage End',
//                   //       successMessage: 'Garage End successful',
//                   //       onSubmit: (odometer, lat, lng, image) {
//                   //         return provider.garageEndApi(
//                   //           context: context,
//                   //           bookingId: d.id,
//                   //           odometer: odometer,
//                   //           currentLat: lat,
//                   //           currentLng: lng,
//                   //           odometerImage: image,
//                   //         );
//                   //       },
//                   //     ),
//                   //   ),
//
//                   // 6. Extra Charges (after dropped)
//                   if (d.tripStatus == 'returning_garage')
//                     _actionButton(
//                       label: 'Add Extra Charges',
//                       color: Colors.deepOrange,
//                       isLoading: provider.isGarageEnd,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed:
//                           () => _showExtraChargeSheet(
//                         context: context,
//                         provider: provider,
//                         bookingId: d.id,
//                       ),
//                     ),
//                   if (d.tripStatus == 'returning_garage')
//                     _actionButton(
//                       label: 'Complete Trip',
//                       color: ColorResource.primaryColor,
//                       isLoading: provider.isCompleteTrip,
//                       // or use a new flag if you have isExtraCharge
//                       onPressed: () async {
//                         final success = await provider.completeTripApi(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Complete trip successfully',
//                             type: ToastType.success,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   'Complete trip successfully',
//                           //   Colors.green,
//                           // );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message:
//                             provider.errorMessage ??
//                                 'Failed to complete trip',
//                             type: ToastType.error,
//                           );
//                           // _showSnack(
//                           //   context,
//                           //   provider.errorMessage ?? 'Failed to complete trip',
//                           //   Colors.red,
//                           // );
//                         }
//                       },
//                     ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Future<void> _showExpenseImagesSheet({
//     required BuildContext context,
//     required CorporateBookingProvider provider,
//     required String bookingId,
//   }) async {
//     List<File> selectedImages = [];
//     final picker = ImagePicker();
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom,
//               ),
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Handle
//                     Container(
//                       width: 40,
//                       height: 4,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//
//                     const Text(
//                       'Upload Expense Images (Optional)',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'You can upload up to 10 images',
//                       style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Image Grid
//                     if (selectedImages.isNotEmpty)
//                       SizedBox(
//                         height: 110,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: selectedImages.length,
//                           separatorBuilder: (_, __) => const SizedBox(width: 10),
//                           itemBuilder: (context, index) {
//                             return Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.file(
//                                     selectedImages[index],
//                                     width: 100,
//                                     height: 100,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setModalState(() {
//                                         selectedImages.removeAt(index);
//                                       });
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(4),
//                                       decoration: const BoxDecoration(
//                                         color: Colors.black54,
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Icon(
//                                         Icons.close,
//                                         size: 16,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//
//                     if (selectedImages.isNotEmpty) const SizedBox(height: 16),
//
//                     // Add Image Button
//                     if (selectedImages.length < 10)
//                       GestureDetector(
//                         onTap: () async {
//                           final picked = await picker.pickMultiImage(
//                             imageQuality: 70,
//                           );
//                           if (picked.isEmpty) return;
//
//                           setModalState(() {
//                             final remaining = 10 - selectedImages.length;
//                             final toAdd = picked.take(remaining).toList();
//                             selectedImages.addAll(
//                               toAdd.map((e) => File(e.path)).toList(),
//                             );
//                           });
//                         },
//                         child: Container(
//                           height: 50,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(12),
//                             color: Colors.grey.shade50,
//                           ),
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Add Expense Images',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                     const SizedBox(height: 24),
//
//                     // Submit + Skip
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () => Navigator.pop(ctx),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.grey.shade700,
//                               side: BorderSide(color: Colors.grey.shade300),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               minimumSize: const Size(0, 50),
//                             ),
//                             child: const Text('Skip'),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: selectedImages.isEmpty || provider.isUploadExpenseImages
//                                 ? null
//                                 : () async {
//                               Navigator.pop(ctx);
//
//                               final success = await provider.uploadExpenseImages(
//                                 context: context,
//                                 bookingId: bookingId,
//                                 expenseImages: selectedImages,
//                               );
//
//                               if (success && context.mounted) {
//                                 ToastHelper.show(
//                                   context,
//                                   message: 'Expense images uploaded successfully',
//                                   type: ToastType.success,
//                                 );
//                               } else if (context.mounted) {
//                                 ToastHelper.show(
//                                   context,
//                                   message: provider.errorMessage ?? 'Failed to upload images',
//                                   type: ToastType.error,
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepOrange,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               minimumSize: const Size(0, 50),
//                             ),
//                             child: provider.isUploadExpenseImages
//                                 ? const SizedBox(
//                               height: 22,
//                               width: 22,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.5,
//                                 color: Colors.white,
//                               ),
//                             )
//                                 : const Text(
//                               'Submit',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   // ==================== EXTRA CHARGES BOTTOM SHEET ====================
//   // ==================== EXTRA CHARGES BOTTOM SHEET ====================
//   Future<void> _showExtraChargeSheet({
//     required BuildContext context,
//     required CorporateBookingProvider provider,
//     required String bookingId,
//   }) async {
//     final tollController = TextEditingController();
//     final otherController = TextEditingController();
//     final parkingController = TextEditingController();
//     final stateController = TextEditingController();
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // important
//       backgroundColor: Colors.transparent,
//       builder: (ctx) {
//         return Padding(
//           // This pushes the sheet up when keyboard opens
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(ctx).viewInsets.bottom,
//           ),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: SingleChildScrollView(
//               // ← important so content can scroll
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Handle
//                   Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//
//                   const Text(
//                     'Extra Charges',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//
//                   _chargeField(
//                     controller: tollController,
//                     label: 'Toll Amount',
//                     icon: Icons.toll,
//                   ),
//                   const SizedBox(height: 14),
//
//                   _chargeField(
//                     controller: parkingController,
//                     label: 'Parking Charge',
//                     icon: Icons.local_parking,
//                   ),
//                   const SizedBox(height: 14),
//
//                   _chargeField(
//                     controller: stateController,
//                     label: 'State Charge',
//                     icon: Icons.map,
//                   ),
//                   const SizedBox(height: 14),
//
//                   _chargeField(
//                     controller: otherController,
//                     label: 'Other Charges',
//                     icon: Icons.more_horiz,
//                   ),
//                   const SizedBox(height: 24),
//
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         final toll = tollController.text.trim().isEmpty ? '0' : tollController.text.trim();
//                         final parking = parkingController.text.trim().isEmpty ? '0' : parkingController.text.trim();
//                         final state = stateController.text.trim().isEmpty ? '0' : stateController.text.trim();
//                         final other = otherController.text.trim().isEmpty ? '0' : otherController.text.trim();
//
//                         Navigator.pop(ctx);
//
//                         final success = await provider.extraChargeApi(
//                           context: context,
//                           bookingId: bookingId,
//                           tollAmount: toll,
//                           otherCharges: other,
//                           parkingCharge: parking,
//                           stateCharge: state,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Extra Charges added successfully',
//                             type: ToastType.success,
//                           );
//
//                           // ★ Automatically open Expense Images sheet (optional)
//                           await Future.delayed(const Duration(milliseconds: 400));
//                           if (context.mounted) {
//                             _showExpenseImagesSheet(
//                               context: context,
//                               provider: provider,
//                               bookingId: bookingId,
//                             );
//                           }
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: provider.errorMessage ?? 'Failed to add charges',
//                             type: ToastType.error,
//                           );
//                         }
//                       },
//                       // onPressed: () async {
//                       //   final toll =
//                       //       tollController.text.trim().isEmpty
//                       //           ? '0'
//                       //           : tollController.text.trim();
//                       //   final parking =
//                       //       parkingController.text.trim().isEmpty
//                       //           ? '0'
//                       //           : parkingController.text.trim();
//                       //   final state =
//                       //       stateController.text.trim().isEmpty
//                       //           ? '0'
//                       //           : stateController.text.trim();
//                       //   final other =
//                       //       otherController.text.trim().isEmpty
//                       //           ? '0'
//                       //           : otherController.text.trim();
//                       //
//                       //   Navigator.pop(ctx);
//                       //
//                       //   final success = await provider.extraChargeApi(
//                       //     context: context,
//                       //     bookingId: bookingId,
//                       //     tollAmount: toll,
//                       //     otherCharges: other,
//                       //     parkingCharge: parking,
//                       //     stateCharge: state,
//                       //   );
//                       //
//                       //   if (success && context.mounted) {
//                       //     ToastHelper.show(
//                       //       context,
//                       //       message: 'Extra Charges added successfully',
//                       //       type: ToastType.success,
//                       //     );
//                       //     // _showSnack(
//                       //     //   context,
//                       //     //   'Extra Charges added successfully',
//                       //     //   Colors.green,
//                       //     // );
//                       //   } else if (context.mounted) {
//                       //     ToastHelper.show(
//                       //       context,
//                       //       message:
//                       //           provider.errorMessage ??
//                       //           'Failed to add charges',
//                       //       type: ToastType.error,
//                       //     );
//                       //     // _showSnack(
//                       //     //   context,
//                       //     //   provider.errorMessage ?? 'Failed to add charges',
//                       //     //   Colors.red,
//                       //     // );
//                       //   }
//                       // },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepOrange,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Submit Extra Charges',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _openMapsNavigation({
//     required double destLat,
//     required double destLng,
//     String? label,
//   }) async {
//     // Google Maps navigation URL (from current location → destination)
//     final uri = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1'
//           '&destination=$destLat,$destLng'
//           '${label != null ? '&destination_place_id=&travelmode=driving' : ''}'
//           '&travelmode=driving',
//     );
//
//     // Alternative (works well on both Android & iOS):
//     // final uri = Uri.parse('google.navigation:q=$destLat,$destLng&mode=d');
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       // Fallback
//       final fallback = Uri.parse(
//         'https://www.google.com/maps/search/?api=1&query=$destLat,$destLng',
//       );
//       await launchUrl(fallback, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   Widget _chargeField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: const TextInputType.numberWithOptions(decimal: true),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 14,
//           vertical: 14,
//         ),
//       ),
//     );
//   }
//   Future<void> _showOtpSheet({
//     required BuildContext context,
//     required CorporateBookingProvider provider,
//     required String bookingId,
//     required String title,
//     required String successMessage,
//     required bool isLoading,
//     required Future<bool> Function(String otp) onSubmit,
//   }) async {
//     final otpController = TextEditingController();
//
//     // Pinput Default Theme Definition
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//         color: Colors.black,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//     );
//
//     // Active / Focused Pin Theme
//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         border: Border.all(color: ColorResource.primaryColor, width: 2),
//       ),
//     );
//
//     // Submitted Pin Theme
//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.grey.shade50,
//         border: Border.all(color: ColorResource.primaryColor),
//       ),
//     );
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(ctx).viewInsets.bottom,
//           ),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Standard TextField replaced with 4-digit Pinput
//                 Pinput(
//                   length: 4,
//                   controller: otpController,
//                   defaultPinTheme: defaultPinTheme,
//                   focusedPinTheme: focusedPinTheme,
//                   submittedPinTheme: submittedPinTheme,
//                   keyboardType: TextInputType.number,
//                   showCursor: true,
//                   // pinputAutofreq: true,
//                 ),
//
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: isLoading
//                         ? null
//                         : () async {
//                       final otp = otpController.text.trim();
//                       if (otp.isEmpty || otp.length < 4) {
//                         ToastHelper.show(
//                           context,
//                           message: 'Please enter 4-digit OTP',
//                           type: ToastType.warning,
//                         );
//                         return;
//                       }
//
//                       Navigator.pop(ctx);
//
//                       final success = await onSubmit(otp);
//
//                       if (success && context.mounted) {
//                         ToastHelper.show(
//                           context,
//                           message: successMessage,
//                           type: ToastType.success,
//                         );
//                       } else if (context.mounted) {
//                         ToastHelper.show(
//                           context,
//                           message: provider.errorMessage ?? 'Failed',
//                           type: ToastType.error,
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorResource.primaryColor,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: isLoading
//                         ? const SizedBox(
//                       height: 22,
//                       width: 22,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                         color: Colors.white,
//                       ),
//                     )
//                         : const Text(
//                       'Verify OTP',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   // ==================== REUSABLE ODOMETER BOTTOM SHEET ====================
//   Future<void> _showOdometerSheet({
//     required BuildContext context,
//     required CorporateBookingProvider provider,
//     required String bookingId,
//     required String title,
//     required String submitLabel,
//     required bool isLoading,
//     required String successMessage,
//     required Future<bool> Function(
//         String odometer,
//         double lat,
//         double lng,
//         File image,
//         ) onSubmit,
//   }) async {
//     final odometerController = TextEditingController();
//     File? selectedImage;
//     final picker = ImagePicker();
//     bool isScanning = false;
//
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//                 left: 20,
//                 right: 20,
//                 top: 16,
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Handle bar
//                   Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // ========== Odometer Field (Auto-filled + ReadOnly after scan) ==========
//
//
//                   // ========== Image Picker ==========
//                   GestureDetector(
//                     onTap: () async {
//                       final picked = await picker.pickImage(
//                         source: ImageSource.camera,
//                         imageQuality: 70,
//                       );
//                       if (picked == null) return;
//
//                       setModalState(() {
//                         selectedImage = File(picked.path);
//                         isScanning = true;
//                         odometerController.clear();
//                       });
//
//                       // Auto scan
//                       try {
//                         final double reading =
//                         await getOdometerReadingFromImageOpenAi(
//                             File(picked.path));
//
//                         setModalState(() {
//                           odometerController.text =
//                               reading.toStringAsFixed(0);
//                           isScanning = false;
//                         });
//                       } catch (e) {
//                         setModalState(() => isScanning = false);
//                         if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: e
//                                 .toString()
//                                 .replaceFirst("Exception: ", ""),
//                             type: ToastType.error,
//                           );
//                         }
//                       }
//                     },
//                     child: Container(
//                       height: 150,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(14),
//                         color: Colors.grey.shade50,
//                       ),
//                       child: selectedImage == null
//                           ? const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.camera_alt,
//                               size: 42, color: Colors.grey),
//                           SizedBox(height: 8),
//                           Text(
//                             'Tap to capture Odometer Image',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       )
//                           : ClipRRect(
//                         borderRadius: BorderRadius.circular(14),
//                         child: Image.file(
//                           selectedImage!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: odometerController,
//                     keyboardType: TextInputType.number,
//                     readOnly: false,
//                     // readOnly: selectedImage != null, // image aane ke baad edit band
//                     decoration: InputDecoration(
//                       labelText: 'Odometer Reading',
//                       prefixIcon: const Icon(Icons.speed),
//                       suffixIcon: isScanning
//                           ? const Padding(
//                         padding: EdgeInsets.all(12),
//                         child: SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                       )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       helperText: selectedImage != null
//                           ? 'Auto-filled from image (tap image to re-scan)'
//                           : 'Capture image to auto-fill',
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // ========== Submit Button ==========
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: isScanning
//                           ? null
//                           : () async {
//                         if (odometerController.text.trim().isEmpty) {
//                           ToastHelper.show(
//                             context,
//                             message: 'Please enter odometer reading',
//                             type: ToastType.warning,
//                           );
//                           return;
//                         }
//                         if (selectedImage == null) {
//                           ToastHelper.show(
//                             context,
//                             message: "Please capture odometer image",
//                             type: ToastType.warning,
//                           );
//                           return;
//                         }
//
//                         // Location check
//                         bool serviceEnabled =
//                         await Geolocator.isLocationServiceEnabled();
//                         if (!serviceEnabled) {
//                           ToastHelper.show(
//                             context,
//                             message: "Please enable location",
//                             type: ToastType.warning,
//                           );
//                           return;
//                         }
//
//                         LocationPermission permission =
//                         await Geolocator.checkPermission();
//                         if (permission == LocationPermission.denied) {
//                           permission =
//                           await Geolocator.requestPermission();
//                           if (permission == LocationPermission.denied) {
//                             ToastHelper.show(
//                               context,
//                               message: 'Location permission denied',
//                               type: ToastType.error,
//                             );
//                             return;
//                           }
//                         }
//
//                         final position =
//                         await Geolocator.getCurrentPosition(
//                           desiredAccuracy: LocationAccuracy.high,
//                         );
//
//                         Navigator.pop(ctx);
//
//                         final success = await onSubmit(
//                           odometerController.text.trim(),
//                           position.latitude,
//                           position.longitude,
//                           selectedImage!,
//                         );
//
//                         if (success && context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message: successMessage,
//                             type: ToastType.success, // pehle error tha, ab success
//                           );
//                         } else if (context.mounted) {
//                           ToastHelper.show(
//                             context,
//                             message:
//                             provider.errorMessage ?? 'Failed',
//                             type: ToastType.error,
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorResource.primaryColor,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                         height: 22,
//                         width: 22,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.5,
//                           color: Colors.white,
//                         ),
//                       )
//                           : Text(submitLabel),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   // Future<void> _showOdometerSheet({
//   //   required BuildContext context,
//   //   required CorporateBookingProvider provider,
//   //   required String bookingId,
//   //   required String title,
//   //   required String submitLabel,
//   //   required bool isLoading,
//   //   required String successMessage,
//   //   required Future<bool> Function(
//   //     String odometer,
//   //     double lat,
//   //     double lng,
//   //     File image,
//   //   )
//   //   onSubmit,
//   // }) async {
//   //   final odometerController = TextEditingController();
//   //   File? selectedImage;
//   //   final picker = ImagePicker();
//   //
//   //   await showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.transparent,
//   //     builder: (ctx) {
//   //       return StatefulBuilder(
//   //         builder: (context, setModalState) {
//   //           return Container(
//   //             padding: EdgeInsets.only(
//   //               bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//   //               left: 20,
//   //               right: 20,
//   //               top: 16,
//   //             ),
//   //             decoration: const BoxDecoration(
//   //               color: Colors.white,
//   //               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//   //             ),
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 // Handle bar
//   //                 Container(
//   //                   width: 40,
//   //                   height: 4,
//   //                   margin: const EdgeInsets.only(bottom: 16),
//   //                   decoration: BoxDecoration(
//   //                     color: Colors.grey.shade300,
//   //                     borderRadius: BorderRadius.circular(10),
//   //                   ),
//   //                 ),
//   //
//   //                 Text(
//   //                   title,
//   //                   style: const TextStyle(
//   //                     fontSize: 18,
//   //                     fontWeight: FontWeight.bold,
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 20),
//   //
//   //                 // Odometer
//   //                 TextField(
//   //                   controller: odometerController,
//   //                   keyboardType: TextInputType.number,
//   //                   decoration: InputDecoration(
//   //                     labelText: 'Odometer Reading',
//   //                     prefixIcon: const Icon(Icons.speed),
//   //                     border: OutlineInputBorder(
//   //                       borderRadius: BorderRadius.circular(12),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 16),
//   //
//   //                 // Image picker
//   //                 GestureDetector(
//   //                   onTap: () async {
//   //                     final picked = await picker.pickImage(
//   //                       source: ImageSource.camera,
//   //                       imageQuality: 70,
//   //                     );
//   //                     if (picked != null) {
//   //                       setModalState(() => selectedImage = File(picked.path));
//   //                     }
//   //                   },
//   //                   child: Container(
//   //                     height: 150,
//   //                     width: double.infinity,
//   //                     decoration: BoxDecoration(
//   //                       border: Border.all(color: Colors.grey.shade300),
//   //                       borderRadius: BorderRadius.circular(14),
//   //                       color: Colors.grey.shade50,
//   //                     ),
//   //                     child:
//   //                         selectedImage == null
//   //                             ? const Column(
//   //                               mainAxisAlignment: MainAxisAlignment.center,
//   //                               children: [
//   //                                 Icon(
//   //                                   Icons.camera_alt,
//   //                                   size: 42,
//   //                                   color: Colors.grey,
//   //                                 ),
//   //                                 SizedBox(height: 8),
//   //                                 Text(
//   //                                   'Tap to capture Odometer Image',
//   //                                   style: TextStyle(color: Colors.grey),
//   //                                 ),
//   //                               ],
//   //                             )
//   //                             : ClipRRect(
//   //                               borderRadius: BorderRadius.circular(14),
//   //                               child: Image.file(
//   //                                 selectedImage!,
//   //                                 fit: BoxFit.cover,
//   //                                 width: double.infinity,
//   //                               ),
//   //                             ),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(height: 24),
//   //
//   //                 // Submit
//   //                 SizedBox(
//   //                   width: double.infinity,
//   //                   height: 50,
//   //                   child: ElevatedButton(
//   //                     onPressed: () async {
//   //                       if (odometerController.text.trim().isEmpty) {
//   //                         ToastHelper.show(
//   //                           context,
//   //                           message: 'Please enter odometer reading',
//   //                           type: ToastType.warning,
//   //                         );
//   //                         // _showSnack(
//   //                         //     context, 'Please enter odometer reading', Colors.orange);
//   //                         return;
//   //                       }
//   //                       if (selectedImage == null) {
//   //                         ToastHelper.show(
//   //                           context,
//   //                           message: "Please capture odometer image",
//   //                           type: ToastType.warning,
//   //                         );
//   //                         // _showSnack(
//   //                         //     context, 'Please capture odometer image', Colors.orange);
//   //                         return;
//   //                       }
//   //
//   //                       // Location check
//   //                       bool serviceEnabled =
//   //                           await Geolocator.isLocationServiceEnabled();
//   //                       if (!serviceEnabled) {
//   //                         ToastHelper.show(
//   //                           context,
//   //                           message: "Please enable location",
//   //                           type: ToastType.warning,
//   //                         );
//   //                         // _showSnack(context, 'Please enable location', Colors.orange);
//   //                         return;
//   //                       }
//   //
//   //                       LocationPermission permission =
//   //                           await Geolocator.checkPermission();
//   //                       if (permission == LocationPermission.denied) {
//   //                         permission = await Geolocator.requestPermission();
//   //                         if (permission == LocationPermission.denied) {
//   //                           ToastHelper.show(
//   //                             context,
//   //                             message: 'Location permission denied',
//   //                             type: ToastType.error,
//   //                           );
//   //                           // _showSnack(
//   //                           //     context, 'Location permission denied', Colors.red);
//   //                           return;
//   //                         }
//   //                       }
//   //
//   //                       final position = await Geolocator.getCurrentPosition(
//   //                         desiredAccuracy: LocationAccuracy.high,
//   //                       );
//   //
//   //                       ////yhi code
//   //
//   //                       // final confirmed = await _showConfirmDialog(
//   //                       //   context: context,
//   //                       //   title: 'Confirm Action',
//   //                       //   message: 'Are you sure you want to submit $title?',
//   //                       // );
//   //                       // if (!confirmed) return;
//   //                       ////yhi code hai
//   //
//   //                       Navigator.pop(ctx);
//   //
//   //                       final success = await onSubmit(
//   //                         odometerController.text.trim(),
//   //                         position.latitude,
//   //                         position.longitude,
//   //                         selectedImage!,
//   //                       );
//   //
//   //                       if (success && context.mounted) {
//   //                         ToastHelper.show(
//   //                           context,
//   //                           message: successMessage,
//   //                           type: ToastType.error,
//   //                         );
//   //                         // _showSnack(context, successMessage, Colors.green);
//   //                       } else if (context.mounted) {
//   //                         ToastHelper.show(
//   //                           context,
//   //                           message: provider.errorMessage ?? 'Failed',
//   //                           type: ToastType.error,
//   //                         );
//   //                         // _showSnack(
//   //                         //   context,
//   //                         //   provider.errorMessage ?? 'Failed',
//   //                         //   Colors.red,
//   //                         // );
//   //                       }
//   //                     },
//   //                     style: ElevatedButton.styleFrom(
//   //                       backgroundColor: ColorResource.primaryColor,
//   //                       foregroundColor: Colors.white,
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(12),
//   //                       ),
//   //                     ),
//   //                     child:
//   //                         isLoading == true
//   //                             ? CircularProgressIndicator()
//   //                             : Text(submitLabel),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//
//   Future<bool> _showConfirmDialog({
//     required BuildContext context,
//     required String title,
//     required String message,
//   }) async {
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(ctx),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorResource.primaryColor,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Yes, Confirm'),
//             ),
//           ],
//         );
//       },
//     );
//     return result ?? false;
//   }
//
//   // ==================== HELPERS ====================
//   Widget _actionButton({
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//     bool isLoading = false,
//     bool isOutlined = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: SizedBox(
//         width: double.infinity,
//         height: 52,
//         child:
//         isOutlined
//             ? OutlinedButton(
//           onPressed: isLoading ? null : onPressed,
//           style: OutlinedButton.styleFrom(
//             foregroundColor: color,
//             side: BorderSide(color: color, width: 1.5),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child:
//           isLoading
//               ? SizedBox(
//             height: 22,
//             width: 22,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               color: color,
//             ),
//           )
//               : Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         )
//             : ElevatedButton(
//           onPressed: isLoading ? null : onPressed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             foregroundColor: Colors.white,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child:
//           isLoading
//               ? const SizedBox(
//             height: 22,
//             width: 22,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               color: Colors.white,
//             ),
//           )
//               : Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionCard({required String title, required List<Widget> children}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white, // Pure white background
//         borderRadius: BorderRadius.circular(16), // Smooth rounded corners
//         border: Border.all(
//           color: Colors.grey.shade100, // Very subtle border for crisp depth
//           width: 1,
//         ),
//         boxShadow: [
//           // 1. Primary ambient soft blur shadow
//           BoxShadow(
//             color: const Color(0xFF0D1B2A).withOpacity(0.06),
//             blurRadius: 20,
//             spreadRadius: 0,
//             offset: const Offset(0, 10), // Downward soft glow
//           ),
//           // 2. Secondary subtle directional shadow
//           BoxShadow(
//             color: const Color(0xFF000000).withOpacity(0.02),
//             blurRadius: 6,
//             spreadRadius: -2,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueGrey,
//               ),
//             ),
//             const Divider(height: 20),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _detailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 130,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               formatText( value),
//               style: const TextStyle(
//                 fontSize: 13.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// // void _showSnack(BuildContext context, String message, Color color) {
// //   ScaffoldMessenger.of(context).showSnackBar(
// //     SnackBar(
// //       content: Text(message),
// //       backgroundColor: color,
// //       behavior: SnackBarBehavior.floating,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //     ),
// //   );
// // }
// }
//
//
// String formatText(String value) {
//   return value
//       .replaceAll('_', ' ')
//       .split(' ')
//       .map(
//         (word) => word.isEmpty
//         ? ''
//         : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
//   )
//       .join(' ');
// }