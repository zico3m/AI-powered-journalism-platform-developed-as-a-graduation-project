import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/datamodles/users/UserModel.dart';
import '../../models/data/datamodles/news/NewsModel.dart';
import '../../models/data/services/news/NewsRepository.dart';

class SavedNewsController extends GetxController {
  final NewsRepository _repo = NewsRepository();
  final _client = Supabase.instance.client;

  final savedNews = <NewsModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedNews();
  }
  Future<void> refreshSavedNews() async {
    await loadSavedNews();
  }








  Future<void> removeFromSaved(int newsId) async {
    try {
      final userId = _client.auth.currentUser!.id;

      await _client
          .from('news_favorites')
          .delete()
          .eq('news_id', newsId)
          .eq('user_id', userId);

      savedNews.removeWhere((n) => n.id == newsId);

      Get.snackbar("تم", "تم حذف الخبر من المحفوظات");
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالخادم");
    }
  }



  Future<void> loadSavedNews() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser!.id;
      final data = await _repo.getSavedNews(userId);
      savedNews.assignAll(data);
    } catch (e) {
      debugPrint('loadSavedNews error: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
