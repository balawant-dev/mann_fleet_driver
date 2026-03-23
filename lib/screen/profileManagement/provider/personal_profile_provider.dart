import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/screen/profileManagement/provider/profileDetailProvider.dart';

import '../../auth/register/model/registerModel.dart';
import '../model/getProfileModel.dart';
import '../repo/profileRepo.dart';
import 'package:provider/provider.dart';

class PersonalProfileProvider extends ChangeNotifier {

  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController permanentAddress = TextEditingController();
  TextEditingController currentAddress = TextEditingController();

  File? profileImage;

  final picker = ImagePicker();

  Future pickProfile() async {

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if(picked != null){
      profileImage = File(picked.path);
      notifyListeners();
    }
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final licenceController = TextEditingController();

  String gender = "Male";



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


  final api = ProfileRepo();

  RegisterModel? registerModel;


  bool isLoading = false;
  void setProfileData(DriverProfile? driver) {
    if (driver == null) return;
    String fullName = (driver.name ?? "").trim();
    List<String> parts = fullName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();

    // Reset
    firstName.text = "";
    middleName.text = "";
    lastName.text = "";

    if (parts.isNotEmpty) {
      if (parts.length == 1) {
        firstName.text = parts[0];
      } else if (parts.length == 2) {
        firstName.text = parts[0];
        lastName.text = parts[1];
      } else {
        firstName.text = parts[0];
        lastName.text = parts.last;
        middleName.text = parts.sublist(1, parts.length - 1).join(" ");
      }
    }
    print("Final values set → First: '${firstName.text}', Middle: '${middleName.text}', Last: '${lastName.text}'");
    print("Raw name from API: '${driver.name}'");
    print("After trim: '${fullName}'");
    print("Parts: $parts");
    // firstName.text = driver.name ?? "";
    // middleName.text = driver.name ?? "";
    // lastName.text = driver.name ?? "";
    email.text = driver.email ?? "";
    phone.text = driver.phone ?? "";
    currentAddress.text = driver.currentAddress ?? "";
    permanentAddress.text = driver.permanentAddress ?? "";
    gender = driver.name ?? "Male";

    notifyListeners();
  }
  Future<void> updateBasicDetail({    required String name,
    required String email ,
    required String phone ,

    required String permanentAddress ,
    required String currentAddress ,
    required String gender ,
    required String profilePic ,
    required BuildContext context,}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.updateBasicDetail(phone: phone, context: context,email: email,name: name,gender: "male",permanentAddress: permanentAddress,currentAddress: currentAddress,profilePic: profilePic);
      registerModel = res;
      if (res != null && res.status == true){
        print("Profile Updated Successfully ✅");

        /// 🔥 STEP 2: GET PROFILE AGAIN
        final profileProvider = context.read<ProfileDetailProvider>();

        await profileProvider.getProfileApi(context: context);

        /// 🔥 STEP 3: UI UPDATE (Prefill again)
        setProfileData(profileProvider.getProfileModel?.data?.driver);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully")),
        );
        // navPushBottomRemove(context: context, action: MainScreen(), duration: 2);
      }

    } catch (e) {
      debugPrint("Error in updateBasicDetail: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }
  void onPhoneChanged(String value) {
    notifyListeners();
  }

}