import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'legal_page_model.dart';

class LegalPageController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  var isLoading = true.obs;
  var page = Rxn<LegalPage>();

  Future<void> loadPage(String key) async {
    try {
      isLoading.value = true;

      final response = await _client
          .from('app_legal_pages')
          .select()
          .eq('page_key', key)
          .eq('language', 'ar')
          .eq('is_active', true)
          .single();

      page.value = LegalPage.fromJson(response);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل المحتوى');
    } finally {
      isLoading.value = false;
    }
  }
}
