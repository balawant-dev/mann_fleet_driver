import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mann_fleet_driver/util/color/app_colors.dart';

import '../../../../widget/motionToastHelper.dart';

import '../../fuel_entry/service/open_ai_service.dart';
import '../pro/corporate_booking_provider.dart';
import 'bottom_sheet_shell.dart';
import 'run_with_toast.dart';

typedef OdometerSubmit =
    Future<bool> Function(
      String odometer,
      double lat,
      double lng,
      File image,
    );

Future<void> showOdometerSheet({
  required BuildContext context,
  required CorporateBookingProvider provider,
  required String title,
  required String submitLabel,
  required bool isLoading,
  required String successMessage,
  required OdometerSubmit onSubmit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => _OdometerSheet(
          parentContext: context,
          provider: provider,
          title: title,
          submitLabel: submitLabel,
          isLoading: isLoading,
          successMessage: successMessage,
          onSubmit: onSubmit,
        ),
  );
}

class _OdometerSheet extends StatefulWidget {
  const _OdometerSheet({
    required this.parentContext,
    required this.provider,
    required this.title,
    required this.submitLabel,
    required this.isLoading,
    required this.successMessage,
    required this.onSubmit,
  });

  final BuildContext parentContext;
  final CorporateBookingProvider provider;
  final String title;
  final String submitLabel;
  final bool isLoading;
  final String successMessage;
  final OdometerSubmit onSubmit;

  @override
  State<_OdometerSheet> createState() => _OdometerSheetState();
}

class _OdometerSheetState extends State<_OdometerSheet> {
  final _odometerController = TextEditingController();
  final _picker = ImagePicker();
  File? _image;
  bool _isScanning = false;

  @override
  void dispose() {
    _odometerController.dispose();
    super.dispose();
  }

  void _toast(String message, ToastType type) =>
      ToastHelper.show(context, message: message, type: type);

  /// Capture photo and auto-read the odometer value from it.
  Future<void> _captureAndScan() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _image = File(picked.path);
      _isScanning = true;
      _odometerController.clear();
    });

    try {
      final double reading = await getOdometerReadingFromImageOpenAi(
        File(picked.path),
      );
      if (!mounted) return;
      setState(() {
        _odometerController.text = reading.toStringAsFixed(0);
        _isScanning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isScanning = false);
      _toast(e.toString().replaceFirst('Exception: ', ''), ToastType.error);
    }
  }

  /// Returns current position, or null (after showing a toast) if not allowed.
  Future<Position?> _getPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) _toast('Please enable location', ToastType.warning);
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _toast('Location permission denied', ToastType.error);
        return null;
      }
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _submit() async {
    final odometer = _odometerController.text.trim();
    if (odometer.isEmpty) {
      _toast('Please enter odometer reading', ToastType.warning);
      return;
    }
    final image = _image;
    if (image == null) {
      _toast('Please capture odometer image', ToastType.warning);
      return;
    }

    final position = await _getPosition();
    if (position == null || !mounted) return;

    final parent = widget.parentContext;
    final provider = widget.provider;
    final onSubmit = widget.onSubmit;
    final successMessage = widget.successMessage;

    Navigator.pop(context);

    await runWithToast(
      parent,
      provider,
      () => onSubmit(odometer, position.latitude, position.longitude, image),
      successMessage: successMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetShell(
      title: widget.title,
      children: [
        _buildImagePicker(),
        const SizedBox(height: 16),
        _buildOdometerField(),
        const SizedBox(height: 24),
        SheetPrimaryButton(
          label: widget.submitLabel,
          color: ColorResource.primaryColor,
          isLoading: widget.isLoading,
          onPressed: _isScanning ? null : _submit,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _captureAndScan,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.shade50,
        ),
        child:
            _image == null
                ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 42, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Tap to capture Odometer Image',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
      ),
    );
  }

  Widget _buildOdometerField() {
    return TextField(
      controller: _odometerController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Odometer Reading',
        prefixIcon: const Icon(Icons.speed),
        suffixIcon:
            _isScanning
                ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        helperText:
            _image != null
                ? 'Auto-filled from image (tap image to re-scan)'
                : 'Capture image to auto-fill',
      ),
    );
  }
}
