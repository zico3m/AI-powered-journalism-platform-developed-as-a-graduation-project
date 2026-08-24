import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _interactionNotifications = true;
  bool _gpsEnabled = false;
  String _selectedLanguage = 'العربية';
  String _selectedNewsVersion = 'الأساسية';

  final List<String> _languages = ['العربية', 'English', ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'الإعدادات العامة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.blue.shade800,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان القسم الرئيسي
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'المحتوى واللغة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),

              // البطاقة الرئيسية
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // اللغة
                    _buildDropdownSetting(
                      context,
                      icon: Icons.language_rounded,
                      title: 'اختر لغة التطبيق',
                      value: _selectedLanguage,
                      items: _languages,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),

                    _buildDivider(context),

                    // الإشعارات
                    _buildSwitchSetting(
                      context,
                      icon: Icons.notifications_active_rounded,
                      title: 'الإشعارات',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),

                    _buildDivider(context),

                    // إصدارات الأخبار المفضلة



                    // إشعارات التفاعل
                    _buildSwitchSetting(
                      context,
                      icon: Icons.thumb_up_rounded,
                      title: 'إشعارات التفاعل',
                      value: _interactionNotifications,
                      onChanged: (value) {
                        setState(() {
                          _interactionNotifications = value;
                        });
                      },
                    ),

                    _buildDivider(context),

                    // الأدوات والبيانات
                    _buildSimpleSetting(
                      context,
                      icon: Icons.analytics_rounded,
                      title: 'الأدوات والبيانات',
                      subtitle: 'إحصائيات الاستخدام',
                      onTap: () {
                        // فتح شاشة الأدوات والبيانات
                      },
                    ),

                    _buildDivider(context),

                    // خدمة الموقع (GPS)
                    _buildSwitchSetting(
                      context,
                      icon: Icons.location_on_rounded,
                      title: 'خدمة الموقع (GPS)',
                      value: _gpsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _gpsEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),


              // معلومات التخزين

              const SizedBox(height: 24),

              // نصائح الاستخدام
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      thickness: 1,
      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSimpleSetting(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        Color? iconColor,
      }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.blue.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (iconColor ?? Colors.blue).withOpacity(0.1),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.grey.shade800,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool value,
        required Function(bool) onChanged,
      }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.grey.shade800,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),

              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue.shade600,
              activeTrackColor: Colors.blue.shade300,
              inactiveTrackColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required List<String> items,
        required Function(String?) onChanged,
      }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.grey.shade800,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),

              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
                dropdownColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}