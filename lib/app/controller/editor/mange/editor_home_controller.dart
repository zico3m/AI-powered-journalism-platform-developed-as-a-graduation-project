// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../core/services/editor/editor_service.dart';
//
// class EditorHomeController extends GetxController {
//   final EditorService _service = EditorService();
//   final SupabaseClient _client = Supabase.instance.client;
//
//   var loading = true.obs;
//   var news = <Map<String, dynamic>>[].obs;
//
//   var total = 0.obs;
//   var published = 0.obs;
//   var pending = 0.obs;
//   var rejected = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchEditorData();
//   }
//
//   Future<void> fetchEditorData() async {
//     try {
//       loading.value = true;
//
//       final uid = _client.auth.currentUser?.id;
//       print('EDITOR UID => $uid');
//
//       final stats = await _service.getEditorStats();
//       final newsList = await _service.getEditorNews();
//
//       total.value = stats['total']!;
//       published.value = stats['published']!;
//       pending.value = stats['pending']!;
//       rejected.value = stats['rejected']!;
//
//       news.assignAll(newsList);
//     } catch (e) {
//       print('❌ ERROR FETCH EDITOR DATA => $e');
//     } finally {
//       loading.value = false;
//     }
//   }
//
//
//   Future<void> deleteNews(int newsId) async {
//     try {
//       await _client.from('news').delete().eq('id', newsId);
//       news.removeWhere((e) => e['id'] == newsId);
//       Get.snackbar('تم', 'تم حذف الخبر بنجاح');
//     } catch (e) {
//       Get.snackbar('خطأ', 'فشل في حذف الخبر');
//     }
//   }
//
//
//   Future<void> requestDeleteNews({
//     required int newsId,
//     required String reason,
//   }) async {
//     try {
//       final uid = _client.auth.currentUser!.id;
//
//       // 🔹 اجلب بيانات الخبر أولاً
//       final newsItem = await _client
//           .from('news')
//           .select('title')
//           .eq('id', newsId)
//           .single();
//
//       await _client.from('news_requests').insert({
//         'news_id': newsId,
//         'request_type': 'delete',
//         'title': newsItem['title'], // 🔥 نحفظ العنوان
//         'reason': reason.trim(),
//         'created_by': uid,
//         'status': 'pending',
//       });
//       Get.snackbar('تم', 'تم إرسال طلب الحذف للإدارة',backgroundColor: Colors.red, );
//     } catch (e) {
//       Get.snackbar('خطأ', 'فشل إرسال الطلب');
//     }
//   }
//
//
//
//
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/data/services/editor/editor_service.dart';

class EditorHomeController extends GetxController {
  final EditorService _service = EditorService();
  final SupabaseClient _client = Supabase.instance.client;

  var loading = true.obs;
  var newsList = <Map<String, dynamic>>[].obs; // قائمة الأخبار مع بيانات الطلبات

  // إحصائيات الأخبار
  var total = 0.obs;
  var published = 0.obs;
  var pending = 0.obs;
  var rejected = 0.obs;

  // إحصائيات طلبات الحذف (اختياري)
  var deleteRequestsCount = 0.obs;

  var statusFilter = 'all'.obs; // all, published, pending, rejected
  var requestFilter = 'all'.obs; // all, has_pending_request
  var searchQuery = ''.obs;

