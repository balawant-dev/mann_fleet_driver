import 'package:flutter/material.dart';

import '../../../../widget/motionToastHelper.dart';

import '../pro/corporate_booking_provider.dart';

/// Runs [action] and shows a success toast, or the provider error toast.
///
/// [context] must be a context that stays mounted after the action
/// (the screen context, not a bottom-sheet context).
Future<void> runWithToast(
  BuildContext context,
  CorporateBookingProvider provider,
  Future<bool> Function() action, {
  required String successMessage,
  String fallbackError = 'Failed',
}) async {
  final success = await action();
  if (!context.mounted) return;

  ToastHelper.show(
    context,
    message: success ? successMessage : (provider.errorMessage ?? fallbackError),
    type: success ? ToastType.success : ToastType.error,
  );
}
