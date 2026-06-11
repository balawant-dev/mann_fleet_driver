import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:mann_fleet_driver/widget/commonAppButton.dart';
import 'package:mann_fleet_driver/widget/navigator_method.dart';
import 'package:provider/provider.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../cms/ui/cMSContentScreen.dart';
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
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login.png"),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ), // Side padding thodi kam ki
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 1.5),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Country Picker
                          Theme(
                            // Isse picker ke andar ki default padding/margin control hoti hai
                            data: Theme.of(
                              context,
                            ).copyWith(visualDensity: VisualDensity.compact),
                            child: CountryCodePicker(
                              onChanged: (code) {
                                countryCode = code.dialCode!;
                              },
                              initialSelection: 'IN',
                              favorite: const ['+91', 'IN'],
                              showFlag: false,
                              showDropDownButton: true,
                              padding: EdgeInsets.zero, // Zero padding
                              margin:
                                  EdgeInsets
                                      .zero, // Extra margin hatane ke liye
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                          ),

                          // Vertical Divider (Optional: agar dono ke beech halki line chahiye toh)
                          // Container(height: 20, width: 1, color: Colors.grey[300]),

                          //   const SizedBox(width: 2), // Gap minimum rakha

                          /// Mobile TextField
                          Expanded(
                            child: TextFormField(
                              controller: provider.mobileNumberController,
                              keyboardType: TextInputType.phone,
                              textAlignVertical: TextAlignVertical.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (value) {
                                provider.onPhoneChanged(value);
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter your Mobile number",
                                hintStyle: TextStyle(fontSize: 14),

                                // Sabhi borders ko explicitly hatane ke liye:
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding:
                                    EdgeInsets
                                        .zero, // Default inner padding khatam
                                isDense:
                                    true, // TextField ko compact banane ke liye
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    CommonAppButton(
                      text: 'GetOTP',
                      backgroundColor:
                          isValid(provider)
                              ? ColorResource.primaryColor
                              : Colors.grey,
                      onPressed:
                          isValid(provider)
                              ? () async {
                                final phone =
                                    provider.mobileNumberController.text;

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
                                    action: OtpScreen(mobileNumber: phone),
                                  );
                                } else {
                                  ToastHelper.show(
                                    context,
                                    message: "Failed to send OTP",
                                    type: ToastType.error,
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
                          TextSpan(
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    navPush(
                                      context: context,
                                      action: const CMSContentScreen(
                                        title: "Terms & Conditions",
                                        type: CMSContentType.terms,
                                      ),
                                    );
                                    // 👉 Navigate or open screen
                                    print("Terms clicked");
                                  },
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
                          TextSpan(
                            text: 'Privacy Policy',
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    navPush(
                                      context: context,
                                      action: const CMSContentScreen(
                                        title: "Privacy Policy",
                                        type: CMSContentType.privacy,
                                      ),
                                    );
                                    // 👉 Navigate or open screen
                                    print("Policy clicked");
                                  },
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
      },
    );
  }
}
