
import 'package:flutter/material.dart';

import '../util/color/app_colors.dart';

class CommonTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? counterText;

  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Widget? customSuffix;

  final String? Function(String?)? validator;
  final String? regexPattern;
  final String? regexErrorMessage;

  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final Function(String?)? onSaved;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool isDisabled;
  final bool readOnly;
  final bool autofocus;

  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const CommonTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.counterText,
    this.prefixIcon,
    this.suffixIcon,
    this.customSuffix,
    this.validator,
    this.regexPattern,
    this.regexErrorMessage = 'Invalid format',
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onSaved,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.isDisabled = false,
    this.readOnly = false,
    this.autofocus = false,
    this.height = 50.0,
    this.backgroundColor = Colors.white,
    this.borderColor,
    this.borderRadius = 30.0,
  });

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  String? errorText;

  String? _regexValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    if (widget.regexPattern != null) {
      final regExp = RegExp(widget.regexPattern!);
      if (!regExp.hasMatch(value.trim())) {
        return widget.regexErrorMessage;
      }
    }
    return null;
  }

  String? _getValidator(String? value) {
    if (widget.validator != null) {
      final result = widget.validator!(value);
      if (result != null) return result;
    }
    return _regexValidator(value);
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor =
    errorText != null
        ? Colors.red
        : (widget.borderColor ?? const Color(0xffDBDBDB));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText ?? "",style: TextStyle(fontSize: 12,color: Colors.black),),
        SizedBox(height: 5,),

        /// TEXT FIELD
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: effectiveBorderColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: TextFormField(
            cursorColor: ColorResource.primaryColor,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            obscureText: widget.obscureText,
            enabled: !widget.isDisabled,
            readOnly: widget.readOnly || widget.isDisabled,
            autofocus: widget.autofocus,
            onTap: widget.isDisabled ? () {} : widget.onTap,
            onFieldSubmitted:
            widget.isDisabled ? null : widget.onFieldSubmitted,
            onSaved: widget.onSaved,
            onChanged: (value) {
              setState(() {
                errorText = _getValidator(value);
              });
              widget.onChanged?.call(value);
            },
            style: TextStyle(
              fontSize: 14,
              color: widget.isDisabled ? Colors.grey.shade600 : Colors.black,
            ),
            decoration: InputDecoration(
              filled: false,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Color(0xff6B7280)),

              helperText: widget.helperText,
              counterText: widget.counterText ?? "",
              prefixIcon:
              widget.prefixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Icon(
                  widget.prefixIcon,
                  size: 20,
                  color:
                  widget.isDisabled
                      ? Colors.grey.shade500
                      : Colors.black54,
                ),
              )
                  : null,
              suffixIcon: widget.customSuffix ?? widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorText: null,
              // 🔴 IMPORTANT: field ke andar error band
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),

        /// ERROR TEXT (FIELD KE NICHE)
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
