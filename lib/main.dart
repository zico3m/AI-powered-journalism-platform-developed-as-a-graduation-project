import 'package:flutter/material.dart'; // من الجيد إضافة هذا الاستيراد
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
// تأكد من أن المسارات صحيحة
import 'app/bindings/initial_binding.dart';
import 'app/core/localization/LanguageController.dart';
import 'app/controller/notifications/NotificationsController.dart';
import 'app/core/localization/translations.dart';
import 'app/core/theme/AppTheme.dart';
import 'app/core/theme/theme_controller.dart';
import 'app/models/data/services/auth_rep/AuthService.dart';
import 'app/models/data/services/ConnectivityWrapper.dart';
import 'app/models/data/services/SupabaseService.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  await Get.putAsync(() => SupabaseService().init());
  Get.put(ThemeController());
  await GetStorage.init();
  // Get.put(ConnectivityEngine(), permanent: true);
  Get.put(AuthService());
  runApp(const NabaAi());
}

class NabaAi extends StatelessWidget {
  const NabaAi({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final langController = Get.put(LanguageController());

    return Obx(() => GetMaterialApp(
      translations: AppTranslations(),

      locale: Locale(langController.currentLang.value),
      fallbackLocale: const Locale('ar'),

      initialBinding: InitialBinding(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,

      builder: (context, child) {
        return Directionality(
          textDirection: langController.currentLang.value == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    ));
  }
}

