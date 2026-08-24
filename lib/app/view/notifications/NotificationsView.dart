import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/app_colors.dart';
import '../../controller/auth/login_controller.dart';
import '../../controller/notifications/NotificationsController.dart';
import '../../controller/notifications/notification_group_helper.dart';
import '../../models/data/datamodles/notifications/NotificationModel.dart';
import '../home/news_details_loader.dart';

class NotificationsView extends StatefulWidget {
  NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final controller = Get.find<NotificationsController>();
  final selectedTab = NotificationTab.all.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.background,

          /// ───────── AppBar ─────────
          appBar: AppBar(
            title: const Text(
              "الإشعارات",
              style: TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor:
            isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
            foregroundColor:
            isDark ? AppColor.darkTextPrimary : AppColor.primary,

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkBackground
                      : AppColor.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  onTap: (index) {
                    selectedTab.value = NotificationTab.values[index];
                  },
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primary,
                        AppColor.primary.withOpacity(0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.textSecondary,
                  labelStyle: const TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'الكل'),
                    Tab(text: 'الأخبار'),
                    Tab(text: 'التفاعلات'),
                  ],
                ),
              ),
            ),
          ),

          /// ───────── Body ─────────
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation(AppColor.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "جاري تحميل الإشعارات...",
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

            final filtered = filterNotificationsByTab(
              controller.notifications,
              selectedTab.value,
            );

            if (filtered.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: AppColor.primary.withOpacity(0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "لا توجد إشعارات",
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
                      "ستظهر إشعاراتك هنا عندما تتوفر",
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

            final grouped = groupNotifications(filtered);

            return ListView(
              padding: const EdgeInsets.only(bottom: 90),
              children: grouped.entries.map((entry) {
                final groupTitle = entry.key;
                final items = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ───── Group Title ─────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                            AppColor.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            groupTitle,
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.w700,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// ───── Notifications ─────
                    ...items.map((n) {
                      final timeAgo =
                      timeago.format(n.createdAt, locale: 'ar');

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            controller.markAsRead(n.id);
                            handleNotificationTap(n);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColor.darkCardBackground
                                  : AppColor.cardBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: n.isRead
                                    ? Colors.transparent
                                    : AppColor.primary
                                    .withOpacity(0.25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(isDark ? 0.35 : 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Icon
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary.withOpacity(0.12),
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    getNotificationIcon(n.type),
                                    color: AppColor.primary,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                /// Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              n.title,
                                              maxLines: 2,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: "Cairo",
                                                fontWeight: n.isRead
                                                    ? FontWeight.w600
                                                    : FontWeight.w800,
                                                color: isDark
                                                    ? AppColor.darkTextPrimary
                                                    : AppColor.textPrimary,
                                              ),
                                            ),
                                          ),
                                          if (!n.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: AppColor.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        n.body,
                                        maxLines: 3,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "Cairo",
                                          height: 1.5,
                                          color: isDark
                                              ? AppColor.darkTextSecondary
                                              : AppColor.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        timeAgo,
                                        style: TextStyle(
                                          fontFamily: "Cairo",
                                          fontSize: 12,
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
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            );
          }),

          /// ───────── FAB ─────────
          floatingActionButton: Obx(() {
            final unreadCount =
                controller.notifications.where((n) => !n.isRead).length;

            if (unreadCount == 0) return const SizedBox.shrink();

            return FloatingActionButton.extended(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.done_all_rounded),
              label: Text(
                'تحديد الكل كمقروء ($unreadCount)',
                style: const TextStyle(fontFamily: "Cairo"),
              ),
              onPressed: () {
                controller.markAllAsRead();
                Get.snackbar(
                  'تمت القراءة',
                  'تم تحديد جميع الإشعارات كمقروءة',
                  backgroundColor: AppColor.primary,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// ───────── Navigation Logic (unchanged) ─────────
  void handleNotificationTap(NotificationModel n) {
    switch (n.type) {
      case 'breaking_news':
      case 'news_interest':
        final newsId = n.data?['news_id'];
        if (newsId != null) {
          Get.to(() => NewsDetailsLoader(newsId: newsId));
        }
        break;

      case 'article_comment':
      case 'article_interest':
        Get.toNamed(
          '/article-details',
          arguments: n.data?['article_id'],
        );
        break;

      case 'upgrade_approved':
        Get.defaultDialog(
          title: n.title,
          content: const Text(
            'تمت ترقية حسابك بنجاح.\nيرجى تسجيل الخروج ثم الدخول مرة أخرى لتفعيل حساب الكاتب.',
            textAlign: TextAlign.center,
          ),
          confirm: ElevatedButton(
            onPressed: () async {
              await Get.find<LoginController>().logout();
              Get.offAllNamed('/login');
            },
            child: const Text('تسجيل الخروج'),
          ),
        );
        break;

      case 'upgrade_rejected':
        Get.defaultDialog(
          title: n.title,
          content: Text(
            n.data?['reason'] ?? 'تم رفض طلب الترقية',
            textAlign: TextAlign.center,
          ),
          confirm: ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('حسناً'),
          ),
        );
        break;
    }
  }
}
