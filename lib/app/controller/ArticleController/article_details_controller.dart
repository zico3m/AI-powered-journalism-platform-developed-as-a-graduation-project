import 'dart:convert';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/data/services/SupabaseService.dart';

class ArticleDetailsController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;

  final int articleId;

  ArticleDetailsController(this.articleId);

  final likesCount = 0.obs;
  final commentsCount = 0.obs;
  final isLiked = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    await Future.wait([
      loadLikes(),
      loadComments(),
      loadLikeStatus(),
    ]);
  }

  Future<void> loadLikes() async {
    final res = await _client
        .from('article_likes')
        .select('id')
        .eq('article_id', articleId);

    likesCount.value = (res as List).length;
  }

  Future<void> loadComments() async {
    final res = await _client
        .from('comments')
        .select('id')
        .eq('article_id', articleId)
        .eq('status_id', 1);

    commentsCount.value = (res as List).length;


  }

  Future<void> loadLikeStatus() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final res = await _client
        .from('article_likes')
        .select('id')
        .eq('article_id', articleId)
        .eq('user_id', user.id)
        .maybeSingle();

    isLiked.value = res != null;
  }

  Future<void> toggleLike() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      Get.snackbar("تنبيه", "يجب تسجيل الدخول للإعجاب");
      return;
    }

    if (isLiked.value) {
      await _client
          .from('article_likes')
          .delete()
          .eq('article_id', articleId)
          .eq('user_id', user.id);

      isLiked.value = false;
      likesCount.value--;
    } else {
      await _client.from('article_likes').insert({
        'article_id': articleId,
        'user_id': user.id,
      });

      isLiked.value = true;
      likesCount.value++;
    }
  }





}


class AskNewsService {
  static Future<String> askNews({
    required int newsId,
    required String question,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://nophyetcritlguostfsh.supabase.co/functions/v1/ask_news',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer sb_publishable_eSz6tnpyIjCOPk9Z_OoCtw_vZieZWm9',
      },
      body: jsonEncode({
        'news_id': newsId,
        'question': question,
      }),
    );

    final data = jsonDecode(response.body);
    return data['answer'] ?? 'لا توجد معلومات كافية';
  }
}
