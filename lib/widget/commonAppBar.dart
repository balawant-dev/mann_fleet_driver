import 'package:flutter/material.dart';


import '../util/FontResource/FontResource.dart';
import '../util/color/app_colors.dart';
import 'custom_text.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final bool isBack;
  final String? actionImage;
  final VoidCallback? onActionTap;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.subTitle,
    this.isBack = false,
    this.actionImage,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: FontResource.plusJakartaSans,
            ),
          ),

          if (subTitle != null && subTitle!.isNotEmpty)
            CustomText(
              subTitle!,
              size: 11,
              weight: FontWeight.w400,
              color: ColorResource.black,
            ),
        ],
      ),

      /// Back Button
      leading: !isBack && Navigator.canPop(context)
          ? IconButton(
        icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
        onPressed: () {
          Navigator.pop(context);
        },
      )
          : null,

      /// Action Button
      actions: actionImage != null
          ? [
        IconButton(
          onPressed: onActionTap,
          icon: Image.asset(
            actionImage!,
            height: 24,
            width: 24,
          ),
        ),
      ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}