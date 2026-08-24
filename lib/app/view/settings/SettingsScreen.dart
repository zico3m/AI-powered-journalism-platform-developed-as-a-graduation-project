import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controller/TTS/WeatherController.dart';
import '../../core/localization/LanguageController.dart';
import '../../controller/auth/login_controller.dart';
import '../../controller/profile/ProfileController.dart';
import '../../controller/settings/settings_controller.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../about_nabaa/LegalPageBinding.dart';
import '../about_nabaa/legal_page_view.dart';

import '../profile/ProfileView.dart';
import '../favorites/SavedNewsView.dart';
import '../articles/my_articles_view.dart';
import 'moresettings.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});
  final LanguageController langController = Get.put(LanguageController());

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;
  final WeatherController weatherController =
  Get.put(WeatherController());

  final loginController = Get.find<LoginController>();
  final settingsController = Get.put(SettingsController());
  final ProfileController profile = Get.find<ProfileController>();

  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppColor.darkBackground : AppColor.background;
    final cardBg =
    isDark ? AppColor.darkCardBackground : AppColor.cardBackground;
    final textPrimary =
    isDark ? AppColor.darkTextPrimary : AppColor.textPrimary;
    final textSecondary =
    isDark ? AppColor.darkTextSecondary : AppColor.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'settings'.tr,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// ---------------- Account ----------------
            _buildSection(
              iconcolr: isDark ? AppColor.background : AppColor.primary ,
              title: 'account_management'.tr,
              icon: Icons.person_outline,
              cardBg: cardBg,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              children: [
                _buildMenuItem(
                  iconcoler:isDark ? AppColor.background : AppColor.primary ,

                  icon: Icons.person_rounded,
                  title: 'profile'.tr,
                  onTap: () => Get.to(() => UserProfileView()),
                  textPrimary: textPrimary,
                ),
                Obx(() {
                  if (profile.accountTypeId.value == 2) {
                    return _buildMenuItem(
                      iconcoler:isDark ? AppColor.background : AppColor.primary ,

                      icon: Icons.article_rounded,
                      title: 'my_articles'.tr,
                      onTap: () => Get.to(() => MyArticlesView()),
                      textPrimary: textPrimary,
                    );
                  }
                  return const SizedBox.shrink();
                }),
                _buildMenuItem(
                  iconcoler:isDark ? AppColor.background : AppColor.primary ,

                  icon: Icons.bookmark_rounded,
                  title: 'favorites'.tr,
                  onTap: () => Get.to(() => SavedNewsView()),
                  textPrimary: textPrimary,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ---------------- App Settings ----------------
            _buildSection(
              iconcolr: isDark ? AppColor.background : AppColor.primary ,
              title: 'settings'.tr,
              icon: Icons.settings_rounded,
              cardBg: cardBg,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              children: [
                Obx(
                      () => _buildSwitchItem(
                        iconcolr: isDark ? AppColor.background : AppColor.primary,
                    icon: themeController.isDark.value
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    title: 'dark_mode'.tr,
                    value: themeController.isDark.value,
                    onChanged: themeController.toggleTheme,
                    textPrimary: textPrimary,
                  ),
                ),





                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: 'change_language'.tr,
                  onTap: () => _showLanguageDialog(context),
                  textPrimary: textPrimary,
                  iconcoler:isDark ? AppColor.background : AppColor.primary ,

                ),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: 'more'.tr,
                  onTap: () => Get.to(MoreSettings()),
                  textPrimary: textPrimary,
                  iconcoler:isDark ? AppColor.background : AppColor.primary ,

                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ---------------- Support ----------------
            _buildSection(
              iconcolr: isDark ? AppColor.background : AppColor.primary ,
              title: 'support_info'.tr,
              icon: Icons.help_outline_rounded,
              cardBg: cardBg,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              children: [

                _buildMenuItem(
                  iconcoler:isDark ? AppColor.background : AppColor.primary ,

                  icon: Icons.info_rounded,
                  title: 'about_app'.tr,
                  onTap: () {

                    Get.to(
                          () => const LegalPageView(pageKey: 'about'),
                      binding: LegalPageBinding(),
                    );



                  }
                  ,
                  textPrimary: textPrimary,
                ),
                _buildMenuItem(
                  iconcoler:isDark ? AppColor.background : AppColor.primary ,

                  icon: Icons.security_rounded,
                  title: 'privacy_policy'.tr,
                  onTap: () {



                    Get.to(
                          () => const LegalPageView(pageKey: 'privacy_policy'),
                      binding: LegalPageBinding(),
                    );


                  },
                  textPrimary: textPrimary,
                ),

              ],
            ),

            const SizedBox(height: 32),

            _buildLogoutButton(context),

            const SizedBox(height: 24),


          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
    required Color iconcolr,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: iconcolr),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? textSecondary.withOpacity(0.2)
                        : Colors.grey.shade200,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color iconcoler,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary.withOpacity(0.12),
                ),
                child: Icon(icon, color: iconcoler, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required Color textPrimary,
    required Color iconcolr,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary.withOpacity(0.12),
            ),
            child: Icon(icon, color: iconcolr, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppColor.primary,
              activeTrackColor:
              AppColor.primary.withOpacity(0.3),
              inactiveTrackColor: isDark
                  ? AppColor.darkTextSecondary.withOpacity(0.4)
                  : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showLogoutDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout_rounded,
                    color: Colors.white, size: 22),
                SizedBox(width: 12),
                Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Dialogs ----------------

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color:
            isDark ? AppColor.darkCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.logout_rounded,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'logout_title'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'logout_confirm'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColor.darkTextSecondary
                            : AppColor.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: ()  {
                        loginController.logout();

                      },

                      child: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      Dialog(
        backgroundColor:
        isDark ? AppColor.darkCardBackground : Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            final currentLang =
                widget.langController.currentLang.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'choose_language'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption('العربية', 'ar',
                    currentLang == 'ar'),
                const SizedBox(height: 12),
                _buildLanguageOption(
                    'English', 'en', currentLang == 'en'),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      String language, String code, bool selected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: selected
          ? AppColor.primary.withOpacity(0.1)
          : (isDark
          ? AppColor.darkCardBackground
          : Colors.grey.shade50),
      leading: Icon(
        selected
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: selected ? AppColor.primary : Colors.grey,
      ),
      title: Text(
        language,
        style: TextStyle(
          fontFamily: 'Cairo',
          color: isDark
              ? AppColor.darkTextPrimary
              : AppColor.textPrimary,
        ),
      ),
      onTap: () {
        widget.langController.changeLanguage(code);
        Get.back();
      },
    );
  }
}
