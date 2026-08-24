import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/utils.dart';
import '../../models/data/services/SupabaseService.dart';

class CreateArticleController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final isLoading = false.obs;
  final imagePath = RxnString();
  File? selectedImage;

  // -------------------------
  // اختيار صورة
  // -------------------------
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);

    if (picked == null) return;

    selectedImage = File(picked.path);
    imagePath.value = picked.path;
  }

  // -------------------------
  // نشر المقال
  // -------------------------
  Future<void> publishArticle() async {


    // ❌ منع المحتوى الخبيث من الأساس
    if (containsDangerousContent(titleController.text) ||
        containsDangerousContent(contentController.text)) {
      Get.snackbar(
        "خطأ أمني",
        "يمنع إدخال أكواد أو وسوم HTML",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    final safeTitle = sanitizeText(titleController.text);
    final safeContent = sanitizeText(contentController.text);

    if (safeTitle.isEmpty || safeContent.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "المحتوى يحتوي على رموز غير مسموحة",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = _client.auth.currentUser;
      if (user == null) return;

      String? imageUrl;

      // رفع الصورة
      if (selectedImage != null) {
        final fileExt = selectedImage!.path.split('.').last;
        final fileName =
            "articles/${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt";

        await _client.storage.from('article_images').upload(
          fileName,
          selectedImage!,
          fileOptions: const FileOptions(upsert: true),
        );

        imageUrl = _client.storage
            .from('article_images')
            .getPublicUrl(fileName);
      }

      // حفظ المقال
      await _client.from('articles').insert({
        'title': safeTitle,
        'content': safeContent,
        'cover_image': imageUrl,
        'author_id': user.id,
        'status': 'published',
        'published_at': DateTime.now().toIso8601String(),
      });


      Get.back();
      Get.snackbar("تم", "تم نشر المقال بنجاح",backgroundColor: Colors.blue,
      snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint("ARTICLE SAVE ERROR => $e");
      Get.snackbar(
        "خطأ",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
