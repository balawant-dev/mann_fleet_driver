import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';
import '../../../widget/commonAppButton.dart';
import '../provider/compliance_provider.dart';


class ComplianceScreen extends StatelessWidget {
  const ComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ComplianceProvider>(context);

    return Scaffold(

      appBar: const CommonAppBar(title: "Compliance"),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            _uploadBox("Insurance Policy", provider.insurance, provider.pickInsurance),

            const SizedBox(height: 15),

            _uploadBox("Pollution Certificate", provider.pollution, provider.pickPollution),

            const SizedBox(height: 15),

            _uploadBox("Police Verification", provider.policeVerification, provider.pickPolice),

            const SizedBox(height: 30),

            CommonAppButton(
              text: "Submit",
              onPressed: () {},
            )

          ],
        ),
      ),
    );
  }

  Widget _uploadBox(String title, File? image, VoidCallback onTap){

    return GestureDetector(

      onTap: onTap,

      child: Container(
        height: 120,
        width: double.infinity,
        color: Colors.grey.shade200,

        child: image == null
            ? Center(child: Text(title))
            : Image.file(image,fit: BoxFit.cover),

      ),

    );

  }
}