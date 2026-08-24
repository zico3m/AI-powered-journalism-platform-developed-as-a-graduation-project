

import 'dart:async';
import 'package:get/get.dart';

import '../../models/data/datamodles/news/NewsModel.dart';
import '../../models/data/services/news/NewsRepository.dart';

// class HomeController extends GetxController {
//   final NewsRepository _newsRepository = NewsRepository();
//
//   final RxList<NewsModel> breakingNewsList = <NewsModel>[].obs;
//   final RxList<NewsModel> latestNewsList = <NewsModel>[].obs;
//
//   final RxnInt selectedCategoryId = RxnInt(); // null = الكل
//
//   final RxBool isLoadingBreaking = false.obs;
//   final RxBool isLoadingLatest = false.obs;
//
//   final RxString errorBreaking = ''.obs;
//   final RxString errorLatest = ''.obs;
//
//   Timer? _breakingTimer;
//
//   static const Duration _breakingRefreshInterval = Duration(seconds: 60);
//
//   @override
//   void onInit() {
//     super.onInit();
//
//
//     _loadBreakingNews();
//     loadLatestNews();
//
//
//     _breakingTimer = Timer.periodic(_breakingRefreshInterval, (_) async {
//       await _loadBreakingNews();
//     });
//   }
//
//   @override
//   void onClose() {
//     _breakingTimer?.cancel();
//     super.onClose();
//   }
//
//   void changeCategory(int? categoryId) {
//     selectedCategoryId.value = categoryId;
//     loadLatestNews();
//   }
//
//   Future<void> _loadBreakingNews() async {
//     try {
//       errorBreaking.value = '';
//       isLoadingBreaking.value = true;
//
//       final news = await _newsRepository.getBreakingNews();
//
//       if (!_sameIds(breakingNewsList, news)) {
//         breakingNewsList.assignAll(news);
//       }
//     } catch (e) {
//       errorBreaking.value = 'فشل في جلب الأخبار العاجلة';
//     } finally {
//       isLoadingBreaking.value = false;
//     }
//   }
//
//   Future<void> loadLatestNews() async {
//     try {
//       errorLatest.value = '';
//       isLoadingLatest.value = true;
//
//       final news = await _newsRepository.getLatestNews(
//         categoryId: selectedCategoryId.value,
//       );
//
//       latestNewsList.assignAll(news);
//     } catch (e) {
//       errorLatest.value = 'فشل في جلب آخر الأخبار';
//     } finally {
//       isLoadingLatest.value = false;
//     }
//   }
//
//   Future<void> refreshNews() async {
//     // refresh يدوي (pull-to-refresh)
//     await Future.wait([
//       _loadBreakingNews(),
//       loadLatestNews(),
//     ]);
//   }
//
//   bool _sameIds(List<NewsModel> oldList, List<NewsModel> newList) {
//     if (oldList.length != newList.length) return false;
//     for (int i = 0; i < newList.length; i++) {
//       if (oldList[i].id != newList[i].id) return false;
//     }
//     return true;
//   }
// }


// home_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../models/data/datamodles/news/NewsModel.dart';
import '../../models/data/services/news/NewsRepository.dart';

class HomeController extends GetxController {
  final NewsRepository _newsRepository = NewsRepository();

  final RxList<NewsModel> breakingNewsList = <NewsModel>[].obs;
  final RxList<NewsModel> latestNewsList = <NewsModel>[].obs;
  final RxString selectedVoice = "noura".obs;

  final RxnInt selectedCategoryId = RxnInt(); // null = الكل

  final RxBool isLoadingBreaking = false.obs;
  final RxBool isLoadingLatest = false.obs; // للتحميل الأولي
  final RxBool isLoadingMore = false.obs;   // للتحميل الإضافي

  final RxString errorBreaking = ''.obs;
  final RxString errorLatest = ''.obs;

  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 10;
  final RxBool hasMore = true.obs;           // هل توجد صفحات إضافية؟

  Timer? _breakingTimer;
  static const Duration _breakingRefreshInterval = Duration(seconds: 60);

  @override
  void onInit() {
    super.onInit();
    _loadBreakingNews();
    loadLatestNews(reset: true); // تحميل الصفحة الأولى

    _breakingTimer = Timer.periodic(_breakingRefreshInterval, (_) async {
      await _loadBreakingNews();
    });
  }

  @override
  void onClose() {
    _breakingTimer?.cancel();
    super.onClose();
  }

  // تغيير التصنيف يعيد تعيين القائمة ويحمل من جديد
  void changeCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    _resetPagination();
    loadLatestNews(reset: true);
  }

  void _resetPagination() {
    _currentPage = 1;
    hasMore.value = true;
  }

  Future<void> _loadBreakingNews() async {
    try {
      errorBreaking.value = '';
      isLoadingBreaking.value = true;

      final news = await _newsRepository.getBreakingNews();

      if (!_sameIds(breakingNewsList, news)) {
        breakingNewsList.assignAll(news);
      }
    } catch (e) {
      errorBreaking.value = 'فشل في جلب الأخبار العاجلة';
    } finally {
      isLoadingBreaking.value = false;
    }
  }

  // تحميل الأخبار (أول مرة أو عند السحب للتحديث)
  Future<void> loadLatestNews({bool reset = false}) async {
    if (reset) {
      _resetPagination();
    }

    // إذا كان التحميل جارياً بالفعل، لا تكرر
    if (isLoadingLatest.value || isLoadingMore.value) return;

    // إذا لم يعد هناك المزيد، لا تفعل شيئاً
    if (!hasMore.value && !reset) return;

    try {
      // تحديد أي مؤشر تحميل نشغل
      if (reset) {
        isLoadingLatest.value = true;
      } else {
        isLoadingMore.value = true;
      }

      errorLatest.value = '';

      final offset = (_currentPage - 1) * _pageSize;
      final news = await _newsRepository.getLatestNews(
        categoryId: selectedCategoryId.value,
        limit: _pageSize,
        offset: offset,
      );

      if (news.isEmpty) {
        // لا توجد نتائج أخرى
        hasMore.value = false;
      } else {
        if (reset) {
          latestNewsList.assignAll(news);
        } else {
          latestNewsList.addAll(news);
        }
        _currentPage++;
        // إذا كان عدد النتائج أقل من حجم الصفحة، نفترض أنه لا يوجد المزيد
        if (news.length < _pageSize) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      errorLatest.value = 'فشل في جلب آخر الأخبار';
    } finally {
      isLoadingLatest.value = false;
      isLoadingMore.value = false;
    }
  }

  // دالة لتحميل الصفحة التالية (يستدعيها الـ ScrollController)
  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoadingLatest.value) return;
    await loadLatestNews(reset: false);
  }

  Future<void> refreshNews() async {
    // refresh يدوي (pull-to-refresh)
    await _loadBreakingNews();
    await loadLatestNews(reset: true);
  }

  bool _sameIds(List<NewsModel> oldList, List<NewsModel> newList) {
    if (oldList.length != newList.length) return false;
    for (int i = 0; i < newList.length; i++) {
      if (oldList[i].id != newList[i].id) return false;
    }
    return true;
  }
}