import 'dart:async';
import 'package:get/get.dart';

import '../../models/data/datamodles/news/NewsModel.dart';
import '../../models/data/services/SupabaseService.dart';
import '../../models/data/services/interest/Users_Interests_Repository.dart';

// class InterestNewsController extends GetxController {
//   final InterestNewsRepository _repository = InterestNewsRepository();
//
//   final RxList<int> userCategoryIds = <int>[].obs;
//   final RxList<String> userCategoryNames = <String>[].obs;
//
//   final RxList<NewsModel> allNews = <NewsModel>[].obs;
//   final RxList<NewsModel> filteredNews = <NewsModel>[].obs;
//
//   final RxString selectedCategory = "الكل".obs;
//   final RxBool isLoading = true.obs;
//
//   Timer? _timer;
//   final _client = SupabaseService.to.client;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadUserInterests();
//   }
//
//   /// 1️⃣ تحميل الاهتمامات
//   Future<void> loadUserInterests() async {
//     try {
//       isLoading.value = true;
//
//       final uid = _client.auth.currentUser?.id;
//       if (uid == null) return;
//
//       final interests = await _repository.getUserInterests(uid);
//
//       userCategoryIds.assignAll(
//         interests.map<int>((e) => e['category_id'] as int).toList(),
//       );
//
//       userCategoryNames
//         ..clear()
//         ..add("الكل")
//         ..addAll(
//           interests.map<String>(
//                 (e) => e['categories']['name'] as String,
//           ),
//         );
//
//       if (userCategoryIds.isEmpty) {
//         isLoading.value = false;
//         return;
//       }
//
//       /// 🔥 تحميل أول مرة
//       await loadNews();
//
//       /// 🔥 بدء التحديث الدوري كل 60 ثانية
//       _startAutoRefresh();
//
//     } catch (e) {
//       isLoading.value = false;
//       print("Error loading interests: $e");
//     }
//   }
//
//   /// 2️⃣ جلب الأخبار
//   Future<void> loadNews() async {
//     try {
//       final newsList =
//       await _repository.getNewsByCategories(userCategoryIds);
//
//       allNews.assignAll(newsList);
//       applyFilter();
//       isLoading.value = false;
//     } catch (e) {
//       print("Error loading news: $e");
//     }
//   }
//
//   /// 3️⃣ تشغيل المؤقت
//   void _startAutoRefresh() {
//     _timer?.cancel();
//
//     _timer = Timer.periodic(const Duration(seconds: 60), (_) {
//       loadNews();
//     });
//   }
//
//   /// 4️⃣ الفلترة
//   void applyFilter() {
//     final filter = selectedCategory.value;
//
//     if (filter == "الكل") {
//       filteredNews.assignAll(allNews);
//     } else {
//       filteredNews.assignAll(
//         allNews.where((n) => n.categoryName == filter),
//       );
//     }
//   }
//
//   void changeFilter(String newValue) {
//     selectedCategory.value = newValue;
//     applyFilter();
//   }
//
//   Future<void> refreshAll() async {
//     _timer?.cancel();          // نوقف المؤقت
//     userCategoryIds.clear();
//     userCategoryNames.clear();
//     allNews.clear();
//     filteredNews.clear();
//     selectedCategory.value = "الكل";
//
//     await loadUserInterests(); // يعيد تحميل الاهتمامات + الأخبار
//   }
//
//
//
//
//
//
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }



// interest_news_controller.dart

class InterestNewsController extends GetxController {
  final InterestNewsRepository _repository = InterestNewsRepository();

  final RxList<int> userCategoryIds = <int>[].obs;
  final RxList<String> userCategoryNames = <String>[].obs;

  // كل الأخبار (تُستخدم للفلترة)
  final RxList<NewsModel> allNews = <NewsModel>[].obs;
  // الأخبار المعروضة حالياً (بعد الفلتر)
  final RxList<NewsModel> filteredNews = <NewsModel>[].obs;

  final RxString selectedCategory = "الكل".obs;
  final RxBool isLoading = true.obs;      // تحميل أولي
  final RxBool isLoadingMore = false.obs; // تحميل المزيد

  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 10;
  final RxBool hasMore = true.obs;

  Timer? _timer;
  final _client = SupabaseService.to.client;

  @override
  void onInit() {
    super.onInit();
    loadUserInterests();
  }

  Future<void> loadUserInterests() async {
    try {
      isLoading.value = true;
      final uid = _client.auth.currentUser?.id;
      if (uid == null) return;

      final interests = await _repository.getUserInterests(uid);
      userCategoryIds.assignAll(
        interests.map<int>((e) => e['category_id'] as int).toList(),
      );

      userCategoryNames
        ..clear()
        ..add("الكل")
        ..addAll(interests.map<String>((e) => e['categories']['name'] as String));

      if (userCategoryIds.isEmpty) {
        isLoading.value = false;
        return;
      }

      // تحميل الصفحة الأولى
      await _loadNewsPage(reset: true);
      _startAutoRefresh();
    } catch (e) {
      isLoading.value = false;
      print("Error loading interests: $e");
    }
  }

  /// تحميل صفحة معينة من الأخبار
  Future<void> _loadNewsPage({required bool reset}) async {
    if (reset) {
      _currentPage = 1;
      hasMore.value = true;
      allNews.clear();
      filteredNews.clear();
    }

    if (!hasMore.value) return;
    if (isLoadingMore.value) return;

    try {
      if (reset) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final offset = (_currentPage - 1) * _pageSize;
      final news = await _repository.getNewsByCategories(
        categoryIds: userCategoryIds,
        limit: _pageSize,
        offset: offset,
      );

      if (news.isEmpty) {
        hasMore.value = false;
      } else {
        allNews.addAll(news);
        applyFilter(); // يعيد تطبيق الفلتر على allNews الجديد
        _currentPage++;
        if (news.length < _pageSize) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      print("Error loading news: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// تحميل الصفحة التالية (يستدعى من الواجهة)
  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;
    await _loadNewsPage(reset: false);
  }

  /// تحديث يدوي (سحب للأسفل)
  Future<void> refreshNews() async {
    _timer?.cancel(); // نوقف المؤقت أثناء التحديث
    await _loadNewsPage(reset: true);
    _startAutoRefresh();
  }

  /// الفلترة حسب التصنيف
  void applyFilter() {
    final filter = selectedCategory.value;
    if (filter == "الكل") {
      filteredNews.assignAll(allNews);
    } else {
      filteredNews.assignAll(
        allNews.where((n) => n.categoryName == filter).toList(),
      );
    }
  }

  void changeFilter(String newValue) {
    selectedCategory.value = newValue;
    applyFilter();
  }

  void _startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      // نعيد تحميل الصفحة الأولى فقط (للحصول على الأخبار الجديدة)
      _loadNewsPage(reset: true);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}