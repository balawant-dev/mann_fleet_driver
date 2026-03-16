import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/commonAppBar.dart';
import '../../../../widget/commonAppButton.dart';
import '../../../../widget/commonTextFormField.dart';
import '../../../../widget/navigator_method.dart';
import '../../../bottomBar/bottomBar.dart';
import '../../../home_screen/ui/home_screen.dart';
import '../provider/registerProvider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<RegisterProvider>(context);

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
            CommonAppButton(onPressed: (){

              print(provider.nameController.text);
              print(provider.emailController.text);
          navPushBottomRemove(context: context, action: MainScreen(), duration: 1);
            },text:"Register" ,),

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
}