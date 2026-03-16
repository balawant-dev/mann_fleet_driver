import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:mann_fleet_driver/widget/commonAppBar.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/custom_text.dart';

class StartRideScreen extends StatefulWidget {
  const StartRideScreen({super.key});

  @override
  State<StartRideScreen> createState() => _StartRideScreenState();
}

class _StartRideScreenState extends State<StartRideScreen> {

  File? selectedImage;

  int rating = 4;

  List<String> feedbackList = [
    "Polite",
    "On Time",
    "Clear Directions",
    "Great Conversation",
    "Quiet & Relaxing"
  ];

  List<String> selectedFeedback = [];

  final TextEditingController reviewController = TextEditingController();

  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Widget star(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          rating = index;
        });
      },
      child: Icon(
        Icons.star,
        size: 35,
        color: index <= rating ? Colors.amber : Colors.grey.shade300,
      ),
    );
  }

  Widget feedbackChip(String text) {

    bool isSelected = selectedFeedback.contains(text);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedFeedback.remove(text);
          } else {
            selectedFeedback.add(text);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? ColorResource.indigo : ColorResource.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? ColorResource.indigo : ColorResource.grayText,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? ColorResource.white : ColorResource.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CommonAppBar(title: 'Start Your Ride'),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(15),
        child: CommonAppButton(
          text: 'Submit Review',
          onPressed: () {},
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorResource.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(.05),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                        selectedImage != null ? FileImage(selectedImage!) : null,
                        child: selectedImage == null
                            ? const Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomText(
                      "Johnathan Doe",
                      size: 20,
                      weight: FontWeight.w400,
                      color: ColorResource.black,
                    ),

                    const SizedBox(height: 4),
                    CustomText(
                        "PASSENGER",
                      size: 10,
                      weight: FontWeight.w400,
                      color: ColorResource.grayText,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      "How was your trip with\n Johnathan?",
                      size: 14,
                      weight: FontWeight.w400,
                      color: ColorResource.grayText,
                      align: TextAlign.center ,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        star(1),
                        star(2),
                        star(3),
                        star(4),
                        star(5),
                      ],
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorResource.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(.05),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        "QUICK FEEDBACK",
                      size: 10,
                      weight: FontWeight.w400,
                      color: ColorResource.indigo,
                    ),

                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                      feedbackList.map((e) => feedbackChip(e)).toList(),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),


              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: ColorResource.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(.05),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CustomText(
                      "ADDITIONAL COMMENTS",
                      size: 10,
                      weight: FontWeight.w400,
                      color: ColorResource.indigo,
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write a review...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )

                  ],
                ),
              ),

              const SizedBox(height: 100),

            ],
          ),
        ),
      ),
    );
  }
}