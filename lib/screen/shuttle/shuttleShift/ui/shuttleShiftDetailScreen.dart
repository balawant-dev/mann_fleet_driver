import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/screen/shuttle/shuttleShift/ui/shuttleBookingListScreen.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:provider/provider.dart';

import '../provider/shuttleShiftPro.dart';

class ShuttleShiftDetailScreen extends StatefulWidget {
  final String shiftId;

  const ShuttleShiftDetailScreen({
    super.key,
    required this.shiftId,
  });

  @override
  State<ShuttleShiftDetailScreen> createState() => _ShuttleShiftDetailScreenState();
}

class _ShuttleShiftDetailScreenState extends State<ShuttleShiftDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShuttleShiftProvider>(
        context,
        listen: false,
      ).shuttleShiftDetailApi(context:context,shiftID: widget.shiftId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<ShuttleShiftProvider>();

    final detail =
        provider.shuttleShiftDetailModel?.data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Shift Details"),

      // appBar: AppBar(
      //   title: const Text("Shift Details"),
      //   backgroundColor: const Color(0xff0A2472),
      //   foregroundColor: Colors.white,
      // ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0A2472),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              navPush(context: context, action: ShuttleBookingListScreen(shiftId: detail!.shuttleRouteShift!.sId.toString()));

              /// Check Booking Screen
            },
            child: const Text(
              "Check Booking",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),

      body: detail == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Route Card
            _card(
              child: Column(
                children: [
                  _row(
                    "Route",
                    detail.shuttleRoute?.name ??
                        "",
                  ),
                  _row(
                    "Shift",
                    detail.shuttleRouteShift
                        ?.shiftName ??
                        "",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// Driver
            _card(
              child: Column(
                children: [
                  const Text(
                    "Driver Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _row(
                    "Name",
                    detail.driver?.name ?? "",
                  ),
                  _row(
                    "Phone",
                    detail.driver?.phone ??
                        "",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// Vehicle
            _card(
              child: Column(
                children: [
                  const Text(
                    "Vehicle Details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _row(
                    "Brand",
                    detail.vehicle?.brand ??
                        "",
                  ),
                  _row(
                    "Model",
                    detail.vehicle?.model ??
                        "",
                  ),
                  _row(
                    "Number",
                    detail.vehicle?.carNumber ??
                        "",
                  ),
                  _row(
                    "Capacity",
                    "${detail.vehicle?.capacity ?? 0}",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// Stoppages
            _card(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Stops",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ListView.builder(
                    itemCount: detail
                        .shuttleRouteShift
                        ?.stoppageTimes
                        ?.length ??
                        0,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final stop = detail
                          .shuttleRouteShift!
                          .stoppageTimes![index];

                      return ListTile(
                        contentPadding:
                        EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor:
                          const Color(
                              0xff0A2472),
                          child: Text(
                            "${index + 1}",
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          stop.name ?? "",
                        ),
                        subtitle: Text(
                          stop.departureTime ??
                              "",
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}