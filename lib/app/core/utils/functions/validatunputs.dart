import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ValidInput {
  // ---------------------- الاسم ----------------------
  static String? validateName(String name) {
    final v = name.trim();
    if (v.isEmpty) return 'name_required'.tr;
    if (v.length < 3) return 'name_min_length'.tr;

    // يسمح فقط: العربية + الإنجليزية + المسافات
    final regex = RegExp(r"^[a-zA-Z\u0600-\u06FF ]+$");
    if (!regex.hasMatch(v)) {
      return 'name_only_letters'.tr;
    }

    return null;
  }

  // ---------------------- البريد ----------------------
  static String? validateEmail(String email) {
    final v = email.trim();
    if (v.isEmpty) return 'email_required'.tr;

    // منع الحروف العربية نهائيًا
    final hasArabic = RegExp(r'[\u0600-\u06FF]');
    if (hasArabic.hasMatch(v)) {
      return 'email_no_arabic'.tr;
    }

    if (!GetUtils.isEmail(v)) {
      return 'email_invalid'.tr;
    }

    return null;
  }

  // ---------------------- كلمة المرور ----------------------
  static String? validatePassword(String pass) {
    final v = pass.trim();
    if (v.isEmpty) return 'password_required'.tr;
    if (v.length < 6) return 'password_min_length'.tr;

    // على الأقل حرف إنجليزي واحد
    final hasEnglish = RegExp(r'[A-Za-z]');
    if (!hasEnglish.hasMatch(v)) {
      return 'password_english_required'.tr;
    }

    return null;
  }

  // ---------------------- تأكيد كلمة المرور ----------------------
  static String? validateConfirmPassword(String confirmPass, String pass) {
    final v = confirmPass.trim();
    if (v.isEmpty) return 'confirm_password_required'.tr;
    if (pass.trim() != v) return 'password_not_match'.tr;
    return null;
  }
}


ImageProvider safeImage(String? url) {
  if (url == null || url.isEmpty || !url.startsWith('http')) {
    return const AssetImage('assets/images/default_user.png');
  }
  return NetworkImage(url);
}
