import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../provider/personal_profile_provider.dart';


class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<PersonalProfileProvider>(context);

    return Scaffold(

      appBar: const CommonAppBar(title: "Personal Profile"),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(

          children: [

            GestureDetector(
              onTap: provider.pickProfile,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: provider.profileImage != null
                    ? FileImage(provider.profileImage!)
                    : null,
                child: provider.profileImage == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            CommonTextFormField(
              controller: provider.name,
              labelText: "Name",
              hintText: "Enter name",
            ),

            const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.email,
              labelText: "Email",
              hintText: "Enter email",
            ),

            const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.phone,
              labelText: "Phone",
              hintText: "Enter phone number",
            ),

            const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.address,
              labelText: "Address",
              hintText: "Enter address",
            ),

            const SizedBox(height: 30),

            CommonAppButton(
              text: "Save",
              onPressed: () {},
            )

          ],
        ),
      ),
    );
  }
}