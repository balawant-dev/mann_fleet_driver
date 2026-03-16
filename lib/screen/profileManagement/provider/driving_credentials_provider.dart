import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DrivingCredentialsProvider extends ChangeNotifier{

  TextEditingController dlNumber = TextEditingController();
  TextEditingController dlExpiry = TextEditingController();

  File? dlFront;
  File? dlBack;

  final picker = ImagePicker();

  Future pickFront() async{

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if(picked != null){
      dlFront = File(picked.path);
      notifyListeners();
    }

  }

  Future pickBack() async{

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if(picked != null){
      dlBack = File(picked.path);
      notifyListeners();
    }

  }

}