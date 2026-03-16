import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ComplianceProvider extends ChangeNotifier{

  File? insurance;
  File? pollution;
  File? policeVerification;

  final picker = ImagePicker();

  Future pickInsurance() async{
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if(picked != null){
      insurance = File(picked.path);
      notifyListeners();
    }
  }

  Future pickPollution() async{
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if(picked != null){
      pollution = File(picked.path);
      notifyListeners();
    }
  }

  Future pickPolice() async{
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if(picked != null){
      policeVerification = File(picked.path);
      notifyListeners();
    }
  }

}