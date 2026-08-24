import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;

  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool value) async {
    isDark.value = value;
    Get.changeThemeMode(themeMode);
    // حفظ داخل التخزين المحلي لو أردت
  }
}


