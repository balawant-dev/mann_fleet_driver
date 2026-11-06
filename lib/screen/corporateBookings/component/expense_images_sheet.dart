import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../pro/corporate_booking_provider.dart';
import 'bottom_sheet_shell.dart';
import 'run_with_toast.dart';

Future<void> showExpenseImagesSheet({
  required BuildContext context,
  required CorporateBookingProvider provider,
  required String bookingId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => _ExpenseImagesSheet(
          parentContext: context,
          provider: provider,
          bookingId: bookingId,
        ),
  );
}

class _ExpenseImagesSheet extends StatefulWidget {
  const _ExpenseImagesSheet({
    required this.parentContext,
    required this.provider,
    required this.bookingId,
  });

  final BuildContext parentContext;
  final CorporateBookingProvider provider;
  final String bookingId;

  @override
  State<_ExpenseImagesSheet> createState() => _ExpenseImagesSheetState();
}

class _ExpenseImagesSheetState extends State<_ExpenseImagesSheet> {
  static const _maxImages = 10;

  final _picker = ImagePicker();
  final List<File> _images = [];

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 70);
    if (picked.isEmpty || !mounted) return;

    setState(() {
      final remaining = _maxImages - _images.length;
      _images.addAll(picked.take(remaining).map((e) => File(e.path)));
    });
  }

  Future<void> _submit() async {
    final images = List<File>.of(_images);
    final parent = widget.parentContext;
    final provider = widget.provider;
    final bookingId = widget.bookingId;

    Navigator.pop(context);

    await runWithToast(
      parent,
      provider,
      () => provider.uploadExpenseImages(
        context: parent,
        bookingId: bookingId,
        expenseImages: images,
      ),
      successMessage: 'Expense images uploaded successfully',
      fallbackError: 'Failed to upload images',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUploading = widget.provider.isUploadExpenseImages;

    return BottomSheetShell(
      title: 'Upload Expense Images (Optional)',
      titleGap: 6,
      children: [
        Text(
          'You can upload up to $_maxImages images',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        if (_images.isNotEmpty) ...[_buildThumbnails(), const SizedBox(height: 16)],
        if (_images.length < _maxImages) _buildAddButton(),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildSkipButton()),
            const SizedBox(width: 12),
            Expanded(
              child: SheetPrimaryButton(
                label: 'Submit',
                color: Colors.deepOrange,
                isLoading: isUploading,
                onPressed: _images.isEmpty || isUploading ? null : _submit,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThumbnails() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _images[index],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _images.removeAt(index)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
            SizedBox(width: 8),
            Text('Add Expense Images', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Skip'),
      ),
    );
  }
}
