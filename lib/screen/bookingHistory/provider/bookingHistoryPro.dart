import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assume your repo & model files are already created
import '../model/bookingHistoryModel.dart';
import '../repo/bookingHistoryRepo.dart';


// ================= PROVIDER =================
class BookingHistoryProvider extends ChangeNotifier {
  final BookingHistoryRepo repo = BookingHistoryRepo();

  bool isLoading = false;
  BookingHistoryModel? bookingModel;

  Future<void> fetchBookings(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      bookingModel = await repo.getBookingHistoryApi(context: context);
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}