import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickupProvider extends ChangeNotifier {

  final ImagePicker picker = ImagePicker();

  File? front;
  File? back;
  File? left;
  File? right;
  File? interior;
  File? speedometer;

  Future pickImage(String type) async {

    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    File file = File(picked.path);

    switch (type) {
      case "front":
        front = file;
        break;
      case "back":
        back = file;
        break;
      case "left":
        left = file;
        break;
      case "right":
        right = file;
        break;
      case "interior":
        interior = file;
        break;
      case "speedometer":
        speedometer = file;
        break;
    }

    notifyListeners();
  }

}