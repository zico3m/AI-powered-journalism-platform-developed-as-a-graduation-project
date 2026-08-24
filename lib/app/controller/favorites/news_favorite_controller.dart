import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class NewsFavoriteController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  final int newsId;

  NewsFavoriteController(this.newsId);

  final isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final res = await _client
        .from('news_favorites')
        .select('id')
        .eq('news_id', newsId)
        .eq('user_id', user.id)
        .maybeSingle();

    isSaved.value = res != null;
  }

  Future<void> toggleSave() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      Get.snackbar("تنبيه", "يجب تسجيل الدخول");
      return;
    }

    if (isSaved.value) {
      await _client
          .from('news_favorites')
          .delete()
          .eq('news_id', newsId)
          .eq('user_id', user.id);

      isSaved.value = false;
    } else {
      await _client.from('news_favorites').insert({
        'news_id': newsId,
        'user_id': user.id,
      });

      isSaved.value = true;
    }
  }
}
