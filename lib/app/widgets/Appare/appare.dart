import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:naba_ai/app/view/WeatherDetailsView.dart';
import 'package:naba_ai/app/view/notifications/NotificationsView.dart';
import 'package:naba_ai/app/view/profile/ProfileView.dart';
import 'package:naba_ai/app/view/searchview/search_view.dart';

import '../../controller/TTS/WeatherController.dart';
import '../../controller/notifications/NotificationsController.dart';
import '../../controller/profile/ProfileController.dart';
import '../../core/app_colors.dart';

PreferredSizeWidget buildAppBar(bool isDark) {
  final WeatherController weatherController = Get.find();
  final NotificationsController notificationsController = Get.find();
  final ProfileController profileController = Get.find();
  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();

    if (desc.contains("clear")) {
      return Icons.wb_sunny_rounded;
    } else if (desc.contains("cloud")) {
      return Icons.cloud_rounded;
    } else if (desc.contains("rain")) {
      return Icons.umbrella_rounded;
    } else if (desc.contains("storm")) {
      return Icons.thunderstorm_rounded;
    } else if (desc.contains("snow")) {
      return Icons.ac_unit_rounded;
    } else {
      return Icons.wb_cloudy_rounded;
    }
  }

  return AppBar(
    elevation: 0,
    backgroundColor:
    isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
    foregroundColor:
    isDark ? AppColor.darkTextPrimary : AppColor.primary,
    centerTitle: true,

    /// 🌦️ الطقس
    title: Obx(() {
      if (weatherController.city.isEmpty) {
        return const Text(
          'نبأ',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        );
      }

      return GestureDetector(
        onTap: () => Get.to(() => const WeatherDetailsView()),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔥 إذا عندنا أيقونة من API
            if (weatherController.icon.value.isNotEmpty)
              Image.network(
                'https://openweathermap.org/img/wn/${weatherController.icon.value}@2x.png',
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) {
                  return Icon(
                    _getWeatherIcon(
                        weatherController.description.value),
                    size: 28,
                    color: Colors.orangeAccent,
                  );
                },
              )
            else
              Icon(
                _getWeatherIcon(
                    weatherController.description.value),
                size: 28,
                color: Colors.orangeAccent,
              ),

            const SizedBox(width: 8),

            Text(
              '${weatherController.city.value} '
                  '${weatherController.temperature.value}°',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );

    }),

    /// 🔔 Notifications
    leading: IconButton(
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_active,
            color: isDark
                ? AppColor.darkTextPrimary
                : AppColor.primary,
          ),
          Obx(() {
            final count = notificationsController.unreadCount;
            if (count == 0) return const SizedBox.shrink();

            return Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
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

    /// 🔍 + 👤
    actions: [
      IconButton(
        icon: Icon(
          Icons.search_rounded,
          color: isDark
              ? AppColor.darkTextPrimary
              : AppColor.primary,
        ),
        onPressed: () => Get.to(() => SearchView()),
      ),
      Obx(() {
        final image = profileController.profileImageUrl.value;
        return GestureDetector(
          onTap: () => Get.to(() => UserProfileView()),
          child: CircleAvatar(
            backgroundImage:
            (image != null && image.isNotEmpty)
                ? NetworkImage(image)
                : null,
            child: image == null || image.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
        );
      }),
    ],
  );
}






