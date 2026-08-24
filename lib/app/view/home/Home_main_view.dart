import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controller/share/sharenews.dart';
import '../../core/utils/utils.dart';
import '../../widgets/Appare/appare.dart';
import '../../controller/home/CategoriesController.dart';
import '../../controller/TTS/WeatherController.dart';
import '../../controller/home/HomeController.dart';
import '../../controller/favorites/news_favorite_controller.dart';
import '../../controller/notifications/NotificationsController.dart';
import '../../controller/profile/ProfileController.dart';
import '../../core/app_colors.dart';
import '../../models/data/datamodles/news/NewsModel.dart';
import '../../widgets/news/NewsCards.dart';

import 'detailsnews/NewsDetailsView.dart';

class HomeMainView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final ProfileController controller1 = Get.put(ProfileController());

  final ScrollController _scrollController = ScrollController();
  // final NewsController newsController = Get.find<NewsController>();


  final categoriesController = Get.find<CategoriesController>();

  HomeMainView({super.key}) {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // قرب النهاية
      controller.loadMore();
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.background,
      appBar: buildAppBar(isDark),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.primary,
          backgroundColor:
              isDark ? AppColor.darkBackground : AppColor.background,
          onRefresh: () async => controller.refreshNews(),
          child: Obx(() {
            final isLoading = controller.isLoadingBreaking.value ||
                controller.isLoadingLatest.value;

            final hasBreaking = controller.breakingNewsList.isNotEmpty;
            final hasLatest = controller.latestNewsList.isNotEmpty;

            if (isLoading && !hasBreaking && !hasLatest) {
              return _buildLoadingView(isDark);
            }
            if (!isLoading && !hasBreaking && !hasLatest) {
              return _buildEmptyView(isDark);
            }

            return _buildContent(
              isDark: isDark,
              hasBreakingNews: hasBreaking,
              hasLatestNews: hasLatest,
            );
          }),
        ),
      ),
    );
  }
  Widget _buildLoadingView(bool isDark) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // رأس التحميل مع مؤشر دائري ونص
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColor.primary,
                strokeWidth: 2.5,
              ),
              const SizedBox(width: 12),
              Text(
                'جار تحميل الأخبار...',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? AppColor.darkTextSecondary : AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // 6 بطاقات skeleton
        ...List.generate(
          6,
              (index) => Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // صورة skeleton
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                // نصوص skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // Widget _buildLoadingView(bool isDark) {
  //   return ListView(
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     padding: const EdgeInsets.all(16),
  //     children: List.generate(
  //       6,
  //       (_) => Container(
  //         height: 90,
  //         margin: const EdgeInsets.only(bottom: 12),
  //         decoration: BoxDecoration(
  //           color:
  //               isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEmptyView(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 70,
            color: AppColor.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد أخبار حالياً',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              color: isDark ? AppColor.darkTextPrimary : AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'جاري تحديث المحتوى',
            style: TextStyle(
              fontFamily: 'Cairo',
              color:
                  isDark ? AppColor.darkTextSecondary : AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── Content ─────────────────


  Widget _buildContent({
    required bool isDark,
    required bool hasBreakingNews,
    required bool hasLatestNews,
  }) {
    return ListView(
      controller: _scrollController, // إضافة المتحكم
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        if (hasBreakingNews)
          _buildBreakingStrip(controller.breakingNewsList.first, isDark),
        const SizedBox(height: 10),
        _buildCategoriesSection(isDark),
        const SizedBox(height: 12),
        _buildLatestHeader(isDark),
        const SizedBox(height: 8),
        if (hasLatestNews)
          _buildLatestNewsList()
        else
          _buildNoLatestNewsMessage(isDark),
        // إضافة مؤشر تحميل المزيد إذا كان هناك صفحات قادمة
        Obx(() {
          if (controller.isLoadingMore.value) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
            );
          } else if (!controller.hasMore.value && controller.latestNewsList.isNotEmpty) {
            // رسالة نهاية القائمة
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'لا توجد أخبار أخرى',
                  style: TextStyle(
                    color: isDark ? AppColor.darkTextSecondary : AppColor.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
  // Widget _buildContent({
  //   required bool isDark,
  //   required bool hasBreakingNews,
  //   required bool hasLatestNews,
  // }) {
  //   return ListView(
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     padding: const EdgeInsets.only(bottom: 16),
  //     children: [
  //       if (hasBreakingNews)
  //         _buildBreakingStrip(controller.breakingNewsList.first, isDark),
  //       const SizedBox(height: 10),
  //       _buildCategoriesSection(isDark),
  //       const SizedBox(height: 12),
  //       _buildLatestHeader(isDark),
  //       const SizedBox(height: 8),
  //       if (hasLatestNews)
  //         _buildLatestNewsList()
  //       else
  //         _buildNoLatestNewsMessage(isDark),
  //     ],
  //   );
  // }

  Widget _buildLatestHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.new_releases, color: AppColor.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'أحدث الأخبار',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: isDark ? AppColor.darkTextPrimary : AppColor.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── Breaking ─────────────────

  Widget _buildBreakingStrip(NewsModel news, bool isDark) {
    final hasImage =
        news.primaryImageUrl != null && news.primaryImageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () => Get.to(() => NewsDetailsView(news: news)),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            /// Badge عاجل
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                children: [
                  Icon(Icons.flash_on, size: 16, color: Colors.red),
                  SizedBox(width: 6),
                  Text(
                    'عاجل',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// العنوان
            Expanded(
              child: Text(
                news.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// صورة الخبر (اختيارية)
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  news.primaryImageUrl!,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 46,
                    height: 46,
                    color:
                        isDark ? AppColor.darkBackground : AppColor.background,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 20,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ───────────────── Categories ─────────────────

  Widget _buildCategoriesSection(bool isDark) {
    return SizedBox(
      height: 44,
      child: Obx(() {
        if (categoriesController.isLoading.value) {
          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: List.generate(
              5,
              (_) => Container(
                width: 90,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkCardBackground
                      : AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          );
        }

        final selectedId = controller.selectedCategoryId.value;

        return ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _chip(
              label: 'الكل',
              selected: selectedId == null,
              onTap: () => controller.changeCategory(null),
              isDark: isDark,
            ),
            ...categoriesController.categories.map((cat) {
              return _chip(
                label: cat['name'],
                selected: selectedId == cat['id'],
                onTap: () => controller.changeCategory(cat['id']),
                isDark: isDark,
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? AppColor.primary.withOpacity(0.15)
                : (isDark
                    ? AppColor.darkCardBackground
                    : AppColor.cardBackground),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? AppColor.primary.withOpacity(0.4)
                  : AppColor.dividerLight,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              color: selected
                  ? AppColor.primary
                  : (isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── Latest List ─────────────────

  Widget _buildLatestNewsList() {

    return Obx(() {
      if (controller.isLoadingLatest.value) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.latestNewsList.length,
        itemBuilder: (context, index) {
          final news = controller.latestNewsList[index];
          final favController = Get.put(
            NewsFavoriteController(news.id),
            tag: 'fav_news_${news.id}',
          );

          final timeAgo = news.publishedAt != null
              ? formatTime(news.publishedAt!)
              : '';


          return GestureDetector(
            onTap: () {
              Get.to(() => NewsDetailsView(news: news));
            },
            child: NewsCard(
              title: news.title,
              imageUrl: news.primaryImageUrl,
              sourceName: news.source?.name ?? "نبأ",
              sourceLogoUrl: news.source?.logoUrl ??
                  "assets/images/icon.png",
              categoryName: news.categoryName,
              timeAgo: timeAgo,
              isBreaking: news.isBreakingUntil != null &&
                  news.isBreakingUntil!
                      .toLocal()
                      .isAfter(DateTime.now()),
              onFavorite: favController.toggleSave,
              isSaved: favController.isSaved.value,


            ),
          );
        },
      );
    });
  }

  Widget _buildNoLatestNewsMessage(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.article_outlined,
              size: 36, color: AppColor.primary.withOpacity(0.4)),
          const SizedBox(height: 8),
          Text(
            'لا توجد أخبار في هذا التصنيف',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              color: isDark ? AppColor.darkTextPrimary : AppColor.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
