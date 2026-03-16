import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PersonalProfileProvider extends ChangeNotifier {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  File? profileImage;

  final picker = ImagePicker();

  Future pickProfile() async {

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if(picked != null){
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

}