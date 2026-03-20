
import 'package:flutter/material.dart';



import '../model/bookingDetailModel.dart';
import '../repo/bookingDetailRepo.dart';



class BookingDetailProvider extends ChangeNotifier {
  final api = BookingDetailRepo();

  BookingDetailModel? bookingDetailModel;


  bool isLoading = false;

  Future<void> getNewBooking({required BuildContext context,required String id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getBookingDetailApi( context: context,id: id);
      bookingDetailModel = res;
      if(res!=null||res.status==true){
        print("Get Profile Successfully");
      }

    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }


}
