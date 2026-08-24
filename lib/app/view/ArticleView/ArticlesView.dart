import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naba_ai/app/widgets/artical/CardNews.dart';

import '../../widgets/Appare/appare.dart';
import '../../controller/ArticleController/ArticlesController.dart';
import '../../controller/likes/like_controller.dart';
import '../../controller/notifications/NotificationsController.dart';
import '../../controller/profile/ProfileController.dart';
import '../../core/app_colors.dart';
import '../Comments/comment_dialog.dart';
import '../notifications/NotificationsView.dart';
import '../profile/ProfileView.dart';
import '../searchview/search_view.dart';
import '../time.dart';
import 'ArticleDetailsView.dart';

class ArticlesView extends StatefulWidget {
  ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  final controller = Get.put(ArticleController(), tag: 'all_articles');
  final NotificationsController notificationsController =
  Get.find<NotificationsController>();

  final ProfileController profileController =
  Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg =
    isDark ? AppColor.darkBackground : AppColor.background;
    final textPrimary =
    isDark ? AppColor.darkTextPrimary : AppColor.textPrimary;
    final textSecondary =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return Scaffold(
      appBar: buildAppBar(isDark),
      backgroundColor: scaffoldBg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
            ),
          );
        }

        if (controller.error.value != null) {
          return Center(
            child: Text(
              controller.error.value!,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: textSecondary,
                fontSize: 14,
              ),
            ),
          );
        }

        if (controller.articles.isEmpty) {
          return Center(
            child: Text(
              "لا توجد مقالات",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColor.primary,
          backgroundColor:
          isDark ? AppColor.darkCardBackground : Colors.white,
          onRefresh: controller.fetchArticles,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final article = controller.articles[index];

              /// ✅ LikeController خاص بكل مقال
              final LikeController likeController = Get.put(
                LikeController(article.id!),
                tag: 'like_${article.id}',
              );

              return Obx(() {
                return GestureDetector(
                  onTap: () {
                    Get.to(
                          () => ArticleDetailsView(article: article),
                    );
                  },
                  child: ArticleCard(
                    title: article.title,
                    imageUrl: article.coverImage ??
                        "https://via.placeholder.com/600x300.png",
                    authorName: article.author.name,
                    authorImage: article.author.pictureUrl != null
                        ? NetworkImage(article.author.pictureUrl!)
                        : null,
                    timeAgo: timeAgo(article.createdAt),

                    /// ❤️ Likes
                    isLiked: likeController.isLiked.value,
                    likesCount: likeController.likesCount.value,
                    onLikeTapped: likeController.onLikeTapped,

                    /// 💬 Comments
                    commentsCount:
                    controller.commentsCount[article.id] ?? 0,
                    onComment: () {
                      showCommentsDialog(context, article.id!);
                    },

                    showEngagementStats: true,
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }








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






  Widget _buildProfileAvatar(BuildContext context) {
    final ProfileController controller5 =
    Get.find<ProfileController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final image = controller5.profileImageUrl.value;
      return GestureDetector(
        onTap: () => Get.to(() => UserProfileView()),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? AppColor.darkTextSecondary.withOpacity(0.3)
                  : Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: isDark
                ? AppColor.darkCardBackground
                : Colors.grey.shade100,
            backgroundImage: (image != null && image.isNotEmpty)
                ? NetworkImage(image)
                : null,
            child: (image == null || image.isEmpty)
                ? Icon(Icons.person_rounded,
                color: isDark
                    ? AppColor.darkTextSecondary
                    : Colors.grey.shade400,
                size: 20)
                : null,
          ),
        ),
      );
    });
  }




}
