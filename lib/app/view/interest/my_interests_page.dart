import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../widgets/Appare/appare.dart';
import '../../controller/TTS/WeatherController.dart';
import '../../controller/interest/interests_controller.dart';
import '../../controller/favorites/news_favorite_controller.dart';
import '../../controller/notifications/NotificationsController.dart';
import '../../controller/profile/ProfileController.dart';
import '../../core/app_colors.dart';
import '../../widgets/artical/CardNews.dart';
import '../../widgets/news/NewsCards.dart';
import '../notifications/NotificationsView.dart';
import '../profile/ProfileView.dart';
import '../home/detailsnews/NewsDetailsView.dart';
import '../searchview/search_view.dart';

class InterestStreamView extends StatefulWidget {
  const InterestStreamView({super.key});

  @override
  State<InterestStreamView> createState() => _InterestStreamViewState();
}

class _InterestStreamViewState extends State<InterestStreamView> {
  final controller = Get.put(InterestNewsController());
  final NotificationsController notificationsController =
  Get.find<NotificationsController>();
  final ProfileController profileController =
  Get.find<ProfileController>();

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدام brightness من السياق لضمان التفاعل مع تغيير الثيم
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDarkMode ? AppColor.darkBackground : AppColor.background;
    final surfaceBg =
    isDarkMode ? AppColor.darkCardBackground : AppColor.cardBackground;

    final textPrimary =
    isDarkMode ? AppColor.darkTextPrimary : AppColor.textPrimary;
    final textSecondary =
    isDarkMode ? AppColor.darkTextSecondary : AppColor.textSecondary;

    final chipBg = isDarkMode
        ? AppColor.darkCardBackground
        : AppColor.background.withOpacity(0.9);

    final chipBorder = isDarkMode
        ? AppColor.darkTextSecondary.withOpacity(0.30)
        : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: _buildAppBar(isDarkMode),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// العنوان وعداد الأخبار
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أخبار اهتماماتك',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        color: textPrimary,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? surfaceBg
                            : AppColor.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Obx(() {
                        return Text(
                          '${controller.filteredNews.length} خبر',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Cairo",
                            color: isDarkMode ? textSecondary : AppColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// شريط التصنيفات
          Obx(() {
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.userCategoryNames.length,
                itemBuilder: (context, index) {
                  final category = controller.userCategoryNames[index];
                  final isSelected =
                      controller.selectedCategory.value == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          fontFamily: "Cairo",
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Colors.white : textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      backgroundColor: chipBg,
                      selectedColor: AppColor.primary,
                      checkmarkColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) {
                          controller.changeFilter(category);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColor.primary : chipBorder,
                        width: 1,
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 8),

          /// قائمة الأخبار
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingShimmer(context, isDarkMode);
                }

                if (controller.filteredNews.isEmpty) {
                  return _buildEmptyState(context, isDarkMode);
                }

                return _buildNewsList(isDarkMode);
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء قائمة الأخبار مع دعم التحميل التدريجي
  Widget _buildNewsList(bool isDarkMode) {
    return RefreshIndicator(
      color: AppColor.primary,
      backgroundColor: isDarkMode ? AppColor.darkCardBackground : AppColor.cardBackground,
      onRefresh: controller.refreshNews,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: controller.filteredNews.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          // عنصر التحميل أو رسالة النهاية
          if (index == controller.filteredNews.length) {
            return Obx(() {
              if (controller.isLoadingMore.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (!controller.hasMore.value && controller.filteredNews.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'لا توجد أخبار أخرى',
                      style: TextStyle(
                        color: isDarkMode ? AppColor.darkTextSecondary : AppColor.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            });
          }

          // بناء بطاقة الخبر
          final news = controller.filteredNews[index];
          final favController = Get.put(
            NewsFavoriteController(news.id),
            tag: 'fav_news_${news.id}',
          );
          final timeAgo = news.publishedAt != null
              ? timeago.format(news.publishedAt!, locale: 'ar')
              : "";

          return GestureDetector(
            onTap: () => Get.to(() => NewsDetailsView(news: news)),
            child: NewsCard(
              title: news.title,
              imageUrl: news.primaryImageUrl,
              sourceName: news.source?.name ?? "نبأ",
              sourceLogoUrl: news.source?.logoUrl ??
                  "assets/images/ai_nabaa_logo_option1.png",
              categoryName: news.categoryName,
              timeAgo: timeAgo,
              isBreaking: news.isBreakingUntil != null &&
                  news.isBreakingUntil!.isAfter(DateTime.now()),
              onFavorite: favController.toggleSave,
              isSaved: favController.isSaved.value,
              onShare: () {},
            ),
          );
        },
      ),
    );
  }

  /// شاشة التحميل (Skeleton)
  Widget _buildLoadingShimmer(BuildContext context, bool isDarkMode) {
    final cardBg =
    isDarkMode ? AppColor.darkCardBackground : AppColor.cardBackground;
    final skeletonBg = isDarkMode
        ? AppColor.darkTextSecondary.withOpacity(0.12)
        : Colors.grey.shade200;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          height: 280,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: skeletonBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: skeletonBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 16,
                      decoration: BoxDecoration(
                        color: skeletonBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 12,
                          decoration: BoxDecoration(
                            color: skeletonBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 12,
                          decoration: BoxDecoration(
                            color: skeletonBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// الحالة الفارغة
  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    final textPrimary =
    isDarkMode ? AppColor.darkTextPrimary : AppColor.textPrimary;
    final textSecondary =
    isDarkMode ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: 80,
            color: textSecondary.withOpacity(0.85),
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد أخبار حالياً',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Cairo",
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جاري تحديث الأخبار بناءً على اهتماماتك',
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Cairo",
              height: 1.55,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.refreshNews();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'تحديث الأخبار',
              style: TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// شريط التطبيق (معتمد على isDarkMode)
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      elevation: 0,
      backgroundColor:
      isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
      foregroundColor:
      isDark ? AppColor.darkTextPrimary : AppColor.primary,
      centerTitle: true,
      title: const Text(
        'نبأ',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications_none_rounded),
            Obx(() {
              final count = notificationsController.unreadCount;
              if (count == 0) return const SizedBox.shrink();

              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        onPressed: () => Get.to(() => NotificationsView()),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => Get.to(() => SearchView()),
        ),
        const SizedBox(width: 4),
        Obx(() {
          final image = profileController.profileImageUrl.value;
          return GestureDetector(
            onTap: () => Get.to(() => UserProfileView()),
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.primary,
                ),
              ),
              child: CircleAvatar(
                backgroundColor:
                isDark ? AppColor.darkBackground : AppColor.background,
                backgroundImage:
                (image != null && image.isNotEmpty)
                    ? NetworkImage(image)
                    : null,
                child: (image == null || image.isEmpty)
                    ? Icon(
                  Icons.person,
                  size: 18,
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.textSecondary,
                )
                    : null,
              ),
            ),
          );
        }),
      ],
    );
  }
}