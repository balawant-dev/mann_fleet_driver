import 'package:flutter/material.dart';

import '../../../../widget/motionToastHelper.dart';

import '../pro/corporate_booking_provider.dart';
import 'bottom_sheet_shell.dart';
import 'expense_images_sheet.dart';

Future<void> showExtraChargeSheet({
  required BuildContext context,
  required CorporateBookingProvider provider,
  required String bookingId,
  VoidCallback? onSuccess,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => _ExtraChargeSheet(
          parentContext: context,
          provider: provider,
          bookingId: bookingId,
          onSuccess: onSuccess,
        ),
  );
}

class _ExtraChargeSheet extends StatefulWidget {
  const _ExtraChargeSheet({
    required this.parentContext,
    required this.provider,
    required this.bookingId,
    this.onSuccess,
  });

  final BuildContext parentContext;
  final CorporateBookingProvider provider;
  final String bookingId;
  final VoidCallback? onSuccess;

  @override
  State<_ExtraChargeSheet> createState() => _ExtraChargeSheetState();
}

class _ExtraChargeSheetState extends State<_ExtraChargeSheet> {
  final _tollController = TextEditingController();
  final _parkingController = TextEditingController();
  final _stateController = TextEditingController();
  final _otherController = TextEditingController();

  @override
  void dispose() {
    _tollController.dispose();
    _parkingController.dispose();
    _stateController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  String _valueOrZero(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty ? '0' : text;
  }

  Future<void> _submit() async {
    final toll = _valueOrZero(_tollController);
    final parking = _valueOrZero(_parkingController);
    final state = _valueOrZero(_stateController);
    final other = _valueOrZero(_otherController);

    final parent = widget.parentContext;
    final provider = widget.provider;
    final bookingId = widget.bookingId;
    final onSuccess = widget.onSuccess;

    Navigator.pop(context);

    final success = await provider.extraChargeApi(
      context: parent,
      bookingId: bookingId,
      tollAmount: toll,
      otherCharges: other,
      parkingCharge: parking,
      stateCharge: state,
    );
    if (!parent.mounted) return;

    if (!success) {
      ToastHelper.show(
        parent,
        message: provider.errorMessage ?? 'Failed to add charges',
        type: ToastType.error,
      );
      return;
    }

    ToastHelper.show(
      parent,
      message: 'Extra Charges added successfully',
      type: ToastType.success,
    );

    // Optional expense images sheet opens automatically.
    await Future.delayed(const Duration(milliseconds: 400));
    if (parent.mounted) {
      showExpenseImagesSheet(
        context: parent,
        provider: provider,
        bookingId: bookingId,
      );
    }
    onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: 'Extra Charges',
      scrollable: true,
      children: [
        _chargeField(_tollController, 'Toll Amount', Icons.toll),
        const SizedBox(height: 14),
        _chargeField(_parkingController, 'Parking Charge', Icons.local_parking),
        const SizedBox(height: 14),
        _chargeField(_stateController, 'State Charge', Icons.map),
        const SizedBox(height: 14),
        _chargeField(_otherController, 'Other Charges', Icons.more_horiz),
        const SizedBox(height: 24),
        SheetPrimaryButton(
          label: 'Submit Extra Charges',
          color: Colors.deepOrange,
          onPressed: _submit,
        ),
      ],
    );
  }

  Widget _chargeField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
