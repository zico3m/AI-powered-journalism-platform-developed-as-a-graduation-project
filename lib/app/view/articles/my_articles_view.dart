import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naba_ai/app/view/time.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controller/ArticleController/ArticlesController.dart';
import '../../widgets/artical/CardNews.dart';
import 'edit_article_view.dart';

class MyArticlesView extends StatefulWidget {
  const MyArticlesView({super.key});

  @override
  State<MyArticlesView> createState() => _MyArticlesViewState();
}

class _MyArticlesViewState extends State<MyArticlesView> {
  late final ArticleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ArticleController(),
      tag: 'my_articles',
    );
    controller.fetchMyArticles();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "منشوراتي",
          style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: colorScheme.primary));
        }

        if (controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 80, color: colorScheme.outline),
                const SizedBox(height: 16),
                Text(
                  "لم تقم بنشر أي مقال بعد",
                  style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          );
        }

        final currentUserId = Supabase.instance.client.auth.currentUser!.id;

        return Column(
          children: [
            // بطاقة إحصائية محسّنة
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "عدد منشوراتي",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${controller.articles.length}",
                      style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // قائمة المقالات
            Expanded(
              child: ListView.builder(
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  final article = controller.articles[index];
                  final isOwner = article.author.id == currentUserId;

                  return Stack(
                    children: [
                      // بطاقة المقال مع تحسينات بصرية
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ArticleCard(
                          title: article.title,
                          imageUrl: article.coverImage ??
                              "https://via.placeholder.com/600x300",
                          authorName: article.author.name,
                          authorImage: article.author.pictureUrl != null
                              ? NetworkImage(article.author.pictureUrl!)
                              : null,
                          timeAgo: timeAgo(article.createdAt),
                          likesCount: controller.likesCount[article.id] ?? 0,
                          commentsCount: controller.commentsCount[article.id] ?? 0,
                          isLiked: false,
                        ),
                      ),

                      // زر القائمة للمالك فقط
                      if (isOwner)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Get.to(() => EditArticleView(article: article));
                                } else if (value == 'delete') {
                                  _showDeleteDialog(article.id!); // article.id is int
                                }
                              },
                              icon: const Icon(Icons.more_vert, size: 24),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 20),
                                      SizedBox(width: 8),
                                      Text("تعديل"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
                                      const SizedBox(width: 8),
                                      Text("حذف", style: TextStyle(color: colorScheme.error)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // ✅ تم تصحيح نوع المعامل إلى int ليتوافق مع article.id
  void _showDeleteDialog(int articleId) {
    Get.defaultDialog(
      title: "حذف المقال",
      middleText: "هل أنت متأكد من حذف هذا المقال؟",
      textConfirm: "حذف",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await controller.deleteArticle(articleId); // الآن articleId من النوع int
      },
    );
  }

  @override
  void dispose() {
    Get.delete<ArticleController>(tag: 'my_articles');
    super.dispose();
  }
}