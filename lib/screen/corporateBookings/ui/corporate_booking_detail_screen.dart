// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import '../pro/corporate_booking_provider.dart';
//
// import 'dart:io';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
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
//       appBar: AppBar(title: const Text('Booking Detail'), centerTitle: true),
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
//                   Text(provider.errorMessage ?? 'Failed to load details'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed:
//                         () => provider.fetchBookingDetail(
//                           context,
//                           widget.bookingId,
//                         ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final d = provider.bookingDetail!;
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Status Card
//                 _sectionCard(
//                   title: 'Status',
//                   children: [
//                     _detailRow('Overall', d.overallStatus),
//                     _detailRow('Trip Status', d.tripStatus),
//                     _detailRow('Assignment', d.assignmentStatus),
//                     _detailRow('Billing', d.billingStatus),
//                     _detailRow('Driver Response', d.driverResponse.status),
//                   ],
//                 ),
//
//                 // Booking Info
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
//                 // Guest
//                 _sectionCard(
//                   title: 'Guest Details',
//                   children: [
//                     _detailRow('Name', d.guestDetail.name),
//                     _detailRow('Email', d.guestDetail.email),
//                     _detailRow('Phone', '${d.guestDetail.phone}'),
//                   ],
//                 ),
//
//                 // Corporate & Booker
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
//                 // Vehicle
//                 _sectionCard(
//                   title: 'Vehicle',
//                   children: [
//                     _detailRow('Brand', d.vehicle.brand),
//                     _detailRow('Model', d.vehicle.model),
//                     _detailRow('Car Number', d.vehicle.carNumber),
//                   ],
//                 ),
//
//                 // Locations
//                 _sectionCard(
//                   title: 'Locations',
//                   children: [
//                     _detailRow('Pickup', d.pickup.address),
//                     _detailRow('Dropoff', d.dropoff.address),
//                   ],
//                 ),
//
//                 // Package (from agreement)
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
//                 // OTPs
//                 _sectionCard(
//                   title: 'OTP',
//                   children: [
//                     _detailRow('Start OTP', d.tripStartOtp),
//                     _detailRow('End OTP', d.tripEndOtp),
//                     _detailRow(
//                       'Start Verified',
//                       d.tripStartOtpVerify ? 'Yes' : 'No',
//                     ),
//                     _detailRow(
//                       'End Verified',
//                       d.tripEndOtpVerify ? 'Yes' : 'No',
//                     ),
//                   ],
//                 ),
//
//                 // Accept / Reject buttons
//                 if (d.driverResponse.status == 'pending') ...[
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed:
//                               provider.isResponding
//                                   ? null
//                                   : () async {
//                                     // Inside onAccept / Accept button
//                                     final position =
//                                         await Geolocator.getCurrentPosition(
//                                           desiredAccuracy:
//                                               LocationAccuracy.high,
//                                         );
//
//                                     final success = await provider
//                                         .acceptBooking(
//                                           context: context,
//                                           bookingId: widget.bookingId,
//                                           currentLat: position.latitude,
//                                           currentLng: position.longitude,
//                                         );
//
//                                     if (success && context.mounted) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text('Booking Accepted'),
//                                         ),
//                                       );
//                                     }
//                                   },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child:
//                               provider.isResponding
//                                   ? const SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                   : const Text('Accept Booking'),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed:
//                               provider.isResponding
//                                   ? null
//                                   : () async {
//                                     final success = await provider
//                                         .rejectBooking(context, d.id);
//                                     if (success && context.mounted) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text('Booking Rejected'),
//                                         ),
//                                       );
//                                       Navigator.pop(context);
//                                     }
//                                   },
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.red,
//                             side: const BorderSide(color: Colors.red),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: const Text('Reject'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 const SizedBox(height: 30),
//                 // ========== GARAGE START (only for garage to garage) ==========
//                 if (d.tripType.toLowerCase() == "garage to garage" &&
//                     d.tripStatus == "driver_enroute") ...[
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           provider.isGarageStarting
//                               ? null
//                               : () => _showGarageStartSheet(
//                                 context,
//                                 provider,
//                                 d.id,
//                               ),
//                       icon:
//                           provider.isGarageStarting
//                               ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                               : const Icon(Icons.play_arrow),
//                       label: Text(
//                         provider.isGarageStarting
//                             ? "Starting..."
//                             : "Garage Start",
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 if (d.tripType.toLowerCase() == "garage to garage" &&
//                     d.tripStatus == "garage_started") ...[
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           provider.isPickupCheckpoint
//                               ? null
//                               : () => _showPickupCheckpointSheet(
//                                 context,
//                                 provider,
//                                 d.id,
//                               ),
//                       icon:
//                           provider.isPickupCheckpoint
//                               ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                               : const Icon(Icons.play_arrow),
//                       label: Text(
//                         provider.isPickupCheckpoint
//                             ? "Starting..."
//                             : "Pickup Check Start",
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 if (d.tripType.toLowerCase() == "garage to garage" &&
//                     d.tripStatus == "in_progress") ...[
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           provider.isDropCheckpoint
//                               ? null
//                               : () => _showDropCheckpointSheet(
//                                 context,
//                                 provider,
//                                 d.id,
//                               ),
//                       icon:
//                           provider.isDropCheckpoint
//                               ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                               : const Icon(Icons.play_arrow),
//                       label: Text(
//                         provider.isDropCheckpoint
//                             ? "Dropping..."
//                             : "Drop Check Point",
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],   if (d.tripType.toLowerCase() == "garage to garage" &&
//                     d.tripStatus == "returning_garage") ...[
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           provider.isGarageEnd
//                               ? null
//                               : () => _showGarageEndSheet(
//                                 context,
//                                 provider,
//                                 d.id,
//                               ),
//                       icon:
//                           provider.isGarageEnd
//                               ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                               : const Icon(Icons.play_arrow),
//                       label: Text(
//                         provider.isGarageEnd
//                             ? "GarageEnd..."
//                             : "GarageEnd",
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//
//                 if (d.tripType.toLowerCase() == "garage to garage" &&
//                     d.tripStatus == "arrived") ...[
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () async {
//                         final success = await provider.startRide(
//                           context: context,
//                           bookingId: widget.bookingId,
//                         );
//
//                         if (success && context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Start Ride successful"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         } else if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(provider.errorMessage ?? "Failed"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       icon:
//                           provider.isStartRide
//                               ? const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                               : const Icon(Icons.play_arrow),
//                       label: Text(
//                         provider.isStartRide ? "Starting..." : "Start Ride",
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 30),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _showGarageStartSheet(
//     BuildContext context,
//     CorporateBookingProvider provider,
//     String bookingId,
//   ) async {
//     final odometerController = TextEditingController();
//     File? selectedImage;
//     final picker = ImagePicker();
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
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//                 left: 20,
//                 right: 20,
//                 top: 20,
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Garage Start",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Odometer Input
//                   TextField(
//                     controller: odometerController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: "Odometer Reading",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       prefixIcon: const Icon(Icons.speed),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Image Picker
//                   GestureDetector(
//                     onTap: () async {
//                       final picked = await picker.pickImage(
//                         source: ImageSource.camera, // or gallery
//                         imageQuality: 70,
//                       );
//                       if (picked != null) {
//                         setModalState(() {
//                           selectedImage = File(picked.path);
//                         });
//                       }
//                     },
//                     child: Container(
//                       height: 140,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade400),
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.grey.shade50,
//                       ),
//                       child:
//                           selectedImage == null
//                               ? const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.camera_alt,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text("Tap to capture Odometer Image"),
//                                 ],
//                               )
//                               : ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   selectedImage!,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (odometerController.text.trim().isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enter odometer reading"),
//                             ),
//                           );
//                           return;
//                         }
//                         if (selectedImage == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please capture odometer image"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         // Get current location
//                         bool serviceEnabled =
//                             await Geolocator.isLocationServiceEnabled();
//                         if (!serviceEnabled) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enable location"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         LocationPermission permission =
//                             await Geolocator.checkPermission();
//                         if (permission == LocationPermission.denied) {
//                           permission = await Geolocator.requestPermission();
//                           if (permission == LocationPermission.denied) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Location permission denied"),
//                               ),
//                             );
//                             return;
//                           }
//                         }
//
//                         final position = await Geolocator.getCurrentPosition(
//                           desiredAccuracy: LocationAccuracy.high,
//                         );
//
//                         Navigator.pop(ctx); // close bottom sheet
//
//                         final success = await provider.garageStart(
//                           context: context,
//                           bookingId: bookingId,
//                           odometer: odometerController.text.trim(),
//                           currentLat: position.latitude,
//                           currentLng: position.longitude,
//                           odometerImage: selectedImage!,
//                         );
//
//                         if (success && context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Garage Start successful"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         } else if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(provider.errorMessage ?? "Failed"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text("Submit Garage Start"),
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
//
//   Future<void> _showPickupCheckpointSheet(
//     BuildContext context,
//     CorporateBookingProvider provider,
//     String bookingId,
//   ) async {
//     final odometerController = TextEditingController();
//     File? selectedImage;
//     final picker = ImagePicker();
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
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//                 left: 20,
//                 right: 20,
//                 top: 20,
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Pickup Check Point",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Odometer Input
//                   TextField(
//                     controller: odometerController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: "Odometer Reading",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       prefixIcon: const Icon(Icons.speed),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Image Picker
//                   GestureDetector(
//                     onTap: () async {
//                       final picked = await picker.pickImage(
//                         source: ImageSource.camera, // or gallery
//                         imageQuality: 70,
//                       );
//                       if (picked != null) {
//                         setModalState(() {
//                           selectedImage = File(picked.path);
//                         });
//                       }
//                     },
//                     child: Container(
//                       height: 140,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade400),
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.grey.shade50,
//                       ),
//                       child:
//                           selectedImage == null
//                               ? const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.camera_alt,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text("Tap to capture Odometer Image"),
//                                 ],
//                               )
//                               : ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   selectedImage!,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (odometerController.text.trim().isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enter odometer reading"),
//                             ),
//                           );
//                           return;
//                         }
//                         if (selectedImage == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please capture odometer image"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         // Get current location
//                         bool serviceEnabled =
//                             await Geolocator.isLocationServiceEnabled();
//                         if (!serviceEnabled) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enable location"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         LocationPermission permission =
//                             await Geolocator.checkPermission();
//                         if (permission == LocationPermission.denied) {
//                           permission = await Geolocator.requestPermission();
//                           if (permission == LocationPermission.denied) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Location permission denied"),
//                               ),
//                             );
//                             return;
//                           }
//                         }
//
//                         final position = await Geolocator.getCurrentPosition(
//                           desiredAccuracy: LocationAccuracy.high,
//                         );
//
//                         Navigator.pop(ctx); // close bottom sheet
//
//                         final success = await provider.pickupCheckpoint(
//                           context: context,
//                           bookingId: bookingId,
//                           odometer: odometerController.text.trim(),
//                           currentLat: position.latitude,
//                           currentLng: position.longitude,
//                           odometerImage: selectedImage!,
//                         );
//
//                         if (success && context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Pickup Check point successful"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         } else if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(provider.errorMessage ?? "Failed"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text("Submit Pickup Checkpoint"),
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
//
//   Future<void> _showDropCheckpointSheet(
//     BuildContext context,
//     CorporateBookingProvider provider,
//     String bookingId,
//   ) async {
//     final odometerController = TextEditingController();
//     File? selectedImage;
//     final picker = ImagePicker();
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
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//                 left: 20,
//                 right: 20,
//                 top: 20,
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Drop Check Point",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Odometer Input
//                   TextField(
//                     controller: odometerController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: "Odometer Reading",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       prefixIcon: const Icon(Icons.speed),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Image Picker
//                   GestureDetector(
//                     onTap: () async {
//                       final picked = await picker.pickImage(
//                         source: ImageSource.camera, // or gallery
//                         imageQuality: 70,
//                       );
//                       if (picked != null) {
//                         setModalState(() {
//                           selectedImage = File(picked.path);
//                         });
//                       }
//                     },
//                     child: Container(
//                       height: 140,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade400),
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.grey.shade50,
//                       ),
//                       child:
//                           selectedImage == null
//                               ? const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.camera_alt,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text("Tap to capture Odometer Image"),
//                                 ],
//                               )
//                               : ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   selectedImage!,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (odometerController.text.trim().isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enter odometer reading"),
//                             ),
//                           );
//                           return;
//                         }
//                         if (selectedImage == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please capture odometer image"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         // Get current location
//                         bool serviceEnabled =
//                             await Geolocator.isLocationServiceEnabled();
//                         if (!serviceEnabled) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enable location"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         LocationPermission permission =
//                             await Geolocator.checkPermission();
//                         if (permission == LocationPermission.denied) {
//                           permission = await Geolocator.requestPermission();
//                           if (permission == LocationPermission.denied) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Location permission denied"),
//                               ),
//                             );
//                             return;
//                           }
//                         }
//
//                         final position = await Geolocator.getCurrentPosition(
//                           desiredAccuracy: LocationAccuracy.high,
//                         );
//
//                         Navigator.pop(ctx); // close bottom sheet
//
//                         final success = await provider.dropCheckpoint(
//                           context: context,
//                           bookingId: bookingId,
//                           odometer: odometerController.text.trim(),
//                           currentLat: position.latitude,
//                           currentLng: position.longitude,
//                           odometerImage: selectedImage!,
//                         );
//
//                         if (success && context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Pickup Check point successful"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         } else if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(provider.errorMessage ?? "Failed"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text("Submit Drop Checkpoint"),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }  Future<void> _showGarageEndSheet(
//     BuildContext context,
//     CorporateBookingProvider provider,
//     String bookingId,
//   ) async {
//     final odometerController = TextEditingController();
//     File? selectedImage;
//     final picker = ImagePicker();
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
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//                 left: 20,
//                 right: 20,
//                 top: 20,
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Garage End",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Odometer Input
//                   TextField(
//                     controller: odometerController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: "Odometer Reading",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       prefixIcon: const Icon(Icons.speed),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Image Picker
//                   GestureDetector(
//                     onTap: () async {
//                       final picked = await picker.pickImage(
//                         source: ImageSource.camera, // or gallery
//                         imageQuality: 70,
//                       );
//                       if (picked != null) {
//                         setModalState(() {
//                           selectedImage = File(picked.path);
//                         });
//                       }
//                     },
//                     child: Container(
//                       height: 140,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade400),
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.grey.shade50,
//                       ),
//                       child:
//                           selectedImage == null
//                               ? const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.camera_alt,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text("Tap to capture Odometer Image"),
//                                 ],
//                               )
//                               : ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   selectedImage!,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (odometerController.text.trim().isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enter odometer reading"),
//                             ),
//                           );
//                           return;
//                         }
//                         if (selectedImage == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please capture odometer image"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         // Get current location
//                         bool serviceEnabled =
//                             await Geolocator.isLocationServiceEnabled();
//                         if (!serviceEnabled) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Please enable location"),
//                             ),
//                           );
//                           return;
//                         }
//
//                         LocationPermission permission =
//                             await Geolocator.checkPermission();
//                         if (permission == LocationPermission.denied) {
//                           permission = await Geolocator.requestPermission();
//                           if (permission == LocationPermission.denied) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Location permission denied"),
//                               ),
//                             );
//                             return;
//                           }
//                         }
//
//                         final position = await Geolocator.getCurrentPosition(
//                           desiredAccuracy: LocationAccuracy.high,
//                         );
//
//                         Navigator.pop(ctx); // close bottom sheet
//
//                         final success = await provider.garageEndApi(
//                           context: context,
//                           bookingId: bookingId,
//                           odometer: odometerController.text.trim(),
//                           currentLat: position.latitude,
//                           currentLng: position.longitude,
//                           odometerImage: selectedImage!,
//                         );
//
//                         if (success && context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Garage End successful"),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         } else if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(provider.errorMessage ?? "Failed"),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text("Submit Drop Garage End"),
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
//
//   Widget _sectionCard({required String title, required List<Widget> children}) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       elevation: 1.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
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
//             const Divider(height: 18),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _detailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 130,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/motionToastHelper.dart';
import '../pro/corporate_booking_provider.dart';

class CorporateBookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const CorporateBookingDetailScreen({super.key, required this.bookingId});

  @override
  State<CorporateBookingDetailScreen> createState() =>
      _CorporateBookingDetailScreenState();
}

class _CorporateBookingDetailScreenState
    extends State<CorporateBookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CorporateBookingProvider>().fetchBookingDetail(
        context,
        widget.bookingId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CommonAppBar(title: 'Booking Detail'),
      // appBar: AppBar(
      //   title: const Text('Booking Detail'),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Consumer<CorporateBookingProvider>(
        builder: (context, provider, _) {
          if (provider.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bookingDetail == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? 'Failed to load details',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => provider.fetchBookingDetail(
                          context,
                          widget.bookingId,
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final d = provider.bookingDetail!;
          final tripType = d.tripType.toLowerCase();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========== STATUS ==========
                _sectionCard(
                  title: 'Status',
                  children: [
                    _detailRow('Overall', d.overallStatus),
                    _detailRow('Trip Status', d.tripStatus),
                    _detailRow('Assignment', d.assignmentStatus),
                    // _detailRow('Billing', d.billingStatus),
                    _detailRow('Driver Response', d.driverResponse.status),
                  ],
                ),

                // ========== BOOKING INFO ==========
                _sectionCard(
                  title: 'Booking Info',
                  children: [
                    _detailRow('Booking No', d.bookingNumber),
                    _detailRow(
                      'Corporate Booking No',
                      d.corporateBookingNumber,
                    ),
                    _detailRow('Agreement Code', d.agreementCode),
                    _detailRow('Trip Type', d.tripType),
                    _detailRow('Scheduled At', d.scheduledAtIST),
                    _detailRow('Passengers', '${d.numberofPassangers}'),
                    _detailRow(
                      'Remark',
                      d.bookingRemark.isEmpty ? '-' : d.bookingRemark,
                    ),
                  ],
                ),

                // ========== GUEST ==========
                _sectionCard(
                  title: 'Guest Details',
                  children: [
                    _detailRow('Name', d.guestDetail.name),
                    _detailRow('Email', d.guestDetail.email),
                    _detailRow('Phone', '${d.guestDetail.phone}'),
                  ],
                ),

                // ========== CORPORATE ==========
                _sectionCard(
                  title: 'Corporate',
                  children: [
                    _detailRow('Company', d.corporate.companyName),
                    _detailRow('Code', d.corporate.companyCode),
                    _detailRow('Booker', d.booker.name),
                    _detailRow('Booker Mobile', d.booker.mobile),
                  ],
                ),

                // ========== VEHICLE ==========
                _sectionCard(
                  title: 'Vehicle',
                  children: [
                    _detailRow('Brand', d.vehicle.brand),
                    _detailRow('Model', d.vehicle.model),
                    _detailRow('Car Number', d.vehicle.carNumber),
                  ],
                ),

                // ========== LOCATIONS ==========
                _sectionCard(
                  title: 'Locations',
                  children: [
                    // Pickup - only show if not null
                    if (d.pickup?.lat != null && d.pickup?.lng != null)
                      GestureDetector(
                        onTap: () {
                          _openMapsNavigation(
                            destLat: d.pickup!.lat!.toDouble(),
                            destLng: d.pickup!.lng!.toDouble(),
                            label: d.pickup?.address,
                          );
                        },
                        child: _detailRow('Pickup', d.pickup?.address ?? 'N/A'),
                      ),

                    // Dropoff - only show if not null
                    if (d.dropoff?.lat != null && d.dropoff?.lng != null)
                      GestureDetector(
                        onTap: () {
                          _openMapsNavigation(
                            destLat: d.dropoff!.lat!.toDouble(),
                            destLng: d.dropoff!.lng!.toDouble(),
                            label: d.dropoff?.address,
                          );
                        },
                        child: _detailRow('Dropoff', d.dropoff?.address ?? 'N/A'),
                      ),
                  ],
                ),

                // ========== PACKAGE ==========
                if (d.agreement.packageSnapshot.packageName.isNotEmpty)
                  _sectionCard(
                    title: 'Package',
                    children: [
                      _detailRow(
                        'Package Name',
                        d.agreement.packageSnapshot.packageName,
                      ),
                      _detailRow(
                        'Hours',
                        '${d.agreement.packageSnapshot.hours}',
                      ),
                      _detailRow(
                        'Included KMs',
                        '${d.agreement.packageSnapshot.includedKms}',
                      ),
                      _detailRow(
                        'Base Fare',
                        '₹${d.agreement.packageSnapshot.baseFare}',
                      ),
                      _detailRow(
                        'Fix Amount',
                        '₹${d.agreement.packageSnapshot.fixAmount}',
                      ),
                      _detailRow(
                        'Extra / Km',
                        '₹${d.agreement.packageSnapshot.extraPerKm}',
                      ),
                      _detailRow(
                        'Driver Charge',
                        '₹${d.agreement.packageSnapshot.driverCharge}',
                      ),
                    ],
                  ),

                // ========== OTP ==========
                // _sectionCard(
                //   title: 'OTP',
                //   children: [
                //     _detailRow('Start OTP', d.tripStartOtp),
                //     _detailRow('End OTP', d.tripEndOtp),
                //     _detailRow(
                //       'Start Verified',
                //       d.tripStartOtpVerify ? 'Yes' : 'No',
                //     ),
                //     _detailRow(
                //       'End Verified',
                //       d.tripEndOtpVerify ? 'Yes' : 'No',
                //     ),
                //   ],
                // ),
                const SizedBox(height: 8),

                // ========== ACCEPT / REJECT ==========
                if (d.driverResponse.status == 'pending') ...[
                  _actionButton(
                    label: 'Accept Booking',
                    color: Colors.green,
                    isLoading: provider.isResponding,
                    onPressed: () async {
                      final position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );

                      final success = await provider.acceptBooking(
                        context: context,
                        bookingId: widget.bookingId,
                        currentLat: position.latitude,
                        currentLng: position.longitude,
                      );

                      if (success && context.mounted) {
                        ToastHelper.show(
                          context,
                          message: "Booking Accepted",
                          type: ToastType.success,
                        );
                        // _showSnack(context, 'Booking Accepted', Colors.green);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    label: 'Reject Booking',
                    color: Colors.red,
                    isOutlined: true,
                    isLoading: provider.isResponding,
                    onPressed: () async {
                      final success = await provider.rejectBooking(
                        context,
                        d.id,
                      );
                      if (success && context.mounted) {
                        ToastHelper.show(
                          context,
                          message: "Booking Rejected",
                          type: ToastType.error,
                        );
                        // _showSnack(context, 'Booking Rejected', Colors.red);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],

                // ========== TRIP ACTION BUTTONS (Garage to Garage) ==========
                if (tripType == 'garage to garage') ...[
                  // 1. Garage Start
                  if (d.tripStatus == 'driver_enroute')
                    _actionButton(
                      label: 'Garage Start',
                      color: Colors.indigo,
                      isLoading: provider.isGarageStarting,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isGarageStarting,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Garage Start',
                            submitLabel: 'Submit Garage Start',
                            successMessage: 'Garage Start successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.garageStart(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 2. Pickup Checkpoint
                  if (d.tripStatus == 'garage_started')
                    _actionButton(
                      label: 'Pickup Checkpoint',
                      color: Colors.indigo,
                      isLoading: provider.isPickupCheckpoint,
                      onPressed:
                          () => _showOdometerSheet(
                            context: context,
                            isLoading: provider.isPickupCheckpoint,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Pickup Checkpoint',
                            submitLabel: 'Submit Pickup Checkpoint',
                            successMessage: 'Pickup Checkpoint successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.pickupCheckpoint(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 3. Start Ride (after arrived)
                  if (d.tripStatus == 'arrived')
                    _actionButton(
                      label: 'Start Ride',
                      color: Colors.indigo,
                      isLoading: provider.isStartRide,
                      onPressed: () async {
                        final success = await provider.startRide(
                          context: context,
                          bookingId: widget.bookingId,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Start Ride successful',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Start Ride successful',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message: provider.errorMessage ?? 'Failed',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed',
                          //   Colors.red,
                          // );
                        }
                      },
                    ),

                  // 4. Drop Checkpoint
                  if (d.tripStatus == 'in_progress')
                    _actionButton(
                      label: 'Drop Checkpoint',
                      color: Colors.indigo,
                      isLoading: provider.isDropCheckpoint,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isDropCheckpoint,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Drop Checkpoint',
                            submitLabel: 'Submit Drop Checkpoint',
                            successMessage: 'Drop Checkpoint successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.dropCheckpoint(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 5. Garage End
                  if (d.tripStatus == 'returning_garage')
                    _actionButton(
                      label: 'Garage End',
                      color: Colors.indigo,
                      isLoading: provider.isGarageEnd,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isGarageEnd,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Garage End',
                            submitLabel: 'Submit Garage End',
                            successMessage: 'Garage End successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.garageEndApi(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 6. Extra Charges (after dropped)
                  if (d.tripStatus == 'dropped')
                    _actionButton(
                      label: 'Add Extra Charges',
                      color: Colors.deepOrange,
                      isLoading: provider.isGarageEnd,
                      // or use a new flag if you have isExtraCharge
                      onPressed:
                          () => _showExtraChargeSheet(
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                          ),
                    ),
                  if (d.tripStatus == 'dropped')
                    _actionButton(
                      label: 'Complete Trip',
                      color: ColorResource.primaryColor,
                      isLoading: provider.isGarageEnd,
                      // or use a new flag if you have isExtraCharge
                      onPressed: () async {
                        final success = await provider.completeTripApi(
                          context: context,
                          bookingId: widget.bookingId,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Complete trip successfully',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Complete trip successfully',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message:
                                provider.errorMessage ??
                                'Failed to complete trip',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed to complete trip',
                          //   Colors.red,
                          // );
                        }
                      },
                    ),
                ],

                if (tripType == 'pickup to garage') ...[
                  // 1. Garage Start
                  // if (d.tripStatus == 'driver_enroute')
                  //   _actionButton(
                  //     label: 'Garage Start',
                  //     color: Colors.indigo,
                  //     isLoading: provider.isGarageStarting,
                  //     onPressed: () => _showOdometerSheet(
                  //       context: context,
                  //       provider: provider,
                  //       bookingId: d.id,
                  //       title: 'Garage Start',
                  //       submitLabel: 'Submit Garage Start',
                  //       successMessage: 'Garage Start successful',
                  //       onSubmit: (odometer, lat, lng, image) {
                  //         return provider.garageStart(
                  //           context: context,
                  //           bookingId: d.id,
                  //           odometer: odometer,
                  //           currentLat: lat,
                  //           currentLng: lng,
                  //           odometerImage: image,
                  //         );
                  //       },
                  //     ),
                  //   ),

                  // 2. Pickup Checkpoint
                  if (d.tripStatus == 'driver_enroute')
                    _actionButton(
                      label: 'Pickup Checkpoint',
                      color: Colors.indigo,
                      isLoading: provider.isPickupCheckpoint,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isPickupCheckpoint,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Pickup Checkpoint',
                            submitLabel: 'Submit Pickup Checkpoint',
                            successMessage: 'Pickup Checkpoint successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.pickupCheckpoint(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 3. Start Ride (after arrived)
                  if (d.tripStatus == 'arrived')
                    _actionButton(
                      label: 'Start Ride',
                      color: Colors.indigo,
                      isLoading: provider.isStartRide,
                      onPressed: () async {
                        final success = await provider.startRide(
                          context: context,
                          bookingId: widget.bookingId,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Start Ride successful',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Start Ride successful',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message: provider.errorMessage ?? 'Failed',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed',
                          //   Colors.red,
                          // );
                        }
                      },
                    ),

                  // 4. Drop Checkpoint
                  if (d.tripStatus == 'in_progress')
                    _actionButton(
                      label: 'Drop Checkpoint',
                      color: Colors.indigo,
                      isLoading: provider.isDropCheckpoint,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isDropCheckpoint,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Drop Checkpoint',
                            submitLabel: 'Submit Drop Checkpoint',
                            successMessage: 'Drop Checkpoint successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.dropCheckpoint(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 5. Garage End
                  if (d.tripStatus == 'returning_garage')
                    _actionButton(
                      label: 'Garage End',
                      color: Colors.indigo,
                      isLoading: provider.isGarageEnd,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isGarageEnd,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Garage End',
                            submitLabel: 'Submit Garage End',
                            successMessage: 'Garage End successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.garageEndApi(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 6. Extra Charges (after dropped)
                  if (d.tripStatus == 'dropped')
                    _actionButton(
                      label: 'Add Extra Charges',
                      color: Colors.deepOrange,
                      isLoading: provider.isGarageEnd,
                      // or use a new flag if you have isExtraCharge
                      onPressed:
                          () => _showExtraChargeSheet(
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                          ),
                    ),
                  if (d.tripStatus == 'dropped')
                    _actionButton(
                      label: 'Complete Trip',
                      color: ColorResource.primaryColor,
                      isLoading: provider.isGarageEnd,
                      // or use a new flag if you have isExtraCharge
                      onPressed: () async {
                        final success = await provider.completeTripApi(
                          context: context,
                          bookingId: widget.bookingId,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Complete trip successfully',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Complete trip successfully',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message:
                                provider.errorMessage ??
                                'Failed to complete trip',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed to complete trip',
                          //   Colors.red,
                          // );
                        }
                      },
                    ),
                ],
                if (tripType == 'pickup to destination') ...[
                  // 1. Garage Start
                  // if (d.tripStatus == 'driver_enroute')
                  //   _actionButton(
                  //     label: 'Garage Start',
                  //     color: Colors.indigo,
                  //     isLoading: provider.isGarageStarting,
                  //     onPressed: () => _showOdometerSheet(
                  //       context: context,
                  //       provider: provider,
                  //       bookingId: d.id,
                  //       title: 'Garage Start',
                  //       submitLabel: 'Submit Garage Start',
                  //       successMessage: 'Garage Start successful',
                  //       onSubmit: (odometer, lat, lng, image) {
                  //         return provider.garageStart(
                  //           context: context,
                  //           bookingId: d.id,
                  //           odometer: odometer,
                  //           currentLat: lat,
                  //           currentLng: lng,
                  //           odometerImage: image,
                  //         );
                  //       },
                  //     ),
                  //   ),

                  // 2. Pickup Checkpoint
                  if (d.tripStatus == 'driver_enroute')
                    _actionButton(
                      label: 'Pickup Checkpoint',
                      color: Colors.indigo,
                      isLoading: provider.isPickupCheckpoint,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isPickupCheckpoint,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Pickup Checkpoint',
                            submitLabel: 'Submit Pickup Checkpoint',
                            successMessage: 'Pickup Checkpoint successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.pickupCheckpoint(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 3. Start Ride (after arrived)
                  if (d.tripStatus == 'arrived')
                    _actionButton(
                      label: 'Start Ride',
                      color: Colors.indigo,
                      isLoading: provider.isStartRide,
                      onPressed: () async {
                        final success = await provider.startRide(
                          context: context,
                          bookingId: widget.bookingId,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Start Ride successful',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Start Ride successful',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message: provider.errorMessage ?? 'Failed',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed',
                          //   Colors.red,
                          // );
                        }
                      },
                    ),

                  // 4. Drop Checkpoint
                  if (d.tripStatus == 'in_progress')
                    _actionButton(
                      label: 'Drop Checkpoint',
                      color: Colors.indigo,
                      isLoading: provider.isDropCheckpoint,
                      onPressed:
                          () => _showOdometerSheet(
                            isLoading: provider.isDropCheckpoint,
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                            title: 'Drop Checkpoint',
                            submitLabel: 'Submit Drop Checkpoint',
                            successMessage: 'Drop Checkpoint successful',
                            onSubmit: (odometer, lat, lng, image) {
                              return provider.dropCheckpoint(
                                context: context,
                                bookingId: d.id,
                                odometer: odometer,
                                currentLat: lat,
                                currentLng: lng,
                                odometerImage: image,
                              );
                            },
                          ),
                    ),

                  // 5. Garage End
                  // if (d.tripStatus == 'returning_garage')
                  //   _actionButton(
                  //     label: 'Garage End',
                  //     color: Colors.indigo,
                  //     isLoading: provider.isGarageEnd,
                  //     onPressed: () => _showOdometerSheet(
                  //       context: context,
                  //       provider: provider,
                  //       bookingId: d.id,
                  //       title: 'Garage End',
                  //       submitLabel: 'Submit Garage End',
                  //       successMessage: 'Garage End successful',
                  //       onSubmit: (odometer, lat, lng, image) {
                  //         return provider.garageEndApi(
                  //           context: context,
                  //           bookingId: d.id,
                  //           odometer: odometer,
                  //           currentLat: lat,
                  //           currentLng: lng,
                  //           odometerImage: image,
                  //         );
                  //       },
                  //     ),
                  //   ),

                  // 6. Extra Charges (after dropped)
                  if (d.tripStatus == 'dropped')
                    _actionButton(
                      label: 'Add Extra Charges',
                      color: Colors.deepOrange,
                      isLoading: provider.isGarageEnd,
                      // or use a new flag if you have isExtraCharge
                      onPressed:
                          () => _showExtraChargeSheet(
                            context: context,
                            provider: provider,
                            bookingId: d.id,
                          ),
                    ),
                  if (d.tripStatus == 'dropped')
                    _actionButton(
                      label: 'Complete Trip',
                      color: ColorResource.primaryColor,
                      isLoading: provider.isGarageEnd,
                      // or use a new flag if you have isExtraCharge
                      onPressed: () async {
                        final success = await provider.completeTripApi(
                          context: context,
                          bookingId: widget.bookingId,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Complete trip successfully',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Complete trip successfully',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message:
                                provider.errorMessage ??
                                'Failed to complete trip',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed to complete trip',
                          //   Colors.red,
                          // );
                        }
                      },
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== EXTRA CHARGES BOTTOM SHEET ====================
  // ==================== EXTRA CHARGES BOTTOM SHEET ====================
  Future<void> _showExtraChargeSheet({
    required BuildContext context,
    required CorporateBookingProvider provider,
    required String bookingId,
  }) async {
    final tollController = TextEditingController();
    final otherController = TextEditingController();
    final parkingController = TextEditingController();
    final stateController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // important
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          // This pushes the sheet up when keyboard opens
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              // ← important so content can scroll
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const Text(
                    'Extra Charges',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  _chargeField(
                    controller: tollController,
                    label: 'Toll Amount',
                    icon: Icons.toll,
                  ),
                  const SizedBox(height: 14),

                  _chargeField(
                    controller: parkingController,
                    label: 'Parking Charge',
                    icon: Icons.local_parking,
                  ),
                  const SizedBox(height: 14),

                  _chargeField(
                    controller: stateController,
                    label: 'State Charge',
                    icon: Icons.map,
                  ),
                  const SizedBox(height: 14),

                  _chargeField(
                    controller: otherController,
                    label: 'Other Charges',
                    icon: Icons.more_horiz,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final toll =
                            tollController.text.trim().isEmpty
                                ? '0'
                                : tollController.text.trim();
                        final parking =
                            parkingController.text.trim().isEmpty
                                ? '0'
                                : parkingController.text.trim();
                        final state =
                            stateController.text.trim().isEmpty
                                ? '0'
                                : stateController.text.trim();
                        final other =
                            otherController.text.trim().isEmpty
                                ? '0'
                                : otherController.text.trim();

                        Navigator.pop(ctx);

                        final success = await provider.extraChargeApi(
                          context: context,
                          bookingId: bookingId,
                          tollAmount: toll,
                          otherCharges: other,
                          parkingCharge: parking,
                          stateCharge: state,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: 'Extra Charges added successfully',
                            type: ToastType.success,
                          );
                          // _showSnack(
                          //   context,
                          //   'Extra Charges added successfully',
                          //   Colors.green,
                          // );
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message:
                                provider.errorMessage ??
                                'Failed to add charges',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed to add charges',
                          //   Colors.red,
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Extra Charges',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openMapsNavigation({
    required double destLat,
    required double destLng,
    String? label,
  }) async {
    // Google Maps navigation URL (from current location → destination)
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$destLat,$destLng'
      '${label != null ? '&destination_place_id=&travelmode=driving' : ''}'
      '&travelmode=driving',
    );

    // Alternative (works well on both Android & iOS):
    // final uri = Uri.parse('google.navigation:q=$destLat,$destLng&mode=d');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback
      final fallback = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destLat,$destLng',
      );
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  Widget _chargeField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  // ==================== REUSABLE ODOMETER BOTTOM SHEET ====================
  Future<void> _showOdometerSheet({
    required BuildContext context,
    required CorporateBookingProvider provider,
    required String bookingId,
    required String title,
    required String submitLabel,
    required bool isLoading,
    required String successMessage,
    required Future<bool> Function(
      String odometer,
      double lat,
      double lng,
      File image,
    )
    onSubmit,
  }) async {
    final odometerController = TextEditingController();
    File? selectedImage;
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 20,
                right: 20,
                top: 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Odometer
                  TextField(
                    controller: odometerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Odometer Reading',
                      prefixIcon: const Icon(Icons.speed),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image picker
                  GestureDetector(
                    onTap: () async {
                      final picked = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 70,
                      );
                      if (picked != null) {
                        setModalState(() => selectedImage = File(picked.path));
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey.shade50,
                      ),
                      child:
                          selectedImage == null
                              ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 42,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to capture Odometer Image',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (odometerController.text.trim().isEmpty) {
                          ToastHelper.show(
                            context,
                            message: 'Please enter odometer reading',
                            type: ToastType.warning,
                          );
                          // _showSnack(
                          //     context, 'Please enter odometer reading', Colors.orange);
                          return;
                        }
                        if (selectedImage == null) {
                          ToastHelper.show(
                            context,
                            message: "Please capture odometer image",
                            type: ToastType.warning,
                          );
                          // _showSnack(
                          //     context, 'Please capture odometer image', Colors.orange);
                          return;
                        }

                        // Location check
                        bool serviceEnabled =
                            await Geolocator.isLocationServiceEnabled();
                        if (!serviceEnabled) {
                          ToastHelper.show(
                            context,
                            message: "Please enable location",
                            type: ToastType.warning,
                          );
                          // _showSnack(context, 'Please enable location', Colors.orange);
                          return;
                        }

                        LocationPermission permission =
                            await Geolocator.checkPermission();
                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.denied) {
                            ToastHelper.show(
                              context,
                              message: 'Location permission denied',
                              type: ToastType.error,
                            );
                            // _showSnack(
                            //     context, 'Location permission denied', Colors.red);
                            return;
                          }
                        }

                        final position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );

                        ////yhi code

                        // final confirmed = await _showConfirmDialog(
                        //   context: context,
                        //   title: 'Confirm Action',
                        //   message: 'Are you sure you want to submit $title?',
                        // );
                        // if (!confirmed) return;
                        ////yhi code hai

                        Navigator.pop(ctx);

                        final success = await onSubmit(
                          odometerController.text.trim(),
                          position.latitude,
                          position.longitude,
                          selectedImage!,
                        );

                        if (success && context.mounted) {
                          ToastHelper.show(
                            context,
                            message: successMessage,
                            type: ToastType.error,
                          );
                          // _showSnack(context, successMessage, Colors.green);
                        } else if (context.mounted) {
                          ToastHelper.show(
                            context,
                            message: provider.errorMessage ?? 'Failed',
                            type: ToastType.error,
                          );
                          // _showSnack(
                          //   context,
                          //   provider.errorMessage ?? 'Failed',
                          //   Colors.red,
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading == true
                              ? CircularProgressIndicator()
                              : Text(submitLabel),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Confirm'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  // ==================== HELPERS ====================
  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isOutlined = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child:
            isOutlined
                ? OutlinedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isLoading
                          ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: color,
                            ),
                          )
                          : Text(
                            label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                )
                : ElevatedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white, // Pure white background
        borderRadius: BorderRadius.circular(16), // Smooth rounded corners
        border: Border.all(
          color: Colors.grey.shade100, // Very subtle border for crisp depth
          width: 1,
        ),
        boxShadow: [
          // 1. Primary ambient soft blur shadow
          BoxShadow(
            color: const Color(0xFF0D1B2A).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10), // Downward soft glow
          ),
          // 2. Secondary subtle directional shadow
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.02),
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _showSnack(BuildContext context, String message, Color color) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: color,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     ),
  //   );
  // }
}
