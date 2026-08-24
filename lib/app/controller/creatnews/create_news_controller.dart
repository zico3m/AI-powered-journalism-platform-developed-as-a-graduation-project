import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/utils/utils.dart';

class CreateNewsController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  /// 📝 الحقول
  final title = ''.obs;
  final content = ''.obs;

  final isBreaking = false.obs;
  final breakingMinutes = 5.obs;

  final RxList<XFile> images = <XFile>[].obs;
  final isLoading = false.obs;

  final ImagePicker picker = ImagePicker();

  /// 📸 اختيار صورة (حد أقصى صورتين)
  Future<void> pickImage() async {
    if (images.length >= 2) {
      Get.snackbar(
        "تنبيه",
        "يمكنك رفع صورتين فقط",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      images.add(image);
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  DateTime? _lastPublishTime;

  //
  // Future<String> classifyNews(String text) async {
  //   final response = await http.post(
  //     Uri.parse("http://192.168.1.101:5000/classify-news"),
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //     body: jsonEncode({
  //       "text": text,
  //     }),
  //   );
  //
  //   print("STATUS CODE: ${response.statusCode}");
  //   print("RESPONSE BODY: ${response.body}");
  //
  //   if (response.statusCode != 200) {
  //     throw Exception("Classification failed");
  //   }
  //
  //   final data = jsonDecode(response.body);
  //   return data["classification"].toString().trim();
  // }

  // Future<String> classifyNews(String text) async {
  //   final response = await http.post(
  //     Uri.parse(
  //         "https://paraglossate-untrapped-tena.ngrok-free.dev/predict"
  //     ),
  //
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //     body: jsonEncode({
  //       "text": text,
  //     }),
  //   );
  //
  //   debugPrint("STATUS CODE: ${response.statusCode}");
  //   debugPrint("RESPONSE BODY: ${response.body}");
  //
  //   if (response.statusCode != 200) {
  //     throw Exception("Classification failed");
  //   }
  //
  //   final data = jsonDecode(response.body);
  //
  //   // 🔥 هذا هو الفرق المهم
  //   return data["label"].toString().trim();
  // }

  Future<String> classifyNews(String text) async {
    final url = Uri.parse(
      "https://zicosulatn-arabic-news-api.hf.space/api/predict",
    );

    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "text": text,
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Classification failed");
    }

    final data = jsonDecode(response.body);
    return data["label"];
  }

  final Map<String, String> aiToDbCategoryMap = {
    "Sports": "sports",
    "Finance": "Economy",
    "Politics": "Politics",
    "Tech": "Technology",
    "Religion": "Religion",
    "Culture": "culture",
  };

  Future<int?> getCategoryIdByName(String name) async {
    final res = await _client
        .from('categories')
        .select('id')
        .eq('name', name)
        .maybeSingle();

    return res?['id'] as int?;
  }

  Future<void> publishNews() async {
    if (containsDangerousContent(title.value) ||
        containsDangerousContent(content.value)) {
      Get.snackbar(
        "خطأ أمني",
        "يمنع إدخال أكواد HTML أو JavaScript",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (_lastPublishTime != null &&
        DateTime.now().difference(_lastPublishTime!).inSeconds < 10) {
      Get.snackbar(
        "انتظر",
        "يرجى الانتظار قبل نشر خبر آخر",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _lastPublishTime = DateTime.now();

    if (title.value.length > 200) {
      Get.snackbar(
        "خطأ",
        "العنوان طويل جدًا",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (content.value.length > 5000) {
      Get.snackbar(
        "خطأ",
        "المحتوى طويل جدًا",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (title.value.trim().isEmpty || content.value.trim().isEmpty) {
      Get.snackbar(
        "خطأ",
        "العنوان والمحتوى مطلوبان",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (images.isEmpty) {
      Get.snackbar(
        "خطأ",
        "يجب إضافة صورة واحدة على الأقل",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final user = _client.auth.currentUser;
    if (user == null) {
      Get.snackbar("خطأ", "يجب تسجيل الدخول");
      return;
    }

    try {
      isLoading.value = true;

      final classification = await classifyNews(
        "${title.value}\n\n${content.value}",
      );

      final dbCategoryName = aiToDbCategoryMap[classification];

      if (dbCategoryName == null) {
        Get.snackbar(
          "خطأ",
          "تصنيف غير معروف من الذكاء الاصطناعي: ",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellow,
          colorText: Colors.black,
        );
        return;
      }

      final int? categoryId = await getCategoryIdByName(dbCategoryName);

      if (categoryId == null) {
        Get.snackbar(
          "تنبيه",
          "لم يتم التعرف على تصنيف الخبر",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final String newsStatus = "published";

      final List<String> uploadedImageUrls = [];

      for (final image in images) {
        final bytes = await image.readAsBytes();
        final filePath =
            'news/${DateTime.now().millisecondsSinceEpoch}_${image.name}';

        await _client.storage.from('news-images').uploadBinary(
              filePath,
              bytes,
            );

        final publicUrl =
            _client.storage.from('news-images').getPublicUrl(filePath);

        if (!image.name.endsWith(".jpg") &&
            !image.name.endsWith(".png") &&
            !image.name.endsWith(".jpeg")) {
          Get.snackbar(
            "خطأ",
            "نوع الصورة غير مدعوم",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        uploadedImageUrls.add(publicUrl);
      }
      print("isBreaking: ${isBreaking.value}");
      print("breakingMinutes: ${breakingMinutes.value}");

      final insertedNews = await _client
          .from('news')
          .insert({
            'title': title.value.trim(),
            'content': content.value.trim(),
            'primary_image': uploadedImageUrls.first,
            'author_id': user.id,
            'category_id': categoryId,
            'published_at': DateTime.now().toIso8601String(),
            'is_breaking_until': isBreaking.value
                ? DateTime.now()
                    .add(Duration(minutes: breakingMinutes.value))
                    .toUtc()
                    .toIso8601String()
                : null,
            'status': newsStatus,
          })
          .select('id')
          .single();

      final int newsId = insertedNews['id'];

      // 🖼 4️⃣ حفظ بقية الصور
      for (int i = 0; i < uploadedImageUrls.length; i++) {
        await _client.from('news_images').insert({
          'news_id': newsId,
          'image_url': uploadedImageUrls[i],
          'order_index': i,
        });
      }

      // 🔄 تحديث الواجهة

      Get.back();

      Get.snackbar(
        "تم",
        "تم نشر الخبر بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("❌ ERROR PUBLISH NEWS => $e");

      Get.snackbar(
        "خطأ",
        "فشل في نشر الخبر",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
