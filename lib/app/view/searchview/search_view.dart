import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controller/favorites/news_favorite_controller.dart';
import '../../controller/search/search_controller.dart';
import '../../core/app_colors.dart';
import '../../widgets/news/NewsCards.dart';
import '../home/detailsnews/NewsDetailsView.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final SearchControllerr controller = Get.put(SearchControllerr());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        isDark ? AppColor.darkBackground : AppColor.background,

        /// ───────── AppBar ─────────
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
          isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
          foregroundColor:
          isDark ? AppColor.darkTextPrimary : AppColor.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "بحث",
            style: TextStyle(
              fontFamily: "Cairo",
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),

        body: Column(
          children: [
            const SizedBox(height: 12),

            /// ───────── Search Field ─────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkCardBackground
                      : AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: controller.onQueryChanged,
                  onSubmitted: (_) => controller.submitSearch(),
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 14,
                    color: isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن خبر، موضوع، تصنيف...',
                    hintStyle: TextStyle(
                      fontFamily: "Cairo",
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.textSecondary,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor.primary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Obx(() {
              final q = controller.query.value.trim();
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    q.isEmpty
                        ? "اكتب كلمة للبحث في الأخبار"
                        : "نتائج البحث عن: $q",
                    style: TextStyle(
                      fontFamily: "Cairo",
                      fontSize: 13,
                      color: q.isEmpty
                          ? (isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.textSecondary)
                          : (isDark
                          ? AppColor.darkTextPrimary
                          : AppColor.textPrimary),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 6),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation(AppColor.primary),
                    ),
                  );
                }

                if (controller.query.value.trim().isNotEmpty &&
                    controller.results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color:
                          AppColor.primary.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "لا توجد أخبار مطابقة لبحثك",
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.results.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final news = controller.results[index];

                    final favController = Get.put(
                      NewsFavoriteController(news.id),
                      tag: 'fav_news_${news.id}',
                    );

                    final timeAgo = news.publishedAt != null
                        ? timeago.format(news.publishedAt!, locale: 'ar')
                        : "";

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => NewsDetailsView(news: news));
                      },
                      child: Obx(() {
                        return NewsCard(
                          title: news.title,
                          imageUrl: news.primaryImageUrl,
                          sourceName: news.source?.name ?? "نبأ",
                          sourceLogoUrl: news.source?.logoUrl,
                          categoryName: news.categoryName,
                          timeAgo: timeAgo,
                          isBreaking: news.isBreakingUntil != null &&
                              news.isBreakingUntil!
                                  .isAfter(DateTime.now()),
                          onFavorite: favController.toggleSave,
                          isSaved: favController.isSaved.value,
                          onShare: () {},
                        );
                      }),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
