// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../models/data/services/SupabaseService.dart';
// import '../ArticleController/ArticlesController.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class CommentController extends GetxController {
//   final SupabaseClient _client = SupabaseService.to.client;
//
//   final int articleId;
//
//   CommentController(this.articleId);
//   int get commentsCount => comments.length;
//
//   final comments = <Map<String, dynamic>>[].obs;
//   final isLoading = false.obs;
//   final TextEditingController textController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchComments();
//   }
//
//   Future<void> fetchComments() async {
//     try {
//       isLoading.value = true;
//       final data = await _client
//           .from('comments')
//           .select('''
//       id,
//       content,
//       created_at,
//       user_id,
//       users:user_id (
//         id,
//         name,
//         picture_url
//       )
//     ''')
//           .eq('article_id', articleId)
//           .eq('status_id', 1)
//           .order('created_at', ascending: false);
//
//
//       comments.assignAll(List<Map<String, dynamic>>.from(data));
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//
//
//
//
//
//   Future<String> classifyComment(String comment) async {
//     final response = await http.post(
//       Uri.parse("http://192.168.1.4:5000/predict"),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "comment": comment,
//       }),
//     );
//
//     if (response.statusCode != 200) {
//       throw Exception("Server error: ${response.body}");
//     }
//
//     final data = jsonDecode(response.body);
//     return data["sentiment"].toString().trim();
//   }
//
//
//
//
//
//
//
//   Future<void> addComment() async {
//     final user = _client.auth.currentUser;
//     final text = textController.text.trim();
//
//     if (user == null || text.isEmpty) return;
//
//     isLoading.value = true;
//
//     try {
//       // 1️⃣ تصنيف التعليق
//       final sentiment = await classifyComment(text);
//
//       // 2️⃣ تحديد الحالة
//       int statusId;
//       String message;
//
//       if (sentiment == "Positive") {
//         statusId = 1;
//         message = "تم نشر تعليقك بنجاح";
//       } else if (sentiment == "Neutral") {
//         statusId = 3;
//         message = "تم إرسال تعليقك للمراجعة";
//       } else {
//         statusId = 2;
//         message = "تم حجب تعليقك لمخالفته سياسة النشر";
//       }
//
//       // 3️⃣ حفظ التعليق
//       await _client.from('comments').insert({
//         'article_id': articleId,
//         'user_id': user.id,
//         'content': text,
//         'status_id': statusId,
//       });
//
//       textController.clear();
//
//       // 4️⃣ تحديث الواجهة فقط لو كان ظاهر
//       if (statusId == 1) {
//         await fetchComments();
//         final articleController = Get.put(ArticleController());
//         await articleController.loadCommentsCount(articleId);
//       }
//
//       // 5️⃣ إشعار المستخدم
//       Get.snackbar(
//         "تنبيه",
//         message,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: statusId == 2
//             ? Colors.red.shade600
//             : statusId == 3
//             ? Colors.orange.shade600
//             : Colors.green.shade600,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("ERROR: $e");
//       Get.snackbar(
//         "خطأ",
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//     finally {
//       isLoading.value = false;
//     }
//   }
//
//
//
//   Future<void> deleteComment(int commentId) async {
//     await _client
//         .from('comments')
//         .delete()
//         .eq('id', commentId);
//     final articleController = Get.find<ArticleController>();
//     await articleController.loadCommentsCount(articleId);
//     await fetchComments();
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//   @override
//   void onClose() {
//     textController.dispose();
//     super.onClose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/utils.dart';
import '../../models/data/services/comment/CommentRepository.dart';
import '../../models/data/services/SupabaseService.dart';

class CommentController extends GetxController {
  final int articleId;
  CommentController(this.articleId);

  final SupabaseClient _client = SupabaseService.to.client;
  final CommentRepository _repository = CommentRepository();

  final comments = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      final data = await _repository.fetchComments(articleId);
      comments.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  //   Future<void> addComment() async {
  //   final user = _client.auth.currentUser;
  //   final text = textController.text.trim();
  //   if (user == null || text.isEmpty) return;
  //
  //   isLoading.value = true;
  //
  //   try {
  //     final sentiment = await _repository.classifyComment(text);
  //
  //     int statusId;
  //     if (sentiment == "Positive") {
  //       statusId = 1;
  //     } else if (sentiment == "Neutral") {
  //       statusId = 3;
  //     } else {
  //       statusId = 2;
  //     }
  //
  //     await _repository.addComment(
  //       articleId: articleId,
  //       userId: user.id,
  //       content: text,
  //       statusId: statusId,
  //     );
  //
  //     textController.clear();
  //
  //     if (statusId == 1) {
  //       await fetchComments();
  //
  //       Get.back(result: true);
  //     } else {
  //       Get.snackbar(
  //         "تنبيه",
  //         statusId == 3
  //             ? "تم إرسال تعليقك للمراجعة"
  //             : "تم حجب تعليقك لمخالفته سياسة النشر",backgroundColor: Colors.red,colorText: Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("❌ ADD COMMENT ERROR: $e");
  //     Get.snackbar("خطأ", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> addComment() async {
    final user = _client.auth.currentUser;
    final text = textController.text.trim();
    if (user == null || text.isEmpty) return;

    isLoading.value = true;

    if (containsDangerousContent(text)) {
      Get.snackbar(
        "خطأ أمني",
        "يمنع إدخال أكواد أو وسوم غير معروفة",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final safeText = sanitizeText(text);

    try {
      final sentiment = await _repository.classifyComment(safeText);

      final int sentimentValue = int.tryParse(sentiment) ?? 0;

      int statusId;

      if (sentimentValue == 1) {
        statusId = 1;
      } else {
        statusId = 2;
      }

      await _repository.addComment(
        articleId: articleId,
        userId: user.id,
        content: safeText,
        statusId: statusId,
      );

      textController.clear();

      if (statusId == 1) {
        await fetchComments();

        Get.back(result: true);
      } else {
        Get.snackbar(
          "تنبيه",
          statusId == 3
              ? "تم إرسال تعليقك للمراجعة"
              : "تم حجب تعليقك لمخالفته سياسة النشر",backgroundColor: Colors.red,colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,

        );
      }
    } catch (e) {
      debugPrint("❌ ADD COMMENT ERROR: $e");
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteComment(int commentId) async {
    await _repository.deleteComment(commentId);
    await fetchComments();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
