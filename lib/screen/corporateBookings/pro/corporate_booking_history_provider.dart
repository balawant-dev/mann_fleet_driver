import 'dart:io';

import 'package:flutter/material.dart';
import '../model/corporate_booking_history_model.dart';
import '../model/corporate_booking_list_model.dart';
import '../model/corporate_booking_detail_model.dart';
import '../repo/corporate_booking_repo.dart';

class CorporateBookingHistoryProvider extends ChangeNotifier {
  final CorporateBookingRepo _repo = CorporateBookingRepo();

  bool isLoading = false;
  bool isDetailLoading = false;
  bool isResponding = false;

  String? errorMessage;



  CorporateBookingHistoryResponse?corporateBookingHistoryResponse;
  bool isLoadingHistory=false;
  Future<void> fetchBookingsHistory(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.getCorporateBookingsHistory(context: context);
      corporateBookingHistoryResponse = result;
    } catch (e) {
      errorMessage = e.toString();
      corporateBookingHistoryResponse = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}