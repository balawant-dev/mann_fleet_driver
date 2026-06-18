import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class LocationTrackingService extends TaskHandler {
  LocationTrackingService();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("Tracking Started");
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    print("Repeat Event");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print("Tracking Stopped");
  }
}
