import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:provider/provider.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../otp_screen/ui/otp_screen.dart';
import '../provider/loginProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController mobileController = TextEditingController();
  String countryCode = "+91";
  bool isValid(LoginProvider provider) =>
      provider.mobileNumberController.text.length == 10;
  @override
  Widget build(BuildContext context) {
    return  Consumer<LoginProvider>(
        builder: (context, provider, child){
          return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/loginImage.png"),
                  fit: BoxFit.cover,
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 310),



                    /// Title
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome to Mann Fleet\nPartners Limited",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4A4F58),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Mobile Input
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          /// Country Picker
                          CountryCodePicker(
                            onChanged: (code) {
                              countryCode = code.dialCode!;
                            },
                            initialSelection: 'IN',
                            favorite: const ['+91', 'IN'],
                            showFlag: false,
                            showDropDownButton: true,
                            padding: EdgeInsets.zero,
                            textStyle: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(width: 5),

                          /// Mobile TextField
                          Expanded(
                            child: TextField(
                              controller: provider.mobileNumberController,
                              keyboardType: TextInputType.phone,
                              textAlignVertical: TextAlignVertical.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (value) {
                                provider.onPhoneChanged(value); // 👈 IMPORTANT
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter your Mobile number",
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    CommonAppButton(
                      text: 'GetOTP',
                      backgroundColor: isValid(provider) ? ColorResource.primaryColor : Colors.grey,
                      onPressed: isValid(provider)
                          ? () async {

                        final phone = provider.mobileNumberController.text;

                        showLoader(context);

                        final viewModel = context.read<LoginProvider>();

                        await viewModel.sendOtp(
                          context: context,
                          phone: phone,
                          countryCode: provider.countryCode,
                        );

                        Navigator.pop(context);

                        if (viewModel.signInModel != null &&
                            viewModel.signInModel!.status == true) {

                          navPush(
                            context: context,
                            action: OtpScreen(
                              mobileNumber: phone,
                            ),
                          );

                        } else {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to send OTP"),
                            ),
                          );

                        }

                      }
                          : null,
                    ),



                    const SizedBox(height: 20),

                    /// Terms Text
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const TextSpan(
                            text: 'Terms of Use',
                            style: TextStyle(
                              color: Color(0xFF3E4959),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ' and\n ',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF3E4959),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}