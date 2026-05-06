import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
/// 🔲 Custom Overlay Shape
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QrScannerOverlayShape({
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderLength,
    required this.cutOutSize,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;

    final cutOutRect = Rect.fromCenter(
      center: Offset(width / 2, height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final backgroundPath = Path()..addRect(rect);
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)));

    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(finalPath, overlayPaint);

    // Draw corners
    final r = borderRadius;
    final l = borderLength;

    // Top Left
    canvas.drawLine(
        Offset(cutOutRect.left, cutOutRect.top + r),
        Offset(cutOutRect.left, cutOutRect.top + l),
        borderPaint);
    canvas.drawLine(
        Offset(cutOutRect.left + r, cutOutRect.top),
        Offset(cutOutRect.left + l, cutOutRect.top),
        borderPaint);

    // Top Right
    canvas.drawLine(
        Offset(cutOutRect.right - r, cutOutRect.top),
        Offset(cutOutRect.right - l, cutOutRect.top),
        borderPaint);
    canvas.drawLine(
        Offset(cutOutRect.right, cutOutRect.top + r),
        Offset(cutOutRect.right, cutOutRect.top + l),
        borderPaint);

    // Bottom Left
    canvas.drawLine(
        Offset(cutOutRect.left, cutOutRect.bottom - r),
        Offset(cutOutRect.left, cutOutRect.bottom - l),
        borderPaint);
    canvas.drawLine(
        Offset(cutOutRect.left + r, cutOutRect.bottom),
        Offset(cutOutRect.left + l, cutOutRect.bottom),
        borderPaint);

    // Bottom Right
    canvas.drawLine(
        Offset(cutOutRect.right - r, cutOutRect.bottom),
        Offset(cutOutRect.right - l, cutOutRect.bottom),
        borderPaint);
    canvas.drawLine(
        Offset(cutOutRect.right, cutOutRect.bottom - r),
        Offset(cutOutRect.right, cutOutRect.bottom - l),
        borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }
}