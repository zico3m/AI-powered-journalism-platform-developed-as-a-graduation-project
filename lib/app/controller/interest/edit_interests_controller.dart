import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/services/SupabaseService.dart';
import '../profile/ProfileController.dart';
import 'interests_controller.dart';

class EditInterestsController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;

  final isLoading = true.obs;
  final isSaving = false.obs;

  final categories = <CategoryItem>[].obs;
  final selectedCategoryIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;

      final authUser = _client.auth.currentUser;
      if (authUser == null) {
        Get.snackbar('خطأ', 'المستخدم غير مسجل دخولاً');
        return;
      }

      /// 1) جلب كل التصنيفات
      final cats = await _client
          .from('categories')
          .select('id, name');

      categories.assignAll(
        (cats as List).map((row) {
          return CategoryItem(
            id: row['id'] as int,
            name: row['name'] as String,
          );
        }).toList(),
      );

      /// 2) جلب اهتمامات المستخدم (category_id فقط)
      final interestRows = await _client
          .from('interests')
          .select('category_id')
          .eq('user_id', authUser.id);

      final ids = <int>{};
      for (final row in interestRows as List) {
        final cid = row['category_id'];
        if (cid != null) ids.add(cid as int);
      }

      selectedCategoryIds
        ..clear()
        ..addAll(ids);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الاهتمامات');
      // تجاهل الطباعة إن حبيت
      // debugPrint('EditInterests load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// تبديل اختيار تصنيف
  void toggleCategory(int id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }
  }

  /// حفظ التغييرات في جدول interests
  Future<void> saveInterests() async {
    try {
      isSaving.value = true;

      final authUser = _client.auth.currentUser;
      if (authUser == null) {
        Get.snackbar('خطأ', 'المستخدم غير مسجل دخولاً');
        return;
      }

      // 1) حذف الاهتمامات القديمة
      await _client
          .from('interests')
          .delete()
          .eq('user_id', authUser.id);

      // 2) إدخال الاهتمامات الجديدة
      if (selectedCategoryIds.isNotEmpty) {
        final payload = selectedCategoryIds.map((cid) {
          return {
            'user_id': authUser.id,
            'category_id': cid,
          };
        }).toList();

        await _client.from('interests').insert(payload);
      }

      // 3) تحديث ProfileController.interests بالأسماء الجديدة
      final profileController = Get.find<ProfileController>();
      final names = <String>{};

      for (final cat in categories) {
        if (selectedCategoryIds.contains(cat.id)) {
          names.add(cat.name);
        }
      }

      profileController.interests.assignAll(names.toList());

      /// 🔥 تحديث صفحة أخبار الاهتمامات إذا كانت موجودة
      if (Get.isRegistered<InterestNewsController>()) {
        await Get.find<InterestNewsController>().refreshNews();
      }

      Get.back();
      Get.snackbar(
        'تم',
        'تم تحديث اهتماماتك بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back(); // إغلاق الـ Dialog
      Get.snackbar('تم', 'تم تحديث اهتماماتك بنجاح',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حفظ الاهتمامات',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }
}

class CategoryItem {
  final int id;
  final String name;

  CategoryItem({
    required this.id,
    required this.name,
  });
}
