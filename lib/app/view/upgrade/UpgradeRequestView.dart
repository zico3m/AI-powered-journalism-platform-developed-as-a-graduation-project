import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/upgrade/UpgradeRequestController.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';

class UpgradeRequestView extends StatelessWidget {
  UpgradeRequestView({super.key});

  final UpgradeRequestController controller =
  Get.put(UpgradeRequestController());

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
              expandedHeight: 100,
              collapsedHeight: 70,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
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
              title: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  "طلب ترقية الحساب",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
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

            /// محتوى النموذج
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      context,
                      title: "المعلومات الشخصية",
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 15),

                    /// الاسم الكامل
                    _buildTextFieldCard(
                      context,
                      child: Obx(() => CustomTextFieldForm(
                        controller: controller.fullNameController,
                        hintText: "الاسم الكامل كما في الهوية",
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                        obscured: false,
                        enabled: !controller.isSubmitting.value,
                        onChanged: (_) {},
                      )),
                    ),

                    const SizedBox(height: 12),

                    /// رقم الهوية
                    _buildTextFieldCard(
                      context,
                      child: Obx(() => CustomTextFieldForm(
                        controller: controller.nationalIdController,
                        hintText: "رقم الهوية",
                        prefixIcon: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                        obscured: false,
                        enabled: !controller.isSubmitting.value,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {},
                      )),
                    ),

                    const SizedBox(height: 25),

                    _buildSectionHeader(
                      context,
                      title: "نوع الهوية",
                      icon: Icons.badge_outlined,
                    ),

                    /// نوع الهوية
                    Obx(() => _buildDocumentTypeDropdown(context)),

                    const SizedBox(height: 25),

                    _buildSectionHeader(
                      context,
                      title: "إرفاق صورة الهوية",
                      icon: Icons.attach_file_rounded,
                      subtitle: "يجب أن تكون الصورة واضحة ومقروءة",
                    ),

                    /// رفع الصور
                    Obx(() => _buildImageUploadSection(context)),

                    const SizedBox(height: 25),

                    _buildSectionHeader(
                      context,
                      title: "سبب طلب الترقية",
                      icon: Icons.edit_note_rounded,
                      subtitle: "اشرح سبب رغبتك في أن تصبح كاتبًا",
                    ),

                    /// سبب الترقية
                    _buildTextFieldCard(
                      context,
                      child: Obx(() => CustomTextFieldForm(
                        controller: controller.reasonController,
                        hintText: "اكتب سبب طلبك للترقية...",
                        prefixIcon: Icon(
                          Icons.message_rounded,
                          color: Colors.blue.withOpacity(0.7),
                        ),
                        obscured: false,
                        enabled: !controller.isSubmitting.value,
                        maxLines: 4,
                        onChanged: (_) {},
                      )),
                    ),

                    const SizedBox(height: 30),

                    /// زر الإرسال
                    Obx(() => _buildSubmitButton(context)),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==============================
  //        مكونات واجهة المستخدم
  //==============================

  Widget _buildSectionHeader(
      BuildContext context, {
        required String title,
        required IconData icon,
        String? subtitle,
      }) {
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              subtitle,
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildTextFieldCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: child,
      ),
    );
  }

  Widget _buildDocumentTypeDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<int>(
        value: controller.selectedDocumentTypeId.value,
        items: controller.documentTypes
            .map(
              (e) => DropdownMenuItem<int>(
            value: e['id'] as int,
            child: Text(
              e['name'],
              style: const TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: controller.isSubmitting.value
            ? null
            : (v) => controller.selectedDocumentTypeId.value = v!,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          hintText: "اختر نوع الهوية",
          hintStyle: TextStyle(
            fontFamily: "Cairo",
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.badge_rounded,
            color: Colors.blue.withOpacity(0.7),
          ),
        ),
        style: TextStyle(
          fontFamily: "Cairo",
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        dropdownColor: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildImageUploadSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// زر رفع الصور
        _buildUploadButton(context),

        const SizedBox(height: 15),

        /// معرض الصور المرفوعة
        if (controller.selectedDocuments.isEmpty)
          _buildEmptyImagesPlaceholder(context)
        else
          _buildImagesGallery(context),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.isSubmitting.value
            ? null
            : () => controller.pickDocumentImage(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.9),
                Colors.blueAccent,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "إضافة صورة الهوية",
                style: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyImagesPlaceholder(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 45,
            color: Colors.blue.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            "لم يتم رفع أي صور بعد",
            style: TextStyle(
              fontFamily: "Cairo",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "انقر على الزر أعلاه لرفع صورة الهوية",
            style: TextStyle(
              fontFamily: "Cairo",
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesGallery(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الصور المرفوعة (${controller.selectedDocuments.length})",
          style: TextStyle(
            fontFamily: "Cairo",
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(controller.selectedDocuments.length, (index) =>
              _buildImageThumbnail(context, index, controller.selectedDocuments[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail(BuildContext context, int index, dynamic file) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: theme.colorScheme.surfaceVariant,
                child: Icon(
                  Icons.broken_image_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: GestureDetector(
            onTap: () => controller.removeDocument(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.isSubmitting.value
              ? null
              : () => controller.submitUpgradeRequest(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: controller.isSubmitting.value
                  ? LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.grey.shade600,
                ],
              )
                  : LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blueAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: controller.isSubmitting.value
                  ? null
                  : [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.isSubmitting.value)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                const SizedBox(width: 10),
                Text(
                  controller.isSubmitting.value
                      ? "جارٍ إرسال الطلب..."
                      : "إرسال طلب الترقية",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}