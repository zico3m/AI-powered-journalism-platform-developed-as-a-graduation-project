import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/data/services/SupabaseService.dart';

class LikeController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;

  final int articleId;

  LikeController(this.articleId);

  final isLiked = false.obs;
  final likesCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLikeStatus();
  }

  /// تُستخدم مع like_button
  Future<bool> onLikeTapped(bool _) async {
    await toggleLike();
    return isLiked.value;
  }

  Future<void> loadLikeStatus() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final liked = await _client
        .from('article_likes')
        .select('id')
        .eq('article_id', articleId)
        .eq('user_id', user.id)
        .maybeSingle();

    isLiked.value = liked != null;

    final count = await _client
        .from('article_likes')
        .select('id')
        .eq('article_id', articleId);

    likesCount.value = (count as List).length;
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