  // قائمة مصفاة
  List<Map<String, dynamic>> get filteredNews {
    return newsList.where((item) {
      // فلترة حسب حالة الخبر
      final newsStatus = item['status']?.toString() ?? '';
      if (statusFilter.value != 'all' && newsStatus != statusFilter.value) {
        return false;
      }

      // فلترة حسب وجود طلب حذف pending
      if (requestFilter.value == 'has_pending_request') {
        final hasPending = item['delete_request'] != null &&
            item['delete_request']['status'] == 'pending';
        if (!hasPending) return false;
      }

      // فلترة حسب البحث في العنوان
      if (searchQuery.value.isNotEmpty) {
        final title = item['title']?.toString().toLowerCase() ?? '';
        if (!title.contains(searchQuery.value.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchEditorData();
  }

  Future<void> fetchEditorData() async {
    try {
      loading.value = true;
      final uid = _client.auth.currentUser?.id;
      if (uid == null) return;

      // 1. جلب أخبار المحرر (RLS يتكفل بفلترة المحرر الحالي)
      final newsResponse = await _client
          .from('news')
          .select('*, sources(name), categories(name)')
          .eq('is_external', false)
          .order('published_at', ascending: false);

      final List<dynamic> newsData = newsResponse as List<dynamic>;
      final List<Map<String, dynamic>> news = newsData.cast<Map<String, dynamic>>();

      // 2. جلب طلبات الحذف الخاصة بالمحرر
      final requestsResponse = await _client
          .from('news_requests')
          .select('id, news_id, status, reason, created_at')
          .eq('created_by', uid)
          .eq('request_type', 'delete')
          .order('created_at', ascending: false);

      final List<dynamic> requestsData = requestsResponse as List<dynamic>;
      final List<Map<String, dynamic>> requests = requestsData.cast<Map<String, dynamic>>();

      // 3. بناء map للطلبات (news_id -> request)
      final Map<int, Map<String, dynamic>> requestsMap = {};
      for (var req in requests) {
        final newsId = req['news_id'] as int?;
        if (newsId != null) {
          // نحتفظ بأحدث طلب (إذا تعددت الطلبات) - يمكن تحسينه حسب الحاجة
          requestsMap[newsId] = req;
        }
      }

      // 4. دمج الطلبات مع الأخبار
      final combined = news.map((item) {
        final newsId = item['id'] as int?;
        if (newsId != null && requestsMap.containsKey(newsId)) {
          item['delete_request'] = requestsMap[newsId];
        }
        return item;
      }).toList();

      newsList.assignAll(combined);

      // 5. حساب إحصائيات الأخبار
      _calculateNewsStats();

      // 6. حساب عدد طلبات الحذف (للعرض الاختياري)
      deleteRequestsCount.value = requests.length;
    } catch (e) {
      print('❌ ERROR FETCHING EDITOR DATA: $e');
      Get.snackbar('خطأ', 'فشل تحميل البيانات');
    } finally {
      loading.value = false;
    }
  }

  void _calculateNewsStats() {
    total.value = newsList.length;
    published.value = newsList.where((n) => n['status'] == 'published').length;
    pending.value = newsList.where((n) => n['status'] == 'pending').length;
    rejected.value = newsList.where((n) => n['status'] == 'rejected').length;
  }

  // إنشاء طلب حذف جديد
  Future<void> requestDeleteNews({
    required int newsId,
    required String reason,
  }) async {
    try {
      final uid = _client.auth.currentUser!.id;

      // جلب عنوان الخبر
      final newsItem = await _client
          .from('news')
          .select('title')
          .eq('id', newsId)
          .single();

      await _client.from('news_requests').insert({
        'news_id': newsId,
        'request_type': 'delete',
        'title': newsItem['title'],
        'reason': reason.trim(),
        'created_by': uid,
        'status': 'pending',
      });

      Get.snackbar('تم', 'تم إرسال طلب الحذف للإدارة',
          backgroundColor: Colors.green);
      fetchEditorData(); // تحديث القائمة
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إرسال الطلب');
    }
  }

  // إلغاء طلب حذف (إذا كان pending)
  Future<void> cancelDeleteRequest(int requestId) async {
    try {
      await _client
          .from('news_requests')
          .update({'status': 'cancelled'})
          .eq('id', requestId);

      Get.snackbar('تم', 'تم إلغاء الطلب');
      fetchEditorData(); // تحديث القائمة
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إلغاء الطلب');
    }
  }

  // دوال الفلترة
  void onStatusFilter(String? value) {
    if (value != null) statusFilter.value = value;
  }

  void onRequestFilter(String? value) {
    if (value != null) requestFilter.value = value;
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }
}