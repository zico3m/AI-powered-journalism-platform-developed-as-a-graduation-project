// lib/app/views/root/RootView.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/RootView/RootController.dart';
import '../../controller/profile/ProfileController.dart';
import '../../core/app_colors.dart';
import '../ArticleView/CreateArticleView.dart';

class RootView extends StatelessWidget {
  final RootController controller = Get.put(RootController());
  final ProfileController profileController = Get.find<ProfileController>();

  RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.darkBackground : AppColor.background,
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        );
      }),

      bottomNavigationBar: _buildCustomBottomNavBar(),
      floatingActionButton: Obx(() {
        if (profileController.accountTypeName.value != "كاتب") {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          backgroundColor: AppColor.primary,
          elevation: 6,
          child: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            Get.to(() => CreateArticleView());
          },
        );
      }),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Obx(() {
      final isDark = Get.isDarkMode;

      final bgColor =
      isDark ? AppColor.darkCardBackground : AppColor.cardBackground;

      return Container(
        height: 85,
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.10),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              activeIcon: Icons.home_filled,
              label: 'home'.tr,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.favorite_rounded,
              activeIcon: Icons.favorite_rounded,
              label: 'interests'.tr,
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.article_rounded,
              activeIcon: Icons.article_rounded,
              label: 'articles'.tr,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.category_rounded,
              activeIcon: Icons.category_rounded,
              label: 'ai_ask'.tr,
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.settings_rounded,
              activeIcon: Icons.settings_rounded,
              label: 'settings'.tr,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isActive = controller.currentIndex.value == index;
    final bool isDark = Get.isDarkMode;

    final Color activeColor = AppColor.primary;
    final Color inactiveColor =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    // 🔥 المطلوب: الأيقونة المفعّلة دائمًا بيضاء
    final Color activeIconColor = Colors.white;

    final Color currentIconColor =
    isActive ? activeIconColor : inactiveColor;

    final Color currentTextColor =
    isActive ? activeIconColor : inactiveColor;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isActive ? 75 : 60,
        height: isActive ? 60 : 50,
        decoration: BoxDecoration(
          // 🔵 الخلفية زرقاء دائمًا عند التفعيل
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? Border.all(
            color: activeColor.withOpacity(0.4),
          )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: isActive ? 26 : 22,
                color: currentIconColor,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isActive ? 1 : 0.7,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: isActive ? 11 : 10,
                  fontWeight:
                  isActive ? FontWeight.w800 : FontWeight.w600,
                  color: currentTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
