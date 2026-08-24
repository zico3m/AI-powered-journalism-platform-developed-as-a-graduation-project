
import 'package:flutter/material.dart';

import '../../models/data/datamodles/notifications/NotificationModel.dart';

String getNotificationGroup(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final notificationDate =
  DateTime(date.year, date.month, date.day);

  if (notificationDate == today) {
    return 'اليوم';
  } else if (notificationDate == yesterday) {
    return 'أمس';
  } else {
    return 'أقدم';
  }
}


IconData getNotificationIcon(String type) {
  switch (type) {
    case 'breaking_news':
      return Icons.flash_on;
    case 'news_interest':
      return Icons.article;
    case 'article_comment':
      return Icons.comment;
    case 'article_interest':
      return Icons.library_books;

    case 'upgrade_approved':
      return Icons.verified; // ✅ موافقة

    case 'upgrade_rejected':
      return Icons.cancel; // ❌ رفض

    default:
      return Icons.notifications;
  }
}


Color getNotificationColor(String type, bool isRead) {
  if (isRead) return Colors.grey;

  switch (type) {
    case 'breaking_news':
      return Colors.red;
    case 'news_interest':
      return Colors.blue;
    case 'article_comment':
      return Colors.green;
    case 'article_interest':
      return Colors.deepPurple;

    case 'upgrade_approved':
      return Colors.green; // ✅

    case 'upgrade_rejected':
      return Colors.red; // ❌

    default:
      return Colors.blueGrey;
  }
}



Map<String, List<NotificationModel>> groupNotifications(
    List<NotificationModel> notifications) {
  final Map<String, List<NotificationModel>> grouped = {};

  for (var n in notifications) {
    final group = getNotificationGroup(n.createdAt);
    grouped.putIfAbsent(group, () => []);
    grouped[group]!.add(n);
  }

  return grouped;
}

enum NotificationTab {
  all,
  news,
  interactions,
}


List<NotificationModel> filterNotificationsByTab(
    List<NotificationModel> notifications,
    NotificationTab tab,
    ) {
  switch (tab) {
    case NotificationTab.news:
      return notifications.where((n) =>
      n.type == 'breaking_news' ||
          n.type == 'news_interest').toList();

    case NotificationTab.interactions:
      return notifications.where((n) =>
      n.type == 'article_comment' ||
          n.type == 'article_interest' ||
          n.type == 'upgrade_request').toList();

    case NotificationTab.interactions:
      return notifications.where((n) =>
      n.type == 'article_comment' ||
          n.type == 'article_interest' ||
          n.type == 'upgrade_approved' ||
          n.type == 'upgrade_rejected'
      ).toList();

    case NotificationTab.all:
    default:
      return notifications;


  }
}
