import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': ar,
    'en': en,
  };
}

final Map<String, String> ar = {
  // General
  'settings': 'الإعدادات',
  'cancel': 'إلغاء',
  'confirm': 'تأكيد',
  'language': 'اللغة',
  'change_language': 'تغيير اللغة',
  'choose_language': 'اختر اللغة',

  // Sections
  'account_management': 'إدارة الحساب',
  'app_settings': 'إعدادات التطبيق',
  'support_info': 'الدعم والمعلومات',

  // Account
  'profile': 'الملف الشخصي',
  'my_articles': 'منشوراتي',
  'favorites': 'المفضلة',

  // App settings
  'dark_mode': 'الوضع الليلي',
  'notifications': 'الإشعارات',
  'gps_service': 'خدمة الموقع',
   'more' : 'المزيد',

  // Support
  'share_app': 'شارك التطبيق',
  'about_app': 'عن نبأ',
  'privacy_policy': 'سياسة الخصوصية',
  'terms_of_service': 'شروط الخدمة',



  // Logout
  'logout': 'تسجيل الخروج',
  'logout_title': 'تسجيل الخروج',
  'logout_confirm': 'هل أنت متأكد من تسجيل الخروج؟',

  // Bottom Nav
  'home': 'الرئيسية',
  'interests': 'اهتماماتي',
  'articles': 'المقالات',
  'ai_ask': 'اسأل الذكاء',
  'breaking_news': 'أخبار عاجلة',
  'sharing': 'مشاركة',
  'save': 'حفظ',
  'no_breaking_news': 'لا يوجد أخبار عاجلة',
  'my_profile': 'ملفي الشخصي',
  'edit_profile': 'تعديل الملف الشخصي',
  'login_in': 'تسجيل دخول',


  // Validation
  'name_required': 'الاسم مطلوب',
  'name_min_length': 'الاسم يجب أن يكون على الأقل 3 أحرف',
  'name_only_letters': 'الاسم يجب أن يحتوي على أحرف فقط بدون أرقام أو رموز',

  'email_required': 'البريد الإلكتروني مطلوب',
  'email_no_arabic': 'البريد الإلكتروني لا يجب أن يحتوي على أحرف عربية',
  'email_invalid': 'صيغة البريد الإلكتروني غير صحيحة',

  'password_required': 'كلمة المرور مطلوبة',
  'password_min_length': 'كلمة المرور يجب أن تكون على الأقل 6 أحرف',
  'password_english_required': 'كلمة المرور يجب أن تحتوي على حرف إنجليزي واحد على الأقل',

  'confirm_password_required': 'تأكيد كلمة المرور مطلوب',
  'password_not_match': 'كلمة المرور غير متطابقة',


// Login
  'email_hint': 'البريد الإلكتروني',
  'password_hint': 'كلمة المرور',
  'forgot_password': 'نسيت كلمة السر ؟',
  'no_account_register': 'ليس لديك حساب ؟ إنشاء حساب',

// Register
  'name_hint': 'الاسم',

  'confirm_password_hint': 'تأكيد كلمة المرور',
  'register': 'إنشاء حساب',
  'have_account_login': 'هل لديك حساب ؟ تسجيل دخول',
  'moresettings' :'المزيد من الاعدادات',
  'controlaccount' :'التحكم بالحساب'

};

final Map<String, String> en = {
  // General
  'settings': 'Settings',
  'cancel': 'Cancel',
  'confirm': 'Confirm',
  'language': 'Language',
  'change_language': 'Change Language',
  'choose_language': 'Choose Language',
 'controlaccount' : 'ControlAccount',
  // Sections
  'account_management': 'Account Management',
  'app_settings': 'App Settings',
  'support_info': 'Support & Info',

  // Account
  'profile': 'Profile',
  'my_articles': 'My Articles',
  'favorites': 'Favorites',

  // App settings
  'dark_mode': 'Dark Mode',
  'notifications': 'Notifications',
  'gps_service': 'Location Service (GPS)',
  'more': 'More',
  'moresettings': 'MoreSettings',
  // Support
  'share_app': 'Share App',
  'about_app': 'About Nabaa',
  'privacy_policy': 'Privacy Policy',
  'terms_of_service': 'Terms of Service',

  // Logout
  'logout': 'Logout',
  'logout_title': 'Logout',
  'logout_confirm': 'Are you sure ',

  // Bottom Nav
  'home': 'Home',
  'interests': 'My Interests',
  'articles': 'Articles',
  'ai_ask': 'Ask AI',
  'breaking_news': 'Breaking News',
  'sharing': 'Sharing',
  'save': 'Save',
  'no_breaking_news': 'No Breaking News',
  'my_profile': 'My Profile',
  'edit_profile': 'Edit Profile',
  'login_in': 'Login',


  // Validation
  'name_required': 'Name is required',
  'name_min_length': 'Name must be at least 3 characters',
  'name_only_letters': 'Name must contain letters only without numbers or symbols',

  'email_required': 'Email is required',
  'email_no_arabic': 'Email must not contain Arabic characters',
  'email_invalid': 'Invalid email format',

  'password_required': 'Password is required',
  'password_min_length': 'Password must be at least 6 characters',
  'password_english_required': 'Password must contain at least one English letter',

  'confirm_password_required': 'Confirm password is required',
  'password_not_match': 'Passwords do not match',

// Login
  'email_hint': 'Email',
  'password_hint': 'Password',
  'forgot_password': 'Forgot password?',
  'no_account_register': 'Don’t have an account? Create one',


  // Register
  'name_hint': 'Name',

  'confirm_password_hint': 'Confirm Password',
  'register': 'Create Account',
  'have_account_login': 'Already have an account? Login',


};
