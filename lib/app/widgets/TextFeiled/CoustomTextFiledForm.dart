import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

class CustomTextFieldForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final RxnString? errorText;
  final bool obscured;
  final bool? enabled;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Function(String) onChanged;
  final TextStyle? style;

  const CustomTextFieldForm({
    super.key,
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.obscured = false,
    required this.onChanged,
    this.controller,
    this.style,
    this.enabled,
    this.keyboardType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    // If errorText is observable → rebuild with Obx
    if (errorText != null) {
      return Obx(() {
        return _buildTextField(context, error: errorText!.value);
      });
    }

    return _buildTextField(context, error: null);
  }

  // --------------------------------------------------
  //                Actual TextFormField
  // --------------------------------------------------
  Widget _buildTextField(BuildContext context, {String? error}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? AppColor.darkCardBackground : AppColor.cardBackground;

    final textPrimary =
    isDark ? AppColor.darkTextPrimary : AppColor.textPrimary;

    final textSecondary =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        enabled: enabled,
        controller: controller,
        obscureText: obscured,
        onChanged: onChanged,
        cursorColor: AppColor.primary,
        textAlign: TextAlign.center,
        style: style ??
            TextStyle(
              fontSize: 16,
              color: textPrimary,
            ),
        decoration: InputDecoration(
          labelText: labelText,
          errorText: error,
          hintText: hintText,
          hintStyle: AppFonts.titlefortext.copyWith(
            fontSize: 16,
            color: textSecondary,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          suffixIconColor: AppColor.primary,
          prefixIconColor: AppColor.primary,
          filled: true,
          fillColor: bgColor,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColor.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
