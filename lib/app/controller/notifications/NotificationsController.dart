

import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/datamodles/notifications/NotificationModel.dart';

class NotificationsController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  Timer? _pollingTimer;

  static const Duration _refreshInterval = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();

    final uid = _client.auth.currentUser?.id;
    if (uid != null) {
      _loadNotifications();
      _startPolling();
    }

    // مراقبة تسجيل الدخول / الخروج
    _client.auth.onAuthStateChange.listen((event) {
      final user = event.session?.user;

      if (user == null) {
        notifications.clear();
        _pollingTimer?.cancel();
      } else {
        _loadNotifications();
        _startPolling();
      }
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(_refreshInterval, (_) async {
      await _loadNotifications(silent: true);
    });
  }

  Future<void> _loadNotifications({bool silent = false}) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;

    if (!silent) isLoading.value = true;

    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);

    final newList = (data as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();

    if (!_sameIds(notifications, newList)) {
      notifications.assignAll(newList);
    }

    if (!silent) isLoading.value = false;
  }

  bool _sameIds(
      List<NotificationModel> oldList,
      List<NotificationModel> newList,
      ) {
    if (oldList.length != newList.length) return false;

    for (int i = 0; i < newList.length; i++) {
      if (oldList[i].id != newList[i].id) return false;
    }
    return true;
  }

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;

  Future<void> markAsRead(int id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      final old = notifications[index];
      notifications[index] = NotificationModel(
        id: old.id,
        type: old.type,
        title: old.title,
        body: old.body,
        isRead: true,
        createdAt: old.createdAt,
        data: old.data,
      );
    }

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }

  Future<void> markAllAsRead() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;

    for (int i = 0; i < notifications.length; i++) {
      final n = notifications[i];
      if (!n.isRead) {
        notifications[i] = NotificationModel(
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          isRead: true,
          createdAt: n.createdAt,
          data: n.data,
        );
      }
    }

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', uid)
        .eq('is_read', false);
  }
}
