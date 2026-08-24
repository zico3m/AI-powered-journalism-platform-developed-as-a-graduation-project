import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controller/Commentss/comment_controller.dart';
import '../../core/app_colors.dart';

Future<bool?> showCommentsDialog(BuildContext context, int articleId) {
  final controller = Get.put(
    CommentController(articleId),
    tag: 'comments_$articleId',
  );

  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.darkCardBackground
                : AppColor.cardBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: (isDark
                        ? AppColor.darkTextSecondary
                        : AppColor.textSecondary)
                        .withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "التعليقات",
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.textPrimary,
                      ),
                    ),
                    Obx(() {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${controller.comments.length}",
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColor.primary,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const Divider(height: 1),

              /// ───────── Comments List ─────────
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              AppColor.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "جاري تحميل التعليقات...",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 56,
                            color: AppColor.primary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "كن أول من يعلق",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColor.darkTextPrimary
                                  : AppColor.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "شاركنا رأيك حول هذا المقال",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.comments.length,
                    itemBuilder: (context, index) {
                      final comment = controller.comments[index];
                      final user = comment['users'];
                      final currentUserId = Supabase
                          .instance.client.auth.currentUser?.id;

                      final isMine =
                          currentUserId == comment['user_id'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColor.darkBackground
                                : AppColor.background,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// User Row
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                    AppColor.primary.withOpacity(0.15),
                                    backgroundImage:
                                    user?['picture_url'] != null
                                        ? NetworkImage(
                                        user['picture_url'])
                                        : null,
                                    child: user?['picture_url'] == null
                                        ? Icon(
                                      Icons.person,
                                      color: AppColor.primary,
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user?['name'] ?? 'مستخدم',
                                          style: TextStyle(
                                            fontFamily: "Cairo",
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? AppColor.darkTextPrimary
                                                : AppColor.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${comment['created_at']}",
                                          style: TextStyle(
                                            fontFamily: "Cairo",
                                            fontSize: 11,
                                            color: isDark
                                                ? AppColor.darkTextSecondary
                                                : AppColor.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isMine)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "حذف التعليق",
                                          middleText:
                                          "هل أنت متأكد من حذف تعليقك؟",
                                          textConfirm: "حذف",
                                          textCancel: "إلغاء",
                                          confirmTextColor: Colors.white,
                                          buttonColor: Colors.red,
                                          onConfirm: () {
                                            Get.back();
                                            controller.deleteComment(
                                                comment['id']);
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// Comment Content
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColor.darkCardBackground
                                      : AppColor.cardBackground,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  comment['content'],
                                  style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 14,
                                    height: 1.6,
                                    color: isDark
                                        ? AppColor.darkTextPrimary
                                        : AppColor.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              /// ───────── Add Comment ─────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkCardBackground
                      : AppColor.cardBackground,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColor.darkBackground
                              : AppColor.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: controller.textController,
                          maxLines: 3,
                          minLines: 1,
                          style: TextStyle(
                            fontFamily: "Cairo",
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: "اكتب تعليقك هنا...",
                            hintStyle: TextStyle(
                              fontFamily: "Cairo",
                              color: isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColor.primary,
                            AppColor.primary.withOpacity(0.85),
                          ],
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded,
                            color: Colors.white),
                        onPressed: controller.addComment,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
