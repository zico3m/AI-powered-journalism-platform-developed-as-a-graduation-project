import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../models/data/datamodles/news/NewsModel.dart';
import '../../models/data/services/SupabaseService.dart';

class SearchControllerr extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;

  final query = ''.obs;

  final isLoading = false.obs;

  final results = <NewsModel>[].obs;

  final searchController = TextEditingController();

  Timer? _debounce;

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void onQueryChanged(String value) {
    query.value = value;

    if (value.trim().length < 3) {
      results.clear();
      isLoading.value = false;
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(value.trim());
    });
  }


  Future<void> search(String text) async {
    if (text.isEmpty) return;

    try {
      isLoading.value = true;

      final data = await _client
          .from('news')
          .select(r'''
          id,
          title,
          content,
          primary_image,
          published_at,
          is_breaking_until,
          category_id,
          categories(name),
          sources (
            id,
            name,
            logo_url
          )
        ''')
          .or('title.ilike.%$text%,content.ilike.%$text%')
          .order('published_at', ascending: false);

      final list = (data as List)
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      results.assignAll(list);
    } catch (e, st) {
      Get.snackbar('خطأ', 'فشل في جلب نتائج البحث');

      print("======= SEARCH ERROR =======");
      print(e);
      print(st);
      print("============================");
    } finally {
      isLoading.value = false;
    }
  }


  void submitSearch() {
    final text = searchController.text.trim();
    if (text.isEmpty) return;
    search(text);
  }
}
