import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VehicleDetailsProvider extends ChangeNotifier{

  TextEditingController carModel = TextEditingController();
  TextEditingController numberPlate = TextEditingController();

  File? rcImage;

  final picker = ImagePicker();

  Future pickRC() async{

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if(picked != null){
      rcImage = File(picked.path);
      notifyListeners();
    }

  }

}