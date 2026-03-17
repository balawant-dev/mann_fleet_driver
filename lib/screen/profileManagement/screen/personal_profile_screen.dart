import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../../../widget/commonTextFormField.dart';
import '../../../widget/showLoaderFunction.dart';
import '../provider/personal_profile_provider.dart';
import '../provider/profileDetailProvider.dart';


class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final profileProvider = context.read<ProfileDetailProvider>();
      final personalProvider = context.read<PersonalProfileProvider>();

      await profileProvider.getProfileApi(context: context);

      personalProvider.setProfileData(
        profileProvider.getProfileModel?.data?.driver,
      );
    });
  }
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<PersonalProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const CommonAppBar(title: "Personal Profile"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(

          children: [

            GestureDetector(
              onTap: provider.pickProfile,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: provider.profileImage != null
                    ? FileImage(provider.profileImage!)
                    : (context.watch<ProfileDetailProvider>().getProfileModel?.data?.driver?.profilePic != null
                    ? NetworkImage(
                    context.watch<ProfileDetailProvider>().getProfileModel!.data!.driver!.profilePic!
                ) as ImageProvider
                    : null),
                // backgroundImage: provider.profileImage != null
                //     ? FileImage(provider.profileImage!)
                //     : null,
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
              controller: provider.permanentAddress,
              labelText: "Permanent Address",
              hintText: "Enter permanent address",
            ),    const SizedBox(height: 15),

            CommonTextFormField(
              controller: provider.currentAddress,
              labelText: "Current Address",
              hintText: "Enter current address",
            ),

            const SizedBox(height: 30),

            CommonAppButton(
              text: "Save",
              onPressed: () async {

                final provider = context.read<PersonalProfileProvider>();
                showLoader(context);

                await provider.updateBasicDetail(
                  context: context,
                  name: provider.name.text,
                  email: provider.email.text,
                  phone: provider.phone.text,
                  permanentAddress: provider.permanentAddress.text,
                  currentAddress: provider.currentAddress.text,
                  gender: provider.gender,
                  profilePic: provider.profileImage?.path ?? "", // 👈 optional
                );
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }
}