import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../controller/profile/ProfileController.dart';
import '../../core/app_colors.dart';
import '../upgrade/UpgradeRequestView.dart';
import '../interest/edit_interests_dialog.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// AppBar أنيق
            SliverAppBar(
              expandedHeight: 140,
              collapsedHeight: 80,
              floating: true,
              pinned: true,
              backgroundColor: theme.colorScheme.background,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.blue,
                    size: 20,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
              centerTitle: true,
              title: Obx(() => AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  controller.isEditing.value ? 'edit_profile'.tr : 'profile'.tr,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              )),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.withOpacity(0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// المحتوى الرئيسي
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerLoading(context);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Column(
                    children: [
                      /// البطاقة الرئيسية
                      _buildMainProfileCard(context),

                      const SizedBox(height: 20),

                      /// بطاقة الإحصائيات
                      // _buildStatsCard(context),

                      const SizedBox(height: 20),

                      /// أزرار الإجراءات
                      _buildActionButtons(context),

                      const SizedBox(height: 30),

                      /// تاريخ الإنشاء
                      _buildCreationDate(context),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          /// قسم الصورة مع الخلفية المتدرجة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Obx(() {
              final url = controller.profileImageUrl.value;
              final isEditing = controller.isEditing.value;

              ImageProvider? imageProvider;
              if (url != null && url.isNotEmpty) {
                if (url.startsWith('http')) {
                  imageProvider = NetworkImage(url);
                } else {
                  imageProvider = FileImage(File(url));
                }
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  /// صورة المستخدم مع حدود متدرجة
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade300,
                          Colors.blueAccent,
                        ],
                      ),

                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surface,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      )
                          : null,
                    ),
                  ),

                  /// زر تغيير الصورة (يظهر فقط في وضع التعديل)
                  if (isEditing)
                    Positioned(
                      bottom: 8,
                      right: -2,
                      child: GestureDetector(
                        onTap: () => _showImagePickerSheet(context),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.blueAccent,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),

          /// معلومات المستخدم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                /// الاسم الكامل (قابل للتحرير فقط في وضع التعديل)
                Obx(() {
                  return CustomTextFieldForm(
                    controller: controller.nameController,
                    hintText: "الاسم الكامل",
                    prefixIcon: Icon(
                      Icons.person,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    obscured: false,
                    enabled: controller.isEditing.value,
                    style: TextStyle(
                      color: controller.isEditing.value
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    onChanged: (_) {},
                  );
                }),

                /// البريد الإلكتروني (للعرض فقط)
                CustomTextFieldForm(
                  enabled: false,
                  controller: controller.emailController,
                  hintText: "البريد الإلكتروني",
                  prefixIcon: Icon(
                    Icons.email,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  obscured: false,

                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  onChanged: (_) {},
                ),

                const SizedBox(height: 20),

                /// نوع الحساب وحالته
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusPill(
                        context,
                        label: "نوع الحساب",
                        value: controller.accountTypeName.value,
                        icon: Icons.badge_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatusPill(
                        context,
                        label: "حالة الحساب",
                        value: controller.accountStatusName.value,
                        icon: Icons.verified_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// اهتمامات المستخدم
                _buildInterestsSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
      }) {
    final theme = Theme.of(context);
    final Color blueColor = Colors.blue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blueColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blueColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: blueColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: blueColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: blueColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 11,
                    color: blueColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: blueColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.interests_outlined,
                size: 20,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "اهتماماتي",
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Obx(() {
              if (controller.interests.isNotEmpty && controller.isEditing.value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.dialog(
                          EditInterestsDialog(),
                          barrierDismissible: false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "تعديل",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.interests.isEmpty) {
            return _buildEmptyInterests(context);
          }
          return _buildInterestsGrid(context);
        }),
      ],
    );
  }

  Widget _buildEmptyInterests(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (controller.isEditing.value) {
          Get.dialog(
            EditInterestsDialog(),
            barrierDismissible: false,
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 45,
              color: Colors.blue.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            Text(
              "لا توجد اهتمامات",
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 6),
            Obx(() {
              return Text(
                controller.isEditing.value
                    ? "انقر هنا لإضافة اهتماماتك"
                    : "تفعيل وضع التعديل لإضافة اهتمامات",
                style: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsGrid(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: controller.interests
          .map((interest) => Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.9),
              Colors.blueAccent,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.label_important_outlined,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              interest,
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ))
          .toList(),
    );
  }

  // Widget _buildStatsCard(BuildContext context) {
  //   final theme = Theme.of(context);
  //   final isDarkMode = theme.brightness == Brightness.dark;
  //
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           Colors.blue.withOpacity(0.05),
  //           Colors.blueAccent.withOpacity(0.08),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: isDarkMode
  //               ? Colors.black.withOpacity(0.2)
  //               : Colors.grey.withOpacity(0.1),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(6),
  //               decoration: BoxDecoration(
  //                 color: Colors.blue.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Icon(
  //                 Icons.analytics_outlined,
  //                 size: 20,
  //                 color: Colors.blue,
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Text(
  //               "إحصائياتي",
  //               style: TextStyle(
  //                 fontFamily: "Cairo",
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w800,
  //                 color: theme.colorScheme.onSurface,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         // Row(
  //         //   children: [
  //         //     Expanded(
  //         //       child: _StatCard(
  //         //         icon: Icons.favorite_rounded,
  //         //         label: "الإعجابات",
  //         //         value: "0",
  //         //       ),
  //         //     ),
  //         //     const SizedBox(width: 16),
  //         //     Expanded(
  //         //       child: _StatCard(
  //         //         icon: Icons.chat_bubble_rounded,
  //         //         label: "التعليقات",
  //         //         value: "0",
  //         //       ),
  //         //     ),
  //         //   ],
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      return Column(
        children: [
          /// وضع التعديل
          if (controller.isEditing.value) ...[
            _buildAnimatedButton(
              context,
              text: controller.isSaving.value
                  ? "جارٍ الحفظ..."
                  : "حفظ التعديلات",
              onTap: controller.isSaving.value
                  ? null
                  : () => controller.saveProfile(),
              color: Colors.blue,
              icon: Icons.check_rounded,
            ),
            const SizedBox(height: 12),
            _buildAnimatedButton(
              context,
              text: "cancel".tr,
              onTap: controller.cancelEditing,
              color: Colors.grey,
              icon: Icons.close_rounded,
              isSecondary: true,
            ),
          ]

          /// وضع العرض (ليس تعديل)
          else ...[
            /// زر تعديل الملف الشخصي (دائمًا موجود)
            _buildAnimatedButton(
              context,
              text: 'edit_profile'.tr,
              onTap: () => controller.enableEditing(),
              color: Colors.blue,
              icon: Icons.edit_rounded,
            ),

            const SizedBox(height: 12),

            /// زر طلب الترقية (زائر فقط + لا يوجد طلب pending)
            if (controller.accountTypeId.value == 1 &&
                !controller.hasPendingUpgradeRequest.value)
              _buildAnimatedButton(
                context,
                text: "طلب ترقية الحساب",
                onTap: () {
                  Get.to(() => UpgradeRequestView());

                },
                color: Colors.blue,
                icon: Icons.workspace_premium_rounded,
              ),

            /// رسالة عند وجود طلب قيد المراجعة
            if (controller.accountTypeId.value == 1 &&
                controller.hasPendingUpgradeRequest.value)
              _buildAnimatedButton(
                context,
                text: "طلب الترقية قيد المراجعة",
                onTap: null,
                color: Colors.blue.shade300,
                icon: Icons.hourglass_top_rounded,
              ),
          ],
        ],

      );
    });
  }

  Widget _buildAnimatedButton(
      BuildContext context, {
        required String text,
        required VoidCallback? onTap,
        required Color color,
        required IconData icon,
        bool isSecondary = false,
      }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: isSecondary
            ? null
            : LinearGradient(
          colors: [
            color,
            color.withOpacity(0.9),
          ],
        ),
        color: isSecondary ? Colors.transparent : null,
        borderRadius: BorderRadius.circular(16),
        border: isSecondary ? Border.all(color: color, width: 2) : null,
        boxShadow: isSecondary
            ? null
            : [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSecondary ? color : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isSecondary ? color : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreationDate(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final text = controller.creationYearText;
      if (text.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: Colors.blue.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 12,
                color: Colors.blue.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // صورة شيمر
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 30),
                // حقول النص
                ...List.generate(
                    4,
                        (index) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "تحديث الصورة الشخصية",
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _buildImagePickerOption(
              context,
              icon: Icons.camera_alt_rounded,
              title: "التقاط صورة جديدة",
              subtitle: "استخدام الكاميرا",
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
            _buildImagePickerOption(
              context,
              icon: Icons.photo_library_rounded,
              title: "اختيار من المعرض",
              subtitle: "من مكتبة الصور",
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "إلغاء",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final Color blueColor = Colors.blue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: blueColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: blueColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: blueColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: blueColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

