import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:provider/provider.dart';
import '../provider/notificationPro.dart';
import 'notificationDetailScreen.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NotificationProvider>()
          .getNotificationApi(context: context);
    });
  }

  Future<void> _onRefresh() async {
    await context.read<NotificationProvider>()
        .getNotificationApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Notifications"),
      // appBar: AppBar(
      //   title: const Text("Notifications"),
      // ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {

          final list = provider.getNotificationModel?.data ?? [];

          return Column(
            children: [

              /// 🔥 Top Soft Loader
              if (provider.isLoading)
                const LinearProgressIndicator(),

              Expanded(
                child: provider.isLoading && list.isEmpty
                    ? const Center(child: CircularProgressIndicator())

                    : list.isEmpty
                    ? const Center(
                  child: Text("No Notifications Found"),
                )

                    : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];

                      return GestureDetector(
                        onTap: (){
                          navPush(context: context, action: NotificationDetailScreen(id: item.sId.toString(),));
                        },
                          child: _notificationCard(item));
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🎨 Notification Card UI
  Widget _notificationCard(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.isRead == true? Color(0xFFF8FAFC):Colors.blue.shade50,        // ← Changed: Soft elegant background
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
      // decoration: BoxDecoration(
      //   color: item.isRead == true
      //       ? Colors.white
      //       : Colors.blue.shade50,
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: Colors.grey.shade200),
      //   boxShadow: [
      //     BoxShadow(
      //       blurRadius: 6,
      //       color: Colors.black.withOpacity(0.05),
      //       offset: const Offset(0, 3),
      //     )
      //   ],
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications, color: Colors.blue),
          ),

          const SizedBox(width: 10),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Title
                Text(
                  item.title ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                /// Body
                Text(
                  item.body ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                /// Booking Info
                if (item.booking != null)
                  Text(
                    "Booking ID: ${item.booking?.bookingNumber ?? ''}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),

                const SizedBox(height: 6),

                /// Time
                Text(
                  item.createdAt ?? "",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          /// Unread Dot
          if (item.isRead == false)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}