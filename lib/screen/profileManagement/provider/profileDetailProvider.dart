
import 'package:flutter/material.dart';


import '../model/getProfileModel.dart';

import '../repo/profileRepo.dart';



class ProfileDetailProvider extends ChangeNotifier {
  final api = ProfileRepo();

  GetProfileModel? getProfileModel;


  bool isLoading = false;

  Future<void> getProfileApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getProfileApi( context: context);
      getProfileModel = res;
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
