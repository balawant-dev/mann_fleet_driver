


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/screen/bottomBar/bottomBar.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';

import '../model/registerModel.dart';
import '../repo/registerRepo.dart';

class RegisterProvider extends ChangeNotifier {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final licenceController = TextEditingController();

  String gender = "Male";

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

  void setGender(String value){
    gender = value;
    notifyListeners();
  }

  TextEditingController mobileNumberController = TextEditingController();

  String? errorText;
  String countryCode = "+91";

  void changeCountryCode(String code) {
    countryCode = code;
    notifyListeners();
  }


  final api = RegisterRepo();

  RegisterModel? registerModel;


  bool isLoading = false;

  Future<void> registerApi({    required String name,
    required String email ,
    required String phone ,
    required String licenseNumber ,
    required String gender ,
    required String profilePic ,
    required BuildContext context,}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.registerApi(phone: phone, context: context,email: email,name: name,gender: gender,licenseNumber: licenseNumber,profilePic: profilePic);
      registerModel = res;
      if (res != null && res.status == true){
        print("registerApi Successfully");
        // navPushBottomRemove(context: context, action: MainScreen(), duration: 2);
      }

    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }
  void onPhoneChanged(String value) {
    notifyListeners();
  }

}