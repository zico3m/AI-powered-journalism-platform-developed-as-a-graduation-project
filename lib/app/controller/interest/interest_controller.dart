// lib/app/controllers/interest/interest_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/data/datamodles/catogaries/CategoryModel.dart';
import '../../models/data/services/interest/InterestRepository.dart';
import '../../routes/app_routes.dart';

class InterestController extends GetxController {
  // --- Dependencies ---
  final InterestRepository _interestRepository = InterestRepository();

  // --- Observables ---
  // قائمة لتخزين التصنيفات القادمة من قاعدة البيانات
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // قائمة لتخزين أرقام التصنيفات التي يختارها المستخدم
  final RxList<int> selectedCategoryIds = <int>[].obs;

  // متغيرات لحالة الواجهة
  final isLoading = false.obs; // للتحميل العام (جلب البيانات)
  final isSaving = false.obs;  // للتحميل عند الحفظ

  /// يتم استدعاؤها تلقائياً عند تهيئة الـ Controller
  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // جلب التصنيفات عند فتح الشاشة
  }

  /// دالة لجلب التصنيفات من الـ Repository
  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _interestRepository.getAllCategories();
      categories.assignAll(fetchedCategories); // تحديث القائمة بالبيانات الجديدة
    } catch (e) {
      showSnackbar('خطأ', e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// دالة لتبديل اختيار التصنيف
  void toggleCategorySelection(int categoryId) {
    if (selectedCategoryIds.contains(categoryId)) {
      selectedCategoryIds.remove(categoryId);
    } else {
      selectedCategoryIds.add(categoryId);
    }
  }

  /// دالة للتحقق مما إذا كان التصنيف محدداً
  bool isCategorySelected(int categoryId) {
    return selectedCategoryIds.contains(categoryId);
  }

  /// دالة لحفظ الاهتمامات المختارة والانتقال إلى الرئيسية
  Future<void> saveAndContinue() async {
    if (selectedCategoryIds.isEmpty) {
      showSnackbar('تنبيه', 'الرجاء اختيار اهتمام واحد على الأقل.');
      return;
    }

    isSaving.value = true;
    try {
      // استدعاء دالة الحفظ من الـ Repository
      await _interestRepository.saveUserInterests(selectedCategoryIds);

      // الانتقال إلى الصفحة الرئيسية وإزالة كل الشاشات السابقة
      Get.offAllNamed(AppRoutes.HOME);

    } catch (e) {
      showSnackbar('خطأ', e.toString(), isError: true);
    } finally {
      isSaving.value = false;
    }
  }

  // دالة مساعدة لعرض الرسائل
  void showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.withOpacity(0.8) : Colors.grey.shade800,
      colorText: Colors.white,
    );
  }
}
