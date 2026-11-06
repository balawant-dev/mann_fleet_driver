import 'package:flutter/material.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';
import 'package:pinput/pinput.dart';

import '../../../../widget/motionToastHelper.dart';

import '../pro/corporate_booking_provider.dart';
import 'bottom_sheet_shell.dart';
import 'run_with_toast.dart';

Future<void> showOtpSheet({
  required BuildContext context,
  required CorporateBookingProvider provider,
  required String title,
  required String successMessage,
  required bool isLoading,
  required Future<bool> Function(String otp) onSubmit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => _OtpSheet(
          parentContext: context,
          provider: provider,
          title: title,
          successMessage: successMessage,
          isLoading: isLoading,
          onSubmit: onSubmit,
        ),
  );
}

class _OtpSheet extends StatefulWidget {
  const _OtpSheet({
    required this.parentContext,
    required this.provider,
    required this.title,
    required this.successMessage,
    required this.isLoading,
    required this.onSubmit,
  });

  final BuildContext parentContext;
  final CorporateBookingProvider provider;
  final String title;
  final String successMessage;
  final bool isLoading;
  final Future<bool> Function(String otp) onSubmit;

  @override
  State<_OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<_OtpSheet> {
  static const _otpLength = 4;

  final _otpController = TextEditingController();

  late final PinTheme _defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
  );

  late final PinTheme _focusedPinTheme = _defaultPinTheme.copyWith(
    decoration: _defaultPinTheme.decoration?.copyWith(
      border: Border.all(color: ColorResource.primaryColor, width: 2),
    ),
  );

  late final PinTheme _submittedPinTheme = _defaultPinTheme.copyWith(
    decoration: _defaultPinTheme.decoration?.copyWith(
      color: Colors.grey.shade50,
      border: Border.all(color: ColorResource.primaryColor),
    ),
  );

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final otp = _otpController.text.trim();
    final parent = widget.parentContext;

    if (otp.length < _otpLength) {
      ToastHelper.show(
        parent,
        message: 'Please enter 4-digit OTP',
        type: ToastType.warning,
      );
      return;
    }

    final provider = widget.provider;
    final onSubmit = widget.onSubmit;
    final successMessage = widget.successMessage;

    Navigator.pop(context);

    await runWithToast(
      parent,
      provider,
      () => onSubmit(otp),
      successMessage: successMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: widget.title,
      children: [
        Pinput(
          length: _otpLength,
          controller: _otpController,
          defaultPinTheme: _defaultPinTheme,
          focusedPinTheme: _focusedPinTheme,
          submittedPinTheme: _submittedPinTheme,
          keyboardType: TextInputType.number,
          showCursor: true,
        ),
        const SizedBox(height: 24),
        SheetPrimaryButton(
          label: 'Verify OTP',
          color: ColorResource.primaryColor,
          isLoading: widget.isLoading,
          onPressed: widget.isLoading ? null : _submit,
        ),
      ],
    );
  }
}
