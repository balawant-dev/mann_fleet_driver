


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

}