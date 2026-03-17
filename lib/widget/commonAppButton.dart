import 'package:flutter/material.dart';


import '../util/FontResource/FontResource.dart';
import '../util/color/app_colors.dart';
import 'customImageView.dart';
//
//
// class CommonAppButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed; // null hoga to button disabled ho jayega
//   final bool isLoading; // Loader show karne ke liye
//   final Color? backgroundColor;
//   final Color? disabledColor;
//   final Color? textColor;
//   final double? width;
//   final double height;
//   final double borderRadius;
//   final FontWeight fontWeight;
//   final double fontSize;
//
//   const CommonAppButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//     this.backgroundColor,
//     this.disabledColor,
//     this.textColor,
//     this.width,
//     this.height = 48.0,
//     this.borderRadius = 12.0,
//     this.fontWeight = FontWeight.bold,
//     this.fontSize = 16.0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final Color primaryColor = backgroundColor ?? ColorResource.primaryColor;
//     // Agar aapke pass ColorResource.primaryColor hai toh usko use karo
//     // final Color primaryColor = backgroundColor ?? ColorResource.primaryColor;
//
//     return SizedBox(
//       width: width ?? double.infinity,
//       height: height,
//       child: GestureDetector(
//         onTap: isLoading ? null : onPressed, // Loading mein disabled
//
//         child:Container(
//           width: MediaQuery.of(context).size.width,
//           height: 45,
//           alignment: Alignment.center,
//
//           clipBehavior: Clip.antiAlias,
//           decoration: ShapeDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(0.00, 0.50),
//               end: Alignment(1.00, 0.50),
//               colors: [ColorResource.primaryColor,  ColorResource.primaryColor],
//             ),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//             shadows: [
//               BoxShadow(
//                 color: Color(0x26000000),
//                 blurRadius: 4,
//                 offset: Offset(0, 4),
//                 spreadRadius: 0,
//               ),BoxShadow(
//                 color: Color(0x26000000),
//                 blurRadius: 4,
//                 offset: Offset(4, 0),
//                 spreadRadius: 0,
//               )
//             ],
//           ),
//           child: isLoading
//               ? SizedBox(
//             height: 24,
//             width: 24,
//             child: CircularProgressIndicator(
//               color: textColor ?? Colors.white,
//               strokeWidth: 2.5,
//             ),
//           )
//               : Text(
//             text,
//             style: TextStyle(
//               color: textColor ?? Colors.white,
//               fontWeight: fontWeight,
//               fontSize: fontSize,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//



// import 'package:flutter/material.dart';
// import 'package:mannfleet/util/FontResource/FontResource.dart';
// import 'package:mannfleet/widget/customImageView.dart';
//
// import '../util/color/app_colors.dart';

// class CommonAppButton extends StatelessWidget {
//   final String title;
//   final VoidCallback? onTap;
//   final Color backgroundColor;
//   final Color textColor;
//   final Color? borderColor;
//
//   const CommonAppButton({
//     super.key,
//     required this.title,
//     required this.onTap,
//     this.backgroundColor = ColorResource.buttonBackground,
//     this.textColor = ColorResource.white,
//     this.borderColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 45,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(30),
//           border: borderColor != null
//               ? Border.all(color: borderColor!)
//               : null,
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x3F000000),
//               blurRadius: 50,
//               offset: Offset(0, 25),
//               spreadRadius: -12,
//             )
//           ],
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: textColor,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
// }
//


class CommonAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final String? image;

  const CommonAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorResource.primaryColor,
    this.textColor = ColorResource.white,
    this.borderColor,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 50,
              offset: Offset(0, 25),
              spreadRadius: -12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) ...[
              CustomImageView(
                imagePath: image,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: FontResource.plusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


