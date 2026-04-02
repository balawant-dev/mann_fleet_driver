import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/commonAppBar.dart';
import '../../../../widget/commonAppButton.dart';
import '../../../../widget/commonTextFormField.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../bottomBar/bottomBar.dart';
import '../../../home_screen/ui/home_screen.dart';
import '../../../profileManagement/screen/profileManagementScreen.dart';
import '../provider/registerProvider.dart';

class RegisterScreen extends StatefulWidget {
  final String mobileNumber;
  const RegisterScreen({super.key,required this.mobileNumber});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    // Very important: show the number received from previous screen
    final provider = Provider.of<RegisterProvider>(context, listen: false);
    provider.mobileController.text = widget.mobileNumber;

    // Optional: if you want to show only last 10 digits or clean it
    // provider.mobileController.text = widget.mobileNumber.replaceAll(RegExp(r'[^0-9]'), '').substring(widget.mobileNumber.length - 10);
  }
  @override
  Widget build(BuildContext context) {



    return Consumer<RegisterProvider>(
        builder: (context, provider, child){
          return Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(title: "Driver Registration",),
          // appBar: AppBar(
          //   title: const Text("Driver Registration"),
          //   backgroundColor: ColorResource.primaryColor,
          // ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// PROFILE IMAGE
                GestureDetector(
                  onTap: () {
                    provider.pickImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: provider.profileImage != null
                        ? FileImage(provider.profileImage!)
                        : null,
                    child: provider.profileImage == null
                        ? const Icon(Icons.camera_alt,size:30)
                        : null,
                  ),
                ),

                const SizedBox(height: 30),

                /// NAME
                CommonTextFormField(
                  controller: provider.nameController,
                  labelText: "Full Name",
                  hintText: "Enter full name",
                  prefixIcon: Icons.person,
                ),

                const SizedBox(height: 15),

                /// EMAIL
                CommonTextFormField(
                  controller: provider.emailController,
                  labelText: "Email",
                  hintText: "Enter email",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 15),

                /// MOBILE
                CommonTextFormField(
                  controller: provider.mobileController,
                  labelText: "Mobile Number",
                  hintText: "Enter mobile number",
                  prefixIcon: Icons.phone,
                  readOnly: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),

                const SizedBox(height: 15),

                /// LICENSE
                CommonTextFormField(
                  controller: provider.licenceController,
                  labelText: "Driving Licence Number",
                  hintText: "Enter licence number",
                  prefixIcon: Icons.badge,
                ),

                const SizedBox(height: 20),

                /// GENDER
                Row(
                  children: [

                    const Text(
                      "Gender : ",
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                    ),

                    Radio(
                      value: "Male",
                      groupValue: provider.gender,
                      onChanged: (value){
                        provider.setGender(value!);
                      },
                    ),
                    const Text("Male"),

                    Radio(
                      value: "Female",
                      groupValue: provider.gender,
                      onChanged: (value){
                        provider.setGender(value!);
                      },
                    ),
                    const Text("Female"),
                  ],
                ),

                const SizedBox(height: 30),
                CommonAppButton(
                  text: "Register",
                  onPressed: () async {

                    if (provider.profileImage == null) {
                      ToastHelper.show(
                        context,
                        message:"Please select profile image",
                        type: ToastType.error,
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text("Please select profile image")),
                      // );
                      return;
                    }

                    if (provider.nameController.text.isEmpty ||
                        provider.emailController.text.isEmpty ||
                        provider.mobileController.text.length != 10 ||
                        provider.licenceController.text.isEmpty) {
                      ToastHelper.show(
                        context,
                        message:"Please fill all fields correctly",
                        type: ToastType.error,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields correctly")),
                      );
                      return;
                    }
                    showLoader(context);

                    await provider.registerApi(
                      context: context,
                      name: provider.nameController.text,
                      email: provider.emailController.text,
                      phone: provider.mobileController.text,
                      licenseNumber: provider.licenceController.text,
                      gender: provider.gender=="Male"?"male":"female",
                      profilePic: provider.profileImage!.path??"No Image",
                    );
                    Navigator.pop(context);

                    if (provider.registerModel != null &&
                        provider.registerModel!.status == true) {


                      navPushBottomRemove(
                        duration: 1,
                        context: context,
                        action: const ProfileManagementScreen(),
                      );

                    } else {
                      ToastHelper.show(
                        context,
                        message:"Registration failed. Please try again.",
                        type: ToastType.error,
                      );
                      //
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Registration failed. Please try again."),
                      //   ),
                      // );

                    }
                  },
                ),
              //   CommonAppButton(onPressed: (){
              //
              //     print(provider.nameController.text);
              //     print(provider.emailController.text);
              // navPushBottomRemove(context: context, action: MainScreen(), duration: 1);
              //   },text:"Register" ,),

                /// REGISTER BUTTON
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: ColorResource.primaryColor,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     onPressed: () {
                //
                //
                //     },
                //     child: const Text(
                //       "Register",
                //       style: TextStyle(fontSize: 16,color: Colors.white),
                //     ),
                //   ),
                // )

              ],
            ),
          ),
        );
      }
    );
  }
}