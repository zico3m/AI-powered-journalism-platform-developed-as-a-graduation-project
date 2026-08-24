import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/app_colors.dart';
import '../../controller/favorites/SavedNewsController.dart';
import '../../widgets/news/NewsCards.dart';
import '../home/detailsnews/NewsDetailsView.dart';

class SavedNewsView extends StatelessWidget {
  final controller = Get.find<SavedNewsController>();

  SavedNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.darkBackground : AppColor.background,

      appBar: AppBar(
        title: const Text(
          "الأخبار المحفوظة",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
        isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
        foregroundColor:
        isDark ? AppColor.darkTextPrimary : AppColor.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.savedNews.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(AppColor.primary),
            ),
          );
        }

        if (controller.savedNews.isEmpty) {
          return RefreshIndicator(
            color: AppColor.primary,
            onRefresh: controller.refreshSavedNews,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 180),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          size: 48,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "لا توجد أخبار محفوظة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColor.darkTextPrimary
                              : AppColor.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "احفظ الأخبار للعودة إليها لاحقًا",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: controller.refreshSavedNews,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            itemCount: controller.savedNews.length,
            itemBuilder: (context, index) {
              final news = controller.savedNews[index];

              final timeAgo = news.publishedAt != null
                  ? timeago.format(news.publishedAt!, locale: 'ar')
                  : '';

              return Dismissible(
                key: ValueKey(news.id),
                direction: DismissDirection.endToStart,

                background: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                confirmDismiss: (_) async {
                  return await Get.defaultDialog<bool>(
                    title: "حذف الخبر",
                    middleText: "هل تريد إزالة هذا الخبر من المحفوظات؟",
                    textConfirm: "حذف",
                    textCancel: "إلغاء",
                    confirmTextColor: Colors.white,
                    buttonColor: AppColor.primary,
                    onConfirm: () => Get.back(result: true),
                    onCancel: () => Get.back(result: false),
                  );
                },

                onDismissed: (_) async {
                  await controller.removeFromSaved(news.id);
                },

                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: NewsCard(
                    title: news.title,
                    imageUrl: news.primaryImageUrl,
                    sourceName: news.source?.name ?? "نبأ",
                    sourceLogoUrl: news.source?.logoUrl,
                    categoryName: news.categoryName,
                    timeAgo: timeAgo,
                    isBreaking: news.isBreakingUntil != null &&
                        news.isBreakingUntil!
                            .isAfter(DateTime.now()),
                    isSaved: true,
                    onFavorite: () async {
                      await controller.removeFromSaved(news.id);
                    },
                    onShare: () {},
                    onTap: () {
                      Get.to(() => NewsDetailsView(news: news));
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
