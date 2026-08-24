// lib/app/core/app_colors.dart
import 'package:flutter/material.dart';

class AppColor {
  /* -------------------- Brand -------------------- */
  static const Color primary = Color(0xff038EF1);

  /* -------------------- Light Theme -------------------- */
  static const Color background = Color(0xffECEEF2);
  static const Color cardBackground = Color(0xffFFFFFF);

  // Replaced pure black with deep blue-gray (softer, premium)
  static const Color textPrimary = Color(0xff1E293B); // blue-gray 800
  static const Color textSecondary = Color(0xff64748B); // blue-gray 500

  /* -------------------- Dark Theme -------------------- */
  // Soft dark palette (NO pure black)
  static const Color darkBackground = Color(0xff0F172A); // blue-gray 950
  static const Color darkCardBackground = Color(0xff111827); // blue-gray 900

  static const Color darkTextPrimary = Color(0xffE5E7EB); // gray 200
  static const Color darkTextSecondary = Color(0xffCBD5E1); // gray 300

  /* -------------------- Utility -------------------- */
  static const Color dividerLight = Color(0x1F000000);
  static const Color dividerDark = Color(0x1FFFFFFF);
}
