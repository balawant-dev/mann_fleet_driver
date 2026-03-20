
import 'package:flutter/material.dart';



import '../model/newBookingModel.dart';
import '../repo/newBookingRepo.dart';



class NewBookingProvider extends ChangeNotifier {
  final api = NewBookingRepo();

  NewBookingModel? newBookingModel;


  bool isLoading = false;

  Future<void> getNewBooking({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getNewBooking( context: context);
      newBookingModel = res;
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
