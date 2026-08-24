import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();

  RxString currentLang = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    String? savedLang = _box.read('language');
    if (savedLang != null) {
      currentLang.value = savedLang;
      Get.updateLocale(Locale(savedLang));
    }
  }

  void changeLanguage(String langCode) {
    currentLang.value = langCode;
    _box.write('language', langCode); // حفظ اللغة
    Get.updateLocale(Locale(langCode));
  }
}
